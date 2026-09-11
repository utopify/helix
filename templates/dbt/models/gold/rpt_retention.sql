{{
  config(
    materialized='table',
    tags=['gold', 'report', 'ipeds', 'consumption']
  )
}}

/*
  HELIX Gold: Fall-to-Fall Retention Cohort Report

  Methodology:
  - Identifies first-time freshmen (student_type = 'first_time_freshman') at fall census
  - Checks if the same student appears enrolled in the following fall term
  - Retention rate = (returned in fall N+1) / (cohort in fall N)

  IPEDS: This aligns with the IPEDS Fall Enrollment survey retention rate calculation.
  Cohort is defined as first-time, full-time (or first-time, part-time) degree-seeking
  undergraduates.
*/

with fall_cohort as (
    -- First-time freshmen in their entry fall term
    select
        s.helix_id                                        as student_helix_id,
        s.student_type,
        s.full_part_time,
        s.is_international,
        s.is_first_generation,
        s.veteran_status,
        s.cumulative_gpa,
        e.period_ref                                      as entry_term,
        -- Extract year from period (assumes period format like '2025FA')
        left(e.period_ref, 4)                             as entry_year
    from {{ ref('helix_student') }} s
    inner join {{ ref('helix_enrollment') }} e
        on s.helix_id = e.student_ref
    where s.student_type = 'first_time_freshman'
      and e.enrollment_status = 'enrolled'
      -- Filter to fall terms (customize for your period naming convention)
      and e.period_ref like '%FA%'
),

next_fall_enrollment as (
    -- Check if cohort students appear in the next fall
    select distinct
        student_ref                                       as student_helix_id,
        period_ref                                        as return_term
    from {{ ref('helix_enrollment') }}
    where enrollment_status = 'enrolled'
      and period_ref like '%FA%'
),

retention as (
    select
        c.student_helix_id,
        c.entry_term,
        c.entry_year,
        c.full_part_time,
        c.is_international,
        c.is_first_generation,
        c.veteran_status,
        case
            when n.student_helix_id is not null then true
            else false
        end                                               as retained,
        n.return_term

    from fall_cohort c
    left join next_fall_enrollment n
        on c.student_helix_id = n.student_helix_id
        and left(n.return_term, 4) = cast(cast(c.entry_year as int) + 1 as varchar)
)

select
    entry_year,
    full_part_time,
    count(*)                                              as cohort_size,
    sum(case when retained then 1 else 0 end)             as retained_count,
    round(
        100.0 * sum(case when retained then 1 else 0 end) / count(*),
        1
    )                                                     as retention_rate_pct
from retention
group by entry_year, full_part_time
order by entry_year desc, full_part_time
