# HELIX Bridge: Oracle PeopleSoft

42 mappings across 3 modules with full PS table/record references.

- `cs/` — Campus Solutions / SIS (19 mappings)
- `fin/` — Financials / FSCM (11 mappings, 69 PS source tables)
- `hcm/` — Human Capital Management (12 mappings, 60 PS source tables)

## Moving to Workday?

Use the direct crosswalks in `../xref/ps-to-workday-hr/`, `../xref/ps-to-workday-fin/`, and `../xref/ps-to-workday-sis/` (PS code -> HELIX code -> Workday value), the conversion rules in `templates/ps-to-workday/worktag-conversion-rules.json`, and the 18 tie-outs in `templates/ps-to-workday/reconciliation/`. The full playbook is `docs/ps-to-workday-migration.md`. *(v0.6.0)*
