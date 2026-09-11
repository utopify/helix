{{
  config(
    materialized='view',
    tags=['staging', 'identity']
  )
}}

/*
  HELIX Staging: Student
  Source: Bronze layer raw student data
  Target: Cleaned student records with standardized status and type codes

  Mapping notes:
  - PeopleSoft: PS_STDNT_CAR_TERM + PS_ACAD_PROG + PS_ACAD_PLAN
  - Banner: SGBSTDN + SFBETRM + SORCMJR
  - Workday: Student → Academic_Record
*/

with source as (
    select * from {{ source('bronze', 'src_student') }}
),

cleaned as (
    select
        cast(source_id as varchar(50))                    as source_student_id,
        cast(person_source_id as varchar(50))             as source_person_id,

        -- Student classification
        lower(trim(student_status))                       as student_status,
        lower(trim(student_type))                         as student_type,
        lower(trim(academic_level))                       as academic_level,
        lower(trim(class_standing))                       as class_standing,

        -- Enrollment intensity
        lower(trim(full_part_time))                       as full_part_time,
        cast(enrolled_credits as decimal(5,2))            as enrolled_credits,

        -- Academic performance
        cast(cumulative_gpa as decimal(4,3))              as cumulative_gpa,
        cast(cumulative_credits_earned as decimal(7,2))   as cumulative_credits_earned,

        -- Flags
        cast(coalesce(veteran_status, 'none') as varchar) as veteran_status,
        cast(coalesce(international_student, false) as boolean) as is_international,
        cast(coalesce(first_generation, false) as boolean) as is_first_generation,

        -- Dates
        cast(admit_date as date)                          as admit_date,
        cast(first_enrolled_date as date)                 as first_enrolled_date,

        -- Metadata
        {{ source_system_meta() }}

    from source
    where source_id is not null
)

select * from cleaned
