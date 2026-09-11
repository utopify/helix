{{
  config(
    materialized='view',
    tags=['staging', 'identity']
  )
}}

/*
  HELIX Staging: Person
  Source: Bronze layer raw person data
  Target: Cleaned, typed person records ready for silver-layer dedup

  Mapping notes:
  - PeopleSoft: PERSONAL_DATA + NAMES + ADDRESSES + EMAIL_ADDRESSES + PERSONAL_PHONE
  - Banner: SPRIDEN + SPBPERS + GORPRAC + GOREMAL + SPRADDR
  - Workday: Worker → Personal_Data, Contact_Information
*/

with source as (
    select * from {{ source('bronze', 'src_person') }}
),

cleaned as (
    select
        -- Native source key (will be resolved to helix_id in silver)
        cast(source_id as varchar(50))                    as source_person_id,

        -- Name components
        trim(first_name)                                  as first_name,
        trim(middle_name)                                 as middle_name,
        trim(last_name)                                   as last_name,
        trim(preferred_first_name)                        as preferred_first_name,
        trim(prefix)                                      as prefix,
        trim(suffix)                                      as suffix,

        -- Demographics
        cast(date_of_birth as date)                       as date_of_birth,
        lower(trim(gender))                               as gender,
        lower(trim(ethnicity))                            as ethnicity,

        -- Contact
        lower(trim(email))                                as institutional_email,
        trim(phone)                                       as primary_phone,

        -- Address (flatten if nested in source)
        trim(address_line_1)                              as address_line_1,
        trim(address_line_2)                              as address_line_2,
        trim(city)                                        as city,
        trim(state_province)                              as state_province,
        trim(postal_code)                                 as postal_code,
        trim(country)                                     as country,

        -- Metadata
        {{ source_system_meta() }}

    from source
    where source_id is not null
      and last_name is not null  -- Filter out skeleton records
)

select * from cleaned
