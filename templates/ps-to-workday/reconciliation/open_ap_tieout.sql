/*
  HELIX PS to Workday Reconciliation: Open AP Tie-Out
  ===========================================================================
  What it checks: Every open PeopleSoft voucher exists as an open Workday supplier invoice with the same remaining amount.

  When to run: After open-item conversion and before first Workday payment run.

  What passing looks like:
    Zero rows. Duplicates or missing invoices risk double or missed payments.

  Parameters:
    :ps_schema          HELIX Silver from PeopleSoft
    :wd_schema          HELIX Silver from Workday
    :cutover_date       Cutover date

  Model: both sides are compared through HELIX Silver. :ps_schema holds the
  PeopleSoft extract mapped to HELIX; :wd_schema holds the Workday extract
  (RaaS / Web Services / EIB round-trip) mapped to HELIX.

  Warehouse notes: Snowflake/Redshift: works as-is. BigQuery: replace DECIMAL with NUMERIC and :param with @param.
*/

with ps as (
    select vendor_id, invoice_number, cast(sum(gross_amount) as decimal(18,2)) as open_amount
    from :ps_schema.ap_voucher
    where voucher_status not in ('paid','cancelled','voided') and invoice_date <= :cutover_date
    group by vendor_id, invoice_number
),
wd as (
    select vendor_id, invoice_number, cast(sum(gross_amount) as decimal(18,2)) as open_amount, count(*) as copies
    from :wd_schema.ap_voucher
    where voucher_status not in ('paid','cancelled','voided')
    group by vendor_id, invoice_number
)
select coalesce(ps.vendor_id, wd.vendor_id) as vendor_id, coalesce(ps.invoice_number, wd.invoice_number) as invoice_number,
       ps.open_amount as ps_open, wd.open_amount as wd_open, wd.copies,
       case when ps.invoice_number is null then 'extra_in_workday'
            when wd.invoice_number is null then 'missing_in_workday'
            when wd.copies > 1 then 'duplicate_in_workday'
            else 'amount_mismatch' end as issue
from ps full outer join wd on ps.vendor_id = wd.vendor_id and ps.invoice_number = wd.invoice_number
where ps.invoice_number is null or wd.invoice_number is null or wd.copies > 1 or ps.open_amount <> wd.open_amount;
