# The HELIX Context Route

### Turning historical and custom tables into defined, governed, agent-ready data

Every migration leaves tables behind that no standard covers: PeopleSoft custom records, Banner Z tables, columns someone added in 2009, a legacy warehouse nobody fully understands, departmental spreadsheets that became databases. The customization register (`docs/conversion/`) decides which of them to keep. This route is what happens next: each kept table gets a definition, a classification, a link to HELIX, and usage rules, so people and AI agents can use it correctly.

The same route also describes everything in silver and gold, so the lakehouse carries its own meaning instead of relying on a vendor's semantic layer.

---

## What "context" means here

| Context | Example | Where it lives |
|---------|---------|----------------|
| **Definition** | "`ZZ_ATHLETE_IND`: Y when the student is on an NCAA varsity roster for the term" | Column description |
| **Classification** | confidential, FERPA education record | Table parameters, LF-tags |
| **HELIX link** | Maps to StudentGroup with group type `athletics` | Custom metadata, ontology |
| **Grain and keys** | One row per student per term; join on `helix_id` and `academic_period_ref` | Skill file |
| **Usage rules** | Exclude withdrawn students before counting; never publish counts under 5 | Skill file, guardrails |
| **Metric logic** | Fall-to-fall retention = returned by census / first-time full-time cohort | `templates/context/gold-metrics.yaml` |
| **Lineage** | Came from Banner `SGBSTDN_ZATHLETE_IND`, register row BN-00003 | Custom metadata, S3 annotations |

## Where AWS stands (as of November 2026)

HELIX builds on what's available now and is ready for AWS Context when it arrives. Everything here is from public AWS announcements.

| Capability | Status | What HELIX uses it for |
|------------|--------|------------------------|
| **AWS Glue Data Catalog table and column descriptions, table parameters** | Generally available | Definitions, classification, HELIX links for every silver and gold table. Works today with `tools/apply_glue_context.py` |
| **Glue Data Catalog business context and semantic search** | Preview (announced June 2026) | Business descriptions, glossary terms, and custom metadata indexed for search by people and agents |
| **Glue Data Catalog skill assets** | Preview (announced June 2026) | Points each table at its HELIX skill file (grain, joins, filters, rules) |
| **Amazon S3 annotations** | Generally available (June 2026) | Context on bronze objects: source system, extract, register row, classification. Queryable as an Iceberg table |
| **Context Ontology Accelerator** | Open source on GitHub, Apache 2.0 (July 2026) | Loads the HELIX ontology (`helix-ontology.ttl`) so stewards can review and approve it; AWS says its ontology capability will become part of AWS Context |
| **AWS Context** | Announced June 2026, listed as coming soon | An organizational knowledge graph over the catalog, with steward review, agentic search, MCP tools, and the caller's IAM and Lake Formation permissions. Key metadata published as Iceberg in S3 Tables |

**What that means in practice:** do steps 1 to 6 below today. Everything lands in the Glue Data Catalog, S3, and open files in your repo. AWS has said AWS Context integrates with the Glue Data Catalog, SageMaker Unified Studio, and Lake Formation, so the context you curate now is already where it needs to be. Step 7 turns it on.

Don't build against features or dates you've only heard about privately. HELIX is public; use public announcements only.

---

## The route

| Step | Do this | Tool | Done when |
|------|---------|------|-----------|
| 1. Pick the tables | Custom and historical tables marked `preserve_as_data` or `convert` in the register, plus every silver and gold table | `templates/customization-discovery/customization-register.csv` | You have a list with owners |
| 2. Profile them | Row counts, null rates, distinct counts, min and max, and top values for low-cardinality columns only | `templates/context/profile-table.sql` (Athena) | One profile CSV per table |
| 3. Match to HELIX | Score each column against HELIX attributes, the data dictionary, and the glossary | `tools/draft_custom_table_context.py` | Every column has candidate matches with scores |
| 4. Draft definitions | A model writes plain-English definitions, proposes classification, and flags anything unclear | `templates/context/prompts/draft-definitions.md` in Amazon Bedrock | A draft review sheet |
| 5. Steward review | The data steward edits, approves, or rejects each row. Nothing AI-drafted is published without approval | `templates/context/definition-review.csv`, `govern/context-governance-policy.json` | Every row is `approved` or `rejected` |
| 6. Publish | Push approved context to Glue, annotate bronze objects in S3, add skill files, extend the ontology | `tools/apply_glue_context.py`, `templates/context/s3-annotation-template.json` | Descriptions show in the catalog; agents can find them |
| 7. Connect AWS Context | When it's available, enable it over the same catalog and load the ontology | AWS Context console | Agents query the knowledge graph with the caller's permissions |

