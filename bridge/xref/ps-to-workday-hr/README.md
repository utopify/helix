# HELIX XREF: PeopleSoft HCM to Workday HCM

Direct crosswalks from PeopleSoft HCM codes to Workday HCM values, routed through the HELIX canonical code. These files exist so a migration team can look up a PeopleSoft value and get its Workday equivalent in one step, instead of reading `bridge/peoplesoft/hcm/` and `bridge/workday/hr/` side by side and matching them by hand.

Same shape as the finance crosswalks in `../ps-to-workday-fin/`: every dimension ships as a JSON file (`title`, `version`, `dimension`, `description`, `mappings`) and a CSV with identical rows, so you can load them into a warehouse, a dbt seed, or a spreadsheet.

## How to use a crosswalk

Lookup order is always:

```
PeopleSoft code  -->  helix_code  -->  Workday value
(ps_code)            (canonical)       (wd_value on wd_object)
```

1. Find the PeopleSoft value in `ps_code`. `ps_source` tells you which record and field it comes from.
2. Read `helix_code`. That is the canonical HELIX value, and it always exists in the terminology named in `helix_terminology` (see `core/terminologies/`).
3. Read `wd_value` and `wd_object` for the Workday target, and check `notes` before you load.

Because the middle column is canonical, the same HELIX code also lines up with the Banner, Colleague, and Workday bridges. If you later add a different target system, you reuse the left half of these files unchanged.

## Row columns

| Column | Meaning |
|--------|---------|
| `ps_code` | PeopleSoft value (or value combination, such as `EMP + R`) |
| `ps_description` | What the PeopleSoft value means |
| `ps_source` | PeopleSoft record.field the value comes from |
| `helix_code` | HELIX canonical code |
| `helix_terminology` | HELIX code system the code belongs to |
| `wd_value` | Workday value, plan, or business process |
| `wd_description` | What the Workday value means |
| `wd_object` | Workday business object, field, or business process |
| `notes` | Conversion guidance, edge cases, and `VALIDATE:` flags |

## Dimensions (121 rows)

| File | Dimension | HELIX terminology | Rows |
|------|-----------|-------------------|-----:|
| `worker-type-xref.json` / `.csv` | Worker Type / Employee Type | `helix/worker-type` | 12 |
| `employment-status-xref.json` / `.csv` | Employment Status | `helix/employment-status` | 12 |
| `job-action-xref.json` / `.csv` | Job Action / Business Process Event | `helix/employment-status` | 15 |
| `compensation-xref.json` / `.csv` | Compensation Component / Earning | `helix/compensation-type` | 13 |
| `pay-frequency-xref.json` / `.csv` | Pay Frequency / Pay Group | `helix/pay-frequency` | 8 |
| `deduction-benefit-xref.json` / `.csv` | Benefit Plan Type / Deduction | `helix/benefit-plan-type` | 13 |
| `absence-type-xref.json` / `.csv` | Absence Type | `helix/absence-type` | 12 |
| `flsa-eeo-xref.json` / `.csv` | FLSA Status / EEO-IPEDS Category | `helix/eeo-category`, `helix/flsa-status` | 10 |
| `job-code-to-profile-xref.json` / `.csv` | Job Code / Job Profile / Compensation Grade | `helix/eeo-category`, `helix/faculty-rank`, `helix/worker-type` | 16 |
| `position-xref.json` / `.csv` | Position / Staffing Model | `helix/position-status` | 10 |

## The one principle that matters most: rows become events

PeopleSoft stores the employee as effective-dated rows on `PS_JOB` (EFFDT + EFFSEQ). Each row is a snapshot of state. Workday stores the employee as a sequence of business process events (Hire, Change Job, Request Compensation Change, Place Worker on Leave, Terminate).

So history conversion is not a row-for-row copy. Use `job-action-xref` and plan for three patterns:

```
One PS row      -->  one WD event        (HIR  -> Hire Employee)
One PS row      -->  several WD events   (XFR with a pay change -> Change Job + Request Compensation Change)
Several PS rows -->  one WD event        (LOA + RFL pair -> one leave with first and last day;
                                          same-day DTA corrections -> collapse or skip)
```

Two practical rules:

- Decide how much history you convert before you map anything. Many institutions load current state plus a limited window of job history, and archive the rest.
- Review `DTA` (data change) volume early. It is usually the largest action code in PeopleSoft and much of it should never become a Workday event.

## Structural decisions these files surface

Some rows are not value lookups, they are design decisions your team has to make before loading:

- **Supervisory Organizations** come from the `REPORTS_TO` position tree, not from `DEPTID`. `DEPTID` becomes Cost Center. See `position-xref`.
- **Position Management vs Job Management** is set per Supervisory Organization. Position-controlled staff usually go to Position Management; student workers, adjuncts, and temps usually go to Job Management. See `position-xref`.
- **Faculty rank and tenure** live on the Workday Academic Appointment, not only on the Job Profile. See `job-code-to-profile-xref`.
- **9-over-12 academic pay** is the most error-prone faculty conversion. See `pay-frequency-xref`.
- **Persons of Interest** have no `PS_JOB` row. Decide per POI type whether they become Contingent Workers, Academic Affiliates, or nothing. See `worker-type-xref`.

## A note on `VALIDATE:`

PeopleSoft code values (EMPL_CLASS, ERNCD, COMP_RATECD, POI_TYPE, plan type numbers) and Workday tenant configuration (Employee Types, Leave Types, plan names) vary by institution. Rows use commonly documented values. Where a value is known to vary, the `notes` column starts with `VALIDATE:`. Treat those rows as the pattern, then replace the value with what your PeopleSoft system and your Workday tenant actually use. Nothing in these files replaces a pull of your own PS setup tables.

## Related files

- `../ps-to-workday-fin/` and `../ps-to-workday-sis/`: the finance and student crosswalks
- `../../peoplesoft/hcm/` and `../../workday/hr/`: full column-level bridge mappings
- `core/terminologies/`: the HELIX code systems referenced in `helix_terminology`
- `templates/ps-to-workday/`: conversion rules and the reconciliation pack
- `docs/ps-to-workday-migration.md`: the end-to-end cutover guide
