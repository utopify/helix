# HELIX Templates

Ready-to-use project templates and query libraries for implementing HELIX.

## Contents

### `dbt/` — dbt Starter Project (27 files)

A complete dbt project implementing the HELIX medallion architecture:
- **Staging models** (4): Bronze → cleaned, typed data
- **Silver models** (4): Staging → HELIX Core resources with UUID, dedup, FERPA
- **Gold models** (3): Silver → consumption-ready dimensions, facts, reports
- **Macros** (4): HELIX UUID generation, classification tagging, FERPA-safe views, source metadata
- **Tests** (4): Quality rule implementations from `govern/quality-rules.json`
- **Seeds** (1): All 435 HELIX terminology codes as a CSV lookup table
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
