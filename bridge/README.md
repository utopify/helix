# HELIX Bridge

126 mapping templates: 118 ERP-to-HELIX mappings across 4 major systems, plus an 8-mapping reverse bridge from HELIX into Banner SaaS.

| ERP | Mappings | Modules |
|-----|----------|---------|
| PeopleSoft | 42 | CS (19), FIN (11), HCM (12) |
| Banner (on-prem) | 31 | SIS (11), HR (2), Finance (7), Advancement (4), Financial Aid (7) |
| Workday | 42 | SIS (19), FIN (11), HR (12) |
| Colleague | 3 | SIS (3) |
| Banner SaaS (reverse) | 8 | HELIX to Ethos write-back |

## PeopleSoft to Workday crosswalks (`xref/`)

Direct code lookups (PS code → HELIX code → Workday value), so a PeopleSoft to Workday team never has to hop through two bridge files.

| Folder | Dimensions | Rows |
|--------|-----------:|-----:|
| `xref/ps-to-workday-hr/` | 10 | 121 |
| `xref/ps-to-workday-fin/` | 8 | 120 |
| `xref/ps-to-workday-sis/` | 11 | 128 |
| **Total** | **29** | **369** |

Every dimension ships as JSON and CSV. Pair with `templates/ps-to-workday/worktag-conversion-rules.json` and the reconciliation pack in `templates/ps-to-workday/reconciliation/`.

PeopleSoft ↔ Workday parity: SIS 100%, FIN 96%, HCM 100%.

Banner on-prem extraction: `banner/ONPREM_EXTRACTION.md`. Banner SaaS write-back: `banner-saas/WRITEBACK_PATTERNS.md`.
