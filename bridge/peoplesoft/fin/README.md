# HELIX Bridge: PeopleSoft Financials

11 mappings with full PS table references:

- General Ledger (PS_JRNL_HEADER, PS_JRNL_LN, PS_LEDGER, PS_GL_ACCOUNT_TBL + 6 more)
- Accounts Payable (PS_VOUCHER, PS_DISTRIB_LINE, PS_VENDOR, PS_PAYMENT_TBL + 2 more)
- Accounts Receivable / Student Financials (PS_ITEM, PS_SF_ACCTG_LN, PS_ITEM_TYPE_TBL + 5 more)
- Budget / Commitment Control (PS_LEDGER_KK, PS_KK_BUDGET_TYPE + 4 more)
- Purchasing (PS_PO_HDR, PS_PO_LINE, PS_PO_LINE_DIST + 4 more)
- Grants / Sponsored Programs (PS_GM_AWD_HDR, PS_GM_BUDGET_DTL, PS_GM_SPONSOR + 6 more)
- Asset Management (PS_ASSET, PS_COST, PS_ASSET_CAT_TBL + 4 more)
- Expenses / Travel (PS_EX_SHEET_HDR, PS_EX_SHEET_LINE + 4 more)
- Contracts (PS_CNTRCT_HDR, PS_CNTRCT_LINE + 2 more)
- Cost Center / Department (PS_DEPT_TBL, PSTREENODE, PS_COMPANY_TBL)
- Fund (PS_FUND_TBL, PSTREENODE, PS_FUND_TYPE_TBL)

## Workday crosswalk

Direct PeopleSoft to Workday value lookups for this module live in `../../xref/ps-to-workday-fin/`. *(v0.6.0)*
