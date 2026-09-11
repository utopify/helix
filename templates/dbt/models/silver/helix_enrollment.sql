{{
  config(
    materialized='table',
    tags=['silver', 'enrollment', 'ferpa']
  )
}}

/*
  HELIX Silver: Enrollment
  One row per student-section-term enrollment record.

  Quality rules enforced:
  - QR-EN-001: enrollment_status from HELIX terminology
  - QR-EN-002: credits_attempted >= 0
  - QR-EN-003: if final_grade exists, enrollment_status should be 'completed'
*/

with staged as (
    select * from {{ ref('stg_enrollment') }}
),

student_lookup as (
    select helix_id as student_helix_id, source_student_id
    from {{ ref('helix_student') }}
),

final as (
    select
        {{ helix_uuid('e.source_enrollment_id') }}        as helix_id,
        sl.student_helix_id                               as student_ref,
        e.source_section_id                               as section_ref,
        e.source_period_id                                as period_ref,

        -- Status
        e.enrollment_status,
        e.grade_mode,

        -- Credits
        e.credits_attempted,
        e.credits_earned,

        -- Grades
        e.final_grade,
        e.midterm_grade,
        e.grade_points,

        -- Dates
        e.registration_date,
        e.drop_date,
        e.last_attendance_date,

        -- Federal reporting
        e.attendance_verified,

        -- FERPA flags
        json_build_object(
            'is_education_record', true,
            'disclosure_basis_required', true,
            'directory_restricted', false,
            'legitimate_interest_scope', 'enrollment_management'
        )                                                 as meta_ferpa_flags,

        -- HELIX metadata
        'enrollment'                                      as _helix_resource_type,
        'confidential'                                    as _helix_classification,
        e._helix_source_system,
        e._helix_loaded_at,
        current_timestamp                                 as _helix_transformed_at

    from staged e
    left join student_lookup sl
        on e.source_student_id = sl.source_student_id
)

select * from final
