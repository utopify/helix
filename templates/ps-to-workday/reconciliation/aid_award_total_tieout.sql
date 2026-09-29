/*
  HELIX PS to Workday Reconciliation: Aid Award Total Tie-Out
  ===========================================================================
  What it checks: Offered, accepted, and disbursed award totals by fund match between PeopleSoft and Workday for the award year.

  When to run: After each financial aid mock load, and at cutover for every open award year.

  What passing looks like:
    Zero rows. Tolerance is 0.00 on every fund. Any difference means an award was dropped, duplicated, or mapped to the wrong fund.

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
  select fund_code, count(distinct student_ref) as students,
         sum(amount_offered) as offered, sum(amount_accepted) as accepted, sum(amount_disbursed) as disbursed
  from :ps_schema.fin_aid_award where academic_year = :academic_year group by fund_code),
wd as (
  select fund_code, count(distinct student_ref) as students,
         sum(amount_offered) as offered, sum(amount_accepted) as accepted, sum(amount_disbursed) as disbursed
  from :wd_schema.fin_aid_award where academic_year = :academic_year group by fund_code)
select coalesce(ps.fund_code, wd.fund_code) as fund_code,
       ps.students as ps_students, wd.students as wd_students,
       cast(coalesce(ps.offered,0)   - coalesce(wd.offered,0)   as decimal(14,2)) as offered_diff,
       cast(coalesce(ps.accepted,0)  - coalesce(wd.accepted,0)  as decimal(14,2)) as accepted_diff,
       cast(coalesce(ps.disbursed,0) - coalesce(wd.disbursed,0) as decimal(14,2)) as disbursed_diff
from ps full outer join wd on ps.fund_code = wd.fund_code
where coalesce(ps.students,0) <> coalesce(wd.students,0)
   or coalesce(ps.offered,0)   <> coalesce(wd.offered,0)
   or coalesce(ps.accepted,0)  <> coalesce(wd.accepted,0)
   or coalesce(ps.disbursed,0) <> coalesce(wd.disbursed,0)
order by fund_code;
