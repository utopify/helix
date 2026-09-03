# HELIX

### Higher Education Linked Information eXchange

> What if every university spoke the same data language?

HELIX is an open framework of foundational data models, governance standards, and ERP mapping templates that eliminate integration friction in higher education — worldwide.

---

**Founded by:** Dallas Maddox
**Version:** 0.1.8 (September 2026)
**License:** Apache 2.0

--- 

## The Problem

Every university on the planet runs some version of the same core data domains: students, courses, enrollment, financial aid, HR, research, and advancement. Yet every ERP migration, every data lake build, and every analytics modernization project treats the mapping of these domains as a bespoke engineering effort.

The mapping logic from Banner to a lakehouse is 80% identical to the mapping logic from PeopleSoft to a lakehouse. But nobody has codified that shared 80% into something reusable.

The result: billions of dollars spent globally on redundant integration work, inconsistent definitions that erode trust in institutional data, and an inability to benchmark or collaborate across institutions because everyone speaks a different data dialect.

## The Vision

HELIX provides higher education with a shared, open, technology-neutral vocabulary of linked data objects that any system can produce, consume, and trust.

When an institution adopts HELIX:

- **ERP choice becomes an implementation detail**, not an architecture-defining constraint
- **Data lake ingestion is pre-mapped**, not hand-built from scratch
- **Analytics and AI models are portable** across institutions
- **Data governance has a shared vocabulary**, so "enrolled student" means the same thing everywhere
- **Inter-institutional data sharing** becomes a configuration exercise, not a negotiation

---

## The HELIX Ecosystem

HELIX is not a single spec. It's an ecosystem of interconnected layers, each serving a different audience and a different part of the problem.

```
  +===============================================================+
  |                                                               |
  |                        H E L I X                              |
  |          Higher Education Linked Information eXchange         |
  |                                                               |
  |   +-----------------+  +-----------------+  +---------------+ |
  |   | HELIX Core      |  | HELIX Connect   |  | HELIX Govern  | |
  |   |                 |  |                 |  |               | |
  |   | The data model. |  | The API &       |  | The governance| |
  |   |                 |  | exchange        |  | framework.    | |
  |   | 19 resources,   |  | standard.       |  |               | |
  |   | 23 terminology  |  |                 |  | Roles, rules, | |
  |   | code sets.      |  | 16 REST endpts, |  | quality, and  | |
  |   |                 |  | bulk export,    |  | maturity      | |
  |   |                 |  | validation.     |  | assessment.   | |
  |   +-----------------+  +-----------------+  +---------------+ |
  |                                                               |
  |   +---------------------------------------------------------+ |
  |   | HELIX Bridge                                            | |
  |   |                                                         | |
  |   | ERP-to-HELIX mapping accelerators for Banner,           | | 
  |   | PeopleSoft, Workday, and Colleague.                     | |
  |   +---------------------------------------------------------+ |
  |                                                               |
  +===============================================================+
```

| Layer | What It Is | Who It's For |
|-------|-----------|-------------|
| **HELIX Core** | 19 foundational resource definitions (JSON Schema), 23 terminology code sets, and a comprehensive glossary | Data architects, data engineers, analytics teams |
| **HELIX Connect** | OpenAPI 3.1 spec with 16 REST endpoints for real-time and bulk data exchange | Integration engineers, application developers |
| **HELIX Govern** | Governance roles, quality rule library (22 rules), maturity model, domain taxonomy | CDOs, data stewards, compliance officers |
| **HELIX Bridge** | ERP-specific mapping templates: PeopleSoft (40), Banner (13), Workday (26), Colleague (3) — 82 total | Implementation teams, system integrators |

---

## HELIX Core: Resources (v0.1)

19 foundational resources across 7 domains:

| Domain | Resources |
|--------|-----------|
| **Identity** | `Person`, `Student`, `Institution` |
| **Academic Structure** | `AcademicOrg`, `Course`, `CourseSection`, `Program`, `AcademicPeriod` |
| **Enrollment & Registration** | `Enrollment`, `StudentProgram`, `AdmissionApplication`, `TransferCredit` |
| **Financial Aid** | `FinAidAward` |
| **Outcomes** | `Degree` |
| **Student Services** | `Hold` |
| **Advancement** | `Constituent`, `Gift`, `Campaign`, `EngagementActivity` |

Each resource includes a `meta` block with embedded governance: version, source system, data owner, and classification level.

See the [Resource Catalog](docs/resource-catalog.md) for full attribute details.

## HELIX Core: Glossary

A 34,000-word comprehensive taxonomy covering the complete student lifecycle (web visitor through alumni/donor), all student types (workers, athletes, international, first-gen, veteran), the administrative infrastructure (registrar, student financial services, FERPA, GLBA), and the full faculty taxonomy (10 employment types, 9 academic ranks, tenure system, IPEDS faculty categories).

