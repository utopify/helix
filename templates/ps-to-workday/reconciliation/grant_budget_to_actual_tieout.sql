/*
  HELIX PS to Workday Reconciliation: Grant Budget-to-Actual Tie-Out
  ===========================================================================
  What it checks: Per award: total budget, life-to-date expense, and remaining balance match between PeopleSoft Grants and Workday Grants.

  When to run: After grant conversion and at each parallel month-end. Sponsored balances are audit-sensitive (2 CFR 200).

  What passing looks like:
    Zero rows.

  Parameters:
    :ps_schema          HELIX Silver from PeopleSoft
    :wd_schema          HELIX Silver from Workday
    :tolerance          Use 0.00

  Model: both sides are compared through HELIX Silver. :ps_schema holds the
  PeopleSoft extract mapped to HELIX; :wd_schema holds the Workday extract
  (RaaS / Web Services / EIB round-trip) mapped to HELIX.

  Warehouse notes: Snowflake/Redshift: works as-is. BigQuery: replace DECIMAL with NUMERIC and :param with @param.
*/

with ps as (
    select g.grant_id, cast(max(g.total_budget) as decimal(18,2)) as budget,
           cast(coalesce(sum(t.amount),0) as decimal(18,2)) as ltd_expense
    from :ps_schema.grant g left join :ps_schema.gl_transaction t
      on t.project_id = g.grant_id and t.account_type = 'expenditure'
    group by g.grant_id
),
wd as (
    select g.grant_id, cast(max(g.total_budget) as decimal(18,2)) as budget,
           cast(coalesce(sum(t.amount),0) as decimal(18,2)) as ltd_expense
    from :wd_schema.grant g left join :wd_schema.gl_transaction t
      on t.project_id = g.grant_id and t.account_type = 'expenditure'
    group by g.grant_id
)
select coalesce(ps.grant_id, wd.grant_id) as grant_id,
       ps.budget as ps_budget, wd.budget as wd_budget, ps.ltd_expense as ps_ltd, wd.ltd_expense as wd_ltd,
       (ps.budget - ps.ltd_expense) - (wd.budget - wd.ltd_expense) as remaining_variance
from ps full outer join wd on ps.grant_id = wd.grant_id
where ps.grant_id is null or wd.grant_id is null
   or abs(ps.budget - wd.budget) > :tolerance or abs(ps.ltd_expense - wd.ltd_expense) > :tolerance;
