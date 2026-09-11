# HELIX dbt Starter Project

A ready-to-run dbt project implementing the HELIX medallion lakehouse architecture:
**Bronze → Silver (HELIX Core) → Gold (Consumption)**.

## What This Is

This project provides:
- **Staging models** that clean and type-cast raw Bronze data
- **Silver models** that transform staged data into HELIX Core resources with UUID assignment, deduplication, and FERPA flags
- **Gold models** that produce consumption-ready dimensions, facts, and reports
- **Macros** for HELIX-specific operations (UUID generation, FERPA-safe views, classification tagging)
- **Quality rule tests** implementing all 22 rules from `govern/quality-rules.json`
- **Seed data** with all 435 HELIX terminology codes for reference lookups

## Prerequisites

- **dbt-core** 1.7+ (`pip install dbt-core`)
- **Warehouse adapter**: one of `dbt-snowflake`, `dbt-redshift`, `dbt-databricks`, `dbt-bigquery`
- A data warehouse with Bronze layer tables already populated

## Quick Start

```bash
# 1. Clone or copy this project
cp -r templates/dbt/ ~/projects/helix-dbt/
cd ~/projects/helix-dbt/

# 2. Configure your connection
cp profiles.yml.example ~/.dbt/profiles.yml
# Edit ~/.dbt/profiles.yml with your warehouse credentials

# 3. Install packages
dbt deps

# 4. Load seed data (HELIX terminology lookup tables)
dbt seed

# 5. Set your source system and run
dbt run --vars '{source_system: peoplesoft_cs}'

# 6. Run quality tests
dbt test --select tag:helix_quality
```

## Configuring for Your ERP Source

Set the `source_system` variable to match your ERP:

| Source System | Variable Value | Bridge Reference |
|--------------|----------------|------------------|
| PeopleSoft Campus Solutions | `peoplesoft_cs` | `bridge/peoplesoft/cs/` |
| PeopleSoft Financials | `peoplesoft_fin` | `bridge/peoplesoft/fin/` |
| PeopleSoft HCM | `peoplesoft_hcm` | `bridge/peoplesoft/hcm/` |
| Ellucian Banner | `banner` | `bridge/banner/` |
| Workday Student | `workday_sis` | `bridge/workday/sis/` |
| Workday Financials | `workday_fin` | `bridge/workday/fin/` |
| Workday HCM | `workday_hr` | `bridge/workday/hr/` |
| Ellucian Colleague | `colleague` | `bridge/colleague/` |

Your staging models should map source-specific column names to the HELIX attribute names shown in the bridge mapping files.

## Project Structure

```
├── dbt_project.yml              — Project configuration
├── profiles.yml.example         — Example warehouse connections
├── packages.yml                 — dbt-utils + dbt-expectations
├── models/
│   ├── staging/                 — Bronze → Staging (clean, type-cast)
│   │   ├── _staging_models.yml  — Source definitions
│   │   ├── stg_person.sql
│   │   ├── stg_student.sql
│   │   ├── stg_enrollment.sql
│   │   └── stg_fin_aid_award.sql
│   ├── silver/                  — Staging → HELIX Core (dedup, UUID, FERPA)
│   │   ├── _silver_models.yml   — Model docs + column tests
│   │   ├── helix_person.sql
│   │   ├── helix_student.sql
│   │   ├── helix_enrollment.sql
│   │   └── helix_fin_aid_award.sql
│   └── gold/                    — Silver → Consumption (dimensions, facts, reports)
│       ├── _gold_models.yml
│       ├── dim_student.sql      — Student dimension (Person + Student joined)
│       ├── fct_enrollment.sql   — Enrollment fact table
│       └── rpt_retention.sql    — Fall-to-fall retention cohort analysis
├── macros/
│   ├── helix_uuid.sql           — Deterministic UUID generation
│   ├── helix_classify.sql       — Data classification table comments
│   ├── ferpa_safe.sql           — FERPA directory-info safe view builder
│   └── source_system_meta.sql   — Source system metadata columns
├── tests/
│   ├── helix_quality_rules.yml  — dbt tests for HELIX quality rules
│   └── custom/                  — Custom SQL tests
│       ├── test_student_has_person.sql
│       ├── test_enrollment_valid_status.sql
│       └── test_gpa_range.sql
└── seeds/
    └── helix_terminologies.csv  — All 435 HELIX terminology codes
```

## Extending with Additional Resources

To add a new HELIX resource (e.g., Course, Program, Degree):

1. **Create a staging model** in `models/staging/stg_{resource}.sql`
   - Map source columns to HELIX attribute names
   - Apply type casting and basic cleaning
   - Include `{{ source_system_meta() }}` for lineage tracking

2. **Create a silver model** in `models/silver/helix_{resource}.sql`
   - Use `{{ helix_uuid() }}` for ID generation
   - Resolve foreign key references
   - Apply FERPA flags if the resource is an education record

3. **Add tests** referencing the quality rules for that resource

4. **Add a gold model** if needed for consumption

## FERPA & GLBA Compliance

- All Silver models on education records include `_helix_is_education_record = true`
- Financial aid models include `_helix_is_glba_covered = true`
- Use the `{{ ferpa_safe() }}` macro to build directory-safe views
- See `govern/ferpa-disclosure-framework.json` for disclosure rules
- See `govern/glba-safeguards-framework.json` for GLBA controls

## Quality Rules

The test suite implements the 22 quality rules from `govern/quality-rules.json`:

| Rule ID | Domain | What It Tests |
|---------|--------|--------------|
| QR-SI-001 | Student Identity | Person must have last name |
| QR-SI-002 | Student Identity | Email format validation |
| QR-SI-003 | Student Identity | Date of birth reasonability |
| QR-SI-004 | Student Identity | Student → Person reference integrity |
| QR-SI-005 | Student Identity | Student status terminology |
| QR-EN-001 | Enrollment | Enrollment status terminology |
| QR-EN-002 | Enrollment | Credits non-negative |
| QR-EN-003 | Enrollment | Credits earned ≤ attempted |
| QR-FA-001 | Financial Aid | Disbursed ≤ accepted ≤ offered |
| QR-FA-002 | Financial Aid | SAP status terminology |
| QR-FA-003 | Financial Aid | Award type terminology |

Run all quality tests: `dbt test --select tag:helix_quality`
