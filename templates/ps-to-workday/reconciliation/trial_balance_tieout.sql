/*
  HELIX PS to Workday Reconciliation: Trial Balance Tie-Out
  ===========================================================================
  What it checks: Net balance by Company, Ledger Account, Fund, and period matches between converted PeopleSoft GL and Workday.

  When to run: After every GL conversion load and every parallel period close.

  What passing looks like:
    Zero rows returned. Any row is an unexplained variance.

  Parameters:
    :ps_schema          HELIX Silver from PeopleSoft
    :wd_schema          HELIX Silver from Workday
    :fiscal_year        Fiscal year
    :tolerance          Use 0.00

  Model: both sides are compared through HELIX Silver. :ps_schema holds the
  PeopleSoft extract mapped to HELIX; :wd_schema holds the Workday extract
  (RaaS / Web Services / EIB round-trip) mapped to HELIX.

  Warehouse notes: Snowflake/Redshift: works as-is. BigQuery: replace DECIMAL with NUMERIC and :param with @param.
*/

with ps as (
    select company, ledger_account, fund_code, accounting_period,
           cast(sum(amount) as decimal(18,2)) as net_amount
    from :ps_schema.gl_transaction
    where fiscal_year = :fiscal_year
    group by company, ledger_account, fund_code, accounting_period
),
wd as (
    select company, ledger_account, fund_code, accounting_period,
           cast(sum(amount) as decimal(18,2)) as net_amount
    from :wd_schema.gl_transaction
    where fiscal_year = :fiscal_year
    group by company, ledger_account, fund_code, accounting_period
)
select coalesce(ps.company, wd.company)                   as company,
       coalesce(ps.ledger_account, wd.ledger_account)     as ledger_account,
       coalesce(ps.fund_code, wd.fund_code)               as fund_code,
       coalesce(ps.accounting_period, wd.accounting_period) as accounting_period,
       ps.net_amount as ps_net, wd.net_amount as wd_net,
       coalesce(ps.net_amount,0) - coalesce(wd.net_amount,0) as variance
from ps
full outer join wd
  on  ps.company = wd.company and ps.ledger_account = wd.ledger_account
  and ps.fund_code = wd.fund_code and ps.accounting_period = wd.accounting_period
where abs(coalesce(ps.net_amount,0) - coalesce(wd.net_amount,0)) > :tolerance
order by abs(coalesce(ps.net_amount,0) - coalesce(wd.net_amount,0)) desc;
