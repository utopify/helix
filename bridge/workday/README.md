# HELIX Bridge: Workday

54 mappings across 3 modules. Full parity with PeopleSoft.

- `sis/` — Student Information System (31 mappings, including 10 financial aid)
- `fin/` — Financial Management (11 mappings)
- `hr/` — Human Capital Management (12 mappings)

All mappings use Workday-native terminology (worktags, business objects, supervisory organizations) Default extraction is RaaS plus Web Services, which come with the Workday subscription. Prism Analytics (brings data into Workday) and Workday Data Cloud (zero-copy, separately priced) are optional; see [`docs/landing-zones/workday-landing-zone.md`](../../docs/landing-zones/workday-landing-zone.md).

## Coming from PeopleSoft?

The crosswalks in `../xref/ps-to-workday-{hr,fin,sis}/` translate PeopleSoft values directly into the Workday values these mappings expect. Start with `docs/ps-to-workday-migration.md`. *(v0.6.0)*
