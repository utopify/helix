/*
  HELIX PS to Workday Reconciliation: Headcount Tie-Out
  ===========================================================================
  What it checks: Active headcount by worker type, cost center, and employment status as of the cutover date.

  When to run: After each worker conversion load (mock 1, 2, 3) and at cutover.

  What passing looks like:
    Zero rows.

  Parameters:
    :ps_schema          HELIX Silver from PeopleSoft
    :wd_schema          HELIX Silver from Workday
    :as_of_date         Cutover date

  Model: both sides are compared through HELIX Silver. :ps_schema holds the
  PeopleSoft extract mapped to HELIX; :wd_schema holds the Workday extract
  mapped to HELIX. Compensation, payroll, and benefits are RESTRICTED: run
  under helix_analyst_restricted (govern/lakehouse-rbac-model.json).

  Warehouse notes: Snowflake/Redshift: works as-is. BigQuery: replace DECIMAL with NUMERIC and :param with @param.
*/

with ps as (
    select worker_type, department as cost_center, employment_status, count(distinct helix_id) as headcount
    from :ps_schema.employee where hire_date <= :as_of_date and (termination_date is null or termination_date > :as_of_date)
    group by worker_type, department, employment_status
),
wd as (
    select worker_type, department as cost_center, employment_status, count(distinct helix_id) as headcount
    from :wd_schema.employee where hire_date <= :as_of_date and (termination_date is null or termination_date > :as_of_date)
    group by worker_type, department, employment_status
)
select coalesce(ps.worker_type,wd.worker_type) as worker_type, coalesce(ps.cost_center,wd.cost_center) as cost_center,
       coalesce(ps.employment_status,wd.employment_status) as employment_status,
       ps.headcount as ps_count, wd.headcount as wd_count, coalesce(ps.headcount,0)-coalesce(wd.headcount,0) as variance
from ps full outer join wd on ps.worker_type=wd.worker_type and ps.cost_center=wd.cost_center and ps.employment_status=wd.employment_status
where coalesce(ps.headcount,0) <> coalesce(wd.headcount,0);
