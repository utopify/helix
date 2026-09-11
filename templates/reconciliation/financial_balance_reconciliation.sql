/*
  HELIX Reconciliation: General Ledger Trial Balance
  ===========================================================================
  What it checks: The sum of all GL transactions in the source system must
                  match the sum in HELIX Silver — to the penny. This is the
                  most critical financial reconciliation.

  When to run: After every GL load. MUST pass before month-end close.

  What passing looks like:
    - source_total = helix_total for every fund + account combination
    - net_variance = 0.00 (zero tolerance for financial data)
    - If variance exists, every penny must be explained

  Parameters:
    :source_schema   — Source GL schema
    :helix_schema    — HELIX Silver schema
    :fiscal_year     — Fiscal year to reconcile
    :tolerance       — Acceptable variance (recommend 0.00 for GL)

  Warehouse notes:
    - Uses DECIMAL(18,2) for financial precision. Do NOT use FLOAT.
    - Snowflake/Redshift: works as-is
    - BigQuery: replace DECIMAL with NUMERIC
*/

with source_balances as (
    select
        fund_code,
        account_code,
        cast(sum(debit_amount) as decimal(18,2))           as total_debits,
        cast(sum(credit_amount) as decimal(18,2))          as total_credits,
        cast(sum(debit_amount) - sum(credit_amount) as decimal(18,2)) as net_balance
    from :source_schema.gl_transactions
    where fiscal_year = :fiscal_year
    group by fund_code, account_code
),

helix_balances as (
    select
        fund_ref                                           as fund_code,
        account_code,
        cast(sum(debit_amount) as decimal(18,2))           as total_debits,
        cast(sum(credit_amount) as decimal(18,2))          as total_credits,
        cast(sum(debit_amount) - sum(credit_amount) as decimal(18,2)) as net_balance
    from :helix_schema.helix_gl_transaction
    where fiscal_year = :fiscal_year
    group by fund_ref, account_code
)

select
    coalesce(s.fund_code, h.fund_code)                     as fund_code,
    coalesce(s.account_code, h.account_code)               as account_code,
    s.net_balance                                          as source_balance,
    h.net_balance                                          as helix_balance,
    coalesce(s.net_balance, 0) - coalesce(h.net_balance, 0) as variance,
    case
        when s.net_balance is null then 'FAIL: Missing in source'
        when h.net_balance is null then 'FAIL: Missing in HELIX'
        when abs(coalesce(s.net_balance, 0) - coalesce(h.net_balance, 0)) > :tolerance
            then 'FAIL: Variance exceeds tolerance'
        else 'PASS'
    end                                                    as status
from source_balances s
full outer join helix_balances h
    on s.fund_code = h.fund_code
    and s.account_code = h.account_code
where abs(coalesce(s.net_balance, 0) - coalesce(h.net_balance, 0)) > :tolerance
   or s.net_balance is null
   or h.net_balance is null
order by abs(coalesce(s.net_balance, 0) - coalesce(h.net_balance, 0)) desc;
