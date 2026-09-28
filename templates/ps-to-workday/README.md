# PeopleSoft to Workday Templates

Executable building blocks for the HELIX cornerstone path. Start with `docs/ps-to-workday-migration.md` for the narrative; use these files to do the work.

| File | What it is |
|------|------------|
| `worktag-conversion-rules.json` | 20 FIN rules that convert a PeopleSoft chartfield string into a Workday Ledger Account plus worktags, with precedence, fallbacks, suspense handling, validation checks, and 5 worked examples. Also 10 HCM field rules (JOB actions to business processes, JOBCODE to Job Profile, EMPLID to Universal ID) and 7 Student field rules. |
| `reconciliation/` | 18 tie-out queries (6 FIN, 6 HCM, 6 Student) with run order, tolerances, parallel cadence, and sign-off roles. |

## How the pieces fit

```
PeopleSoft extract
      |
      v
bridge/peoplesoft/{fin,hcm,cs}  --->  HELIX Silver (canonical)
      |                                      |
      +--> bridge/xref/ps-to-workday-*  <----+   (direct code lookups)
      |
      v
templates/ps-to-workday/worktag-conversion-rules.json
      |
      v
Workday load files (EIB / Web Services)
      |
      v
templates/ps-to-workday/reconciliation/*.sql  (prove it)
```

Codes marked VALIDATE in the xrefs and rules differ by institution or Workday tenant. Confirm them in your own configuration workbook before a mock load.
