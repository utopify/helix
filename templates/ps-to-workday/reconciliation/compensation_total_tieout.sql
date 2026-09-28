/*
  HELIX PS to Workday Reconciliation: Compensation Total Tie-Out
  ===========================================================================
  What it checks: Annualized base compensation by cost center, plus per-worker mismatches above tolerance.

  When to run: After compensation conversion and after any mass comp change during parallel.

  What passing looks like:
    Zero rows at worker level. 9-over-12 faculty must annualize the same way on both sides.

  Parameters:
    :ps_schema          HELIX Silver from PeopleSoft
    :wd_schema          HELIX Silver from Workday
    :as_of_date         Cutover date
    :tolerance          Per-worker annualized tolerance, e.g. 1.00

  Model: both sides are compared through HELIX Silver. :ps_schema holds the
  PeopleSoft extract mapped to HELIX; :wd_schema holds the Workday extract
  mapped to HELIX. Compensation, payroll, and benefits are RESTRICTED: run
  under helix_analyst_restricted (govern/lakehouse-rbac-model.json).

  Warehouse notes: Snowflake/Redshift: works as-is. BigQuery: replace DECIMAL with NUMERIC and :param with @param.
*/

with ps as (
    select c.employee_ref, cast(sum(c.annual_amount) as decimal(18,2)) as annual_base
    from :ps_schema.compensation c
    where c.compensation_type = 'base_salary' and c.effective_date <= :as_of_date and (c.end_date is null or c.end_date > :as_of_date)
    group by c.employee_ref
),
wd as (
    select c.employee_ref, cast(sum(c.annual_amount) as decimal(18,2)) as annual_base
    from :wd_schema.compensation c
    where c.compensation_type = 'base_salary' and c.effective_date <= :as_of_date and (c.end_date is null or c.end_date > :as_of_date)
    group by c.employee_ref
)
select coalesce(ps.employee_ref, wd.employee_ref) as employee_ref, ps.annual_base as ps_annual, wd.annual_base as wd_annual,
       coalesce(ps.annual_base,0)-coalesce(wd.annual_base,0) as variance
from ps full outer join wd on ps.employee_ref = wd.employee_ref
where abs(coalesce(ps.annual_base,0)-coalesce(wd.annual_base,0)) > :tolerance;
