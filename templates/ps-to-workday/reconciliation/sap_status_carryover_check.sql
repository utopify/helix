/*
  HELIX PS to Workday Reconciliation: SAP Status Carryover Check
  ===========================================================================
  What it checks: Every student's latest PeopleSoft SAP status lands in Workday with the same HELIX status and the same academic plan flag.

  When to run: Before the first Workday disbursement run. Hard gate.

  What passing looks like:
    Zero rows is the ONLY passing result. A student on suspension in PeopleSoft who shows as meeting in Workday can be paid aid they aren't eligible for, which becomes a program review finding and a liability.

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

with ps as (
  select student_ref, sap_status, academic_plan_flag,
         row_number() over (partition by student_ref order by evaluation_date desc) as rn
  from :ps_schema.sap_evaluation where academic_year = :academic_year),
wd as (
  select student_ref, sap_status, academic_plan_flag,
         row_number() over (partition by student_ref order by evaluation_date desc) as rn
  from :wd_schema.sap_evaluation where academic_year = :academic_year)
select ps.student_ref, ps.sap_status as ps_status, wd.sap_status as wd_status,
       ps.academic_plan_flag as ps_plan, wd.academic_plan_flag as wd_plan,
       case when wd.student_ref is null then 'MISSING_IN_WORKDAY'
            when ps.sap_status <> wd.sap_status then 'STATUS_MISMATCH'
            else 'PLAN_MISMATCH' end as issue
from ps left join wd on ps.student_ref = wd.student_ref and wd.rn = 1
where ps.rn = 1
  and (wd.student_ref is null
       or ps.sap_status <> wd.sap_status
       or coalesce(ps.academic_plan_flag, false) <> coalesce(wd.academic_plan_flag, false));
