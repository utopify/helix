{{
  config(
    materialized='table',
    tags=['silver', 'financial_aid', 'ferpa', 'glba']
  )
}}

/*
  HELIX Silver: Financial Aid Award
  FERPA + GLBA covered data. Apply strictest access controls.

  Quality rules:
  - QR-FA-001: disbursed_amount <= accepted_amount <= offered_amount
  - QR-FA-002: sap_status from HELIX terminology
  - QR-FA-003: award_type from HELIX terminology
*/

with staged as (
    select * from {{ ref('stg_fin_aid_award') }}
),

student_lookup as (
    select helix_id as student_helix_id, source_student_id
    from {{ ref('helix_student') }}
),

final as (
    select
        {{ helix_uuid('fa.source_award_id') }}            as helix_id,
        sl.student_helix_id                               as student_ref,
        fa.source_period_id                               as period_ref,

        fa.award_type,
        fa.award_name,
        fa.fund_source,

        fa.offered_amount,
        fa.accepted_amount,
        fa.disbursed_amount,

        fa.sap_status,
        fa.award_date,
        fa.disbursement_date,

        -- HELIX metadata
        'fin_aid_award'                                   as _helix_resource_type,
        'confidential'                                    as _helix_classification,
        true                                              as _helix_is_education_record,
        true                                              as _helix_is_glba_covered,
        fa._helix_source_system,
        fa._helix_loaded_at,
        current_timestamp                                 as _helix_transformed_at

    from staged fa
    left join student_lookup sl
        on fa.source_student_id = sl.source_student_id
)

select * from final
