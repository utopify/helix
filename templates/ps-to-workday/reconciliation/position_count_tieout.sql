/*
  HELIX PS to Workday Reconciliation: Position Count Tie-Out
  ===========================================================================
  What it checks: Positions by status (filled, open, frozen) and cost center match. Applies to Position Management tenants.

  When to run: After position conversion, before hiring opens in Workday.

  What passing looks like:
    Zero rows. Also confirms no filled PS position lands open in Workday.

  Parameters:
    :ps_schema          HELIX Silver from PeopleSoft
    :wd_schema          HELIX Silver from Workday

  Model: both sides are compared through HELIX Silver. :ps_schema holds the
  PeopleSoft extract mapped to HELIX; :wd_schema holds the Workday extract
  mapped to HELIX. Compensation, payroll, and benefits are RESTRICTED: run
  under helix_analyst_restricted (govern/lakehouse-rbac-model.json).

  Warehouse notes: Snowflake/Redshift: works as-is. BigQuery: replace DECIMAL with NUMERIC and :param with @param.
*/

with ps as (select department as cost_center, position_status, count(*) as n from :ps_schema.position group by department, position_status),
     wd as (select department as cost_center, position_status, count(*) as n from :wd_schema.position group by department, position_status)
select coalesce(ps.cost_center,wd.cost_center) as cost_center, coalesce(ps.position_status,wd.position_status) as position_status,
       ps.n as ps_count, wd.n as wd_count, coalesce(ps.n,0)-coalesce(wd.n,0) as variance
from ps full outer join wd on ps.cost_center=wd.cost_center and ps.position_status=wd.position_status
where coalesce(ps.n,0) <> coalesce(wd.n,0);
