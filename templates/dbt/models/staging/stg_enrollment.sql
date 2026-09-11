{{
  config(
    materialized='view',
    tags=['staging', 'enrollment']
  )
}}

/*
  HELIX Staging: Enrollment
  Source: Bronze layer raw enrollment/registration data
  Target: One row per student-section-term with standardized status codes

  Mapping notes:
  - PeopleSoft: PS_STDNT_ENRL + PS_CLASS_TBL
  - Banner: SFRSTCR + SHRTCKN + SHRTCKG
  - Workday: Student → Course_Registration
*/

with source as (
    select * from {{ source('bronze', 'src_enrollment') }}
),

cleaned as (
    select
        cast(source_id as varchar(50))                    as source_enrollment_id,
        cast(student_source_id as varchar(50))            as source_student_id,
        cast(section_source_id as varchar(50))            as source_section_id,
        cast(period_source_id as varchar(50))             as source_period_id,

        -- Status
        lower(trim(enrollment_status))                    as enrollment_status,
        lower(trim(grade_mode))                           as grade_mode,

        -- Credits
        cast(credits_attempted as decimal(5,2))           as credits_attempted,
        cast(credits_earned as decimal(5,2))              as credits_earned,

        -- Grades
        trim(grade)                                       as final_grade,
        trim(midterm_grade)                               as midterm_grade,
        cast(grade_points as decimal(5,2))                as grade_points,

        -- Dates
        cast(registration_date as date)                   as registration_date,
        cast(drop_date as date)                           as drop_date,
        cast(last_attendance_date as date)                as last_attendance_date,

        -- Federal reporting
        cast(coalesce(attendance_verified, false) as boolean) as attendance_verified,

        -- Metadata
        {{ source_system_meta() }}

    from source
    where source_id is not null
)

select * from cleaned
