# PeopleSoft to Workday: The HELIX Cornerstone Guide

### HCM, Financials, and Student. One canonical hub, three tracks, one cutover plan.

> PeopleSoft to Workday is the most common ERP replacement in higher education, and it is the path HELIX was built to make easy. This guide is written the way a senior implementation lead would walk a team through it: what to do first, what to map, what to prove, and what will bite you at cutover.

---


> **Before you start this guide:** fill in the [institution profile](../templates/intake/institution-profile.md) and land your first slice with [`bridge/peoplesoft/PS_EXTRACTION.md`](../bridge/peoplesoft/PS_EXTRACTION.md). [START_HERE](../START_HERE.md) walks through both. Everything below assumes you can already get clean PeopleSoft data into bronze.

## Contents

1. [Why HELIX makes this faster](#1-why-helix-makes-this-faster)
2. [The three tracks and how to sequence them](#2-the-three-tracks-and-how-to-sequence-them)
3. [The identity foundation](#3-the-identity-foundation)
4. [The five-step loop every track follows](#4-the-five-step-loop-every-track-follows)
5. [Track playbook: HCM](#5-track-playbook-hcm)
6. [Track playbook: Financials](#6-track-playbook-financials)
7. [Track playbook: Student](#7-track-playbook-student)
8. [Worked examples, field by field](#8-worked-examples-field-by-field)
9. [Data conversion strategy](#9-data-conversion-strategy)
10. [Parallel runs and reconciliation](#10-parallel-runs-and-reconciliation)
11. [Cutover checklist: T-90 to T+30](#11-cutover-checklist-t-90-to-t30)
12. [Common pitfalls](#12-common-pitfalls)
13. [Which HELIX agent to use when](#13-which-helix-agent-to-use-when)
14. [File index](#14-file-index)

---

## 1. Why HELIX makes this faster

Most PeopleSoft to Workday projects map every field twice in people's heads: "what does this PS code mean" and then "what is the Workday equivalent." Teams rebuild that knowledge from scratch on every project, usually in spreadsheets that die with the implementation partner's contract.

HELIX turns that into a lookup.

```
  PeopleSoft                 HELIX Core                   Workday
  ----------                 ----------                   -------
  PS_JOB.ACTION = PRO   -->  lifecycle event         -->  Change Job
  EMPL_CLASS    = FAC   -->  helix/worker-type       -->  Employee Type
  ACCOUNT       = 50100 -->  EXP-SAL-FACULTY         -->  Ledger Account 6010
  STRM          = 2248  -->  helix/period-type       -->  Academic Period
                   |                                          ^
                   +------ bridge/xref/ps-to-workday-* -------+
                           (direct crosswalk, one lookup)
```

Three things make it fluid:

- **Bridge mappings on both sides.** PeopleSoft (54 mappings: CS 31, FIN 11, HCM 12) and Workday (54 mappings: SIS 31, FIN 11, HR 12) are both mapped to the same 64 HELIX Core resources, with near-full parity.
- **Direct crosswalks.** The `bridge/xref/ps-to-workday-*` folders collapse the two hops into one: a PS value, its HELIX code, and its Workday value on the same row.
- **Executable rules and proof.** `templates/ps-to-workday/worktag-conversion-rules.json` turns chartfields into worktags, and `templates/ps-to-workday/reconciliation/` proves the numbers tie before you sign off.

You map once, to HELIX. The Workday side is already built. And because the data lands in HELIX shape, the same work feeds your lakehouse, your IPEDS reporting, and every future system change.

---

## 2. The three tracks and how to sequence them

| Track | PeopleSoft source | Workday target | HELIX assets |
|-------|-------------------|----------------|--------------|
| **HCM** | HCM (PS_JOB, PS_POSITION_DATA, payroll, benefits) | Workday HCM + Payroll | `bridge/peoplesoft/hcm/`, `bridge/workday/hr/`, `bridge/xref/ps-to-workday-hr/`, HCM agent |
| **Financials** | FSCM (GL, AP, PO, grants, KK) | Workday Financial Management | `bridge/peoplesoft/fin/`, `bridge/workday/fin/`, `bridge/xref/ps-to-workday-fin/`, worktag rules, FIN agent |
| **Student** | Campus Solutions | Workday Student | `bridge/peoplesoft/cs/`, `bridge/workday/sis/`, `bridge/xref/ps-to-workday-sis/`, SIS agent |

**Recommended sequencing.** Most institutions land HCM and Financials together first, then Student in a later wave. There are good reasons for that pattern:

- HCM and FIN share the organizational backbone (supervisory orgs and cost centers) and payroll posts to the GL, so they are easiest to prove together.
- Student has the longest academic calendar dependency. You want to cut over at a term boundary, with a registration cycle and a financial aid year planned around it.
- Workday Student depends on a clean Universal ID, which the HCM wave establishes.

```
  Phase 0          Phase 1 (Wave 1)                      Phase 2 (Wave 2)
  --------         -----------------------------         ------------------------
  Identity    -->  HCM + Payroll  <---->  Financials -->  Student + Student Aid
  foundation       (shared orgs, payroll to GL)          + Student Financials
  (Universal ID)
```

If your institution goes Student first, the sequence still starts with identity. Nothing else in this guide changes.

---

## 3. The identity foundation

Do this before any track loads a single record.

PeopleSoft uses one EMPLID across HCM and Campus Solutions. A graduate assistant, a student worker, or a staff member taking classes is one EMPLID in PeopleSoft. In Workday, that same human must be one person with one **Universal ID** spanning Workday HCM and Workday Student. If you get this wrong, you create duplicate people that are painful to merge later and that break FERPA and payroll controls at the same time.

The HELIX approach:

1. Land PS person data in bronze with EMPLID and every external ID intact.
2. Resolve to one HELIX Person at Bronze to Silver (deterministic keys first, probabilistic second, ambiguous matches to a steward queue). See `govern/ferpa-disclosure-framework.json`.
3. Generate the Workday Universal ID from the resolved HELIX Person, and keep a crosswalk table: `EMPLID -> helix_id -> Universal ID -> Employee ID / Student ID`.
4. Whichever wave loads first owns the seed. The later wave matches to it and never creates a new person for an existing EMPLID.

Crosswalk: `bridge/xref/ps-to-workday-sis/identifier-xref.json`.

---

## 4. The five-step loop every track follows

Every conversion object, in every track, goes around the same loop. Run it for each mock conversion (plan on at least three mocks plus a dress rehearsal).

```
  +-----------+    +-----------+    +-------------+    +---------+    +-------------+
  | 1 EXTRACT | -> | 2 MAP     | -> | 3 TRANSFORM | -> | 4 LOAD  | -> | 5 RECONCILE |
  | PS to     |    | bridge +  |    | to EIB or   |    | Workday |    | recon pack  |
  | bronze    |    | xref      |    | web service |    | tenant  |    | sign-off    |
  +-----------+    +-----------+    +-------------+    +---------+    +-------------+
        ^                                                                    |
        +---------------------- fix, rerun next mock ------------------------+
```

1. **Extract** PeopleSoft tables to bronze, raw, with native keys (EMPLID, EMPL_RCD, EFFDT, EFFSEQ, BUSINESS_UNIT, JOURNAL_ID, STRM, CLASS_NBR).
2. **Map** to HELIX silver using `bridge/peoplesoft/<module>/`, then to Workday values using `bridge/xref/ps-to-workday-<module>/`. Unmapped codes go to an exception table, never a silent default.
3. **Transform** HELIX silver into the Workday load format. For most conversion objects that is an EIB spreadsheet; for high volume or repeatable loads, Workday Web Services. The Workday side of each object is documented in `bridge/workday/<module>/`.
4. **Load** into the target tenant in dependency order (section 9).
5. **Reconcile** using `templates/ps-to-workday/reconciliation/`. Record variances, fix at the source or in the mapping, rerun.

The payoff of doing this through HELIX: steps 1 and 2 are reusable for your lakehouse, and step 5 compares PeopleSoft and Workday in the same HELIX shape, so the tie-out queries are simple.

---

## 5. Track playbook: HCM

**Load order.** Supervisory orgs and cost centers, locations, job architecture (job families, job profiles, compensation grades), positions, workers (hire), job history events, compensation, benefits, absence balances, payroll balances.

**What to map, and where:**

| Topic | PeopleSoft | Workday | Crosswalk |
|-------|------------|---------|-----------|
| Worker type | EMPL_CLASS, PER_ORG | Worker Type, Employee Type, Contingent Worker Type | `worker-type-xref.json` |
| Status | HR_STATUS, EMPL_STATUS | Worker status, leave, termination | `employment-status-xref.json` |
| Job history | PS_JOB ACTION / ACTION_REASON | Business process events | `job-action-xref.json` |
| Job architecture | JOBCODE, JOB_FAMILY, SAL_ADMIN_PLAN, GRADE, STEP | Job Profile, Job Family, Compensation Grade, Grade Profile | `job-code-to-profile-xref.json` |
| Position | POSITION_DATA, REPORTS_TO | Position, Supervisory Organization | `position-xref.json` |
| Compensation | COMP_RATECD, earnings codes | Compensation Plans, Pay Components | `compensation-xref.json` |
| Pay frequency | PAY_FREQUENCY, PAYGROUP | Pay Group, Period Schedule | `pay-frequency-xref.json` |
| Benefits and deductions | Plan types, DEDCD | Benefit Plans, Deductions | `deduction-benefit-xref.json` |
| Absence | Leave plans, take codes | Time Off Plans, Leave Types | `absence-type-xref.json` |
| FLSA, EEO, IPEDS | FLSA_STATUS, EEO codes | Job Classification | `flsa-eeo-xref.json` |

All crosswalks live in `bridge/xref/ps-to-workday-hr/`.

**The big idea: rows become events.** PS_JOB stores a new effective-dated row for every change. Workday records business process events. Your transform walks each worker's PS_JOB rows in EFFDT and EFFSEQ order and emits events. One PS row can become more than one event (a promotion with a raise), and multiple same-day rows can collapse to one. The rules are in `job-action-xref.json` and the `hcm_field_rules` section of `templates/ps-to-workday/worktag-conversion-rules.json`.

**Position vs job management.** Decide per supervisory org before mapping. Budgeted faculty and staff lines usually belong on Position Management. Student employment and temporary pools often work better on Job Management.

**Higher ed specifics to plan for:** faculty rank and tenure on academic appointments, 9-month faculty paid over 12 months (deferred pay balance at cutover), summer and overload pay as separate components, graduate assistant tuition remission, and IPEDS HR snapshot counts matching before and after.

**Agent:** `agents/ps-to-workday-hcm-agent.json`.

---

## 6. Track playbook: Financials

**Load order.** Companies and hierarchies, ledger accounts, worktag values (funds, cost centers, programs, grants, gifts, projects, revenue and spend categories), suppliers, customers, beginning balances, open AP, open POs and encumbrances, open grants and budgets, then (optionally) historical journal summaries.

**The core of the track: chartfields to worktags.** A PeopleSoft chartfield string (BUSINESS_UNIT, ACCOUNT, FUND_CODE, DEPTID, PROGRAM_CODE, CLASS_FLD, PROJECT_ID) becomes a Workday Company, a Ledger Account, and a set of worktags. It is rarely 1:1. A single PS account often splits into a Ledger Account plus a Revenue or Spend Category, and a project can become a Grant, a Gift, or a Project worktag depending on the fund.

| Dimension | Crosswalk (`bridge/xref/ps-to-workday-fin/`) |
|-----------|----------------------------------------------|
| Business unit to Company | `business-unit-company-xref.json` |
| Account to Ledger Account | `account-xref.json` |
| Account to Revenue / Spend Category | `revenue-spend-category-xref.json` |
| Fund to Fund | `fund-xref.json` |
| Department to Cost Center | `department-xref.json` |
| Program to Program (functional class) | `program-xref.json` |
| Project / award to Grant, Gift, Project | `project-grant-xref.json` |
| Vendor to Supplier | `vendor-supplier-xref.json` |

The executable version of all of this is `templates/ps-to-workday/worktag-conversion-rules.json`: prioritized rules, defaults, a suspense path for unmapped combinations, and validation checks (every line resolves a Company and Ledger Account, debits equal credits per Company).

**Higher ed specifics:** fund accounting (GASB for public, FASB for private), restricted vs unrestricted net assets, grant F&A and cost share, endowment and gift funds, and IPEDS Finance functional classification (the Program worktag must support it).

**Agent:** `agents/ps-to-workday-fin-agent.json`. Also see `core/examples/02-chart-of-accounts-xref-peoplesoft-workday.md`.

---

## 7. Track playbook: Student

**Load order.** Academic units, academic levels, academic calendars and periods, programs of study and concentrations, courses, course sections, students and programs of study, historical registrations and grades (per your history decision), transfer credit, holds, admissions in flight, financial aid (current aid year), student account balances.

| Topic | PeopleSoft | Workday | Crosswalk (`bridge/xref/ps-to-workday-sis/`) |
|-------|------------|---------|-----------|
| Identity | EMPLID, external IDs | Universal ID, Student ID | `identifier-xref.json` |
| Career | ACAD_CAREER | Academic Level | `academic-career-level-xref.json` |
| Program and plan | ACAD_PROG, ACAD_PLAN, ACAD_SUB_PLAN | Program of Study, Concentration | `program-plan-xref.json` |
| Term | STRM, SESSION_CODE | Academic Period, Calendar | `term-period-xref.json` |
| Registration | STDNT_ENRL_STATUS, ENRL_STATUS_REASON | Student Course Registration status | `enrollment-status-xref.json` |
| Grading | GRADING_BASIS | Grading Basis | `grading-basis-xref.json` |
| Program status | PROG_STATUS, PROG_ACTION | Program of Study record events | `program-status-xref.json` |
| Admissions | ADMIT_TYPE, application status | Admissions, student type | `admit-type-xref.json` |
| Holds | SRVC_IND_CD | Student Hold Type | `service-indicator-hold-xref.json` |
| Delivery | INSTRUCTION_MODE, SSR_COMPONENT | Delivery Mode, Instructional Format | `instruction-mode-xref.json` |
| Aid | ITEM_TYPE, FIN_AID_TYPE | Financial Aid award types | `fin-aid-item-type-xref.json` |
| SAP | STDNT_FA_TERM.SAP_STATUS | Student SAP Status | `sap-status-xref.json` |
| Verification | Verification status, checklist items, tracking group | Financial Aid Verification, action items | `verification-status-xref.json` |
| Loans | LOAN_ORIGNATN loan type | Direct Loan Record | `loan-type-xref.json` |
| Disbursement | STDNT_AWRD_DISB state | Financial Aid Disbursement status | `disbursement-status-xref.json` |

**The two hard parts.**

- **Academic history.** Decide early what converts as structured data and what is archived. A tiered answer works for most schools: structured history for active and recently active students, archived official transcripts (plus a HELIX lakehouse copy) for older records, and verified cumulative balances where full history is skipped.
- **Degree audit.** PeopleSoft Academic Advisement requirements do not convert as data. They are rebuilt as Workday Academic Requirements and validated by running audits for a sample of students in both systems.

**Financial aid is its own sub-track.** PeopleSoft and Workday now map all ten aid resources: AidApplication (ISIR), AidPackage (cost of attendance and need), Verification, SAPEvaluation, FinAidAward, Disbursement, LoanRecord, ReturnOfTitleIV, StudentEmployment, and FederalAidReport. Four rules keep a conversion out of trouble with the Department of Education:

- **Reload ISIRs, don't convert them.** Pull current and prior award year ISIRs from FPS into Workday so Workday owns a clean transaction chain. Keep PeopleSoft ISIR history in bronze for audit (STU-009).
- **Carry COD loan IDs unchanged.** Re-originating a loan COD already holds causes rejects and can double-count against a student's limits (STU-011).
- **Gate on SAP.** `sap_status_carryover_check.sql` must return zero rows before Workday disburses anything. A dropped suspension pays aid to an ineligible student (STU-010).
- **Don't cut over mid payment period.** Run one disbursement cycle in parallel, tie it out with `disbursement_cod_tieout.sql`, and convert open R2T4 cases with their 45-day deadlines intact.

Aid tie-outs, in order: `sap_status_carryover_check.sql`, `aid_award_total_tieout.sql`, `loan_record_tieout.sql`, `disbursement_cod_tieout.sql`. The Director of Financial Aid signs off; the Bursar co-signs the COD tie-out.

**FERPA is a cutover gate.** Every PeopleSoft FERPA and directory restriction must exist in Workday before any external feed or student-facing directory goes live. Zero misses. See `govern/ferpa-disclosure-framework.json`.

**Agent:** `agents/ps-to-workday-sis-agent.json`.

---

## 8. Worked examples, field by field

These trace one record end to end. Your local codes will differ; the pattern will not. Where a value below comes from a crosswalk, the file is named so you can look up your own.

### 8.1 One faculty worker (HCM)

PeopleSoft PS_JOB for an associate professor of mathematics:

```
EMPLID  EMPL_RCD  EFFDT       EFFSEQ  ACTION  REASON  DEPTID  JOBCODE  EMPL_CLASS  ANNUAL_RT
100001  0         2020-08-15  0       HIR     NEW     110300  PROF01   FAC         95000
100001  0         2022-07-01  0       PRO     PRM     110300  PROF02   FAC         105000
```

| PeopleSoft field | HELIX | Workday | Source |
|------------------|-------|---------|--------|
| EMPLID 100001 | Person.helix_id (resolved) | Universal ID, Employee ID | `identifier-xref.json`, section 3 |
| EMPL_CLASS FAC | worker_type = `regular` | Employee Type (faculty) | `worker-type-xref.json` |
| ACTION HIR (2020-08-15) | lifecycle event: hire | Hire business process | `job-action-xref.json` |
| ACTION PRO with rate change (2022-07-01) | events: promotion + comp change | Change Job + Request Compensation Change | `job-action-xref.json` |
| JOBCODE PROF02 | faculty_rank = `associate_professor` | Job Profile (Associate Professor) | `job-code-to-profile-xref.json` |
| DEPTID 110300 | AcademicOrg / FinancialOrg MATH | Supervisory Org (Mathematics) + Cost Center CC-MATH | `position-xref.json`, `ps-to-workday-fin/department-xref.json` |
| ANNUAL_RT 105000 | compensation_type = `base_salary` | Salary plan, annual amount 105000 | `compensation-xref.json` |
| FLSA_STATUS | flsa_status = `exempt_teaching` | FLSA status on job profile | `flsa-eeo-xref.json` |

Two PS rows became three Workday events. That is normal, and it is exactly why the job-action crosswalk exists.

### 8.2 One GL journal line (Financials)

PeopleSoft PS_JRNL_LN, the same faculty salary expense posting:

```
BUSINESS_UNIT  ACCOUNT  FUND_CODE  DEPTID  PROGRAM_CODE  MONETARY_AMOUNT
MAIN1          50100    11000      110300  INSTR         8750.00
```

| PeopleSoft chartfield | HELIX | Workday worktag | Crosswalk (`bridge/xref/ps-to-workday-fin/`) |
|-----------------------|-------|-----------------|-----------------------------------------------|
| BUSINESS_UNIT MAIN1 | Institution / business unit | Company | `business-unit-company-xref.json` |
| ACCOUNT 50100 (Faculty Salaries) | EXP-SAL-FACULTY | Ledger Account 6010 (Faculty Compensation) | `account-xref.json` |
| FUND_CODE 11000 (Unrestricted General) | unrestricted_general | Fund FD100 (General Operating) | `fund-xref.json` |
| DEPTID 110300 (Mathematics) | MATH | Cost Center CC-MATH | `department-xref.json` |
| PROGRAM_CODE INSTR | instruction | Program: Instruction (IPEDS Instruction) | `program-xref.json` |
| MONETARY_AMOUNT 8750.00 | amount | Journal Line debit 8750.00 | `bridge/workday/fin/general_ledger_mapping.json` |

The worktag conversion rules add the pieces the crosswalks alone cannot decide, for example whether this line also needs a Spend Category, and what happens if the fund is restricted and requires a Grant or Gift worktag.

### 8.3 One student enrollment (Student)

PeopleSoft PS_STDNT_ENRL:

```
EMPLID  ACAD_CAREER  STRM  CLASS_NBR  STDNT_ENRL_STATUS  ENRL_STATUS_REASON  GRADING_BASIS_ENRL  UNT_TAKEN
200045  UGRD         2248  41872      E                  ENRL                GRD                 3.0
```

| PeopleSoft field | HELIX | Workday | Crosswalk (`bridge/xref/ps-to-workday-sis/`) |
|------------------|-------|---------|-----------|
| EMPLID 200045 | Student.helix_id | Universal ID, Student ID | `identifier-xref.json` |
| ACAD_CAREER UGRD | course level: undergraduate | Academic Level: Undergraduate | `academic-career-level-xref.json` |
| STRM 2248 (Fall 2024) | AcademicPeriod, period_type = `semester` | Academic Period: Fall 2024 | `term-period-xref.json` |
| CLASS_NBR 41872 | CourseSection.helix_id | Course Section | `bridge/workday/sis/course_section_mapping.json` |
| STATUS E + REASON ENRL | enrollment_status = `enrolled` | Student Course Registration: Registered | `enrollment-status-xref.json` |
| GRADING_BASIS GRD | grade_mode = `standard` | Grading Basis: Graded | `grading-basis-xref.json` |
| UNT_TAKEN 3.0 | credit_hours 3.0 | Registered units 3.0 | `bridge/workday/sis/enrollment_mapping.json` |

Load order matters here: the Academic Period, Course, Course Section, and Student must already exist in Workday before this registration will load.

---

## 9. Data conversion strategy

**Balances vs detail.** For most objects, convert current state and point-in-time balances, and keep the full detail in the HELIX lakehouse. Workday is your system of record going forward; the lakehouse is your system of history.

| Object | Recommended in Workday | Recommended in HELIX lakehouse |
|--------|------------------------|--------------------------------|
| Workers | Current state + bounded job history (often 3 to 7 years, or back to most recent hire) | Full PS_JOB history |
| Compensation | Current plans + history within the job window | Full history |
| Payroll | YTD balances for the current tax year (quarter-to-date if mid-year) | Pay check history |
| Absence | Current balances per plan | Accrual history |
| GL | Beginning balances by worktag; optional prior-year monthly summaries for comparatives | Full journal detail |
| AP / PO | Open vouchers, open POs, encumbrances | Closed documents |
| Grants | Active awards with budget-to-date and actuals | Closed awards |
| Students | Active and recently active with structured history for audit, GPA, SAP | Full enrollment history, archived transcripts |
| Financial aid | Current aid year (plus prior year if still processing) | Prior aid years |

**Open vs closed.** Convert open transactions; archive closed ones. The line between them should be a date your controller and registrar sign off on, not a technical convenience.

**Timing.** HCM cutovers are easiest at a pay period boundary near a quarter or year end. FIN cutovers work best at a fiscal period close (many choose fiscal year start). Student cutovers belong at a term boundary after grades post.

---

## 10. Parallel runs and reconciliation

Plan for at least three mock conversions and a dress rehearsal. Reconcile every one. The queries are ready in `templates/ps-to-workday/reconciliation/`, organized by track:

| Track | Tie-outs |
|-------|----------|
| FIN | trial balance to the penny, fund balance, open AP, open PO and encumbrance, grant budget to actual, worktag completeness |
| HCM | headcount, position count, annualized compensation, payroll parallel compare, benefit enrollment, leave balance |
| Student | active students, enrolled credit hours, GPA recompute, program of study, student account balance, FERPA restriction carryover |

**Payroll parallel.** Run two to three full cycles, comparing gross, net, taxes, and deductions per worker per period against an agreed tolerance. Triage every variance into mapping error, configuration error, or expected difference, and get sign-off from payroll and HR before go-live.

**Sign-off.** Map each tie-out to an accountable role in `govern/roles.json` (controller for trial balance, registrar for enrollment and FERPA, payroll director for parallel, and so on). A reconciliation nobody owns is a reconciliation nobody fixes.

---

## 11. Cutover checklist: T-90 to T+30

**T-90 to T-60: foundations**
- Identity crosswalk complete; Universal ID seeding approach signed off
- All crosswalk VALIDATE flags resolved against your Workday tenant
- Local code lists (ACTION_REASON, earnings, plans, service indicators) mapped with zero unmapped values in the last mock
- History depth and open vs closed cutoff dates approved by HR, controller, registrar
- Mock 2 reconciled with all tie-outs within tolerance

**T-60 to T-30: rehearsal**
- Mock 3 and dress rehearsal on production-like volumes, timed end to end
- Payroll parallel cycles 1 and 2 signed off
- FERPA carryover check at zero misses
- Integrations inventory: every PS outbound feed has a Workday replacement or a retirement decision
- Communications and training schedules locked

**T-30 to T-1: freeze**
- PeopleSoft change freeze for converted objects
- Final payroll parallel signed off
- Cutover runbook with owners, durations, and go / no-go criteria
- Rollback plan documented (what happens if you stop at each step)

**Cutover weekend**
- Final extract, transform, load in runbook order
- Full reconciliation pack run; go / no-go decision on tie-out results
- PeopleSoft set to read-only for converted modules

**T+1 to T+30: hypercare**
- Daily reconciliation of new transactions for the first two weeks
- First Workday payroll compared line by line to the last PeopleSoft payroll
- First period close in Workday Financials with the trial balance tie-out
- Exception queue worked to zero
- Decommission plan for PeopleSoft with the HELIX lakehouse as the historical archive

---

## 12. Common pitfalls

- **Two people for one human.** Skipping the identity foundation and letting HCM and Student create workers and students independently.
- **Treating PS_JOB like a table to copy.** Workday wants events. Row-by-row loads produce broken histories.
- **Assuming chartfields map 1:1 to worktags.** Accounts split into ledger accounts and categories; projects fan out into grants, gifts, and projects.
- **Carrying every PS code forward.** Conversion is the best chance you will ever get to retire dead plans, earnings codes, and service indicators. Rationalize before you map.
- **Converting too much history.** Every extra year of history multiplies mapping and reconciliation work. Put history in the lakehouse.
- **Forgetting 9-over-12 and summer pay.** Deferred faculty pay is money owed at cutover.
- **Degree audit as an afterthought.** Requirements rebuild takes longer than anyone budgets.
- **FERPA as a checkbox.** A single missed directory restriction is a disclosure event.
- **Reconciling only at the end.** Reconcile every mock, or you will discover problems during cutover weekend.
- **Orphaned integrations.** The dozens of PS outbound files and queries that other offices quietly depend on.

---

## 13. Which HELIX agent to use when

| You are working on | Use | File |
|--------------------|-----|------|
| Workers, jobs, positions, comp, payroll, benefits, absence | HCM agent | `agents/ps-to-workday-hcm-agent.json` |
| Chartfields, worktags, GL, AP, PO, grants, budgets | FIN agent | `agents/ps-to-workday-fin-agent.json` |
| Students, programs, terms, registration, grades, holds, aid, FERPA | SIS agent | `agents/ps-to-workday-sis-agent.json` |
| Not sure where to start, or planning across tracks | Migration Companion | `agents/helix-migration-companion.json` |

Each agent template drops into ChatGPT, Claude, Gemini, Amazon Q, or Bedrock. Load the knowledge files listed in the template, and the agent works from the same bridges, crosswalks, and reconciliation pack described here.

---

## 14. File index

```
bridge/
  peoplesoft/{hcm,fin,cs}/            PS -> HELIX mappings (54)
  workday/{hr,fin,sis}/               Workday <-> HELIX mappings (54)
  xref/
    ps-to-workday-hr/                 direct HCM crosswalks
    ps-to-workday-fin/                direct FIN crosswalks
    ps-to-workday-sis/                direct Student crosswalks
templates/
  ps-to-workday/
    worktag-conversion-rules.json     chartfield -> worktag rules (+ HCM and Student field rules)
    reconciliation/                   FIN, HCM, Student tie-out queries
agents/
  ps-to-workday-hcm-agent.json
  ps-to-workday-fin-agent.json
  ps-to-workday-sis-agent.json
  helix-migration-companion.json
docs/
  ps-to-workday-migration.md          this guide
  migration-adventure-guide.md        choose-your-own-adventure entry point
govern/
  ferpa-disclosure-framework.json, glba-safeguards-framework.json,
  agent-guardrails.json, roles.json
```

---

*HELIX PeopleSoft to Workday Cornerstone Guide v0.8.0, September 2026*
*Part of the [HELIX Open Framework](https://github.com/utopify/helix)*
