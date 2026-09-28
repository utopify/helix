# HELIX Templates

Ready-to-use project templates and query libraries for implementing HELIX.

## Contents

### `ps-to-workday/` — PeopleSoft to Workday Toolkit (22 files) *New in v0.6.0*

The executable half of the HELIX cornerstone path:
- **`worktag-conversion-rules.json`**: 20 chartfield to worktag rules with precedence, fallbacks, suspense handling, and 5 worked examples, plus 10 HCM field rules and 7 Student field rules
- **`reconciliation/`**: 18 PS to Workday tie-outs (6 FIN, 6 HCM, 6 Student) with run order, tolerances, parallel-run cadence, and sign-off roles. Includes payroll parallel compare, GPA recompute, and a zero-miss FERPA restriction carryover gate.


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
