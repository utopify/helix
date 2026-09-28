/*
  HELIX PS to Workday Reconciliation: Payroll Parallel Compare
  ===========================================================================
  What it checks: Gross, net, taxes, and deductions per worker per pay period between the live PeopleSoft payroll and the Workday parallel run.

  When to run: Every parallel payroll cycle (plan at least 2 full cycles, including a month with benefits deductions and one with a supplemental run).

  What passing looks like:
    Workers outside :tolerance on any component are listed. Target: zero before go-live sign-off by the Payroll Data Steward.

  Parameters:
    :ps_schema          HELIX Silver from PeopleSoft
    :wd_schema          HELIX Silver from Workday
    :pay_period_end     Pay period end date
    :tolerance          Per-component tolerance, e.g. 0.01

  Model: both sides are compared through HELIX Silver. :ps_schema holds the
  PeopleSoft extract mapped to HELIX; :wd_schema holds the Workday extract
  mapped to HELIX. Compensation, payroll, and benefits are RESTRICTED: run
  under helix_analyst_restricted (govern/lakehouse-rbac-model.json).

  Warehouse notes: Snowflake/Redshift: works as-is. BigQuery: replace DECIMAL with NUMERIC and :param with @param.
*/

with ps as (select employee_ref, gross_pay, net_pay, total_taxes, total_deductions from :ps_schema.payroll_result where pay_period_end = :pay_period_end),
     wd as (select employee_ref, gross_pay, net_pay, total_taxes, total_deductions from :wd_schema.payroll_result where pay_period_end = :pay_period_end)
select coalesce(ps.employee_ref, wd.employee_ref) as employee_ref,
       ps.gross_pay as ps_gross, wd.gross_pay as wd_gross, coalesce(ps.gross_pay,0)-coalesce(wd.gross_pay,0) as gross_var,
       coalesce(ps.net_pay,0)-coalesce(wd.net_pay,0) as net_var,
       coalesce(ps.total_taxes,0)-coalesce(wd.total_taxes,0) as tax_var,
       coalesce(ps.total_deductions,0)-coalesce(wd.total_deductions,0) as deduction_var,
       case when ps.employee_ref is null then 'paid_only_in_workday' when wd.employee_ref is null then 'paid_only_in_peoplesoft' else 'amount_variance' end as issue
from ps full outer join wd on ps.employee_ref = wd.employee_ref
where ps.employee_ref is null or wd.employee_ref is null
   or abs(coalesce(ps.gross_pay,0)-coalesce(wd.gross_pay,0)) > :tolerance
   or abs(coalesce(ps.net_pay,0)-coalesce(wd.net_pay,0)) > :tolerance
   or abs(coalesce(ps.total_taxes,0)-coalesce(wd.total_taxes,0)) > :tolerance
   or abs(coalesce(ps.total_deductions,0)-coalesce(wd.total_deductions,0)) > :tolerance;
