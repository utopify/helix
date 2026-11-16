# Gold metric: Summer melt

**Id:** `summer_melt` · **Domain:** Enrollment & Registration · **Owner:** Director of Admissions · **Output classification:** internal

**Approved:** not yet approved

## Grain

Per fall admit period

## Population

- Admitted applicants with enrollment_deposit_paid true or enrollment_intent confirmed

## Formula

Confirmed admits not enrolled at fall census / confirmed admits

## Source columns

- `helix_silver.admission_application.enrollment_deposit_paid`
- `helix_silver.admission_application.enrollment_intent`
- `helix_silver.admission_application.admit_period_ref`
- `helix_silver.enrollment.student_ref`
- `helix_silver.academic_period.census_date`

## Standard

Institutional definition; document whether deposit or intent defines confirmed

## Suppression

Suppress subgroups under 5

## Notes

See core/examples for the melt risk model built on this population.

Defined in `templates/context/gold-metrics.yaml`. Don't answer this metric any other way.
