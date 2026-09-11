/*
  HELIX Reconciliation: Grade Distribution
  ===========================================================================
  What it checks: Grade distribution (count of each grade per term) matches
                  between source and HELIX. Ensures grading data integrity.

  When to run: After grading period close.

  What passing looks like:
    - Same count of each grade per term in source vs HELIX
    - No grades in HELIX that don't exist in source

  Parameters:
    :source_schema    — Source enrollment/grading schema
    :helix_schema     — HELIX Silver schema
    :academic_period  — Term code
*/

with source_grades as (
    select
        final_grade,
        count(*) as grade_count
    from :source_schema.enrollment
    where term_code = :academic_period
      and final_grade is not null
    group by final_grade
),

helix_grades as (
    select
        final_grade,
        count(*) as grade_count
    from :helix_schema.helix_enrollment
    where period_ref = :academic_period
      and final_grade is not null
    group by final_grade
)

select
    coalesce(s.final_grade, h.final_grade) as grade,
    coalesce(s.grade_count, 0) as source_count,
    coalesce(h.grade_count, 0) as helix_count,
    coalesce(s.grade_count, 0) - coalesce(h.grade_count, 0) as variance,
    case
        when coalesce(s.grade_count, 0) = coalesce(h.grade_count, 0) then 'PASS'
        when s.grade_count is null then 'WARN: Grade only in HELIX'
        when h.grade_count is null then 'WARN: Grade only in source'
        else 'FAIL: Count mismatch'
    end as status
from source_grades s
full outer join helix_grades h on s.final_grade = h.final_grade
order by grade;
