# HELIX Bridge

163 mapping templates: 147 ERP-to-HELIX mappings across 4 major systems, 8 Outcomes mappings from sources outside the ERP, and an 8-mapping reverse bridge from HELIX into Banner SaaS. Every one of the 64 Core resources has at least one mapping.

| ERP | Mappings | Modules |
|-----|----------|---------|
| PeopleSoft | 54 | CS (31), FIN (11), HCM (12) |
| Banner (on-prem) | 35 | SIS (14), HR (2), Finance (7), Advancement (5), Financial Aid (7) |
| Workday | 54 | SIS (31), FIN (11), HR (12) |
| Colleague | 4 | SIS (4) |
| Outcomes (non-ERP) | 8 | Handshake, Clearinghouse, state wage records, licensure results, Canvas (`outcomes/`) |
| Banner SaaS (reverse) | 8 | HELIX to Ethos write-back |

## PeopleSoft to Workday crosswalks (`xref/`)

Direct code lookups (PS code → HELIX code → Workday value), so a PeopleSoft to Workday team never has to hop through two bridge files.

| Folder | Dimensions | Rows |
|--------|-----------:|-----:|
| `xref/ps-to-workday-hr/` | 10 | 121 |
| `xref/ps-to-workday-fin/` | 8 | 120 |
| `xref/ps-to-workday-sis/` | 15 | 165 |
| **Total** | **33** | **406** |

Every dimension ships as JSON and CSV. Pair with `templates/ps-to-workday/worktag-conversion-rules.json` and the reconciliation pack in `templates/ps-to-workday/reconciliation/`.

PeopleSoft ↔ Workday parity: SIS 100% (including the full financial aid lifecycle), FIN 96%, HCM 100%.

Extraction playbooks: PeopleSoft `peoplesoft/PS_EXTRACTION.md`, Banner on-prem `banner/ONPREM_EXTRACTION.md`. Banner SaaS write-back: `banner-saas/WRITEBACK_PATTERNS.md`.