See the [Glossary](core/glossary.md) for the full reference.

## HELIX Core: Terminologies (v0.1)

23 standardized code sets that eliminate "what does this code mean?" across institutions:

`student-status` · `enrollment-status` · `period-type` · `grade-mode` · `award-type` · `data-classification` · `gender` · `gender-identity` · `ethnicity` · `identifier-type` · `degree-level` · `delivery-mode` · `course-level` · `admission-status` · `hold-type` · `student-type` · `veteran-status` · `sap-status` · `constituent-type` · `gift-type` · `donor-segment` · `prospect-stage` · `enrollment-funnel-stage`

See the [Terminology Catalog](docs/terminology-catalog.md) for every valid code and definition.

## HELIX Bridge: ERP Mappings

Column-level mapping templates from 4 major ERP systems:

| ERP | Architecture | Mappings | Coverage |
|-----|-------------|----------|----------|
| **Oracle PeopleSoft** | Relational, effective-dated | **40 mappings** across CS (19), FIN (9), HCM (12) | 80-83% per module |
| **Ellucian Banner** | Relational (Oracle) | **13 mappings** across SIS (11), HR (2) | Core + extended SIS |
| **Workday** | Cloud-native (REST/business objects) | **26 mappings** across SIS (3), FIN (11), HR (12) | 80%+ coverage: SIS + Financial Management + HCM |
| **Ellucian Colleague** | Multi-valued (UniData/UniVerse) | 3 mappings | Core SIS resources |

PeopleSoft is the deepest Bridge — 40 mappings covering Student Records, Financial Aid, Admissions, Degree Audit, International/SEVIS, FERPA, General Ledger, AP, AR, Purchasing, Budgets, Grants, Assets, Expenses, Contracts, Core HR, Position Management, Compensation, Benefits, Payroll, Time & Labor, Recruiting, Absence/FMLA, Performance, Job Classification, Position Budgeting, and Learning Management. Workday is now the second-deepest Bridge — 26 mappings covering SIS (Student, Enrollment, AcademicPeriod), Financial Management (General Ledger, AP, AR/Student Financials, Budget, Purchasing, Grants/Sponsored Programs, Asset Management, Expenses/Travel, Contracts, Cost Center, Fund), and HCM (Worker/Employee, Position, Compensation, Benefits, Payroll, Time Tracking, Recruiting, Absence/FMLA, Performance, Job Classification/EEO/Faculty Rank, Learning Management, Position Budgeting). All mappings use Workday-native terminology (worktags, business objects, supervisory organizations) with 4 documented extraction methods.

See the [Bridge Reference](docs/bridge-reference.md) and [Migration Adventure Guide](docs/migration-adventure-guide.md) for details.

## HELIX Govern

| Component | Contents |
|-----------|----------|
| **Roles** | 6 governance roles (Data Trustee, CDO, Data Steward, Data Custodian, Data Consumer, HELIX Champion) with RACI matrix |
| **Quality Rules** | 22 rules across 5 domains with severity, testable expressions, and remediation |
| **Maturity Model** | 5 dimensions × 5 levels, aligned to conformance levels |
| **Domain Taxonomy** | 9 data domains with steward assignments and regulatory context |
| **RACI Matrix** | 18 activities × 5 roles with Responsible/Accountable/Consulted/Informed assignments |
| **Classification Handling** | 4 tiers (Public, Internal, Confidential, Restricted) with encryption, access, audit, masking, retention, sharing, and disposal rules — FERPA and GLBA specific guidance |
| **Data Dictionary** | 537-entry structured dictionary (JSON + CSV) of every resource attribute and terminology code — importable into Collibra, Alation, Atlan, Purview, AWS Glue |

See the [Govern Overview](docs/govern-overview.md) for details.

## HELIX Connect

OpenAPI 3.1 spec with 16 endpoints covering all core resources, bulk export (NDJSON + Parquet), resource validation, and OAuth 2.0 security with classification-aware scopes.

See the [Connect Overview](docs/connect-overview.md) for the full API reference.

## HELIX Agents: Downloadable AI Assistants

Ready-to-use AI agent templates that work with any LLM platform:

