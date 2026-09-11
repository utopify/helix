{{
  config(
    materialized='table',
    tags=['gold', 'dimension', 'consumption']
  )
}}

/*
  HELIX Gold: Student Dimension
  Combines Person + Student into a single denormalized dimension.
  This is the primary student lookup table for all downstream analytics.

  FERPA: This table contains education records.
  Apply {{ ferpa_safe() }} macro when creating views for external consumers.
*/

with person as (
    select * from {{ ref('helix_person') }}
),

student as (
    select * from {{ ref('helix_student') }}
),

final as (
    select
        s.helix_id                                        as student_helix_id,
        p.helix_id                                        as person_helix_id,

        -- Person attributes
        p.first_name,
        p.middle_name,
        p.last_name,
        p.preferred_first_name,
        p.date_of_birth,
        p.gender,
        p.ethnicity,
        p.institutional_email,
        p.primary_phone,
        p.city,
        p.state_province,
        p.postal_code,
        p.country,

        -- Student attributes
        s.student_id,
        s.student_status,
        s.student_type,
        s.academic_level,
        s.class_standing,
        s.full_part_time,
        s.enrolled_credits,
        s.cumulative_gpa,
        s.cumulative_credits_earned,
        s.veteran_status,
        s.is_international,
        s.is_first_generation,
        s.admit_date,
        s.first_enrolled_date,

        -- Derived attributes
        case
            when s.cumulative_gpa >= 3.5 then 'Dean''s List'
            when s.cumulative_gpa >= 2.0 then 'Good Standing'
            when s.cumulative_gpa >= 1.0 then 'Academic Warning'
            else 'Academic Probation'
        end                                               as academic_standing_derived,

        datediff('year', p.date_of_birth, current_date)   as age,

        -- Metadata
        s._helix_source_system,
        greatest(s._helix_transformed_at, p._helix_transformed_at) as _helix_last_updated

    from student s
    inner join person p
        on s.person_ref = p.helix_id
)

select * from final
