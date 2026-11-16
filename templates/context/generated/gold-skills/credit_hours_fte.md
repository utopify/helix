# Gold metric: Credit hours and FTE

**Id:** `credit_hours_fte` · **Domain:** Enrollment & Registration · **Owner:** University Registrar · **Output classification:** internal

**Approved:** not yet approved

## Grain

Per academic period and level

## Population

- Same as census headcount

## Formula

SUM(enrollment.credit_hours_attempted) at census; FTE = undergraduate credit hours / 15 + graduate credit hours / 12 for a semester (set divisors to your state or IPEDS rule)

## Source columns

- `helix_silver.enrollment.credit_hours_attempted`
- `helix_silver.enrollment.enrollment_status`
- `helix_silver.academic_period.census_date`
- `helix_silver.student.academic_level`

## Standard

IPEDS 12-month enrollment instructional activity; divisors vary by calendar and state

## Suppression

None at institution level

## Notes

Write the divisors into the metric, not into a dashboard.

Defined in `templates/context/gold-metrics.yaml`. Don't answer this metric any other way.
