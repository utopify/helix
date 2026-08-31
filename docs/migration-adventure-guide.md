# HELIX Migration Adventure Guide

### Choose Your Path. Map Your Data. Eliminate the Friction.

> Every ERP migration or data integration project starts with the same question: *How do I get from here to there?* This guide answers that question — for every combination of source and target system, organized by module.

---

## 🧭 START HERE: What's Your Migration?

### Step 1: What system are you migrating FROM?

- **PeopleSoft Campus Solutions** → Go to [Chapter 1: PeopleSoft CS](#chapter-1-peoplesoft-campus-solutions)
- **PeopleSoft Financials (FSCM)** → Go to [Chapter 2: PeopleSoft Financials](#chapter-2-peoplesoft-financials)
- **PeopleSoft HCM** → Go to [Chapter 3: PeopleSoft HCM](#chapter-3-peoplesoft-hcm)
- **Ellucian Banner** → Go to [Chapter 4: Banner](#chapter-4-ellucian-banner)
- **Ellucian Colleague** → Go to [Chapter 5: Colleague](#chapter-5-ellucian-colleague)
- **Workday Student** → Go to [Chapter 6: Workday Student](#chapter-6-workday-student)

### Step 2: What's your TARGET?

- **Data Lake / Lakehouse** → Your HELIX Bridge mapping IS the migration plan. Map source → HELIX Core → Iceberg/Parquet.
- **Another ERP** (e.g., PeopleSoft → Workday) → Use HELIX as the intermediate foundational model. Map source → HELIX Core, then HELIX Core → target. Both Bridge mappings are already built.
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
| **Workday Student** | PS → HELIX Person/Student → `bridge/workday/student_mapping.json` (reverse). Map HELIX attributes to Workday Person + Student business objects. |
| **Banner** | PS → HELIX Person/Student → `bridge/banner/student_mapping.json` (reverse). Map to SPRIDEN + SPBPERS + SGBSTDN. |
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
| **Workday Student** | PS → HELIX Enrollment → `bridge/workday/enrollment_mapping.json` (reverse). Map to Workday Student Course Registration. |
| **Banner** | PS → HELIX Enrollment → `bridge/banner/enrollment_mapping.json` (reverse). Map to SFRSTCR + SHRTCKN. |

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

**You're migrating FROM PeopleSoft HCM.**

| Module | What It Covers | Mapping File |
|--------|---------------|-------------|
| Core HR / Employee | Job records, employment history, demographics | `bridge/peoplesoft/hcm/employee_mapping.json` |
| Position Management | Position inventory, reporting structure, FTE | `bridge/peoplesoft/hcm/position_mapping.json` |
| Compensation | Salary, pay grades, comp components, compa-ratio | `bridge/peoplesoft/hcm/compensation_mapping.json` |
| Benefits | Health, retirement, life, FSA, dependents | `bridge/peoplesoft/hcm/benefits_mapping.json` |
| Payroll | Earnings, deductions, taxes, pay checks | `bridge/peoplesoft/hcm/payroll_mapping.json` |
| Time & Labor | Time reporting, punch data, approvals, schedules | `bridge/peoplesoft/hcm/time_labor_mapping.json` |
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

**You're migrating FROM Ellucian Banner.**

| HELIX Resource | Mapping File | Key Banner Tables |
|---------------|-------------|-------------------|
| Student | `bridge/banner/student_mapping.json` | SPRIDEN, SPBPERS, SGBSTDN |
| Enrollment | `bridge/banner/enrollment_mapping.json` | SFRSTCR, SHRTCKN, SSBSECT |
| AcademicPeriod | `bridge/banner/academic_period_mapping.json` | STVTERM, SOBPTRM |

**Migration to PeopleSoft?** Use the Banner Bridge (source) → HELIX Core → PeopleSoft Bridge (target, reversed).
**Migration to Workday?** Banner Bridge → HELIX Core → Workday Bridge.
**Migration to data lake?** Banner Bridge → HELIX Core → Iceberg/Parquet.

*Additional Banner resource mappings (Course, Program, FinAid, etc.) are planned. Contributions welcome.*

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
| Student | `bridge/workday/student_mapping.json` | Person, Student, Academic Affiliation |
| Enrollment | `bridge/workday/enrollment_mapping.json` | Student Course Registration, Student Course Grade |
| AcademicPeriod | `bridge/workday/academic_period_mapping.json` | Academic Period, Academic Calendar |

**Extraction methods:** RaaS, REST API, Prism Analytics, or Workday Data Cloud (zero-copy with AWS).

*Additional Workday resource mappings are planned.*

---

## Cross-Reference: Module-by-Module Migration Paths

### I'm migrating my SIS (Student module)

| From → To | Path |
|-----------|------|
| PeopleSoft CS → Workday Student | `bridge/peoplesoft/cs/` → HELIX Core → `bridge/workday/` (reversed) |
| PeopleSoft CS → Banner | `bridge/peoplesoft/cs/` → HELIX Core → `bridge/banner/` (reversed) |
| PeopleSoft CS → Data Lake | `bridge/peoplesoft/cs/` → HELIX Core → Iceberg/Parquet |
| Banner → Workday Student | `bridge/banner/` → HELIX Core → `bridge/workday/` (reversed) |
| Banner → PeopleSoft CS | `bridge/banner/` → HELIX Core → `bridge/peoplesoft/cs/` (reversed) |
| Banner → Data Lake | `bridge/banner/` → HELIX Core → Iceberg/Parquet |
| Colleague → Workday Student | `bridge/colleague/` → HELIX Core → `bridge/workday/` (reversed) |
| Colleague → Data Lake | `bridge/colleague/` → HELIX Core → Iceberg/Parquet |
| Workday → Data Lake | `bridge/workday/` → HELIX Core → Iceberg/Parquet |

### I'm migrating my Financials

| From → To | Path |
|-----------|------|
| PeopleSoft FSCM → Workday Financials | `bridge/peoplesoft/fin/` → HELIX Core → Workday worktag mapping |
| PeopleSoft FSCM → Data Lake | `bridge/peoplesoft/fin/` → HELIX Core → Iceberg/Parquet |

### I'm migrating my HR

| From → To | Path |
|-----------|------|
| PeopleSoft HCM → Workday HCM | `bridge/peoplesoft/hcm/` → HELIX Core → Workday Worker objects |
| PeopleSoft HCM → Data Lake | `bridge/peoplesoft/hcm/` → HELIX Core → Iceberg/Parquet |

---

## What If My System Isn't Listed?

HELIX Bridge currently covers Banner, PeopleSoft, Workday, and Colleague. If your ERP isn't listed:

1. **Check the [CONTRIBUTING guide](../CONTRIBUTING.md)** — we actively seek mapping contributions for Jenzabar, Unit4, Tribal, Campus Management, and others
2. **Use HELIX Core as your target schema** — even without a pre-built Bridge, the foundational resource definitions give you the target shape. Build your own mapping and contribute it back.
3. **Open a GitHub Issue** requesting your ERP — this helps us prioritize community demand

---

*HELIX Migration Adventure Guide v0.1 — August 2026*
*Part of the [HELIX Open Framework](https://github.com/utopify/helix)*
