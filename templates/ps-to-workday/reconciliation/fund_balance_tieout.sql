/*
  HELIX PS to Workday Reconciliation: Fund Balance Tie-Out
  ===========================================================================
  What it checks: Ending fund balance (net assets) by Company and Fund matches, including restriction class.

  When to run: At conversion of opening balances and at each parallel close.

  What passing looks like:
    Zero rows. Restriction class must also match (an endowment fund cannot land as unrestricted).

  Parameters:
    :ps_schema          HELIX Silver from PeopleSoft
    :wd_schema          HELIX Silver from Workday
    :as_of_period       Fiscal year + period
    :tolerance          Use 0.00

  Model: both sides are compared through HELIX Silver. :ps_schema holds the
  PeopleSoft extract mapped to HELIX; :wd_schema holds the Workday extract
  (RaaS / Web Services / EIB round-trip) mapped to HELIX.

  Warehouse notes: Snowflake/Redshift: works as-is. BigQuery: replace DECIMAL with NUMERIC and :param with @param.
*/

with ps as (
    select g.company, g.fund_code, f.restriction_type, cast(sum(g.amount) as decimal(18,2)) as balance
    from :ps_schema.gl_transaction g join :ps_schema.fund f on f.fund_code = g.fund_code
    where g.account_type = 'fund_balance' and g.fiscal_period_key <= :as_of_period
    group by g.company, g.fund_code, f.restriction_type
),
wd as (
    select g.company, g.fund_code, f.restriction_type, cast(sum(g.amount) as decimal(18,2)) as balance
    from :wd_schema.gl_transaction g join :wd_schema.fund f on f.fund_code = g.fund_code
    where g.account_type = 'fund_balance' and g.fiscal_period_key <= :as_of_period
    group by g.company, g.fund_code, f.restriction_type
)
select coalesce(ps.company, wd.company) as company, coalesce(ps.fund_code, wd.fund_code) as fund_code,
       ps.restriction_type as ps_restriction, wd.restriction_type as wd_restriction,
       ps.balance as ps_balance, wd.balance as wd_balance,
       coalesce(ps.balance,0) - coalesce(wd.balance,0) as variance
from ps full outer join wd on ps.company = wd.company and ps.fund_code = wd.fund_code
where abs(coalesce(ps.balance,0) - coalesce(wd.balance,0)) > :tolerance
   or coalesce(ps.restriction_type,'?') <> coalesce(wd.restriction_type,'?');
