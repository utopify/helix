# HELIX Bridge: ERP Mapping Reference

HELIX Bridge provides pre-built mapping templates for **4 ERP systems** with **49 total mapping files**.

| ERP | Architecture | Mappings | Coverage |
|-----|-------------|----------|----------|
| **Oracle PeopleSoft** | Relational, effective-dated | **40** (CS: 19, FIN: 9, HCM: 12) | 80-83% per module |
| **Ellucian Banner** | Relational (Oracle RDBMS) | 3 | Core SIS resources |
| **Workday Student** | Cloud-native (REST/business objects) | 3 | Core SIS resources |
| **Ellucian Colleague** | Multi-valued (UniData/UniVerse) | 3 | Core SIS resources |

## Oracle PeopleSoft (40 mappings)

The deepest Bridge in the HELIX ecosystem, covering three major PeopleSoft modules.

### Campus Solutions (SIS) — `peoplesoft/cs/` (19 mappings)

| HELIX Resource | Mapping File | Key PS Tables | Attrs |
|---------------|-------------|---------------|-------|
| AcademicOrg | `academic_org_mapping.json` | PS_ACAD_ORG_TBL | 10 |
| AcademicPeriod | `academic_period_mapping.json` | PS_TERM_TBL, PS_SESSION_TBL | 12 |
| AcademicTermRecord | `academic_term_record_mapping.json` | PS_STDNT_CAR_TERM, PS_STDNT_CAR_MLSTN +1 | 16 |
| AdmissionApplication | `admission_application_mapping.json` | PS_ADM_APPL_DATA, PS_ADM_APPL_PROG +4 | 17 |
| Course | `course_mapping.json` | PS_CRSE_CATALOG, PS_CRSE_OFFER | 14 |
| CourseSection | `course_section_mapping.json` | PS_CLASS_TBL, PS_CLASS_MTG_PAT +1 | 21 |
| DegreeAudit | `degree_audit_mapping.json` | PS_AA_RQRMNT, PS_AA_RQRMNT_DESIG +3 | 16 |
| Degree | `degree_mapping.json` | PS_ACAD_DEGR, PS_ACAD_DEGR_PLAN +1 | 16 |
| Enrollment | `enrollment_mapping.json` | PS_STDNT_ENRL, PS_CLASS_TBL +1 | 15 |
| FERPARestriction | `ferpa_restriction_mapping.json` | PS_FERPA_INDC, PS_FERPA_TBL | 8 |
| FinAidAward | `fin_aid_award_mapping.json` | PS_STDNT_AWARDS, PS_ITEM_TYPE_FA +3 | 19 |
| Hold | `hold_mapping.json` | PS_SRVC_IND_DATA, PS_SRVC_IND_TBL +1 | 14 |
| InternationalStudent | `international_student_mapping.json` | PS_VISA_PMT_DATA, PS_VISA_PERMIT_TBL +4 | 18 |
| Person | `person_mapping.json` | PS_PERSONAL_DATA, PS_NAMES +7 | 25 |
| Program | `program_mapping.json` | PS_ACAD_PROG_TBL, PS_ACAD_PLAN_TBL +1 | 13 |
| StudentGroup | `student_group_mapping.json` | PS_STDNT_GRPS, PS_STDNT_GRP_TBL | 8 |
| Student | `student_mapping.json` | PS_PERSONAL_DATA, PS_NAMES +4 | 18 |
| StudentProgram | `student_program_mapping.json` | PS_ACAD_PROG, PS_ACAD_PLAN +1 | 15 |
| TransferCredit | `transfer_credit_mapping.json` | PS_TRNS_CRSE_DTL, PS_TRNS_CRSE_TERM +2 | 16 |

### Financials (FSCM) — `peoplesoft/fin/` (9 mappings)

