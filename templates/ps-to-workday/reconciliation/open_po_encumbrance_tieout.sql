/*
  HELIX PS to Workday Reconciliation: Open PO Encumbrance Tie-Out
  ===========================================================================
  What it checks: Open PO balances and encumbrances by Company, Fund, and Cost Center match after conversion.

  When to run: After open PO conversion, before budget checking goes live in Workday.

  What passing looks like:
    Zero rows. Encumbrance variance means budget availability will be wrong on day one.

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
    select business_unit as company, line_fund as fund_code, line_department as cost_center,
           cast(sum(line_amount) as decimal(18,2)) as open_encumbrance
    from :ps_schema.purchase_order where po_status in ('approved','dispatched','partially_received')
    group by business_unit, line_fund, line_department
),
wd as (
    select business_unit as company, line_fund as fund_code, line_department as cost_center,
           cast(sum(line_amount) as decimal(18,2)) as open_encumbrance
    from :wd_schema.purchase_order where po_status in ('approved','dispatched','partially_received')
    group by business_unit, line_fund, line_department
)
select coalesce(ps.company,wd.company) as company, coalesce(ps.fund_code,wd.fund_code) as fund_code,
       coalesce(ps.cost_center,wd.cost_center) as cost_center,
       ps.open_encumbrance as ps_enc, wd.open_encumbrance as wd_enc,
       coalesce(ps.open_encumbrance,0) - coalesce(wd.open_encumbrance,0) as variance
from ps full outer join wd on ps.company=wd.company and ps.fund_code=wd.fund_code and ps.cost_center=wd.cost_center
where abs(coalesce(ps.open_encumbrance,0) - coalesce(wd.open_encumbrance,0)) > :tolerance;
