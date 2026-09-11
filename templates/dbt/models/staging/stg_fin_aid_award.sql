{{
  config(
    materialized='view',
    tags=['staging', 'financial_aid']
  )
}}

/*
  HELIX Staging: Financial Aid Award
  Source: Bronze layer raw financial aid data
  Target: Cleaned awards with standardized types and amounts

  Mapping notes:
  - PeopleSoft: PS_STDNT_AWARDS + PS_ITEM_TYPE_FA
  - Banner: RPRAWRD + RFRBASE
  - Workday: Student → Financial_Aid_Award

  GLBA: This data is covered by the Gramm-Leach-Bliley Act.
  Financial details must be tokenized/masked per classification rules.
*/

with source as (
    select * from {{ source('bronze', 'src_fin_aid_award') }}
),

cleaned as (
    select
        cast(source_id as varchar(50))                    as source_award_id,
        cast(student_source_id as varchar(50))            as source_student_id,
        cast(period_source_id as varchar(50))             as source_period_id,

        -- Award details
        lower(trim(award_type))                           as award_type,
        trim(award_name)                                  as award_name,
        trim(fund_source)                                 as fund_source,

        -- Amounts
        cast(offered_amount as decimal(12,2))             as offered_amount,
        cast(accepted_amount as decimal(12,2))            as accepted_amount,
        cast(disbursed_amount as decimal(12,2))           as disbursed_amount,

        -- SAP
        lower(trim(sap_status))                           as sap_status,

        -- Dates
        cast(award_date as date)                          as award_date,
        cast(disbursement_date as date)                   as disbursement_date,

        -- Metadata
        {{ source_system_meta() }}

    from source
    where source_id is not null
)

select * from cleaned
