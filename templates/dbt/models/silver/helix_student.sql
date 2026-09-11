{{
  config(
    materialized='table',
    tags=['silver', 'identity', 'ferpa']
  )
}}

/*
  HELIX Silver: Student
  Transforms staging student data into the HELIX Student resource.
  Links to Person via person_ref (resolved helix_id).

  Quality rules enforced:
  - QR-SI-001: student_status must be from HELIX terminology
  - QR-SI-003: every student must link to a valid person
  - QR-EN-004: GPA must be between 0.0 and 4.0
*/

with staged as (
    select * from {{ ref('stg_student') }}
),

-- Resolve person reference
person_lookup as (
    select helix_id as person_helix_id, source_person_id
    from {{ ref('helix_person') }}
),

final as (
    select
        {{ helix_uuid('s.source_student_id') }}           as helix_id,
        p.person_helix_id                                 as person_ref,
        s.source_student_id                               as student_id,

        -- Classification
        s.student_status,
        s.student_type,
        s.academic_level,
        s.class_standing,

        -- Enrollment intensity
        s.full_part_time,
        s.enrolled_credits,

        -- Academic performance
        s.cumulative_gpa,
        s.cumulative_credits_earned,

        -- Flags
        s.veteran_status,
        s.is_international,
        s.is_first_generation,

        -- Dates
        s.admit_date,
        s.first_enrolled_date,

        -- HELIX metadata
        'student'                                         as _helix_resource_type,
        'confidential'                                    as _helix_classification,
        true                                              as _helix_is_education_record,
        s._helix_source_system,
        s._helix_loaded_at,
        current_timestamp                                 as _helix_transformed_at

    from staged s
    left join person_lookup p
        on s.source_person_id = p.source_person_id
)

select * from final
