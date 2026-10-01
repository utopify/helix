# HELIX Templates

Ready-to-use project templates and query libraries for implementing HELIX.

## Contents

### `intake/`: Institution Profile *New in v0.7.0*

Step 1 of [START_HERE](../START_HERE.md). A fill-in profile of your source systems, identity, target platform, governance contacts, and first slice, plus a machine-readable YAML version and a filled-in PeopleSoft example.


### `ps-to-workday/` — PeopleSoft to Workday Toolkit (22 files) *New in v0.6.0*

The executable half of the HELIX cornerstone path:
- **`worktag-conversion-rules.json`**: 20 chartfield to worktag rules with precedence, fallbacks, suspense handling, and 5 worked examples, plus 10 HCM field rules and 13 Student field rules (6 for financial aid)
- **`reconciliation/`**: 22 PS to Workday tie-outs (6 FIN, 6 HCM, 6 Student, 4 Aid) with run order, tolerances, parallel-run cadence, and sign-off roles. Includes payroll parallel compare, GPA recompute, and a zero-miss FERPA restriction carryover gate.


### `customization-discovery/`: Customization Discovery Toolkit *New in v0.9.0*

Find every PeopleSoft and Banner customization and decide what happens to each:
- **`peoplesoft/`** (12 queries) and **`banner/`** (10 queries): inventories to run against a vanilla baseline and production
- **`customization-register.csv`**, its schema, and a filled example
- **`conversion-prompts/`**: 5 Amazon Bedrock prompts (PL/SQL to PostgreSQL, PL/SQL to dbt, PeopleCode to business rules, SQR to dbt, batch to AWS Glue)
- **`sample/`**: a fictional inventory pair and the register the diff tool produced

Use with `tools/diff_customizations.py` and `tools/inventory_source_files.py`. Method: `docs/conversion/`.

### `dbt/` — dbt Starter Project (27 files)

A complete dbt project implementing the HELIX medallion architecture:
- **Staging models** (4): Bronze → cleaned, typed data
- **Silver models** (4): Staging → HELIX Core resources with UUID, dedup, FERPA
- **Gold models** (3): Silver → consumption-ready dimensions, facts, reports
- **Macros** (4): HELIX UUID generation, classification tagging, FERPA-safe views, source metadata
- **Tests** (4): Quality rule implementations from `govern/quality-rules.json`
- **Seeds** (1): All 595 HELIX terminology codes as a CSV lookup table
- **Config** (3): dbt_project.yml, profiles.yml.example, packages.yml
- **README**: Setup guide with ERP configuration table

### `reconciliation/` — Reconciliation Query Templates (10 files)

SQL templates for post-migration and ongoing data validation:

| Query | What It Validates |
|-------|-------------------|
| Row Count | Bronze vs Silver vs Gold row counts per resource |
| Financial Balance | GL trial balance: must tie to the penny |
| Enrollment Headcount | Census headcount by level and FT/PT |
| Student Completeness | Required field population rates |
| Identity Match | Cross-system identity resolution rates |
| Financial Aid Disbursement | Aid totals by type and term |
| Grade Distribution | Grade counts by term |
| Duplicate Detection | Fuzzy person matching (name + DOB + email) |
| Data Freshness | Staleness check across all layers |

All queries are warehouse-agnostic with notes for Snowflake, Redshift, and BigQuery syntax differences.
