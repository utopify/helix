/*
  HELIX Reconciliation: Enrollment Headcount by Term
  ===========================================================================
  What it checks: Unduplicated headcount by term, academic level, and FT/PT
                  status. This is the number reported to IPEDS and used for
                  budget models — it must match the source.

  When to run: After enrollment load, especially at census date.

  What passing looks like:
    - source_headcount = helix_headcount for every combination
    - Variance of ±1% is typical (timing differences in data extraction)
    - At census date: MUST be exact match

  Parameters:
    :source_schema    — Source enrollment schema
    :helix_schema     — HELIX Silver schema
    :academic_period  — Term code (e.g., '2026FA')
*/

with source_headcount as (
    select
        academic_level,
        full_part_time,
        count(distinct student_id) as headcount
    from :source_schema.enrollment
    where term_code = :academic_period
      and enrollment_status in ('enrolled', 'registered')  -- adjust for your source
    group by academic_level, full_part_time
),

helix_headcount as (
    select
        s.academic_level,
        s.full_part_time,
        count(distinct e.student_ref) as headcount
    from :helix_schema.helix_enrollment e
    inner join :helix_schema.helix_student s
        on e.student_ref = s.helix_id
    where e.period_ref = :academic_period
      and e.enrollment_status = 'enrolled'
    group by s.academic_level, s.full_part_time
)

select
    coalesce(s.academic_level, h.academic_level)           as academic_level,
    coalesce(s.full_part_time, h.full_part_time)           as full_part_time,
    coalesce(s.headcount, 0)                               as source_headcount,
    coalesce(h.headcount, 0)                               as helix_headcount,
    coalesce(s.headcount, 0) - coalesce(h.headcount, 0)    as variance,
    case
        when abs(coalesce(s.headcount, 0) - coalesce(h.headcount, 0)) = 0 then 'PASS'
        when abs(coalesce(s.headcount, 0) - coalesce(h.headcount, 0)) <= 
             0.01 * greatest(coalesce(s.headcount, 1), coalesce(h.headcount, 1))
            then 'WARN: Within 1%'
        else 'FAIL: Exceeds 1% variance'
    end                                                    as status
from source_headcount s
full outer join helix_headcount h
    on s.academic_level = h.academic_level
    and s.full_part_time = h.full_part_time
order by academic_level, full_part_time;
