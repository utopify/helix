# HELIX XREF: PeopleSoft Campus Solutions to Workday Student

Direct value-level crosswalks for moving from PeopleSoft Campus Solutions to Workday Student. Each file lets a migrator look up a PeopleSoft code and get the Workday value in one step, through the HELIX canonical code.

The bridge mappings (`bridge/peoplesoft/cs/` and `bridge/workday/sis/`) tell you which **fields** line up. These crosswalks tell you which **values** line up, which is where most conversion time actually goes.

## How to use a crosswalk

Lookup order is always the same:

```
PeopleSoft code  ->  helix_code (bound to helix_terminology)  ->  Workday value / object
```

1. Find the PeopleSoft value in `ps_code` (the source record and field is in `ps_source`).
2. Read the HELIX canonical code in `helix_code`. This is the value that lands in the HELIX Silver layer.
3. Read `wd_value` and `wd_object` for the Workday load (EIB or Workday Web Services).
4. Read `notes` for conversion rules, history guidance, and anything flagged `VALIDATE:`.

Every file ships as JSON and CSV with the same rows. Columns: `ps_code, ps_description, ps_source, helix_code, helix_terminology, wd_value, wd_description, wd_object, notes`.

## Dimensions

| File | Dimension | Rows | HELIX terminology |
|------|-----------|-----:|-------------------|
| `identifier-xref` | Person identifiers (EMPLID, national ID, external IDs) | 13 | helix/identifier-type |
| `academic-career-level-xref` | ACAD_CAREER to Academic Level | 9 | helix/degree-level, helix/course-level |
| `program-plan-xref` | ACAD_PROG / PLAN / SUB_PLAN to Program of Study, Concentration, Academic Unit | 11 | helix/degree-level |
| `term-period-xref` | STRM / SESSION_CODE to Academic Period | 12 | helix/period-type |
| `enrollment-status-xref` | STDNT_ENRL status and reason to Course Registration status | 9 | helix/enrollment-status |
| `grading-basis-xref` | GRADING_BASIS to Grading Basis | 8 | helix/grade-mode |
| `program-status-xref` | PROG_STATUS + PROG_ACTION to Program of Study Record | 13 | helix/student-status |
| `admit-type-xref` | ADMIT_TYPE and application actions to Admissions | 15 | helix/student-type, helix/admission-status |
| `service-indicator-hold-xref` | Service indicators to Student Hold Types | 12 | helix/hold-type |
| `instruction-mode-xref` | INSTRUCTION_MODE / SSR_COMPONENT to Delivery Mode, Instructional Format | 13 | helix/delivery-mode |
| `fin-aid-item-type-xref` | Aid item types to award types and funds | 13 | helix/award-type |
| `sap-status-xref` | SAP_STATUS to Workday SAP status | 8 | helix/sap-status |
| `verification-status-xref` | Verification state and tracking group | 12 | helix/verification-status |
| `loan-type-xref` | Loan types to Workday Direct Loan and private loan funds | 9 | helix/loan-type |
| `disbursement-status-xref` | Disbursement state to Workday disbursement status | 8 | helix/disbursement-status |

**Total: 15 dimensions, 165 rows.**

## Identity comes first: one human, one person

PeopleSoft `EMPLID` is a single key shared by HCM and Campus Solutions. A faculty member who takes a class, or a student worker on payroll, has one EMPLID. Workday keeps that idea through the **Universal ID**.

- Resolve identity once, Bronze to Silver, into a single HELIX Person (see `govern/ferpa-disclosure-framework.json`).
- Seed the Workday Universal ID from that resolved person.
- When Workday HCM goes live before Workday Student (the common sequence), the Student load must match to the existing person by Universal ID, never create a new one.

If you get this wrong, you get duplicate people, split FERPA restrictions, and payroll records that cannot find their student.

## Structural crosswalks

`program-plan-xref` and `term-period-xref` are structural. They show the pattern with representative rows rather than listing every value:

- The PeopleSoft stack ACAD_PROG > ACAD_PLAN > ACAD_SUB_PLAN collapses into Workday **Program of Study + Concentration**, and the program usually becomes the owning **Academic Unit**.
- A PeopleSoft term becomes a **parent Academic Period**; each session under it becomes a **child Academic Period**. Build one Academic Calendar per distinct schedule, not one per career.

## VALIDATE

Rows marked `VALIDATE:` in `notes` are values that commonly vary by institution, PeopleSoft release, or Workday tenant configuration (for example, ADMIT_TYPE and service indicator codes are institution defined, and some Workday object labels differ by tenant). They are honest starting points, not authoritative values. Confirm them against your PeopleSoft translate tables and your Workday tenant before loading.

Related: `bridge/xref/ps-to-workday-hr/`, `bridge/xref/ps-to-workday-fin/`, `docs/ps-to-workday-migration.md`.
