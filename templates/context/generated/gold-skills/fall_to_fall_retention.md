# Gold metric: Fall-to-fall retention (first-time, full-time)

**Id:** `fall_to_fall_retention` · **Domain:** Outcomes · **Owner:** Director of Institutional Research · **Output classification:** internal

**Approved:** not yet approved

## Grain

Per entering fall cohort

## Population

- Cohort: student_type first_time_freshman, full_part_time full_time, entering in a fall period
- Exclude students who left for the IPEDS-allowed reasons (death, total disability, military, foreign service, official church mission)

## Formula

Cohort members enrolled at the next fall census, or who completed a credential before it, / cohort size

## Source columns

- `helix_silver.student.student_type`
- `helix_silver.student.full_part_time`
- `helix_silver.student.cohort`
- `helix_silver.student.admit_period_ref`
- `helix_silver.enrollment.student_ref`
- `helix_silver.enrollment.academic_period_ref`
- `helix_silver.academic_period.census_date`
- `helix_silver.degree.conferral_date`

## Standard

IPEDS Fall Enrollment retention rate

## Suppression

Suppress subgroup rates when the subgroup cohort is under 5

## Notes

Freeze the cohort at the entering census and never re-derive it from current student rows.

Defined in `templates/context/gold-metrics.yaml`. Don't answer this metric any other way.
