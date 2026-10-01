# Customization Discovery Toolkit

Queries, tools, prompts, and a register for finding and converting PeopleSoft and Banner customizations. The method is in [`docs/conversion/customization-discovery.md`](../../docs/conversion/customization-discovery.md).

| Item | What it is |
|------|-----------|
| `peoplesoft/` | 12 inventory queries over the PeopleTools tables (records, fields, PeopleCode, SQL, App Engine, pages, queries, processes, Integration Broker, translate values, quick triage) |
| `banner/` | 10 inventory queries over the Oracle data dictionary and Banner tables (objects, source, columns, triggers, views, dependencies, Job Submission, validation codes, Self-Service, hidden integrations) |
| `conversion-prompts/` | 5 Amazon Bedrock prompt templates: PL/SQL to PostgreSQL, PL/SQL to dbt, PeopleCode to business rules, SQR to dbt, and batch programs to AWS Glue |
| `customization-register.csv` | Empty register with every column |
| `customization-register.schema.json` | What each column means and the allowed values |
| `customization-register.example.csv` | Seven filled rows (Banner and PeopleSoft) showing each kind of disposition |
| `sample/` | A small fictional baseline and production inventory, and the register the diff tool produced from them |

## Run it

```
# 1. Inventory: run each query against the vanilla baseline and production; save as CSV
# 2. Fingerprint server files
python tools/inventory_source_files.py --root <delivered_dir> --out baseline_files.csv
python tools/inventory_source_files.py --root <installed_dir> --out production_files.csv
# 3. Diff
python tools/diff_customizations.py --baseline baseline.csv --production production.csv \
  --source-system banner --case-insensitive --out customization-register.csv
```

Every query returns the same columns (`object_type, object_name, sub_key, seq, owner, last_updated, last_updated_by, definition_text`), so outputs from different queries can be combined into one file per side.

Queries marked **FLAG** reference tables or columns that differ by release. Confirm them against your installation before running.