| HELIX Resource | Mapping File | Key PS Tables | Attrs |
|---------------|-------------|---------------|-------|
| APVoucher | `accounts_payable_mapping.json` | PS_VOUCHER, PS_VOUCHER_LINE +4 | 20 |
| StudentAccount | `accounts_receivable_mapping.json` | PS_ITEM, PS_ITEM_LINE_DTL +3 | 16 |
| FixedAsset | `asset_management_mapping.json` | PS_ASSET, PS_ASSET_ACQUIS_DT +3 | 22 |
| Budget | `budget_mapping.json` | PS_KK_BUDGET_ACTVY, PS_LEDGER_KK +2 | 16 |
| Contract | `contracts_mapping.json` | PS_CA_CONTR_HDR, PS_CA_CONTR_LINE +3 | 17 |
| ExpenseReport | `expenses_mapping.json` | PS_EX_SHEET_HDR, PS_EX_SHEET_LINE +4 | 14 |
| GLTransaction | `general_ledger_mapping.json` | PS_JRNL_HEADER, PS_JRNL_LN +6 | 22 |
| Grant | `grants_mapping.json` | PS_GM_AWARD, PS_GM_AWD_PRJ_LNK +4 | 16 |
| PurchaseOrder | `purchasing_mapping.json` | PS_PO_HDR, PS_PO_LINE +4 | 19 |

### Human Capital Management — `peoplesoft/hcm/` (12 mappings)

| HELIX Resource | Mapping File | Key PS Tables | Attrs |
|---------------|-------------|---------------|-------|
| AbsenceRecord | `absence_management_mapping.json` | PS_ABSENCE_EVENT, PS_ABSENCE_DAILY +4 | 14 |
| BenefitEnrollment | `benefits_mapping.json` | PS_HEALTH_BENEFIT, PS_LIFE_ADD_BEN +4 | 15 |
| Compensation | `compensation_mapping.json` | PS_COMPENSATION, PS_JOB +2 | 17 |
| Employee | `employee_mapping.json` | PS_PERSONAL_DATA, PS_NAMES +4 | 26 |
| JobClassification | `job_classification_mapping.json` | PS_JOBCODE_TBL, PS_SAL_PLAN_TBL +3 | 18 |
| TrainingRecord | `learning_management_mapping.json` | PS_TRAINING, PS_LM_LEARN_COMPNT +3 | 15 |
| PayrollRecord | `payroll_mapping.json` | PS_PAY_EARNINGS, PS_PAY_DEDUCTION +4 | 22 |
| PerformanceReview | `performance_management_mapping.json` | PS_EP_APPRAISAL, PS_EP_APPR_SECTION +3 | 14 |
| PositionBudget | `position_budget_mapping.json` | PS_POSITION_DATA, PS_POS_BUDGET +2 | 12 |
| Position | `position_mapping.json` | PS_POSITION_DATA, PS_POS_DATA_EFFDT | 14 |
| JobOpening | `recruiting_mapping.json` | PS_HRS_JO_I, PS_HRS_APP_I +2 | 13 |
| TimeRecord | `time_labor_mapping.json` | PS_TL_RPTD_TIME, PS_TL_PAYABLE_TIME +2 | 12 |

## Ellucian Banner (3 mappings)
**Architecture:** Relational (Oracle RDBMS)

| HELIX Resource | Mapping File | Key Source Tables | Attrs |
|---------------|-------------|-------------------|-------|
| AcademicPeriod | `academic_period_mapping.json` | STVTERM, SOBPTRM | 12 |
| Enrollment | `enrollment_mapping.json` | SFRSTCR, SHRTCKN +1 | 15 |
| Student | `student_mapping.json` | SPRIDEN, SPBPERS +3 | 18 |

## Workday Student (3 mappings)
**Architecture:** Cloud-native (REST API, business objects)

| HELIX Resource | Mapping File | Key Source Tables | Attrs |
|---------------|-------------|-------------------|-------|
| AcademicPeriod | `academic_period_mapping.json` | Academic Period, Academic Calendar | 12 |
| Enrollment | `enrollment_mapping.json` | Student Course Registration, Student Course Grade +1 | 15 |
| Student | `student_mapping.json` | Person, Student +3 | 19 |

## Ellucian Colleague (3 mappings)
**Architecture:** Multi-valued (UniData/UniVerse)

| HELIX Resource | Mapping File | Key Source Tables | Attrs |
|---------------|-------------|-------------------|-------|
| AcademicPeriod | `academic_period_mapping.json` | TERMS, TERM.SESSIONS | 12 |
| Enrollment | `enrollment_mapping.json` | STUDENT.ACAD.CRED, STUDENT.COURSE.SEC +1 | 15 |
| Student | `student_mapping.json` | PERSON, STUDENTS +3 | 19 |

## Migration Guide

For step-by-step migration paths between any combination of source and target systems, see the [Migration Adventure Guide](migration-adventure-guide.md).