| Agent | What It Does | Best For |
|-------|-------------|----------|
| **[HELIX Migration Companion](agents/helix-migration-companion.json)** | Interactive guide to the entire HELIX framework with a 9-option menu. Combines all specialist knowledge into one conversational entry point. | Anyone starting with HELIX. Drop into ChatGPT, Gemini, Claude, Grok, Amazon Q, or Bedrock. |
| [PS-to-Workday FIN Agent](agents/ps-to-workday-fin-agent.json) | Chartfield-to-worktag mapping, GLBA guardrails, reconciliation | Finance teams migrating PeopleSoft to Workday |
| [Enrollment Analytics Agent](agents/enrollment-analytics-agent.json) | Funnel analysis, marketing ROI, melt prediction, interventions | Enrollment management and student success |
| [Advancement & Donor Agent](agents/advancement-donor-agent.json) | Stewardship acceleration, prospect identification, event briefings | Advancement and fundraising teams |
| [Banner-to-Lakehouse Agent](agents/banner-to-lakehouse-agent.json) | PIDM handling, STV lookups, dbt model generation | Banner institutions building data lakes |

**Setup:** Copy the `system_prompt` field from any agent JSON into your platform's system prompt / custom instructions. Upload the HELIX repository (or relevant files) as knowledge. Each agent template includes platform-specific setup guides for ChatGPT, Gemini, Claude, Grok, Amazon Q, and Bedrock.

---

## Conformance Levels

Institutions adopt HELIX progressively:

| Level | Name | What It Means |
|-------|------|---------------|
| **1** | **Explorer** | Reviewing HELIX resources as a reference model |
| **2** | **Aligned** | Data lake silver layer maps to HELIX Core schemas; passes validation |
| **3** | **Governed** | HELIX Govern templates implemented (roles, quality rules, classification) |
| **4** | **Contributor** | Publishing ERP mappings, profiles, or extensions back to the community |
| **5** | **Champion** | Certified conformance; serving as a reference implementation site |

---

## Design Principles

1. **Spec over software.** HELIX is a standard, not a product.
2. **80/20 pragmatism.** Cover the universal 80%. Let extensions handle the rest.
3. **Technology-neutral at the spec layer.** JSON Schema. No vendor lock-in.
4. **Platform-aware at the implementation layer.** Generators for Iceberg, dbt, Parquet, OpenAPI.
5. **Developer-friendly.** JSON + REST. Any web developer can implement it.
6. **Governance-native.** Every resource carries classification, ownership, and quality metadata.
7. **Evolutionary by design.** Versioned releases. Schema evolution without data rewrites.
8. **Globally scoped, locally profiled.** Base spec is international. Country profiles handle the rest.

---

## Existing Standards: How HELIX Relates

| Standard | Scope | HELIX Relationship |
|----------|-------|-------------------|
| **CEDS** | K-20 data element dictionary | HELIX aligns terminology; extends for ERP/lake integration |
| **Ed-Fi** | K-12 data exchange | Complementary. HELIX focuses on postsecondary. |
| **PESC** | Transcript/enrollment XML | Narrow scope. HELIX is broader. |
| **1EdTech** | Learning tool interoperability | Complementary. Covers LMS, not ERP/SIS. |
| **HESA** (UK) / **TCSI** (AU) | Country-specific reporting | Natural HELIX Implementation Profiles |

HELIX fills the gap none of them cover: **the ERP-to-lake foundational data model with embedded governance.**

---

## Repository Structure (179 files)

