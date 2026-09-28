/*
  HELIX PS to Workday Reconciliation: Benefit Enrollment Tie-Out
  ===========================================================================
  What it checks: Active benefit elections per worker by plan type, coverage level, and employee cost.

  When to run: After benefits conversion and before the first Workday payroll deduction.

  What passing looks like:
    Zero rows. A missing election means a missed deduction or a coverage gap.

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

with ps as (select employee_ref, plan_type, coverage_level, cast(employee_cost as decimal(18,2)) as employee_cost from :ps_schema.benefit_enrollment where status = 'active' and coverage_begin <= :as_of_date),
     wd as (select employee_ref, plan_type, coverage_level, cast(employee_cost as decimal(18,2)) as employee_cost from :wd_schema.benefit_enrollment where status = 'active' and coverage_begin <= :as_of_date)
select coalesce(ps.employee_ref,wd.employee_ref) as employee_ref, coalesce(ps.plan_type,wd.plan_type) as plan_type,
       ps.coverage_level as ps_level, wd.coverage_level as wd_level, ps.employee_cost as ps_cost, wd.employee_cost as wd_cost
from ps full outer join wd on ps.employee_ref=wd.employee_ref and ps.plan_type=wd.plan_type
where ps.employee_ref is null or wd.employee_ref is null
   or coalesce(ps.coverage_level,'?') <> coalesce(wd.coverage_level,'?') or ps.employee_cost <> wd.employee_cost;
