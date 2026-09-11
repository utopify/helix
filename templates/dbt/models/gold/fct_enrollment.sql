{{
  config(
    materialized='table',
    tags=['gold', 'fact', 'consumption']
  )
}}

/*
  HELIX Gold: Enrollment Fact Table
  Grain: one row per student × section × term enrollment event.
  Measures: credits attempted, credits earned, grade points.
*/

with enrollment as (
    select * from {{ ref('helix_enrollment') }}
),

final as (
    select
        helix_id                                          as enrollment_helix_id,
        student_ref,
        section_ref,
        period_ref,

        enrollment_status,
        grade_mode,
        final_grade,
        midterm_grade,

        -- Measures
        credits_attempted,
        credits_earned,
        grade_points,

        -- Dates
        registration_date,
        drop_date,
        last_attendance_date,

        -- Derived
        case
            when enrollment_status = 'completed' and final_grade is not null then true
            else false
        end                                               as is_graded,

        case
            when enrollment_status in ('dropped', 'withdrawn') then true
            else false
        end                                               as is_attrition,

        -- Federal reporting
        attendance_verified,

        -- Metadata
        _helix_source_system,
        _helix_transformed_at

    from enrollment
)

select * from final
