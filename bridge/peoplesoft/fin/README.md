# HELIX Bridge: PeopleSoft Financials (FSCM)

Financial management mappings from Oracle PeopleSoft Financials & Supply Chain Management to HELIX planned resources.

## Mappings (6 areas)

| Area | Mapping File | Key PS Tables |
|------|-------------|---------------|
| General Ledger | `general_ledger_mapping.json` | PS_JRNL_HEADER, PS_JRNL_LN, PS_LEDGER, PS_GL_ACCOUNT_TBL |
| Accounts Payable | `accounts_payable_mapping.json` | PS_VOUCHER, PS_VOUCHER_LINE, PS_PAYMENT_TBL, PS_VENDOR |
| Accounts Receivable / Student Financials | `accounts_receivable_mapping.json` | PS_ITEM, PS_ITEM_LINE_DTL, PS_ITEM_TYPE_TBL |
| Purchasing | `purchasing_mapping.json` | PS_PO_HDR, PS_PO_LINE, PS_PO_LINE_DISTRIB, PS_RECV_LN_SHIP |
| Budget / Commitment Control | `budget_mapping.json` | PS_KK_BUDGET_ACTVY, PS_LEDGER_KK, PS_KK_BD_CONTROL |
| Grants | `grants_mapping.json` | PS_GM_AWARD, PS_PROJECT, PS_GM_SPONSOR |

## Key PeopleSoft FIN Concepts

- **Chartfields**: Flexible chart of accounts structure. Key fields: Business Unit, Account, Fund, Department, Program, Class, Project. Institutions configure which are active.
- **Fund Accounting**: Critical for public higher ed (GASB). Fund codes separate unrestricted, restricted, auxiliary, plant, and endowment activities.
- **Commitment Control (KK)**: Budget checking engine. Tracks budget → pre-encumbrance → encumbrance → expenditure. Can warn or block overages.
- **Student Financials (SF)**: Specialized AR module for student billing. PS_ITEM is the core table. Integrates tuition calculation, financial aid disbursement, and GL posting.
- **Business Unit**: PeopleSoft's organizational partitioning concept. Each BU has its own GL, AP, AR. Multi-campus systems may have one BU per campus.

## Status

These mappings target **planned HELIX Core v0.2 resources** (Finance/GL domain). The source table references and transformation logic are production-ready; the target HELIX resource definitions will be formalized in v0.2.