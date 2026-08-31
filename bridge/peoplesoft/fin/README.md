# HELIX Bridge: PeopleSoft Financials (FSCM)

Financial management mappings from Oracle PeopleSoft Financials & Supply Chain Management to HELIX planned resources.

**Coverage: 82%** of PeopleSoft FIN functional areas (9 of 11).

## Mappings (9 areas)

| Area | Mapping File | Key PS Tables | Attributes |
|------|-------------|---------------|------------|
| APVoucher | `accounts_payable_mapping.json` | PS_VOUCHER, PS_VOUCHER_LINE, PS_DISTRIB_LINE +3 more | 20 |
| StudentAccount | `accounts_receivable_mapping.json` | PS_ITEM, PS_ITEM_LINE_DTL, PS_SF_ACCTG_LN +2 more | 16 |
| FixedAsset | `asset_management_mapping.json` | PS_ASSET, PS_ASSET_ACQUIS_DT, PS_ASSET_DEPR +2 more | 22 |
| Budget | `budget_mapping.json` | PS_KK_BUDGET_ACTVY, PS_LEDGER_KK, PS_KK_BD_CONTROL +1 more | 16 |
| Contract | `contracts_mapping.json` | PS_CA_CONTR_HDR, PS_CA_CONTR_LINE, PS_CA_CONTR_DIST +2 more | 17 |
| ExpenseReport | `expenses_mapping.json` | PS_EX_SHEET_HDR, PS_EX_SHEET_LINE, PS_EX_SHEET_DIST +3 more | 14 |
| GLTransaction | `general_ledger_mapping.json` | PS_JRNL_HEADER, PS_JRNL_LN, PS_LEDGER +5 more | 22 |
| Grant | `grants_mapping.json` | PS_GM_AWARD, PS_GM_AWD_PRJ_LNK, PS_PROJECT +3 more | 16 |
| PurchaseOrder | `purchasing_mapping.json` | PS_PO_HDR, PS_PO_LINE, PS_PO_LINE_DISTRIB +3 more | 19 |

## Key PeopleSoft FIN Concepts

- **Chartfields**: Flexible chart of accounts structure. Key fields: Business Unit, Account, Fund, Department, Program, Class, Project. Institutions configure which are active.
- **Fund Accounting**: Critical for public higher ed (GASB). Fund codes separate unrestricted, restricted, auxiliary, plant, and endowment activities.
- **Commitment Control (KK)**: Budget checking engine. Tracks budget → pre-encumbrance → encumbrance → expenditure. Can warn or block overages.
- **Student Financials (SF)**: Specialized AR module for student billing. PS_ITEM is the core table. Integrates tuition calculation, financial aid disbursement, and GL posting.
- **Business Unit**: PeopleSoft's organizational partitioning concept. Each BU has its own GL, AP, AR. Multi-campus systems may have one BU per campus.
- **Asset Capitalization**: Public institutions (GASB) and private (FASB) have different thresholds and reporting requirements. Federal grants require equipment tracking per 2 CFR 200.

## Not Yet Covered (planned for future versions)

- Treasury / Cash Management
- eProcurement / Catalog
