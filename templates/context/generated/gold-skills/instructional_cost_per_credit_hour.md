# Gold metric: Instructional cost per credit hour

**Id:** `instructional_cost_per_credit_hour` · **Domain:** Financial Operations · **Owner:** Director of Budget · **Output classification:** internal

**Approved:** not yet approved

## Grain

Per department and fiscal year

## Population

- Instructional salary and benefit expense coded to instruction
- Credit hours from sections owned by the department

## Formula

Instructional expense / SUM(enrollment.credit_hours_attempted) for sections the department owns

## Source columns

- `helix_silver.gl_transaction`
- `helix_silver.course_section.academic_org_ref`
- `helix_silver.enrollment.credit_hours_attempted`

## Standard

Delaware Cost Study style; document your expense rules

## Suppression

None at department level

## Notes

Needs Financials, HR, and the student system in one place. Write the expense account rules into this definition.

Defined in `templates/context/gold-metrics.yaml`. Don't answer this metric any other way.
