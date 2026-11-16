# Gold metric: Census headcount

**Id:** `census_headcount` · **Domain:** Enrollment & Registration · **Owner:** University Registrar · **Output classification:** internal

**Approved:** not yet approved

## Grain

One number per academic period, broken down by level, full or part time, and program

## Population

- Students with at least one Enrollment in the period whose enrollment_status is registered, enrolled, completed, or incomplete as of the period's census_date
- Exclude auditing-only and dropped enrollments
- Count each student once

## Formula

COUNT(DISTINCT enrollment.student_ref) as of academic_period.census_date

## Source columns

- `helix_silver.enrollment.student_ref`
- `helix_silver.enrollment.enrollment_status`
- `helix_silver.enrollment.enrollment_date`
- `helix_silver.enrollment.drop_date`
- `helix_silver.enrollment.academic_period_ref`
- `helix_silver.academic_period.census_date`
- `helix_silver.student.academic_level`
- `helix_silver.student.full_part_time`

## Standard

IPEDS Fall Enrollment (12-month and fall census); state reporting may define census differently

## Suppression

Suppress any cell under 5 when published by demographic

## Notes

Use the snapshot taken at census, not today's enrollment rows; late drops change history otherwise.

Defined in `templates/context/gold-metrics.yaml`. Don't answer this metric any other way.
