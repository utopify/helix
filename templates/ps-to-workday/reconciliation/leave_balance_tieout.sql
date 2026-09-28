/*
  HELIX PS to Workday Reconciliation: Leave Balance Tie-Out
  ===========================================================================
  What it checks: Time off and leave balances (vacation, sick, personal) per worker as of the conversion date.

  When to run: After balance conversion; rerun after the first Workday accrual run.

  What passing looks like:
    Zero rows. Balances are a common grievance and union issue if wrong.

  Parameters:
    :ps_schema          HELIX Silver from PeopleSoft
    :wd_schema          HELIX Silver from Workday
    :as_of_date         Balance date
    :tolerance          Hours tolerance, e.g. 0.01

  Model: both sides are compared through HELIX Silver. :ps_schema holds the
  PeopleSoft extract mapped to HELIX; :wd_schema holds the Workday extract
  mapped to HELIX. Compensation, payroll, and benefits are RESTRICTED: run
  under helix_analyst_restricted (govern/lakehouse-rbac-model.json).

  Warehouse notes: Snowflake/Redshift: works as-is. BigQuery: replace DECIMAL with NUMERIC and :param with @param.
*/

with ps as (select employee_ref, absence_type, cast(balance_hours as decimal(10,2)) as bal from :ps_schema.absence_record where balance_as_of = :as_of_date),
     wd as (select employee_ref, absence_type, cast(balance_hours as decimal(10,2)) as bal from :wd_schema.absence_record where balance_as_of = :as_of_date)
select coalesce(ps.employee_ref,wd.employee_ref) as employee_ref, coalesce(ps.absence_type,wd.absence_type) as absence_type,
       ps.bal as ps_hours, wd.bal as wd_hours, coalesce(ps.bal,0)-coalesce(wd.bal,0) as variance
from ps full outer join wd on ps.employee_ref=wd.employee_ref and ps.absence_type=wd.absence_type
where abs(coalesce(ps.bal,0)-coalesce(wd.bal,0)) > :tolerance;
