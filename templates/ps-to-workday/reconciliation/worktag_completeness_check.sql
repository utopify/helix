/*
  HELIX PS to Workday Reconciliation: Worktag Completeness Check
  ===========================================================================
  What it checks: Every converted Workday journal line carries the worktags required by templates/ps-to-workday/worktag-conversion-rules.json (validation_checks).

  When to run: After every conversion load, before posting.

  What passing looks like:
    Zero rows. Lines in suspense are counted separately and must be cleared by the Data Steward.

  Parameters:
    :wd_schema          HELIX Silver from Workday
    :fiscal_year        Fiscal year

  Model: both sides are compared through HELIX Silver. :ps_schema holds the
  PeopleSoft extract mapped to HELIX; :wd_schema holds the Workday extract
  (RaaS / Web Services / EIB round-trip) mapped to HELIX.

  Warehouse notes: Pure Workday-side check; no PeopleSoft comparison needed.
*/

select transaction_id, company, ledger_account, account_type, fund_code, department as cost_center, program_code,
       case when company is null                                            then 'missing_company'
            when ledger_account is null                                     then 'missing_ledger_account'
            when account_type in ('revenue','expenditure') and fund_code is null    then 'missing_fund'
            when account_type in ('revenue','expenditure') and department is null   then 'missing_cost_center'
            when account_type in ('revenue','expenditure') and program_code is null then 'missing_program'
            when ledger_account like '%SUSPENSE%'                          then 'in_suspense'
       end as issue
from :wd_schema.gl_transaction
where fiscal_year = :fiscal_year
  and (company is null or ledger_account is null or ledger_account like '%SUSPENSE%'
       or (account_type in ('revenue','expenditure') and (fund_code is null or department is null or program_code is null)));
