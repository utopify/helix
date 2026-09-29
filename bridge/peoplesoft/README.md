# HELIX Bridge: Oracle PeopleSoft

54 mappings across 3 modules with full PS table/record references.

- `cs/` — Campus Solutions / SIS (31 mappings, including 10 financial aid)
- `fin/` — Financials / FSCM (11 mappings, 69 PS source tables)
- `hcm/` — Human Capital Management (12 mappings, 60 PS source tables)

## Getting data out of PeopleSoft

Start with [`PS_EXTRACTION.md`](PS_EXTRACTION.md): which databases to read from, EMPLID across pillars, EFFDT/EFFSEQ, SETID, translate values, incremental loads, and what to extract for each first slice. *(v0.7.0)*

## Moving to Workday?

Use the direct crosswalks in `../xref/ps-to-workday-hr/`, `../xref/ps-to-workday-fin/`, and `../xref/ps-to-workday-sis/` (PS code -> HELIX code -> Workday value), the conversion rules in `templates/ps-to-workday/worktag-conversion-rules.json`, and the 22 tie-outs in `templates/ps-to-workday/reconciliation/`. The full playbook is `docs/ps-to-workday-migration.md`. *(v0.6.0)*
