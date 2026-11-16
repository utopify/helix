# HELIX Bridge: Banner Finance

Finance module mappings from Ellucian Banner to HELIX Core Financial Operations resources.

## Mappings (7 resources)

| HELIX Resource | Mapping File | Key Banner Tables | Attrs |
|---------------|-------------|-------------------|-------|
| GLTransaction | `gl_transaction_mapping.json` | FGBTRND, FGBTRNH, FGBJVCD, FTVACCT, FTVFUND, FTVORGN, FTVPROG | 20 |
| Fund | `fund_mapping.json` | FTVFUND, FTVFTYP | 8 |
| Budget | `budget_mapping.json` | FGBBALC, FTVACCT | 12 |
| APVoucher | `ap_voucher_mapping.json` | FABINVH, FABINVD, FABCHKD, FTVVEND | 17 |
| PurchaseOrder | `purchase_order_mapping.json` | FPBPOHD, FPBPODT, FTVVEND | 19 |
| FinancialOrg | `financial_org_mapping.json` | FTVORGN, FTVFMGR | 9 |
| Grant | `grant_mapping.json` | FRBGRNT, FRRGRPH, FRVGRNT, FTVAGCY | 21 |

## Key Banner Finance Table Prefixes

| Prefix | Meaning | Examples |
|--------|---------|----------|
| **FGB** | Finance General ledger Base | FGBTRND (transaction detail), FGBTRNH (header), FGBBALC (balances), FGBJVCD (journal voucher) |
| **FTV** | Finance validation | FTVACCT (account), FTVFUND (fund), FTVORGN (org), FTVPROG (program), FTVVEND (vendor), FTVFTYP (fund type), FTVAGCY (agency) |
| **FAB** | Finance Accounts payable Base | FABINVH (invoice header), FABINVD (invoice detail), FABCHKD (check detail) |
| **FPB** | Finance Purchasing Base | FPBPOHD (PO header), FPBPODT (PO detail) |
| **FRB/FRR** | Finance Research/gRant | FRBGRNT (grant), FRRGRPH (grant personnel) |

Banner Finance is built on the **FOAPAL** accounting string: Fund, Organization, Account, Program, Activity, Location. Every GL transaction and budget line distributes across FOAPAL elements, each decoded through its FTV validation table.
