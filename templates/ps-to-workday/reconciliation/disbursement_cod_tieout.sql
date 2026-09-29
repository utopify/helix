/*
  HELIX PS to Workday Reconciliation: Disbursement and COD Tie-Out
  ===========================================================================
  What it checks: Title IV disbursements per student and fund match between PeopleSoft and Workday, and both match the totals reported to COD.

  When to run: Before the first Workday disbursement run, then monthly through the first full award year in Workday.

  What passing looks like:
    Zero rows. Tolerance is 0.00. COD is the federal record: if both systems agree with each other but not with COD, fix the conversion before you disburse anything.

  Parameters:
    :ps_schema          HELIX Silver from PeopleSoft CS
    :wd_schema          HELIX Silver from Workday Student
    :academic_year      Award year to compare, for example '2025-2026'

  Model: both sides are compared through HELIX Silver. These are FERPA
  education records and GLBA-covered customer information. Run under a
  financial aid role (govern/access-control-matrix.json, ACM-SPECIAL-002)
  and never export row-level output outside the project team.

  Extra input: :wd_schema.federal_aid_report must hold the COD school
  account statement totals (report_type = 'pell_reconciliation' and
  'dl_reconciliation') for the award year. The system_totals CASE assumes
  Pell fund codes start with PELL and Direct Loan codes with DL; change it
  to match your fund codes (bridge/xref/ps-to-workday-sis/fin-aid-item-type-xref.json).

  Warehouse notes: Snowflake/Redshift: works as-is. BigQuery: replace DECIMAL with NUMERIC and :param with @param.
*/

with ps as (
  select student_ref, fund_code, sum(net_amount) as net
  from :ps_schema.disbursement
  where academic_year = :academic_year and disbursement_status in ('disbursed','partially_disbursed','returned')
  group by student_ref, fund_code),
wd as (
  select student_ref, fund_code, sum(net_amount) as net
  from :wd_schema.disbursement
  where academic_year = :academic_year and disbursement_status in ('disbursed','partially_disbursed','returned')
  group by student_ref, fund_code),
student_level as (
  select coalesce(ps.student_ref, wd.student_ref) as student_ref, coalesce(ps.fund_code, wd.fund_code) as fund_code,
         cast(coalesce(ps.net,0) - coalesce(wd.net,0) as decimal(14,2)) as diff, 'STUDENT_FUND_MISMATCH' as issue
  from ps full outer join wd on ps.student_ref = wd.student_ref and ps.fund_code = wd.fund_code
  where coalesce(ps.net,0) <> coalesce(wd.net,0)),
cod as (
  select 'PELL' as fund_code, total_pell_disbursed as cod_total from :wd_schema.federal_aid_report
   where academic_year = :academic_year and report_type = 'pell_reconciliation'
  union all
  select 'DL', total_dl_disbursed from :wd_schema.federal_aid_report
   where academic_year = :academic_year and report_type = 'dl_reconciliation'),
system_totals as (
  select case when fund_code like 'PELL%' then 'PELL' when fund_code like 'DL%' then 'DL' end as fund_code, sum(net) as wd_total
  from wd group by 1)
select student_ref, fund_code, diff, issue from student_level
union all
select null, c.fund_code, cast(coalesce(s.wd_total,0) - c.cod_total as decimal(14,2)), 'COD_TOTAL_MISMATCH'
from cod c left join system_totals s on s.fund_code = c.fund_code
where coalesce(s.wd_total,0) <> c.cod_total;
