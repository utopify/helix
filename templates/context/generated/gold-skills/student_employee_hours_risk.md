# Gold metric: Students working over 20 hours a week

**Id:** `student_employee_hours_risk` · **Domain:** Financial Aid · **Owner:** Director of Student Success · **Output classification:** confidential

**Approved:** not yet approved

## Grain

Per academic period

## Population

- Undergraduates enrolled at census with a StudentEmployment record active in the period

## Formula

Students whose hours_per_week_max is over 20 / enrolled undergraduates with campus jobs

## Source columns

- `helix_silver.student_employment.hours_per_week_max`
- `helix_silver.student_employment.position_start_date`
- `helix_silver.student_employment.position_end_date`
- `helix_silver.student.academic_level`
- `helix_silver.enrollment.student_ref`

## Standard

Institutional

## Suppression

Aggregate only outside advising and student employment roles

## Notes

Crosses the student system and HR. One of the questions no single vendor's analytics can answer.

Defined in `templates/context/gold-metrics.yaml`. Don't answer this metric any other way.
