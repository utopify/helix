/*
  HELIX PS to Workday Reconciliation: Loan Record Tie-Out
  ===========================================================================
  What it checks: Every PeopleSoft loan for the award year exists in Workday with the same COD loan ID, loan type, amounts, and MPN and counseling status.

  When to run: After loan conversion and before any Workday loan origination or disbursement.

  What passing looks like:
    Zero rows. A missing or changed COD loan ID causes COD rejects; a lost MPN or counseling flag blocks a disbursement that should go through.

  Parameters:
    :ps_schema          HELIX Silver from PeopleSoft CS
    :wd_schema          HELIX Silver from Workday Student
    :academic_year      Award year to compare, for example '2025-2026'

  Model: both sides are compared through HELIX Silver. These are FERPA
  education records and GLBA-covered customer information. Run under a
  financial aid role (govern/access-control-matrix.json, ACM-SPECIAL-002)
  and never export row-level output outside the project team.

  Warehouse notes: Snowflake/Redshift: works as-is. BigQuery: replace DECIMAL with NUMERIC and :param with @param.
*/

select coalesce(ps.cod_loan_id, wd.cod_loan_id) as cod_loan_id, ps.student_ref,
       ps.loan_type as ps_type, wd.loan_type as wd_type,
       cast(coalesce(ps.gross_loan_amount,0) - coalesce(wd.gross_loan_amount,0) as decimal(14,2)) as gross_diff,
       ps.mpn_flag as ps_mpn, wd.mpn_flag as wd_mpn,
       ps.entrance_counseling_flag as ps_counsel, wd.entrance_counseling_flag as wd_counsel,
       case when wd.cod_loan_id is null then 'MISSING_IN_WORKDAY'
            when ps.cod_loan_id is null then 'EXTRA_IN_WORKDAY'
            when ps.loan_type <> wd.loan_type then 'TYPE_MISMATCH'
            when coalesce(ps.gross_loan_amount,0) <> coalesce(wd.gross_loan_amount,0) then 'AMOUNT_MISMATCH'
            else 'MPN_OR_COUNSELING_MISMATCH' end as issue
from (select * from :ps_schema.loan_record where academic_year = :academic_year) ps
full outer join (select * from :wd_schema.loan_record where academic_year = :academic_year) wd
  on ps.cod_loan_id = wd.cod_loan_id
where wd.cod_loan_id is null or ps.cod_loan_id is null
   or ps.loan_type <> wd.loan_type
   or coalesce(ps.gross_loan_amount,0) <> coalesce(wd.gross_loan_amount,0)
   or coalesce(ps.mpn_flag,false) <> coalesce(wd.mpn_flag,false)
   or coalesce(ps.entrance_counseling_flag,false) <> coalesce(wd.entrance_counseling_flag,false);
