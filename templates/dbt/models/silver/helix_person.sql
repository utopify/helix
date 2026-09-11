{{
  config(
    materialized='table',
    tags=['silver', 'identity', 'ferpa'],
    post_hook="{{ helix_classify('confidential', true, false) }}"
  )
}}

/*
  HELIX Silver: Person
  Transforms staging person data into the HELIX Person resource.

  Key transformations:
  1. Deduplication using deterministic matching (email, source_id)
  2. UUID assignment via helix_uuid()
  3. FERPA flag attachment
  4. Data classification tagging

  FERPA Note: Every row in this table is an education record.
  Directory restriction status must be checked before any external disclosure.
*/

with staged as (
    select * from {{ ref('stg_person') }}
),

-- Deduplicate: prefer the most recent record per source_person_id
deduped as (
    select *,
        row_number() over (
            partition by source_person_id
            order by _helix_loaded_at desc
        ) as _rn
    from staged
),

final as (
    select
        {{ helix_uuid('source_person_id') }}              as helix_id,
        source_person_id,

        -- Name
        first_name,
        middle_name,
        last_name,
        preferred_first_name,
        prefix,
        suffix,

        -- Demographics
        date_of_birth,
        gender,
        ethnicity,

        -- Contact
        institutional_email,
        primary_phone,

        -- Address
        address_line_1,
        address_line_2,
        city,
        state_province,
        postal_code,
        country,

        -- HELIX metadata
        'person'                                          as _helix_resource_type,
        'confidential'                                    as _helix_classification,
        true                                              as _helix_is_education_record,
        _helix_source_system,
        _helix_loaded_at,
        current_timestamp                                 as _helix_transformed_at

    from deduped
    where _rn = 1
)

select * from final
