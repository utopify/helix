# Gold metric: Admissions yield

**Id:** `admissions_yield` · **Domain:** Enrollment & Registration · **Owner:** Director of Admissions · **Output classification:** internal

**Approved:** not yet approved

## Grain

Per admit period, application type, and program

## Population

- Applications with application_status admitted or conditionally_admitted

## Formula

Admitted applicants enrolled at census / admitted applicants

## Source columns

- `helix_silver.admission_application.application_status`
- `helix_silver.admission_application.admit_period_ref`
- `helix_silver.admission_application.application_type`
- `helix_silver.admission_application.program_ref`
- `helix_silver.enrollment.student_ref`
- `helix_silver.academic_period.census_date`

## Standard

Common Data Set C1 definitions

## Suppression

Suppress subgroups under 5

## Notes

Use enrollment at census, not deposit, as the numerator.

Defined in `templates/context/gold-metrics.yaml`. Don't answer this metric any other way.
