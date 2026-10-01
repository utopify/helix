# Customization Discovery and Conversion: The Method

Twenty years of PeopleSoft or Banner leaves a lot behind: custom tables, extra columns on delivered tables, modified PeopleCode and PL/SQL, local jobs, reports nobody remembers writing, and integrations buried in code. Before you move to Workday, Banner SaaS, or a lakehouse, you need to know what all of it is, whether anyone still uses it, and what happens to each piece.

This method finds every difference between your installation and a vanilla one, records each in a register, decides what to do with it, and converts the parts worth keeping.

- PeopleSoft specifics: [`peoplesoft-customizations.md`](peoplesoft-customizations.md)
- Banner specifics: [`banner-customizations.md`](banner-customizations.md)
- AWS services for each step: [`../aws-services-guide.md`](../aws-services-guide.md)
- Queries, register, and prompts: [`../../templates/customization-discovery/`](../../templates/customization-discovery/)
- Agent: [`../../agents/customization-discovery-agent.json`](../../agents/customization-discovery-agent.json)

---

## The seven steps

| Step | Do this | Done when |
|------|---------|-----------|
| 1. Baseline | Stand up a vanilla copy at the same release and patch level you run | You can run the same queries against vanilla and production |
| 2. Inventory | Run the inventory queries against both, and fingerprint file-based code | You have two fingerprint files with the same columns |
| 3. Diff | Run `tools/diff_customizations.py` | Every added, modified, and removed object is a row in the register |
| 4. Enrich | Add usage, owner, and which HELIX resources each object touches | Every row has a last-run date (or "no evidence") and a business owner |
| 5. Decide | Give every row a disposition and a target | No row is blank |
| 6. Convert | Convert only rows marked `convert`, using the tools in section 4 | Converted code is in version control next to the original |
| 7. Prove | Run old and new against the same data and compare outputs | Outputs match, and the business owner signs the row |

### 1. Baseline

The baseline is what the vendor delivered, at exactly the release you run. Comparing against a newer or older release turns every vendor change into a false "customization."

- **PeopleSoft:** the PeopleSoft Update Manager (PUM) image for your application at your current image level, or a demo (DMO) database patched to the same PeopleTools and bundle level.
- **Banner:** a clean database built from Ellucian's release deliverables at the same release levels you have installed, or the delivered source files for those releases.

### 2. Inventory

Run the same queries against baseline and production. Each query returns the same columns, so the two outputs can be compared directly:

| Column | Meaning |
|--------|---------|
| `object_type` | RECORD, PEOPLECODE, PACKAGE_BODY, TRIGGER, JOB, and so on |
| `object_name` | The object |
| `sub_key` | Part of the object, such as a field on a record or the event of a PeopleCode program |
| `seq` | Line or chunk number, when text is split across rows |
| `owner` | Schema or object owner |
| `last_updated` | Last change date |
| `last_updated_by` | Who changed it (PeopleSoft records this; Oracle doesn't) |
| `definition_text` | The definition or source text, or a precomputed `fingerprint` |

Also fingerprint file-based code (SQR, COBOL, Pro*C, shell scripts) with `tools/inventory_source_files.py`. That code lives on servers, not in the database, so database queries alone miss it. AWS DataSync can copy those directories to S3 first.

### 3. Diff

```
python tools/diff_customizations.py \
  --baseline baseline_inventory.csv \
  --production production_inventory.csv \
  --source-system peoplesoft \
  --out customization-register.csv
```

The tool joins text split across rows, normalizes whitespace, hashes each object, and writes one register row per difference: `added` (not in vanilla), `modified` (in vanilla but different), or `removed` (in vanilla, gone from production, which usually means a delivered object was deleted or renamed).

### 4. Enrich

A list of differences isn't useful until you know which ones matter. Add for each row:
- **Usage:** last run and runs in the last 12 months, from the process scheduler, job submission history, or query statistics. If history gets purged, record "no evidence," not "unused."
- **Owner:** the business owner who can say whether it's still needed.
- **Data touched:** the tables it reads and writes, mapped to HELIX resources through the bridge files. This tells you which conversions depend on it.
- **Size and complexity:** lines of code and a low, medium, or high rating.

### 5. Decide

Every row gets one disposition:

| Disposition | Meaning | Typical example |
|-------------|---------|-----------------|
| `retire` | Not needed anymore | A report that hasn't run in three years |
| `configure` | The target does this out of the box with setup | A custom field the target already has |
| `rebuild` | The target needs it, but it has to be rebuilt in the target's own tools | PeopleCode validation becomes a Workday business process condition |
| `convert` | Translate the code into a target database or lakehouse | Banner PL/SQL report logic becomes SQL on Aurora PostgreSQL |
| `preserve_as_data` | Keep the data, drop the code | A custom table of historical data loaded into the lakehouse |
| `crosswalk` | It's a local code value, not code | A custom translate value or validation code, added as a crosswalk row |

What's possible depends on the target:

| Target | What you can carry over |
|--------|--------------------------|
| **Lakehouse or a new database** | Most custom tables, views, PL/SQL, and report logic can be **converted** |
| **Workday** | Code doesn't move. Customizations are **rebuilt** as configuration, business process conditions, custom objects, calculated fields, reports, or integrations, or **retired** |
| **Banner SaaS** | No customer database objects. Data-changing customizations are **rebuilt** through Ethos, Banner Integration API, or Ellucian-supported extensibility; reporting and batch logic is **converted** to run against the Data Connect copy or the lakehouse |

### 6. Convert

| Code | Target | Tool |
|------|--------|------|
| Oracle PL/SQL, views, triggers | Aurora PostgreSQL, RDS for PostgreSQL, Redshift | AWS DMS Schema Conversion, including its generative AI option; Amazon Bedrock for what's left |
| Report logic (PL/SQL, SQR, PeopleSoft SQL) | Lakehouse (dbt or Glue) | Amazon Bedrock with the prompts in `templates/customization-discovery/conversion-prompts/` |
| PeopleCode | Workday requirements | Amazon Bedrock to extract plain-English business rules; AWS Transform for codebase analysis |
| App Engine, COBOL, Pro*C | Glue PySpark, Step Functions, Lambda | AWS Transform and Amazon Bedrock |

Point converted code at **HELIX silver**, not at copies of the old ERP tables, wherever you can. Then the converted logic survives the next ERP change too.

### 7. Prove

Code that compiles isn't done. Run the original against the source and the conversion against the target with the same inputs, then compare outputs row for row. Use the reconciliation templates' approach: zero differences, or each difference explained and signed off.

---

## Rules

- **Convert only what you're keeping.** The register decides before anyone runs a converter.
- **No production data in prompts.** Send code and table definitions to a model, never student or employee rows. Use synthetic examples if needed.
- **Watch for hidden integrations.** Database links, `UTL_HTTP`, `UTL_FILE`, `UTL_SMTP`, Integration Broker routings, and file drops are integrations. Every one needs a new home.
- **FERPA and GLBA travel with the logic.** If custom code read restricted data, the converted version inherits the same access rules (`govern/access-control-matrix.json`).
- **Version-control the originals.** Commit the extracted source next to the conversion so reviewers can compare them.

*HELIX v0.9.0, October 2026*