```
helix/
+-- README.md                          <-- You are here
+-- CONTRIBUTING.md                    <-- How to participate
+-- core/
|   +-- resources/                     <-- 19 JSON Schema resource definitions
|   +-- terminologies/                 <-- 23 standardized code sets
|   +-- glossary.md                    <-- Comprehensive higher ed taxonomy (34K words)
|   +-- data-dictionary.json           <-- 537-entry structured data dictionary
|   +-- data-dictionary.csv            <-- Same dictionary in spreadsheet format
|   +-- examples/                      <-- 3 post-migration use case examples
+-- connect/
|   +-- openapi.json                   <-- OpenAPI 3.1 API specification
+-- govern/
|   +-- roles.json                     <-- Governance role definitions
|   +-- quality-rules.json             <-- Data quality rule library (22 rules)
|   +-- maturity-model.json            <-- 5-dimension maturity assessment
|   +-- domain-taxonomy.json           <-- 9 data domains with steward assignments
|   +-- raci-matrix.json               <-- 18 activities x 5 roles (R/A/C/I)
|   +-- classification-handling-rules.json  <-- 4-tier handling (FERPA/GLBA)
+-- bridge/
|   +-- peoplesoft/                    <-- Oracle PeopleSoft mappings (40)
|   |   +-- cs/                        <-- Campus Solutions / SIS (19)
|   |   +-- fin/                       <-- Financials / FSCM (9)
|   |   +-- hcm/                       <-- Human Capital Management (12)
|   +-- banner/                        <-- Ellucian Banner mappings (13)
|   |   +-- sis/                       <-- Student Information System (11)
|   |   +-- hr/                        <-- Human Resources (2)
|   +-- workday/                       <-- Workday mappings (26)
|   |   +-- sis/                       <-- Student (3)
|   |   +-- fin/                       <-- Financial Management (11)
|   |   +-- hr/                        <-- Human Capital Management (12)
|   +-- colleague/                     <-- Ellucian Colleague mappings (3)
|   +-- xref/                          <-- Machine-readable cross-references
|       +-- ps-to-workday-fin/         <-- 4 dimensions, JSON + CSV
|           +-- account-xref.*         <-- 31 account mappings
|           +-- fund-xref.*            <-- 14 fund mappings
|           +-- department-xref.*      <-- 15 dept/cost center mappings
|           +-- program-xref.*         <-- 12 functional classifications
+-- agents/                            <-- Downloadable AI assistant templates
|   +-- helix-migration-companion.json <-- START HERE: unified guide
|   +-- ps-to-workday-fin-agent.json
|   +-- enrollment-analytics-agent.json
|   +-- advancement-donor-agent.json
|   +-- banner-to-lakehouse-agent.json
+-- tools/
|   +-- validate.py                    <-- Schema validation (JSON/NDJSON/CSV)
+-- docs/
    +-- helix-executive-summary.md     <-- One-pager for CIOs and leadership
    +-- cdo-quick-start.md             <-- 90-day governance quickstart guide
    +-- resource-catalog.md
    +-- terminology-catalog.md
    +-- bridge-reference.md
    +-- govern-overview.md
    +-- connect-overview.md
    +-- migration-adventure-guide.md        <-- "Choose your own adventure"
    +-- lakehouse-architecture-guide.md     <-- Medallion, FERPA/GLBA
```

---

## Getting Started

**New to higher ed data?** Start with the [Glossary](core/glossary.md) for a complete walkthrough of the student lifecycle, faculty taxonomy, and institutional infrastructure.

**Migrating ERPs or building a data lake?** Start with the [Migration Adventure Guide](docs/migration-adventure-guide.md) and the [Lakehouse Architecture Guide](docs/lakehouse-architecture-guide.md).

**Explore the data model:** Browse [core/resources/](core/resources/) or read the [Resource Catalog](docs/resource-catalog.md)

**Check the terminology:** Browse [core/terminologies/](core/terminologies/) or read the [Terminology Catalog](docs/terminology-catalog.md)

**See what's possible after migration:** Browse [core/examples/](core/examples/) for real-world use cases (advancement, COA cross-reference, enrollment analytics)

**Find your ERP mapping:** Browse [bridge/](bridge/) for Banner, PeopleSoft, Workday, or Colleague

**Review governance:** Browse [govern/](govern/) or read the [Govern Overview](docs/govern-overview.md)

**See the API:** Open [connect/openapi.json](connect/openapi.json) in [Swagger Editor](https://editor.swagger.io/) or read the [Connect Overview](docs/connect-overview.md)

**New CDO?** Read the [CDO Quick Start Guide](docs/cdo-quick-start.md) for a 90-day governance implementation plan.

**Briefing leadership?** Share the [Executive Summary](docs/helix-executive-summary.md) — a non-technical one-pager for CIOs, provosts, and presidents.

**Validating your data?** Use the [validation script](tools/validate.py) to check JSON, NDJSON, or CSV files against HELIX schemas.

**Contribute:** Read [CONTRIBUTING.md](CONTRIBUTING.md) and open an issue or pull request

---

## About the Founder

**Dr. Dallas Maddox, PhD** created HELIX from a career spent at the intersection of higher education and technology. With doctoral research focused on the systems and structures that power colleges and universities, Dallas saw the same pattern repeat at every institution: brilliant people solving the same data problems in isolation, duplicating millions of dollars in integration work with no shared benefit and no shared language.

HELIX exists because higher education deserves better tools — tools that accelerate innovation instead of consuming it, tools that free institutions to focus on what actually matters: the student experience, groundbreaking research, and community impact.

At its core, HELIX is about the human element. Behind every data record is a student navigating their future, a faculty member advancing knowledge, a financial aid counselor changing someone's life trajectory, a donor investing in a mission they believe in. The data infrastructure we build should honor that reality — not obscure it beneath layers of technical complexity. When we eliminate the friction of data integration, we give people back the time and clarity to do the work that drew them to higher education in the first place.

HELIX is an open, philanthropic effort. It is not a product, not a consultancy, and not owned by any vendor. It belongs to the higher education community.

The double helix is a fitting metaphor. Two strands — data and governance — wound together into a structure that carries the blueprint for something larger. HELIX is the blueprint.

---

*HELIX v0.1.8 — September 2026*
*Licensed under Apache 2.0*
