/*
  HELIX PS to Workday Reconciliation: Student Account Balance Tie-Out
  ===========================================================================
  What it checks: Open student account balance per student (charges minus payments minus aid) as of cutover.

  When to run: After student financials conversion and before the first Workday billing run.

  What passing looks like:
    Zero rows. GLBA covered: run under helix_analyst_restricted.

  Parameters:
    :ps_schema          HELIX Silver from PeopleSoft CS
    :wd_schema          HELIX Silver from Workday Student
    :as_of_date         Cutover date
    :tolerance          Use 0.00

  Model: both sides are compared through HELIX Silver. :ps_schema holds the
  PeopleSoft Campus Solutions extract mapped to HELIX; :wd_schema holds the
  Workday Student extract mapped to HELIX. These are FERPA education records:
  run under a role with legitimate educational interest (99.31(a)(1)) and
  never export row-level output outside the project team.

  Warehouse notes: Snowflake/Redshift: works as-is. BigQuery: replace DECIMAL with NUMERIC and :param with @param.
*/

with ps as (select student_ref, cast(sum(amount) as decimal(18,2)) as balance from :ps_schema.ar_transaction where transaction_date <= :as_of_date group by student_ref),
     wd as (select student_ref, cast(sum(amount) as decimal(18,2)) as balance from :wd_schema.ar_transaction where transaction_date <= :as_of_date group by student_ref)
select coalesce(ps.student_ref,wd.student_ref) as student_ref, ps.balance as ps_balance, wd.balance as wd_balance,
       coalesce(ps.balance,0)-coalesce(wd.balance,0) as variance
from ps full outer join wd on ps.student_ref = wd.student_ref
where abs(coalesce(ps.balance,0)-coalesce(wd.balance,0)) > :tolerance;
