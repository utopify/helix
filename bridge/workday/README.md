# HELIX Bridge: Workday

42 mappings across 3 modules. Full parity with PeopleSoft.

- `sis/` — Student Information System (19 mappings)
- `fin/` — Financial Management (11 mappings)
- `hr/` — Human Capital Management (12 mappings)

All mappings use Workday-native terminology (worktags, business objects, supervisory organizations) with 4 documented extraction methods (RaaS, REST API, Prism, Data Cloud).

## Coming from PeopleSoft?

The crosswalks in `../xref/ps-to-workday-{hr,fin,sis}/` translate PeopleSoft values directly into the Workday values these mappings expect. Start with `docs/ps-to-workday-migration.md`. *(v0.6.0)*
