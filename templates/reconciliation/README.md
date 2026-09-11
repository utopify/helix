# HELIX Reconciliation Query Templates

SQL query templates for validating data integrity after ETL/migration to a HELIX-conformant lakehouse.

## When to Run

| Query | When | Frequency |
|-------|------|-----------|
| Row Count | After every ETL run | Daily |
| Financial Balance | After GL load, before month-end close | Daily / Monthly |
| Enrollment Headcount | After enrollment load, especially at census | Per term |
| Student Record Completeness | After initial migration + weekly | Weekly |
| Identity Match | After initial migration | Once + spot checks |
| Financial Aid Disbursement | After aid load | Per term |
| Grade Distribution | After grading period close | Per term |
| Duplicate Detection | After initial migration + quarterly | Quarterly |
| Data Freshness | Continuously | Hourly / Daily |

## How to Use

1. Replace parameter placeholders (`:source_schema`, `:helix_schema`, `:academic_period`) with your actual values
2. Adjust warehouse-specific syntax (see notes in each file)
3. Review the "What Passing Looks Like" section in each file header
4. Set up automated alerts for critical reconciliation failures

## Parameter Reference

| Parameter | Description | Example |
|-----------|-------------|---------|
| `:source_schema` | Schema containing source/Bronze data | `bronze_ps` |
| `:helix_schema` | Schema containing Silver HELIX data | `silver` |
| `:gold_schema` | Schema containing Gold consumption data | `gold` |
| `:academic_period` | Term/period code to reconcile | `2026FA` |
| `:fiscal_year` | Fiscal year for financial reconciliation | `2026` |
| `:tolerance` | Acceptable variance threshold | `0.01` |
