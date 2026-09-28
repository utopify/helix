# HELIX XREF: PeopleSoft Financials to Workday Financial Management

Value-level crosswalks for moving from PeopleSoft FSCM to Workday Financial Management. PeopleSoft carries meaning in the chartfield string; Workday spreads it across a Ledger Account and a set of worktags. These files show where each PeopleSoft value lands.

## How to use a crosswalk

```
PeopleSoft chartfield value  ->  HELIX code  ->  Workday ledger account / worktag
```

Pair these files with the executable conversion rules in `templates/ps-to-workday/worktag-conversion-rules.json`, which decide which crosswalk applies to a given journal line.

## Dimensions

| File | Dimension | Rows | Workday target |
|------|-----------|-----:|----------------|
| `account-xref` | Account | 31 | Ledger Account |
| `fund-xref` | Fund | 14 | Fund |
| `department-xref` | Department | 15 | Cost Center |
| `program-xref` | Program / functional classification | 12 | Program |
| `business-unit-company-xref` | Business Unit | 8 | Company, Company Hierarchy |
| `revenue-spend-category-xref` | Account range to category | 16 | Ledger Account + Revenue / Spend Category |
| `project-grant-xref` | Project, award, contract | 12 | Grant, Award, Project, Gift |
| `vendor-supplier-xref` | Vendor | 12 | Supplier, Supplier Category, Payment Type |

**Total: 8 dimensions, 120 rows.**

The first four files use the original v0.1 column layout (`ps_account`, `helix_code`, `wd_ledger_account`, and so on). The four files added in v0.6.0 use the shared crosswalk layout also used by the HR and Student folders: `ps_code, ps_description, ps_source, helix_code, helix_terminology, wd_value, wd_description, wd_object, notes`. Where `helix_terminology` is blank, `helix_code` is a HELIX FIN classification code (the same custom-code style as `account-xref`) rather than a terminology-bound code.

## Rules that save the most time

- **One PeopleSoft account often becomes a Ledger Account plus a category.** Workday keeps ledger accounts summarized and moves detail to Revenue Category and Spend Category (`revenue-spend-category-xref`).
- **PROJECT_ID does too many jobs in PeopleSoft.** Split it into Grant (sponsored), Project (capital and internal), and Gift (donor restricted) (`project-grant-xref`).
- **Business units are not always Companies.** Only separate legal or filing entities become Companies; campuses and schools usually become hierarchy (`business-unit-company-xref`).
- **Not every vendor is a supplier.** Employee and student payees move to Expenses and Student refunds (`vendor-supplier-xref`).

## VALIDATE

Rows marked `VALIDATE:` in `notes` depend on local configuration (for example, PeopleSoft VENDOR_CLASS values or whether a medical school is a separate entity). Confirm them before loading.

Related: `bridge/xref/ps-to-workday-hr/`, `bridge/xref/ps-to-workday-sis/`, `core/examples/02-chart-of-accounts-xref-peoplesoft-workday.md`.
