# Gold metric: Graduation rate within 150 percent of normal time

**Id:** `graduation_rate_150` · **Domain:** Outcomes · **Owner:** Director of Institutional Research · **Output classification:** internal

**Approved:** not yet approved

## Grain

Per entering cohort

## Population

- IPEDS Graduation Rates cohort (first-time, full-time, degree-seeking)
- Same allowable exclusions as retention

## Formula

Cohort members with a conferred degree within 6 years (bachelor's) or 3 years (associate) of entry / adjusted cohort

## Source columns

- `helix_silver.student.cohort`
- `helix_silver.degree.student_ref`
- `helix_silver.degree.conferral_date`
- `helix_silver.degree.degree_level`
- `helix_silver.degree.degree_status`

## Standard

IPEDS Graduation Rates (GR)

## Suppression

Suppress subgroups under 5

## Notes

Count degrees from this institution only; transfers-out are reported separately.

Defined in `templates/context/gold-metrics.yaml`. Don't answer this metric any other way.
