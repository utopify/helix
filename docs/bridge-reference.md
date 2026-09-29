# HELIX Bridge: ERP Mapping Reference

163 mapping templates as of v0.8.1. Generated from the files in `bridge/`, so the counts below are the real file counts.

| System | Mappings | Modules |
|---|---:|---|
| **Oracle PeopleSoft** | 54 | Campus Solutions (SIS): 31, Financials (FSCM): 11, Human Capital Management: 12 |
| **Ellucian Banner (on-prem)** | 35 | Student (SIS): 14, Human Resources: 2, Finance: 7, Advancement: 5, Financial Aid: 7 |
| **Workday** | 54 | Student: 31, Financial Management: 11, Human Capital Management: 12 |
| **Ellucian Colleague** | 4 | Student: 4 |
| **Outcomes (non-ERP)** | 8 | Handshake, Clearinghouse, state wage records, licensure results, Canvas |
| **Banner SaaS (reverse)** | 8 | HELIX to Ethos write-back |

## PeopleSoft to Workday Crosswalks

Direct PS code → HELIX code → Workday value lookups: `xref/ps-to-workday-hr/` (10 dimensions, 121 rows), `xref/ps-to-workday-fin/` (8, 120), `xref/ps-to-workday-sis/` (15, 165). See `docs/ps-to-workday-migration.md`.

## Oracle PeopleSoft (54 mappings)

### Campus Solutions (SIS) — `peoplesoft/cs/` (31 mappings)

