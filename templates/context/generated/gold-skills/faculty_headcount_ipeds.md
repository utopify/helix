# Gold metric: Faculty headcount by rank and tenure

**Id:** `faculty_headcount_ipeds` · **Domain:** Human Resources · **Owner:** Director of HR Systems · **Output classification:** internal

**Approved:** not yet approved

## Grain

Per November 1 snapshot

## Population

- Employees with employment_status active on November 1 whose job classification is instructional

## Formula

COUNT(DISTINCT employee.helix_id) by job_classification.academic_rank and tenure_status

## Source columns

- `helix_silver.employee.employment_status`
- `helix_silver.employee.hire_date`
- `helix_silver.employee.termination_date`
- `helix_silver.job_classification.academic_rank`
- `helix_silver.job_classification.tenure_status`
- `helix_silver.job_classification.ipeds_faculty_category`

## Standard

IPEDS Human Resources (HR) survey

## Suppression

Suppress subgroup cells under 5

## Notes

Workday has no delivered tenure or rank fields; see the JobClassification mapping.

Defined in `templates/context/gold-metrics.yaml`. Don't answer this metric any other way.