### Step 2: profile safely

The profiling template never pulls sample values from columns classified confidential or restricted, and never pulls free text. It returns counts and shapes. That profile is what goes to a model, not the data.

### Step 3: match before you ask a model

`tools/draft_custom_table_context.py` compares each column name and its profile with the 1,870 entries in `core/data-dictionary.json` and the glossary, and suggests the HELIX resource and attribute it most likely corresponds to. Deterministic matching first means the model starts from a short, sourced list, and the steward can see why a match was suggested.

### Step 4: draft with a model

The prompt gives the model the table name, the profile, the candidate matches, the register row, and the bridge mapping excerpts for the source system. It asks for definitions, a proposed classification at least as strict as the source, the grain, likely keys, and questions for the steward. It never sees row-level data.

### Step 5: the steward decides

Approval rules are in `govern/context-governance-policy.json`. The short version: a named steward approves every definition, classification can be raised but not lowered without the data trustee, FERPA and GLBA flags follow the data, and every approval is versioned.

### Step 6: publish

- **Glue Data Catalog (works today):** `tools/apply_glue_context.py` writes table descriptions, column comments, and `helix.*` table parameters. It runs as a dry run by default and shows the change before writing.
- **Glue business context (preview):** the same file carries glossary terms and custom metadata for the business context fields. Map them to the preview API in your account.
- **Skill assets (preview):** point each table at its skill file in `templates/context/generated/skills/` (or your own copy in S3 or git).
- **S3 annotations:** annotate bronze objects with source, extract, register row, and classification using `s3-annotation-template.json`.
- **Ontology:** load `templates/context/generated/helix-ontology.ttl` into the Context Ontology Accelerator, add your custom tables as subclasses or extensions, and have stewards approve them there.

---

## Context for silver and gold, generated

You don't have to write context for the 64 HELIX resources by hand. `tools/build_context_pack.py` generates it from the schemas, data dictionary, terminologies, access matrix, and gold metric definitions:

| Output | What it is |
|--------|-----------|
| `generated/glue-business-context.json` | For every silver table: description, column descriptions, glossary terms, and custom metadata (classification, FERPA and GLBA flags, HELIX resource, code set bindings, steward domain) |
| `generated/skills/<resource>.md` | One skill file per resource: grain, keys, joins, required filters, code sets, access rules, and gotchas |
| `generated/gold-skills/<metric>.md` | One skill file per gold metric from `gold-metrics.yaml` |
| `generated/helix-ontology.ttl` | The HELIX model as a W3C ontology (OWL classes and properties, SKOS concept schemes for the 67 code sets) |

Re-run it whenever HELIX changes. Institutions add their own context in separate files so a HELIX upgrade doesn't overwrite it.

## Gold metrics are institutional knowledge

The most valuable context isn't column descriptions; it's how your institution counts things. `templates/context/gold-metrics.yaml` defines standard higher education metrics (census headcount, retention, graduation, yield, melt, unmet need, instructional cost per credit hour, and more) with grain, inclusion rules, formula, source resources, owner, and the federal or accreditor definition they follow. Copy it, change the parts your institution does differently, and get each metric signed by its owner. That file, not a vendor's semantic layer, is your institution's definition of truth.

## Rules

- **Approved by a person.** AI drafts; stewards decide. Unapproved context is never published to the catalog agents read.
- **No data in prompts.** Profiles and definitions only.
- **Classification never goes down by accident.** A drafted classification lower than the source is rejected automatically.
- **Keep it portable.** Every piece of context exists as a file you own (YAML, Markdown, JSON, Turtle) as well as in the catalog.
- **Public information only.** Plan around what AWS has announced publicly.

*HELIX v0.10.0, November 2026*