| HELIX Resource | Mapping File | Key PS Records | Attrs |
|---|---|---|---:|
| AcademicOrg | `academic_org_mapping.json` | PS_ACAD_ORG_TBL | 10 |
| AcademicPeriod | `academic_period_mapping.json` | PS_TERM_TBL, PS_SESSION_TBL | 12 |
| AcademicTermRecord | `academic_term_record_mapping.json` | PS_STDNT_CAR_TERM, PS_STDNT_CAR_MLSTN, PS_ACAD_STDNG_TBL | 16 |
| AdmissionApplication | `admission_application_mapping.json` | PS_ADM_APPL_DATA, PS_ADM_APPL_PROG, PS_ADM_APPL_PLAN, PS_ADM_APPL_ACTN ... | 17 |
| AidApplication | `aid_application_mapping.json` | PS_STDNT_AID, PS_ISIR_CONTROL, PS_ISIR_STUDENT +3 more | 26 |
| AidPackage | `aid_package_mapping.json` | PS_STDNT_AID, PS_STDNT_BUDGET_IT, PS_STDNT_AWARDS +3 more | 26 |
| AwardHonor | `award_honor_mapping.json` | PS_ACAD_DEGR_HONS, PS_HONOR_AWARD_CS, Term honors (dean's list) +2 more | 19 |
| Course | `course_mapping.json` | PS_CRSE_CATALOG, PS_CRSE_OFFER | 14 |
| CourseSection | `course_section_mapping.json` | PS_CLASS_TBL, PS_CLASS_MTG_PAT, PS_CLASS_INSTR | 21 |
| Degree | `degree_mapping.json` | PS_ACAD_DEGR, PS_ACAD_DEGR_PLAN, PS_ACAD_DEGR_HONS | 16 |
| DegreeAudit | `degree_audit_mapping.json` | PS_AA_RQRMNT, PS_AA_RQRMNT_DESIG, PS_STDNT_ADVR, PS_STDNT_ENRL (cross-ref) ... | 16 |
| Disbursement | `disbursement_mapping.json` | PS_STDNT_AWRD_DISB, PS_STDNT_AWARDS, PS_ITEM_TYPE_FA +3 more | 23 |
| Enrollment | `enrollment_mapping.json` | PS_STDNT_ENRL, PS_CLASS_TBL, PS_TERM_TBL | 15 |
| ExperientialLearning | `experiential_learning_mapping.json` | PS_STDNT_ENRL, PS_CLASS_TBL, PS_CRSE_CATALOG +2 more | 25 |
| FederalAidReport | `federal_aid_report_mapping.json` | PeopleSoft COD records, PeopleSoft FISAP records, PS_STDNT_AWRD_DISB +1 more | 20 |
| FERPARestriction | `ferpa_restriction_mapping.json` | PS_FERPA_INDC, PS_FERPA_TBL | 8 |
| FinAidAward | `fin_aid_award_mapping.json` | PS_STDNT_AWARDS, PS_ITEM_TYPE_FA, PS_STDNT_FA_TERM, PS_ISIR_COMPUTED ... | 19 |
| Hold | `hold_mapping.json` | PS_SRVC_IND_DATA, PS_SRVC_IND_TBL, PS_SRVC_IND_RSLT | 14 |
| Institution | `institution_mapping.json` | PS_INSTITUTION_TBL, PS_CAMPUS_TBL, PS_EXT_ORG_TBL +1 more | 11 |
| InternationalStudent | `international_student_mapping.json` | PS_VISA_PMT_DATA, PS_VISA_PERMIT_TBL, PS_SEVIS_DATA, PS_INTL_STDNT_DATA ... | 18 |
| LoanRecord | `loan_record_mapping.json` | PS_LOAN_ORIGNATN, PS_STDNT_AWARDS, PS_ITEM_TYPE_FA +2 more | 26 |
| Person | `person_mapping.json` | PS_PERSONAL_DATA, PS_NAMES, PS_ADDRESSES, PS_EMAIL_ADDRESSES ... | 25 |
| Program | `program_mapping.json` | PS_ACAD_PROG_TBL, PS_ACAD_PLAN_TBL, PS_ACAD_SUBPLAN_TBL | 13 |
| ReturnOfTitleIV | `return_of_title_iv_mapping.json` | PeopleSoft Return of Title IV records, PS_STDNT_CAR_TERM, PS_STDNT_ENRL +2 more | 23 |
| SAPEvaluation | `sap_evaluation_mapping.json` | PS_STDNT_FA_TERM, PS_STDNT_CAR_TERM, PS_ACAD_PROG +2 more | 20 |
| Student | `student_mapping.json` | PS_PERSONAL_DATA, PS_NAMES, PS_STDNT_CAR_TERM, PS_RESIDENCY ... | 18 |
| StudentEmployment | `student_employment_mapping.json` | PS_STDNT_AWARDS, PS_ITEM_TYPE_FA, PS_JOB +2 more | 21 |
| StudentGroup | `student_group_mapping.json` | PS_STDNT_GRPS, PS_STDNT_GRP_TBL | 8 |
| StudentProgram | `student_program_mapping.json` | PS_ACAD_PROG, PS_ACAD_PLAN, PS_STDNT_CAR_TERM | 15 |
| TransferCredit | `transfer_credit_mapping.json` | PS_TRNS_CRSE_DTL, PS_TRNS_CRSE_TERM, PS_TRNSFR_EQUIVLNC, PS_EXT_ORG_TBL | 16 |
| Verification | `verification_mapping.json` | PS_ISIR_COMPUTED, PS_STDNT_AID_ATRBT, PS_PERSON_CHECKLST +2 more | 19 |

### Financials (FSCM) — `peoplesoft/fin/` (11 mappings)

| HELIX Resource | Mapping File | Key PS Records | Attrs |
|---|---|---|---:|
| APVoucher | `accounts_payable_mapping.json` | PS_VOUCHER, PS_VOUCHER_LINE, PS_DISTRIB_LINE, PS_VENDOR ... | 20 |
| ARTransaction | `accounts_receivable_mapping.json` | PS_ITEM, PS_ITEM_LINE_DTL, PS_BI_HDR / PS_BI_LINE, PS_SF_ACCTG_LN ... | 18 |
| Asset | `asset_management_mapping.json` | PS_ASSET, PS_ASSET_ACQ_DET, PS_COST, PS_ASSET_CAT_TBL ... | 19 |
| Budget | `budget_mapping.json` | PS_LEDGER_KK, PS_KK_BUDGET_TYPE, PS_KK_BD_JOURNAL, PS_BUDGET_HDR / PS_BUDGET_LINE ... | 16 |
| Contract | `contracts_mapping.json` | PS_CNTRCT_HDR, PS_CNTRCT_LINE, PS_CNTRCT_RELEASE, PS_VENDOR | 15 |
| AcademicOrg / FinancialOrg | `cost_center_mapping.json` | PS_DEPT_TBL, PSTREENODE (DEPT_SECURITY tree), PS_COMPANY_TBL | 10 |
| ExpenseReport | `expenses_mapping.json` | PS_EX_SHEET_HDR, PS_EX_SHEET_LINE, PS_EX_LINE_DIST, PS_EX_ACCTG_LINE ... | 15 |
| Fund | `fund_mapping.json` | PS_FUND_TBL, PSTREENODE (FUND tree), PS_FUND_TYPE_TBL | 9 |
| GLTransaction | `general_ledger_mapping.json` | PS_JRNL_HEADER, PS_JRNL_LN, PS_LEDGER, PS_GL_ACCOUNT_TBL ... | 22 |
| Grant | `grants_mapping.json` | PS_GM_AWD_HDR, PS_GM_AWD_PRJ, PS_GM_SPONSOR, PS_GM_BUDGET_DTL ... | 22 |
| PurchaseOrder | `purchasing_mapping.json` | PS_PO_HDR, PS_PO_LINE, PS_PO_LINE_DIST, PS_REQ_HDR ... | 20 |

### Human Capital Management — `peoplesoft/hcm/` (12 mappings)

| HELIX Resource | Mapping File | Key PS Records | Attrs |
|---|---|---|---:|
| AbsenceRecord | `absence_management_mapping.json` | PS_GP_ABS_EVENT, PS_LEAVE_PLAN, PS_LEAVE_ACCRUAL, PS_JOB (LOA rows) ... | 12 |
| BenefitEnrollment | `benefits_mapping.json` | PS_HEALTH_BENEFIT, PS_LIFE_ADD_BEN, PS_SAVINGS_PLAN, PS_PENSION_PLAN ... | 13 |
| Compensation | `compensation_mapping.json` | PS_COMPENSATION, PS_JOB, PS_SAL_GRADE_TBL, PS_SAL_STEP_TBL | 15 |
| JobClassification | `job_classification_mapping.json` | PS_JOBCODE_TBL, PS_JOB_FAMILY_TBL, PS_EEO_JOB_GRP_TBL, PS_FACULTY_TABLE (custom) ... | 15 |
| LearningRecord | `learning_management_mapping.json` | PS_TRAINING, PS_TRAINING_TBL, PS_TRN_ASSIGN, PS_TRN_COMPLETION | 13 |
| PayrollResult | `payroll_mapping.json` | PS_PAY_EARNINGS, PS_PAY_DEDUCTION, PS_PAY_TAX, PS_PAY_CHECK ... | 18 |
| PerformanceReview | `performance_mapping.json` | PS_EP_APPRAISAL, PS_EP_GOAL, PS_EP_RATING_TBL, PS_TALENT_PROFILE | 14 |
| PositionBudget | `position_budget_mapping.json` | PS_POSITION_DATA, PS_POS_BUDGET, PS_POS_DIST, PS_JOB (incumbent join) | 14 |
| Position | `position_mapping.json` | PS_POSITION_DATA, PS_JOBCODE_TBL, PS_SAL_GRADE_TBL, PS_DEPT_TBL ... | 19 |
| Requisition | `recruiting_mapping.json` | PS_HRS_JO_I / PS_HRS_JO_D, PS_HRS_APP_I, PS_HRS_APPLICANT, PS_HRS_OFFER ... | 16 |
| TimeEntry | `time_tracking_mapping.json` | PS_TL_RPTD_TIME, PS_TL_PAYABLE_TIME, PS_TRC_TBL, PS_TL_PUNCH_DATA ... | 13 |
| Employee | `worker_mapping.json` | PS_JOB, PS_PERSONAL_DATA, PS_EMPLOYMENT, PS_NAMES ... | 27 |

## Ellucian Banner (on-prem) (35 mappings)

### Student (SIS) — `banner/sis/` (14 mappings)

| HELIX Resource | Mapping File | Key Banner Tables | Attrs |
|---|---|---|---:|
| AcademicOrg | `academic_org_mapping.json` | STVCOLL, STVDEPT, FTVORGN | 9 |
| AcademicPeriod | `academic_period_mapping.json` | STVTERM, SOBPTRM | 12 |
| AcademicTermRecord | `academic_term_record_mapping.json` | SFBETRM, SHRLGPA, SGRSPRT | 14 |
| AwardHonor | `award_honor_mapping.json` | SHRDGIH, SHRDGDH, STVHONR +3 more | 19 |
| Course | `course_mapping.json` | SCBCRSE, SCBDESC, SCRLEVL | 14 |
| CourseSection | `course_section_mapping.json` | SSBSECT, SSRMEET, SIRASGN, SSRXLST ... | 23 |
| Degree | `degree_mapping.json` | SHRDGMR, SHRLGPA, STVMAJR, STVDEGC ... | 18 |
| Enrollment | `enrollment_mapping.json` | SFRSTCR, SHRTCKN, SSBSECT | 15 |
| ExperientialLearning | `experiential_learning_mapping.json` | SFRSTCR, SSBSECT, STVSCHD +2 more | 25 |
| Institution | `institution_mapping.json` | GUBINST, STVCAMP, STVSBGI +2 more | 11 |
| Person | `person_mapping.json` | SPRIDEN, SPBPERS, GORRACE, GORPRAC ... | 26 |
| Program | `program_mapping.json` | SMRPRLE, SOBCURR, STVMAJR, STVCOLL ... | 13 |
| Student | `student_mapping.json` | SPRIDEN, SPBPERS, SGBSTDN, GOBINTL ... | 18 |
| StudentProgram | `student_program_mapping.json` | SGBSTDN, SORCMJR, SHRLGPA, SFBETRM ... | 15 |

### Human Resources — `banner/hr/` (2 mappings)

| HELIX Resource | Mapping File | Key Banner Tables | Attrs |
|---|---|---|---:|
| Employee | `employee_mapping.json` | PEBEMPL, NBRBJOB, NBBPOSN, PTRECLS ... | 24 |
| Position | `position_mapping.json` | NBBPOSN, NBRPTOT, FTVORGN, PTRECLS | 15 |

### Finance — `banner/finance/` (7 mappings)

| HELIX Resource | Mapping File | Key Banner Tables | Attrs |
|---|---|---|---:|
| APVoucher | `ap_voucher_mapping.json` | FABINVH, FABINVD, FABCHKD, FTVVEND | 17 |
| Budget | `budget_mapping.json` | FGBBALC, FTVACCT | 12 |
| FinancialOrg | `financial_org_mapping.json` | FTVORGN, FTVFMGR | 9 |
| Fund | `fund_mapping.json` | FTVFUND, FTVFTYP | 8 |
| GLTransaction | `gl_transaction_mapping.json` | FGBTRND, FGBTRNH, FGBJVCD, FTVACCT ... | 20 |
| Grant | `grant_mapping.json` | FRBGRNT, FRRGRPH, FRVGRNT, FTVAGCY | 21 |
| PurchaseOrder | `purchase_order_mapping.json` | FPBPOHD, FPBPODT, FTVVEND | 19 |

### Advancement — `banner/advancement/` (5 mappings)

| HELIX Resource | Mapping File | Key Banner Tables | Attrs |
|---|---|---|---:|
| AlumniProfile | `alumni_profile_mapping.json` | APBCONS, APRCATG, APRADEG +5 more | 24 |
| Campaign | `campaign_mapping.json` | AFBCAMP, AFRCDES | 12 |
| Constituent | `constituent_mapping.json` | APBCONS, SPRIDEN, APRCATG, APBCONS_PREF_CLAS ... | 24 |
| EngagementActivity | `engagement_activity_mapping.json` | APRCONT, APRMEMO, STVCTYP | 12 |
| Gift | `gift_mapping.json` | AGBGIFT, AGBPLDG, AFRDESG, APRCFAE | 24 |

### Financial Aid — `banner/financial-aid/` (7 mappings)

| HELIX Resource | Mapping File | Key Banner Tables | Attrs |
|---|---|---|---:|
| AidApplication | `aid_application_mapping.json` | RCRAPP1, RCRAPP2, RCRAPP3, RCRAPP4 ... | 26 |
| AidPackage | `aid_package_mapping.json` | RORSTAT, RBRCOMP, RPRATRM, RNRNA05 | 26 |
| Disbursement | `disbursement_mapping.json` | RPRADSB, RPRAWRD, ROBINST | 23 |
| FinAidAward | `fin_aid_award_mapping.json` | RPRAWRD, RFRBASE, RTVFTYP, RFRMGMT | 24 |
| LoanRecord | `loan_record_mapping.json` | RPRLORG, RPRAWRD, RORLOAN | 26 |
| SAPEvaluation | `sap_evaluation_mapping.json` | RORSTAT, RHRTPADV, RTVSAPR | 20 |
| Verification | `verification_mapping.json` | RRRAREQ, RTVTREQ, RORSTAT, RCRTPGP | 19 |

## Workday (54 mappings)

### Student — `workday/sis/` (31 mappings)

| HELIX Resource | Mapping File | Key Workday Objects | Attrs |
|---|---|---|---:|
| AcademicOrg | `academic_org_mapping.json` | Academic Unit, Academic Unit Hierarchy | 8 |
| AcademicPeriod | `academic_period_mapping.json` | Academic Period, Academic Calendar | 12 |
| AcademicTermRecord | `academic_term_record_mapping.json` | Student Academic Record (per period), Academic Standing | 13 |
| AdmissionApplication | `admission_application_mapping.json` | Student Application, Application Decision, Applicant, Application Checklist Item | 14 |
| AidApplication | `aid_application_mapping.json` | ISIR Record, Student Award Year Record, ISIR Comment Code +1 more | 26 |
| AidPackage | `aid_package_mapping.json` | Cost of Attendance, Financial Aid Package, Financial Aid Award +1 more | 26 |
| AwardHonor | `award_honor_mapping.json` | Academic Honor, Program of Study Completion / Academic Credential, Student Award | 19 |
| Course | `course_mapping.json` | Course Definition, Course Subject, Academic Unit | 15 |
| CourseSection | `course_section_mapping.json` | Course Section, Course Section Meeting Pattern, Course Section Instructor, Location | 14 |
| Degree | `degree_mapping.json` | Awarded Credential, Academic Completion | 13 |
| DegreeAudit | `degree_audit_mapping.json` | Academic Progress, Academic Requirement, Requirement Status | 16 |
| Disbursement | `disbursement_mapping.json` | Financial Aid Disbursement, Financial Aid Award, Student Payment +2 more | 23 |
| Enrollment | `enrollment_mapping.json` | Student Course Registration, Student Course Grade, Course Section | 15 |
| ExperientialLearning | `experiential_learning_mapping.json` | Student Course Registration, Course Section, Instructional Format | 25 |
| FederalAidReport | `federal_aid_report_mapping.json` | COD Batch, COD Response, FISAP Report +1 more | 20 |
| FERPARestriction | `ferpa_restriction_mapping.json` | Student Privacy Setting, Directory Information Category | 11 |
| FinAidAward | `fin_aid_award_mapping.json` | Financial Aid Award, Financial Aid Package, ISIR Record, Aid Fund | 16 |
| Hold | `hold_mapping.json` | Student Hold, Hold Type | 14 |
| Institution | `institution_mapping.json` | Academic Unit (top of hierarchy), Company, Educational Institution | 11 |
| InternationalStudent | `international_student_mapping.json` | International Student Data, Visa/Permit, SEVIS Record | 14 |
| LoanRecord | `loan_record_mapping.json` | Direct Loan Record, Master Promissory Note, Loan Counseling +1 more | 26 |
| Person | `person_mapping.json` | Academic Person, Person Contact Information, Person Identifier, Person Name | 23 |
| Program | `program_mapping.json` | Program of Study, Field of Study, Educational Credential | 11 |
| ReturnOfTitleIV | `return_of_title_iv_mapping.json` | Return of Title IV Calculation, Student Withdrawal, Post-Withdrawal Disbursement +1 more | 23 |
| SAPEvaluation | `sap_evaluation_mapping.json` | Satisfactory Academic Progress Evaluation, Student SAP Status, SAP Appeal +1 more | 20 |
| Student | `student_mapping.json` | Person, Student, Academic Affiliation, Citizenship Status ... | 19 |
| StudentEmployment | `student_employment_mapping.json` | Financial Aid Award, Worker, Position +2 more | 21 |
| StudentGroup | `student_group_mapping.json` | Student Group, Student Group Membership, Student Cohort | 11 |
| StudentProgram | `student_program_mapping.json` | Student Program Enrollment, Student Field of Study Declaration, Academic Standing | 14 |
| TransferCredit | `transfer_credit_mapping.json` | External Academic Record, Transfer Credit Award, External Organization | 15 |
| Verification | `verification_mapping.json` | ISIR Record, Financial Aid Verification, Action Item +1 more | 19 |

### Financial Management — `workday/fin/` (11 mappings)

| HELIX Resource | Mapping File | Key Workday Objects | Attrs |
|---|---|---|---:|
| APVoucher | `accounts_payable_mapping.json` | Supplier Invoice, Supplier Invoice Line, Supplier, Payment ... | 18 |
| ARTransaction | `accounts_receivable_mapping.json` | Customer Invoice, Customer Invoice Line, Customer Payment, Customer Refund ... | 18 |
| Asset | `asset_management_mapping.json` | Business Asset, Asset Category, Asset Depreciation, Asset Location | 19 |
| Budget | `budget_mapping.json` | Budget, Budget Amendment, Budget Line, Commitment | 13 |
| Contract | `contracts_mapping.json` | Supplier Contract, Supplier Contract Line, Supplier Contract Amendment | 15 |
| AcademicOrg / FinancialOrg | `cost_center_mapping.json` | Cost Center, Cost Center Hierarchy, Company | 10 |
| ExpenseReport | `expenses_mapping.json` | Expense Report, Expense Report Line, Expense Item, Travel Booking | 15 |
| Fund | `fund_mapping.json` | Fund, Fund Hierarchy, Fund Type | 9 |
| GLTransaction | `general_ledger_mapping.json` | Journal Entry, Journal Line, Ledger Account, Ledger Summary ... | 21 |
| Grant | `grants_mapping.json` | Grant, Grant Budget, Grant Hierarchy, Effort Certification ... | 22 |
| PurchaseOrder | `purchasing_mapping.json` | Purchase Order, Purchase Order Line, Requisition, Receipt ... | 20 |

### Human Capital Management — `workday/hr/` (12 mappings)

| HELIX Resource | Mapping File | Key Workday Objects | Attrs |
|---|---|---|---:|
| AbsenceRecord | `absence_management_mapping.json` | Leave of Absence, Absence Request, Absence Plan, Time Off Balance | 12 |
| BenefitEnrollment | `benefits_mapping.json` | Worker Benefit Election, Benefit Plan, Benefit Event, Dependent | 13 |
| Compensation | `compensation_mapping.json` | Worker Compensation, Compensation Plan, Compensation Grade, Compensation Step ... | 15 |
| JobClassification | `job_classification_mapping.json` | Job Profile, Job Family, Worker Additional Data (Faculty), EEO/SOC Mapping | 15 |
| LearningRecord | `learning_management_mapping.json` | Learning Course, Learning Enrollment, Learning Assignment, Learning Campaign | 13 |
| PayrollResult | `payroll_mapping.json` | Payroll Result, Pay Component, Payroll Input, Tax Filing | 18 |
| PerformanceReview | `performance_mapping.json` | Performance Review, Goal, Competency Assessment, Talent Profile | 14 |
| PositionBudget | `position_budget_mapping.json` | Position Budget, Staffing Model, Position Funding | 14 |
| Position | `position_mapping.json` | Position, Position Restriction, Supervisory Organization, Job Profile | 19 |
| Requisition | `recruiting_mapping.json` | Job Requisition, Job Application, Candidate, Offer ... | 16 |
| TimeEntry | `time_tracking_mapping.json` | Time Block, Time Entry Code, Time Clock Event, Worker Time Sheet | 13 |
| Employee | `worker_mapping.json` | Worker, Worker Job Data, Worker Employment Status, Worker Contact Information ... | 27 |

## Ellucian Colleague (4 mappings)

### Student — `colleague/` (4 mappings)

| HELIX Resource | Mapping File | Key Colleague Files | Attrs |
|---|---|---|---:|
| AcademicPeriod | `academic_period_mapping.json` |  | 12 |
| Enrollment | `enrollment_mapping.json` |  | 15 |
| Institution | `institution_mapping.json` | INSTITUTIONS, CORP / PERSON, DEFAULTS | 11 |
| Student | `student_mapping.json` |  | 19 |

## Outcomes Sources Outside the ERP (8 mappings)

### `outcomes/` (8 mappings)

Graduate outcomes mostly come from career services, the Clearinghouse, state agencies, licensing boards, and the LMS. See `outcomes/README.md` for which source feeds which resource and the rules that apply to all of them.

| HELIX Resource | Mapping File | Source | Attrs |
|---|---|---|---:|
| ContinuingEducation | `handshake_continuing_education_mapping.json` | First Destination Survey response, Survey recipient list | 17 |
| ContinuingEducation | `nsc_studenttracker_continuing_education_mapping.json` | StudentTracker detail report | 17 |
| EmploymentOutcome | `handshake_employment_outcome_mapping.json` | First Destination Survey response, Survey recipient list | 25 |
| EmploymentOutcome | `state_ui_wage_employment_outcome_mapping.json` | Quarterly UI wage record (matched) | 25 |
| ExperientialLearning | `handshake_experiential_learning_mapping.json` | Experience, Experience approval / evaluation | 25 |
| FirstDestinationSurvey | `handshake_first_destination_survey_mapping.json` | First Destination Survey response, Survey recipient list | 20 |
| LearningOutcome | `canvas_learning_outcome_mapping.json` | Outcome, Outcome Result, Outcome Group | 19 |
| Licensure | `licensure_exam_results_mapping.json` | Individual result files, Program-level reports, Student self-report and public license lookups | 21 |

## Banner SaaS Reverse Bridge (8 mappings)

HELIX Core resources written into Banner SaaS through Ethos. See `bridge/banner-saas/WRITEBACK_PATTERNS.md`.

| HELIX Resource | Mapping File | Ethos Resource | Write Path |
|---|---|---|---|
| AcademicPeriod | `academic_period_reverse_mapping.json` | academic-periods | Ethos Integration API (often read-only) / Banner configuration |
| Course | `course_reverse_mapping.json` | courses | Ethos Integration API |
| Enrollment | `enrollment_reverse_mapping.json` | section-registrations | Banner Integration API (BIA) / Ethos business-process API |
| Person | `person_reverse_mapping.json` | persons | Ethos Integration API |
| Program | `program_reverse_mapping.json` | academic-programs | Ethos Integration API (often config-governed) |
| CourseSection | `section_reverse_mapping.json` | sections | Ethos Integration API |
| StudentProgram | `student_program_reverse_mapping.json` | student-academic-programs | Ethos Integration API |
| Student | `student_reverse_mapping.json` | students | Ethos Integration API / business-process API |

## Migration Guide

For step-by-step paths, see [`migration-adventure-guide.md`](migration-adventure-guide.md). For PeopleSoft to Workday, start with [`ps-to-workday-migration.md`](ps-to-workday-migration.md).

*HELIX Bridge Reference v0.6.0, September 2026*
