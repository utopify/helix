# HELIX Migration Adventure Guide

### Choose Your Path. Map Your Data. Eliminate the Friction.

> Every ERP migration or data integration project starts with the same question: *How do I get from here to there?* This guide answers that question — for every combination of source and target system, organized by module.

---

> **Not sure where to begin? Go to [START_HERE](../START_HERE.md) first.** It's six steps: describe what you have, pick a goal, pick one small slice, land it, prove it, and name an owner. This guide is the map you use once you know which road you're on.

## 🧭 Which Road Are You On?

> **Moving PeopleSoft to Workday?** That is the HELIX cornerstone path, with direct crosswalks, conversion rules, a reconciliation pack, and a specialist agent for every module. Jump to [Chapter 7: PeopleSoft to Workday, The Cornerstone Path](#chapter-7-peoplesoft-to-workday-the-cornerstone-path).
>
> **Moving Banner on-prem to Banner SaaS?** Jump to [Chapter 8: Banner On-Prem to Banner SaaS](#chapter-8-banner-on-prem-to-banner-saas).

### Step 1: What system are you migrating FROM?

- **PeopleSoft Campus Solutions** → Go to [Chapter 1: PeopleSoft CS](#chapter-1-peoplesoft-campus-solutions)
- **PeopleSoft Financials (FSCM)** → Go to [Chapter 2: PeopleSoft Financials](#chapter-2-peoplesoft-financials)
- **PeopleSoft HCM** → Go to [Chapter 3: PeopleSoft HCM](#chapter-3-peoplesoft-hcm)
- **Ellucian Banner** → Go to [Chapter 4: Banner](#chapter-4-ellucian-banner)
- **Ellucian Colleague** → Go to [Chapter 5: Colleague](#chapter-5-ellucian-colleague)
- **Workday Student** → Go to [Chapter 6: Workday Student](#chapter-6-workday-student)
- **PeopleSoft (any module) moving to Workday** → Go to [Chapter 7: The Cornerstone Path](#chapter-7-peoplesoft-to-workday-the-cornerstone-path)
- **Banner on-prem or Oracle-on-EC2 moving to Banner SaaS** → Go to [Chapter 8: Banner On-Prem to Banner SaaS](#chapter-8-banner-on-prem-to-banner-saas)

### Step 2: What's your TARGET?

- **Data Lake / Lakehouse** → Your HELIX Bridge mapping IS the migration plan. Map source → HELIX Core → Iceberg/Parquet.
- **Another ERP** (e.g., PeopleSoft → Workday) → Use HELIX as the intermediate foundational model. Map source → HELIX Core, then HELIX Core → target. Both Bridge mappings are already built. For PeopleSoft to Workday you can skip the double hop entirely: the direct crosswalks in `bridge/xref/ps-to-workday-{fin,hr,sis}/` give you PS code → HELIX code → Workday value in one lookup.
- **Analytics Platform** (QuickSight, Tableau, Power BI) → Land in HELIX Core shape in your lake. The consistent schema means your dashboards work regardless of source.
- **AI/ML Models** → HELIX Core resources are your feature store input. Train once, apply across institutions.

---

## How HELIX Makes Migration Easier

Traditional migration: **Source A → (custom mapping) → Target B**
- Every combination requires a unique mapping
- 4 ERPs × 4 targets = 16 custom mappings

HELIX migration: **Source A → HELIX Core → Target B**
- Each system needs ONE mapping (to/from HELIX Core)
- 4 ERPs = 4 Bridge mappings, then any target is already covered
- The foundational layer absorbs the complexity

```
   Banner ──────┐
   PeopleSoft ──┤                    ┌──→ Data Lake (Iceberg)
   Workday ─────┼──→ HELIX Core ─────┼──→ Analytics (QuickSight, etc.)
   Colleague ───┤                    ├──→ Another ERP
                └                    └──→ AI/ML Models
```

---

## Chapter 1: PeopleSoft Campus Solutions

*Getting data out of PeopleSoft first? See [`bridge/peoplesoft/PS_EXTRACTION.md`](../bridge/peoplesoft/PS_EXTRACTION.md): reporting copies, EMPLID, EFFDT/EFFSEQ, SETID, and incremental loads.*

**You're migrating FROM PeopleSoft Campus Solutions (SIS/Student module).**

### What module are you working with?

| Module | What It Covers | Go To |
|--------|---------------|-------|
| Student Records & Identity | Person records, demographics, contact info | [§1.1 Student Identity](#11-student-identity) |
| Enrollment & Registration | Course registration, grades, transcripts | [§1.2 Enrollment](#12-enrollment) |
| Academic Structure | Courses, sections, terms, departments | [§1.3 Academic Structure](#13-academic-structure) |
| Academic Programs | Majors, minors, degree progress, class standing | [§1.4 Programs & Progress](#14-programs--progress) |
| Financial Aid | Awards, disbursements, SAP, FAFSA/ISIR | [§1.5 Financial Aid](#15-financial-aid) |
| Admissions | Applications, decisions, test scores, deposits | [§1.6 Admissions](#16-admissions) |
| Transfer Credit | External credit evaluation and equivalencies | [§1.7 Transfer Credit](#17-transfer-credit) |
| Service Indicators (Holds) | Registration holds, financial holds, compliance | [§1.8 Holds](#18-holds) |
| Degrees & Outcomes | Conferred degrees, honors, completions | [§1.9 Outcomes](#19-outcomes) |

---

### §1.1 Student Identity

**Source tables:** `PS_PERSONAL_DATA`, `PS_NAMES`, `PS_ADDRESSES`, `PS_EMAIL_ADDRESSES`, `PS_PERSONAL_PHONE`, `PS_DIVERS_ETHNIC`, `PS_CITIZENSHIP`, `PS_EMERGENCY_CNTCT`

**HELIX resources:** `Person` + `Student`

**Bridge mapping files:**
- `bridge/peoplesoft/cs/person_mapping.json` — 25 attribute mappings
- `bridge/peoplesoft/cs/student_mapping.json` — 19 attribute mappings

**Migration targets:**

| Target | How It Works |
|--------|-------------|
| **Data Lake** | Map PS tables → HELIX Person + Student schemas → Iceberg tables. Done. |
| **Workday Student** | PS → HELIX Person/Student → `bridge/workday/sis/` (reversed). Full 19-mapping SIS coverage. Map HELIX attributes to Workday business objects. |
| **Banner** | PS → HELIX Person/Student → `bridge/banner/sis/student_mapping.json` (reverse). Map to SPRIDEN + SPBPERS + SGBSTDN. |
| **Colleague** | PS → HELIX Person/Student → `bridge/colleague/student_mapping.json` (reverse). Map to PERSON + STUDENTS MV files. |

**Watch out for:**
- PeopleSoft effective dating (EFFDT + EFFSEQ) — always take the current row
- Name types: 'PRI' (primary/legal), 'PRF' (preferred). Map both.
- EMPLID is shared with HCM. If migrating both, person records move once.
- Ethnicity is multi-valued (PS_DIVERS_ETHNIC) — one row per selected race/ethnicity

---

### §1.2 Enrollment

**Source tables:** `PS_STDNT_ENRL`, `PS_CLASS_TBL`, `PS_TERM_TBL`

**HELIX resource:** `Enrollment`

**Bridge mapping file:** `bridge/peoplesoft/cs/enrollment_mapping.json` — 15 attribute mappings

**Migration targets:**

| Target | How It Works |
|--------|-------------|
| **Data Lake** | Map PS_STDNT_ENRL → HELIX Enrollment → Iceberg. Highest-volume table. |
| **Workday Student** | PS → HELIX Enrollment → `bridge/workday/sis/enrollment_mapping.json` (reversed). Map to Workday Student Course Registration. |
| **Banner** | PS → HELIX Enrollment → `bridge/banner/sis/enrollment_mapping.json` (reverse). Map to SFRSTCR + SHRTCKN. |

**Watch out for:**
- PS enrollment statuses ('E', 'W', 'D') are simpler than Banner's STVRSTS codes
- STRM (term code) decoding: 2269 = Fall 2026. First digit = century, second = decade+year, last two = term.
- UNT_TAKEN vs UNT_EARNED — attempted vs completed credit hours
- CRSE_GRADE_OFF is the official final grade; CRSE_GRADE_INPUT is preliminary

---

### §1.3 Academic Structure

**Source tables:** `PS_CRSE_CATALOG`, `PS_CRSE_OFFER`, `PS_CLASS_TBL`, `PS_CLASS_MTG_PAT`, `PS_CLASS_INSTR`, `PS_TERM_TBL`, `PS_SESSION_TBL`, `PS_ACAD_ORG_TBL`

**HELIX resources:** `Course`, `CourseSection`, `AcademicPeriod`, `AcademicOrg`

**Bridge mapping files:**
- `bridge/peoplesoft/cs/course_mapping.json`
- `bridge/peoplesoft/cs/course_section_mapping.json`
- `bridge/peoplesoft/cs/academic_period_mapping.json`
- `bridge/peoplesoft/cs/academic_org_mapping.json`

**Watch out for:**
- PeopleSoft separates catalog (PS_CRSE_CATALOG) from offering (PS_CRSE_OFFER) from schedule (PS_CLASS_TBL). Three levels, not two.
- Class meeting patterns: day flags are individual columns (MON, TUES, WED...) not a single string
- Academic org hierarchy uses PeopleSoft Tree Manager — requires tree navigation queries
- CRSE_ID (internal) vs SUBJECT + CATALOG_NBR (display) — use CRSE_ID as the stable key

---

### §1.4 Programs & Progress

**Source tables:** `PS_ACAD_PROG_TBL`, `PS_ACAD_PLAN_TBL`, `PS_ACAD_PROG`, `PS_ACAD_PLAN`, `PS_STDNT_CAR_TERM`

**HELIX resources:** `Program`, `StudentProgram`

**Bridge mapping files:**
- `bridge/peoplesoft/cs/program_mapping.json`
- `bridge/peoplesoft/cs/student_program_mapping.json`

**Watch out for:**
- Career → Program → Plan → Subplan hierarchy. HELIX flattens this: Plan maps to Program, student's plan enrollment maps to StudentProgram.
- Double majors: student has multiple ACAD_PLAN rows under one ACAD_PROG
- Class standing (ACAD_LEVEL_BOT) is calculated from cumulative units, not manually set
- Catalog year (REQ_TERM) governs which degree requirements apply — critical for degree audit

---

### §1.5 Financial Aid

**Source tables:** `PS_STDNT_AWARDS`, `PS_ITEM_TYPE_FA`, `PS_STDNT_FA_TERM`, `PS_ISIR_COMPUTED`, `PS_DISB_DETAIL`

**HELIX resource:** `FinAidAward`

**Bridge mapping file:** `bridge/peoplesoft/cs/fin_aid_award_mapping.json` — 18 attribute mappings

**Watch out for:**
- Aid year vs term: awards may span multiple terms within an aid year
- Federal fund codes (PELL, DSUB, DUNS, DPLUS, FWS) map cleanly to HELIX award types
- EFC is now called SAI (Student Aid Index) for 2024-25+ — same field, new name
- Disbursement detail (PS_DISB_DETAIL) is separate from the award record
- **Classification: RESTRICTED** — financial aid data contains SSN-adjacent info (EFC/SAI from FAFSA)

---

### §1.6 Admissions

**Source tables:** `PS_ADM_APPL_DATA`, `PS_ADM_APPL_PROG`, `PS_ADM_APPL_PLAN`, `PS_ADM_APPL_ACTN`, `PS_STDNT_TEST_COMP`

**HELIX resource:** `AdmissionApplication`

**Bridge mapping file:** `bridge/peoplesoft/cs/admission_application_mapping.json` — 16 attribute mappings

**Watch out for:**
- PeopleSoft admissions uses action/reason history (PS_ADM_APPL_ACTN) — most recent action = current status
- PROG_ACTION codes: APPL (applied), ADMT (admitted), DENY (denied), WADM (waitlisted), COND (conditional)
- Test scores are person-level (PS_STDNT_TEST_COMP), not application-level
- Common App / Coalition imports create the application record — ADM_SOURCE_ID tracks the source

---

### §1.7 Transfer Credit

**Source tables:** `PS_TRNS_CRSE_DTL`, `PS_TRNSFR_EQUIVLNC`, `PS_EXT_ORG_TBL`

**HELIX resource:** `TransferCredit`

**Bridge mapping file:** `bridge/peoplesoft/cs/transfer_credit_mapping.json` — 15 attribute mappings

**Watch out for:**
- External org (sending institution) identified by EXT_ORG_ID — cross-reference with FICE/CEEB codes
- Equivalency table (PS_TRNSFR_EQUIVLNC) maps external course → internal course. May be 1:1 or many:1.
- Transfer GPA policy varies: some institutions include transfer grades in cumulative GPA, some don't

---

### §1.8 Holds

**Source tables:** `PS_SRVC_IND_DATA`, `PS_SRVC_IND_TBL`, `PS_SRVC_IND_RSLT`

**HELIX resource:** `Hold`

**Bridge mapping file:** `bridge/peoplesoft/cs/hold_mapping.json` — 13 attribute mappings

**Watch out for:**
- PeopleSoft calls holds "service indicators" — can be positive (honors, dean's list) or negative (holds)
- Filter to negative indicators only for HELIX Hold mapping
- Impact is determined by PS_SRVC_IND_RSLT rows — one indicator can block multiple services
- Auto-expiration: END_DT controls when the hold lifts automatically

---

### §1.9 Outcomes

**Source tables:** `PS_ACAD_DEGR`, `PS_ACAD_DEGR_PLAN`, `PS_ACAD_DEGR_HONS`

**HELIX resource:** `Degree`

**Bridge mapping file:** `bridge/peoplesoft/cs/degree_mapping.json` — 15 attribute mappings

**Watch out for:**
- Degree conferral is a separate process from program completion — check DEGR_STATUS and DEGR_CONFER_DT
- Multiple plans under one degree (double major) appear in PS_ACAD_DEGR_PLAN
- Honors come from PS_ACAD_DEGR_HONS — separate from GPA-based Latin honors calculation
- IPEDS Completions reporting requires CIP code from the plan, not the program

---

## Chapter 2: PeopleSoft Financials

*Getting data out of PeopleSoft first? See [`bridge/peoplesoft/PS_EXTRACTION.md`](../bridge/peoplesoft/PS_EXTRACTION.md): reporting copies, EMPLID, EFFDT/EFFSEQ, SETID, and incremental loads.*

**You're migrating FROM PeopleSoft Financials / FSCM.**

| Module | What It Covers | Mapping File |
|--------|---------------|-------------|
| General Ledger | Journals, ledger balances, chart of accounts | `bridge/peoplesoft/fin/general_ledger_mapping.json` |
| Accounts Payable | Vouchers, vendor payments, invoices | `bridge/peoplesoft/fin/accounts_payable_mapping.json` |
| Student Financials / AR | Student billing, tuition, charges, payments | `bridge/peoplesoft/fin/accounts_receivable_mapping.json` |
| Purchasing | Purchase orders, requisitions, receiving | `bridge/peoplesoft/fin/purchasing_mapping.json` |
| Budget / Commitment Control | Budget vs. actuals, encumbrances, pre-encumbrances | `bridge/peoplesoft/fin/budget_mapping.json` |
| Grants | Awards, sponsors, projects, F&A, billing | `bridge/peoplesoft/fin/grants_mapping.json` |

### Key Concepts for Financial Migration

**Chartfields** are the DNA of PeopleSoft Financials. Every transaction is coded with a combination of:
- **Business Unit** — organizational partition (often one per campus)
- **Account** — what (revenue, expense, asset, liability)
- **Fund** — why (unrestricted, restricted, auxiliary, endowment)
- **Department** — who (organizational unit)
- **Program** — functional classification (instruction, research, public service)
- **Class** — additional dimension (often object code or revenue source)
- **Project** — grants, capital projects, special initiatives

If you're moving to **Workday Financials**, the chartfield → worktag mapping is the core of your migration. HELIX normalizes these into a standard structure that maps to either system.

If you're moving to a **data lake**, land the chartfield combinations as dimensions in your star schema, with HELIX as the foundational attribute names.

---

## Chapter 3: PeopleSoft HCM

*Getting data out of PeopleSoft first? See [`bridge/peoplesoft/PS_EXTRACTION.md`](../bridge/peoplesoft/PS_EXTRACTION.md): reporting copies, EMPLID, EFFDT/EFFSEQ, SETID, and incremental loads.*

**You're migrating FROM PeopleSoft HCM.**

| Module | What It Covers | Mapping File |
|--------|---------------|-------------|
| Core HR / Employee | Job records, employment history, demographics | `bridge/peoplesoft/hcm/worker_mapping.json` |
| Position Management | Position inventory, reporting structure, FTE | `bridge/peoplesoft/hcm/position_mapping.json` |
| Compensation | Salary, pay grades, comp components, compa-ratio | `bridge/peoplesoft/hcm/compensation_mapping.json` |
| Benefits | Health, retirement, life, FSA, dependents | `bridge/peoplesoft/hcm/benefits_mapping.json` |
| Payroll | Earnings, deductions, taxes, pay checks | `bridge/peoplesoft/hcm/payroll_mapping.json` |
| Time & Labor | Time reporting, punch data, approvals, schedules | `bridge/peoplesoft/hcm/time_tracking_mapping.json` |
| Recruiting | Job openings, applicants, dispositions, postings | `bridge/peoplesoft/hcm/recruiting_mapping.json` |

### PS_JOB: The Table That Rules Everything

`PS_JOB` is the most important table in PeopleSoft HCM. Every employment event creates a new effective-dated row:

```
EMPLID  EMPL_RCD  EFFDT       EFFSEQ  ACTION  DEPTID   JOBCODE  ANNUAL_RT
100001  0         2020-08-15  0       HIR     MATH     PROF01   95000
100001  0         2022-07-01  0       PRO     MATH     PROF02   105000
100001  0         2024-01-01  0       XFR     CS       PROF02   105000
100001  0         2024-07-01  0       PAY     CS       PROF02   112000
```

**Current state** = last row (max EFFDT ≤ today, max EFFSEQ). **History** = all rows.

If migrating to **Workday HCM**, PS_JOB maps to Workday's Worker + Job Profile + Position. The effective-dating concept translates directly to Workday's effective-dated model.

---

## Chapter 4: Ellucian Banner

**You're migrating FROM Ellucian Banner.** As of v0.8.1 the Banner Bridge covers 35 mappings across five modules.

| Module | Folder | Mappings | Key Banner Tables |
|--------|--------|---------:|-------------------|
| Student (SIS) | `bridge/banner/sis/` | 11 | SPRIDEN, SPBPERS, SGBSTDN, SFRSTCR, SHRTCKN, SSBSECT, STVTERM |
| Human Resources | `bridge/banner/hr/` | 2 | NBBPOSN, NBRBJOB, PEBEMPL |
| Finance | `bridge/banner/finance/` | 7 | FGBTRND, FGBTRNH, FGBBALC, FTVFUND, FTVORGN, FABINVH, FPBPOHD, FRBGRNT |
| Advancement | `bridge/banner/advancement/` | 4 | APBCONS, AGBGIFT, AGBPLDG, AFBCAMP, APRCONT |
| Financial Aid | `bridge/banner/financial-aid/` | 7 | RPRAWRD, RCRESAR, RORSTAT, RRRAREQ, RPRADSB, RPRLORG |

Extracting from a self-managed Oracle database? Start with [`bridge/banner/ONPREM_EXTRACTION.md`](../bridge/banner/ONPREM_EXTRACTION.md) for PIDM joins, STV decode, effective-term dating, and CDC options.

**Migration to Banner SaaS?** See [Chapter 8](#chapter-8-banner-on-prem-to-banner-saas).
**Migration to Workday?** Banner Bridge → HELIX Core → Workday Bridge.
**Migration to PeopleSoft?** Banner Bridge → HELIX Core → PeopleSoft Bridge (reversed).
**Migration to data lake?** Banner Bridge → HELIX Core → Iceberg/Parquet.

---

## Chapter 5: Ellucian Colleague

**You're migrating FROM Ellucian Colleague.**

| HELIX Resource | Mapping File | Key Colleague Files |
|---------------|-------------|---------------------|
| Student | `bridge/colleague/student_mapping.json` | PERSON, STUDENTS, FOREIGN.PERSON |
| Enrollment | `bridge/colleague/enrollment_mapping.json` | STUDENT.ACAD.CRED, STUDENT.COURSE.SEC |
| AcademicPeriod | `bridge/colleague/academic_period_mapping.json` | TERMS, TERM.SESSIONS |

**⚠️ Colleague-Specific: Date Conversion Required**
All Colleague dates are stored as integers (days since 12/31/1967). Every date field needs conversion:
`ISO_date = date(1967, 12, 31) + timedelta(days=colleague_int_value)`

*Additional Colleague resource mappings are planned. Contributions especially welcome from Colleague shops.*

---

## Chapter 6: Workday Student

**You're migrating FROM Workday Student.**

| HELIX Resource | Mapping File | Key Workday Objects |
|---------------|-------------|---------------------|
| Student | `bridge/workday/sis/student_mapping.json` | Person, Student, Academic Affiliation |
| Enrollment | `bridge/workday/sis/enrollment_mapping.json` | Student Course Registration, Student Course Grade |
| AcademicPeriod | `bridge/workday/sis/academic_period_mapping.json` | Academic Period, Academic Calendar |

**Extraction methods:** RaaS, REST API, Prism Analytics, or Workday Data Cloud (zero-copy with AWS).

*Additional Workday resource mappings are planned.*

---

## Chapter 7: PeopleSoft to Workday, The Cornerstone Path

**You're moving PeopleSoft to Workday.** This is the most common large ERP move in higher ed, and it is the path HELIX is built around. You code the mapping once against HELIX, then look up the Workday side directly.

### Which track are you on?

- **HCM only** → Go to [§7.1 HCM](#71-hcm-peoplesoft-hcm-to-workday-hcm)
- **Financials only** → Go to [§7.2 Financials](#72-financials-peoplesoft-fscm-to-workday-financial-management)
- **Student only** → Go to [§7.3 Student](#73-student-campus-solutions-to-workday-student)
- **All three** → Read the full [PeopleSoft to Workday Cornerstone Guide](ps-to-workday-migration.md) first. Most institutions land HCM and Financials together, then Student in a later wave. Either way, identity comes first: seed the Workday Universal ID from EMPLID so one person stays one person across Workday HCM and Workday Student (`bridge/xref/ps-to-workday-sis/identifier-xref.json`).

### Your toolkit for every track

| You need | Use |
|----------|-----|
| The narrative and cutover plan | [`docs/ps-to-workday-migration.md`](ps-to-workday-migration.md) (T-90 to T+30 checklist, worked examples) |
| Field-level mapping | `bridge/peoplesoft/{hcm,fin,cs}/` and `bridge/workday/{hr,fin,sis}/` |
| Direct code lookups | `bridge/xref/ps-to-workday-hr/`, `ps-to-workday-fin/`, `ps-to-workday-sis/` |
| Chartfield and field conversion logic | [`templates/ps-to-workday/worktag-conversion-rules.json`](../templates/ps-to-workday/worktag-conversion-rules.json) |
| Proof it worked | [`templates/ps-to-workday/reconciliation/`](../templates/ps-to-workday/reconciliation/) (22 tie-outs) |
| A guide at your side | `agents/ps-to-workday-hcm-agent.json`, `ps-to-workday-fin-agent.json`, `ps-to-workday-sis-agent.json` |

### §7.1 HCM: PeopleSoft HCM to Workday HCM

The big idea: PeopleSoft stores history as effective-dated JOB rows; Workday stores it as business process events. Every JOB action becomes (or merges into) a Hire, Change Job, Compensation Change, Leave, or Terminate event.

| Step | File |
|------|------|
| Worker types, statuses | `ps-to-workday-hr/worker-type-xref.json`, `employment-status-xref.json` |
| JOB actions to business processes | `ps-to-workday-hr/job-action-xref.json` |
| Job codes to Job Profiles, grades, steps | `ps-to-workday-hr/job-code-to-profile-xref.json` |
| Positions and supervisory orgs | `ps-to-workday-hr/position-xref.json` (decide Position vs Job Management early) |
| Pay, benefits, time off | `compensation-xref.json`, `pay-frequency-xref.json`, `deduction-benefit-xref.json`, `absence-type-xref.json` |
| FLSA, EEO, IPEDS | `flsa-eeo-xref.json` |
| Prove it | `headcount_tieout.sql`, `position_count_tieout.sql`, `compensation_total_tieout.sql`, `benefit_enrollment_tieout.sql`, `leave_balance_tieout.sql`, `payroll_parallel_compare.sql` |

Agent: **PeopleSoft HCM to Workday HCM** (`agents/ps-to-workday-hcm-agent.json`).

### §7.2 Financials: PeopleSoft FSCM to Workday Financial Management

The big idea: the PeopleSoft chartfield string splits into a Workday Ledger Account plus worktags. Revenue and expense detail moves out of the account and into Revenue and Spend Categories.

| Step | File |
|------|------|
| Business units to Companies | `ps-to-workday-fin/business-unit-company-xref.json` |
| Accounts to Ledger Accounts and categories | `account-xref.json`, `revenue-spend-category-xref.json` |
| Funds, departments, programs | `fund-xref.json`, `department-xref.json`, `program-xref.json` |
| Projects to Grants, Projects, Gifts | `project-grant-xref.json` |
| Vendors to Suppliers | `vendor-supplier-xref.json` |
| Conversion logic | `templates/ps-to-workday/worktag-conversion-rules.json` (20 rules, 5 worked examples) |
| Prove it | `worktag_completeness_check.sql`, `trial_balance_tieout.sql`, `fund_balance_tieout.sql`, `open_ap_tieout.sql`, `open_po_encumbrance_tieout.sql`, `grant_budget_to_actual_tieout.sql` |

Agent: **PeopleSoft Financials to Workday Financial Management** (`agents/ps-to-workday-fin-agent.json`). See also `core/examples/02-chart-of-accounts-xref-peoplesoft-workday.md`.

### §7.3 Student: Campus Solutions to Workday Student

The big idea: the PeopleSoft career, program, and plan stack collapses into Workday Academic Level, Program of Study, and Concentration. Historical academic records are the hardest decision: what converts as structured data and what stays as an archived transcript.

| Step | File |
|------|------|
| Identity (do this first) | `ps-to-workday-sis/identifier-xref.json` |
| Careers, programs, plans | `academic-career-level-xref.json`, `program-plan-xref.json`, `program-status-xref.json` |
| Terms and sessions | `term-period-xref.json` |
| Enrollment and grading | `enrollment-status-xref.json`, `grading-basis-xref.json`, `instruction-mode-xref.json` |
| Admissions, holds, aid | `admit-type-xref.json`, `service-indicator-hold-xref.json`, `fin-aid-item-type-xref.json` |
| Prove it | `ferpa_restriction_carryover_check.sql` (hard gate), `active_student_tieout.sql`, `program_of_study_tieout.sql`, `enrollment_credit_tieout.sql`, `gpa_recompute_check.sql`, `student_account_balance_tieout.sql` |

Agent: **PeopleSoft Campus Solutions to Workday Student** (`agents/ps-to-workday-sis-agent.json`).

**Before you load:** every value marked VALIDATE in the crosswalks differs by institution or Workday tenant. Confirm them against your configuration workbook before mock 1.

---

## Chapter 8: Banner On-Prem to Banner SaaS

**You're moving Banner from a self-managed Oracle database (on-prem or Oracle-on-EC2) to Banner SaaS (Ellucian Platform).** The hard part is not the data. It is that Banner SaaS has no direct database access, so every integration, view, stored procedure, and SQL script that touched Oracle has to be rebuilt against governed APIs.

**Start with a customization register.** `docs/conversion/banner-customizations.md` walks through comparing your Banner with a vanilla install at the same release, listing every Z object, added column, trigger, local job, and hidden integration, and deciding what happens to each. The AWS tools for each step are in `docs/aws-services-guide.md`.

### The path

```
Banner Oracle (on-prem / EC2)
      |   direct SQL, PIDM joins, STV decode
      v
bridge/banner/  (35 mappings)  --->  HELIX Core (canonical)
                                          |
                                          v
                              bridge/banner-saas/  (8 reverse mappings)
                                          |
                                          v
                  Ethos Integration API / BIA / Data Connect  --->  Banner SaaS
```

| Step | What to do | File |
|------|-----------|------|
| 1. Inventory | List every integration that touches Oracle: SQL jobs, views, stored procedures, Boomi or middleware jobs, file extracts. Each one needs a SaaS-supported replacement. | `bridge/banner-saas/WRITEBACK_PATTERNS.md` |
| 2. Extract | Pull from a standby or replica, carry PIDM and raw codes into bronze. | `bridge/banner/ONPREM_EXTRACTION.md` |
| 3. Canonicalize | Map Banner tables to HELIX Core. | `bridge/banner/{sis,hr,finance,advancement,financial-aid}/` |
| 4. Write back | Push HELIX resources to Banner SaaS through Ethos, keyed by GUID, in dependency order (persons, then students, then registrations). | `bridge/banner-saas/*_reverse_mapping.json` |
| 5. Land analytics | Decide where SaaS data lands for reporting. | `docs/banner-saas-landing-architecture.md` |

### Where does the data land?

- **Writes into Banner SaaS:** only through Ethos Integration API, Banner Integration API, or Data Connect. Storage is never a write target.
- **Operational reads and near-real-time sync:** Data Connect into PostgreSQL (for example Amazon RDS for PostgreSQL) as staging.
- **Analytics and the HELIX lakehouse:** Amazon S3 Tables (managed Apache Iceberg) for bronze, silver, and gold.

Validate Ethos and Data Connect entitlements against your Ellucian license before you design around them. The Ethos field names in `bridge/banner-saas/` flagged VALIDATE vary by API version.

---

## Cross-Reference: Module-by-Module Migration Paths

### I'm migrating my SIS (Student module)

| From → To | Path |
|-----------|------|
| PeopleSoft CS → Workday Student | `bridge/peoplesoft/cs/` → HELIX Core → `bridge/workday/sis/`, direct lookups in `bridge/xref/ps-to-workday-sis/`. See [Chapter 7](#chapter-7-peoplesoft-to-workday-the-cornerstone-path) |
| PeopleSoft CS → Banner | `bridge/peoplesoft/cs/` → HELIX Core → `bridge/banner/` (reversed) |
| PeopleSoft CS → Data Lake | `bridge/peoplesoft/cs/` → HELIX Core → Iceberg/Parquet |
| Banner → Workday Student | `bridge/banner/` → HELIX Core → `bridge/workday/` (reversed) |
| Banner → PeopleSoft CS | `bridge/banner/` → HELIX Core → `bridge/peoplesoft/cs/` (reversed) |
| Banner → Data Lake | `bridge/banner/` → HELIX Core → Iceberg/Parquet |
| Banner on-prem → Banner SaaS | `bridge/banner/` → HELIX Core → `bridge/banner-saas/` (Ethos write-back). See [Chapter 8](#chapter-8-banner-on-prem-to-banner-saas) |
| Colleague → Workday Student | `bridge/colleague/` → HELIX Core → `bridge/workday/` (reversed) |
| Colleague → Data Lake | `bridge/colleague/` → HELIX Core → Iceberg/Parquet |
| Workday → Data Lake | `bridge/workday/` → HELIX Core → Iceberg/Parquet |

### I'm migrating my Financials

| From → To | Path |
|-----------|------|
| PeopleSoft FSCM → Workday Financials | `bridge/peoplesoft/fin/` → HELIX Core → `bridge/workday/fin/`, with `bridge/xref/ps-to-workday-fin/` and `templates/ps-to-workday/worktag-conversion-rules.json` |
| Banner Finance → Data Lake | `bridge/banner/finance/` → HELIX Core → Iceberg/Parquet |
| PeopleSoft FSCM → Data Lake | `bridge/peoplesoft/fin/` → HELIX Core → Iceberg/Parquet |

### I'm migrating my HR

| From → To | Path |
|-----------|------|
| PeopleSoft HCM → Workday HCM | `bridge/peoplesoft/hcm/` → HELIX Core → `bridge/workday/hr/`, direct lookups in `bridge/xref/ps-to-workday-hr/` |
| PeopleSoft HCM → Data Lake | `bridge/peoplesoft/hcm/` → HELIX Core → Iceberg/Parquet |

---

## What If My System Isn't Listed?

HELIX Bridge currently covers Banner, PeopleSoft, Workday, and Colleague. If your ERP isn't listed:

1. **Check the [CONTRIBUTING guide](../CONTRIBUTING.md)** — we actively seek mapping contributions for Jenzabar, Unit4, Tribal, Campus Management, and others
2. **Use HELIX Core as your target schema** — even without a pre-built Bridge, the foundational resource definitions give you the target shape. Build your own mapping and contribute it back.
3. **Open a GitHub Issue** requesting your ERP — this helps us prioritize community demand

---

*HELIX Migration Adventure Guide v0.7.0, September 2026*
*Part of the [HELIX Open Framework](https://github.com/utopify/helix)*
