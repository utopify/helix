# HELIX Core: Terminology Catalog

HELIX Core defines **67 code sets** with **595 codes**. This catalog is generated from `core/terminologies/`, so it always matches them.

A code set standardizes the values an attribute can hold. When `enrollment_status` is bound to `helix/enrollment-status`, every institution uses the same codes with the same meanings, and each institution maps its local codes to them on the way from bronze to silver.

## Student Lifecycle

| Code Set | Codes | Values | Used By |
|----------|------:|--------|---------|
| **Student Status** (`helix/student-status`) | 8 | `prospective`, `applicant`, `admitted`, `enrolled`, `leave_of_absence`, `withdrawn`, `graduated`, `deceased` | Student |
| **Enrollment Status** (`helix/enrollment-status`) | 8 | `registered`, `waitlisted`, `enrolled`, `dropped`, `withdrawn`, `completed`, `incomplete`, `auditing` | Enrollment |
| **Academic Period Type** (`helix/period-type`) | 7 | `semester`, `quarter`, `trimester`, `session`, `mini_term`, `academic_year`, `other` | AcademicPeriod |
| **Grade Mode** (`helix/grade-mode`) | 5 | `standard`, `pass_fail`, `audit`, `satisfactory_unsatisfactory`, `other` | Enrollment |
| **Financial Aid Award Type** (`helix/award-type`) | 11 | `grant`, `scholarship`, `loan_subsidized`, `loan_unsubsidized`, `loan_plus`, `loan_private`, `work_study`, `waiver`, `fellowship`, `assistantship`, `other` | FinAidAward |
| **Degree Level** (`helix/degree-level`) | 12 | `certificate_undergraduate`, `associate`, `bachelors`, `certificate_post_baccalaureate`, `masters`, `certificate_post_masters`, `doctoral_research`, `doctoral_professional`, `professional`, `non_degree`, `micro_credential`, `other` | Degree, Program |
| **Delivery Mode** (`helix/delivery-mode`) | 11 | `in_person`, `online_synchronous`, `online_asynchronous`, `hybrid`, `hyflex`, `competency_based`, `correspondence`, `clinical`, `internship`, `independent_study`, `other` | CourseSection, Program |
| **Course Level** (`helix/course-level`) | 8 | `developmental`, `undergraduate_lower`, `undergraduate_upper`, `graduate`, `doctoral`, `professional`, `non_credit`, `other` | Course |
| **Admission Status** (`helix/admission-status`) | 10 | `submitted`, `in_review`, `incomplete`, `admitted`, `conditionally_admitted`, `denied`, `waitlisted`, `deferred`, `cancelled`, `withdrawn` | AdmissionApplication |
| **Hold Type** (`helix/hold-type`) | 12 | `registration`, `financial`, `academic`, `disciplinary`, `transcript`, `graduation`, `library`, `health_compliance`, `admissions`, `international`, `parking`, `other` | Hold |
| **Student Type** (`helix/student-type`) | 10 | `first_time_freshman`, `transfer`, `readmit`, `continuing`, `dual_enrollment`, `transient`, `non_degree`, `post_baccalaureate`, `audit_only`, `other` | Student |
| **Satisfactory Academic Progress (SAP) Status** (`helix/sap-status`) | 6 | `meeting`, `warning`, `probation`, `suspension`, `appeal_approved`, `not_evaluated` | SAPEvaluation |
| **Enrollment Funnel Stage** (`helix/enrollment-funnel-stage`) | 10 | `suspect`, `inquiry`, `applicant`, `admitted`, `confirmed`, `registered`, `enrolled`, `melted`, `denied`, `withdrawn` | Glossary and enrollment analytics; no Core attribute yet |

## Identity and Demographics

| Code Set | Codes | Values | Used By |
|----------|------:|--------|---------|
| **Gender** (`helix/gender`) | 5 | `male`, `female`, `nonbinary`, `unknown`, `other` | Person, Student |
| **Gender Identity** (`helix/gender-identity`) | 10 | `man`, `woman`, `nonbinary`, `transgender_man`, `transgender_woman`, `genderqueer`, `two_spirit`, `prefer_not_to_say`, `not_listed`, `unknown` | Person |
| **Ethnicity/Race** (`helix/ethnicity`) | 10 | `hispanic_latino`, `american_indian_alaska_native`, `asian`, `black_african_american`, `native_hawaiian_pacific_islander`, `white`, `two_or_more`, `nonresident_alien`, `unknown`, `other` | Person |
| **Identifier Type** (`helix/identifier-type`) | 12 | `institutional_id`, `national_id`, `ssn_last4`, `passport`, `drivers_license`, `login`, `email`, `erp_internal_key`, `prior_institution_id`, `clearing_house_id`, `orcid`, `other` | Person |
| **Veteran Status** (`helix/veteran-status`) | 6 | `none`, `veteran`, `active_duty`, `reserve_national_guard`, `dependent_spouse`, `other` | Student |

## Financial Aid

| Code Set | Codes | Values | Used By |
|----------|------:|--------|---------|
| **Aid Application Status** (`helix/aid-application-status`) | 8 | `received`, `in_review`, `verification_required`, `verification_complete`, `isir_correction_pending`, `complete`, `rejected`, `cancelled` | AidApplication |
| **Verification Status** (`helix/verification-status`) | 9 | `selected`, `documents_requested`, `documents_partial`, `documents_complete`, `in_review`, `conflicting_information`, `completed`, `incomplete`, `waived` | Verification |
| **Dependency Status** (`helix/dependency-status`) | 4 | `dependent`, `independent`, `dependency_override_approved`, `provisional_independent` | AidApplication |
| **Loan Type** (`helix/loan-type`) | 9 | `direct_subsidized`, `direct_unsubsidized`, `direct_plus_parent`, `direct_plus_grad`, `perkins`, `direct_consolidation`, `private_alternative`, `institutional_loan`, `heal` | LoanRecord |
| **Loan Status** (`helix/loan-status`) | 10 | `originated`, `pending_mpn`, `pending_counseling`, `certified`, `disbursed`, `in_school_deferment`, `grace_period`, `repayment`, `cancelled`, `returned` | LoanRecord |
| **Disbursement Status** (`helix/disbursement-status`) | 8 | `scheduled`, `pending`, `held`, `disbursed`, `partially_disbursed`, `cancelled`, `returned`, `refunded` | Disbursement |
| **Return of Title IV (R2T4) Status** (`helix/r2t4-status`) | 7 | `withdrawal_reported`, `calculation_pending`, `calculation_complete`, `funds_returned`, `post_withdrawal_offered`, `pwd_disbursed`, `closed` | ReturnOfTitleIV |
| **Aid Fund Source** (`helix/fund-source`) | 7 | `federal`, `state`, `institutional`, `private`, `employer`, `tribal`, `foreign_government` | FinAidAward |
| **Student Employment Type (Aid)** (`helix/employment-type-aid`) | 7 | `federal_work_study`, `institutional_work_study`, `graduate_assistantship`, `teaching_assistantship`, `research_assistantship`, `fellowship`, `off_campus_community_service` | StudentEmployment |

## Outcomes and Alumni

| Code Set | Codes | Values | Used By |
|----------|------:|--------|---------|
| **First-Destination Status** (`helix/first-destination-status`) | 12 | `employed_full_time`, `employed_part_time`, `continuing_education`, `military_service`, `volunteer_service`, `seeking_employment`, `seeking_continuing_education`, `not_seeking`, `self_employed`, `freelance_contract`, `postgrad_fellowship`, `unknown` | EmploymentOutcome, FirstDestinationSurvey |
| **Employment Relation to Major** (`helix/employment-relation`) | 4 | `directly_related`, `somewhat_related`, `not_related`, `not_applicable` | EmploymentOutcome |
| **Continuing Education Level** (`helix/continuing-ed-level`) | 9 | `masters`, `doctoral`, `professional_jd`, `professional_md`, `professional_other`, `second_bachelors`, `certificate`, `postbaccalaureate`, `postdoctoral` | ContinuingEducation |
| **Experiential Learning Type** (`helix/experiential-type`) | 12 | `internship`, `co_op`, `practicum`, `clinical_rotation`, `student_teaching`, `undergraduate_research`, `service_learning`, `field_experience`, `externship`, `apprenticeship`, `capstone_project`, `study_abroad` | ExperientialLearning |
| **Licensure/Certification Type** (`helix/licensure-type`) | 13 | `nursing_nclex`, `cpa`, `bar_exam`, `teaching_praxis`, `medical_usmle`, `pharmacy_naplex`, `engineering_pe`, `social_work`, `counseling`, `dental`, `veterinary`, `physical_therapy`, `other` | Licensure |
| **Licensure Result** (`helix/licensure-result`) | 8 | `pass`, `fail`, `pass_first_attempt`, `pass_subsequent_attempt`, `pending`, `scheduled`, `no_show`, `conditional` | Licensure |
| **Learning Outcome Type** (`helix/outcome-type`) | 6 | `program_learning_outcome`, `course_learning_outcome`, `institutional_learning_outcome`, `general_education_competency`, `professional_competency`, `accreditation_standard` | LearningOutcome |
| **Achievement Level** (`helix/achievement-level`) | 9 | `exceeds`, `meets`, `approaching`, `below`, `not_demonstrated`, `exemplary`, `proficient`, `developing`, `beginning` | LearningOutcome |
| **Honor/Award Type** (`helix/honor-type`) | 11 | `latin_honors`, `deans_list`, `presidents_list`, `departmental_award`, `institutional_award`, `national_award`, `scholarship`, `fellowship`, `academic_distinction`, `graduation_honor`, `honor_society` | AwardHonor |
| **Survey Status** (`helix/survey-status`) | 7 | `not_sent`, `sent`, `in_progress`, `completed`, `partial`, `no_response`, `opted_out` | FirstDestinationSurvey |

## Advancement

| Code Set | Codes | Values | Used By |
|----------|------:|--------|---------|
| **Constituent Type** (`helix/constituent-type`) | 10 | `alumnus`, `donor`, `parent`, `friend`, `faculty_staff`, `corporation`, `foundation`, `organization`, `prospect`, `other` | Constituent |
| **Gift Type** (`helix/gift-type`) | 14 | `outright_gift`, `pledge`, `pledge_payment`, `matching_gift`, `planned_gift`, `bequest`, `in_kind`, `stock_transfer`, `real_property`, `qcd`, `daf`, `corporate_grant`, `foundation_grant`, `other` | Gift |
| **Donor Segment** (`helix/donor-segment`) | 11 | `non_donor`, `first_time`, `renewing`, `upgrading`, `downgrading`, `loyal`, `lapsed`, `deep_lapsed`, `major`, `planned_giving`, `recaptured` | Constituent |
| **Prospect Stage (Moves Management)** (`helix/prospect-stage`) | 6 | `identification`, `qualification`, `cultivation`, `solicitation`, `stewardship`, `none` | Constituent |

## Human Resources

| Code Set | Codes | Values | Used By |
|----------|------:|--------|---------|
| **Worker Type** (`helix/worker-type`) | 12 | `regular`, `temporary`, `contingent`, `contractor`, `student_worker`, `graduate_assistant`, `intern`, `fellow`, `volunteer`, `emeritus`, `postdoc`, `adjunct` | Employee, Position |
| **Employment Status** (`helix/employment-status`) | 8 | `active`, `inactive`, `leave_of_absence`, `terminated`, `retired`, `suspended`, `deceased`, `furloughed` | Employee |
| **Position Status** (`helix/position-status`) | 6 | `open`, `filled`, `frozen`, `abolished`, `proposed`, `pooled` | Position |
| **Compensation Type** (`helix/compensation-type`) | 12 | `base_salary`, `hourly`, `stipend`, `overload`, `summer_pay`, `administrative_supplement`, `acting_pay`, `shift_differential`, `on_call`, `longevity`, `bonus`, `housing_allowance` | Compensation |
| **Benefit Plan Type** (`helix/benefit-plan-type`) | 15 | `medical`, `dental`, `vision`, `life_insurance`, `disability_short_term`, `disability_long_term`, `retirement_403b`, `retirement_pension`, `retirement_457b`, `tuition_waiver`, `hsa`, `fsa`, `cobra`, `eap`, `supplemental_retirement` | BenefitEnrollment |
| **Pay Frequency** (`helix/pay-frequency`) | 6 | `biweekly`, `semimonthly`, `monthly`, `weekly`, `annual`, `per_course` | Crosswalks (`bridge/xref/ps-to-workday-hr/pay-frequency-xref.json`); no Core attribute yet |
| **Absence Type** (`helix/absence-type`) | 13 | `vacation`, `sick`, `personal`, `fmla`, `military`, `bereavement`, `jury_duty`, `sabbatical`, `parental`, `administrative`, `workers_compensation`, `unpaid`, `professional_development` | AbsenceRecord |
| **Requisition Status** (`helix/requisition-status`) | 10 | `draft`, `pending_approval`, `approved`, `posted`, `interviewing`, `offer_extended`, `filled`, `cancelled`, `on_hold`, `waiver_requested` | Requisition |
| **Performance Rating** (`helix/performance-rating`) | 7 | `exceptional`, `exceeds_expectations`, `meets_expectations`, `partially_meets`, `does_not_meet`, `not_rated`, `improvement_demonstrated` | PerformanceReview |
| **Faculty Rank** (`helix/faculty-rank`) | 13 | `instructor`, `lecturer`, `senior_lecturer`, `assistant_professor`, `associate_professor`, `full_professor`, `distinguished_professor`, `university_professor`, `emeritus_professor`, `clinical_professor`, `research_professor`, `professor_of_practice`, `visiting_professor` | JobClassification |
| **Tenure Status** (`helix/tenure-status`) | 5 | `pre_tenure`, `tenured`, `non_tenure_track`, `tenure_denied`, `tenure_revoked` | JobClassification |
| **EEO/IPEDS Occupational Category** (`helix/eeo-category`) | 7 | `executive_admin`, `faculty`, `professional_nonfaculty`, `clerical_secretarial`, `technical_paraprofessional`, `skilled_crafts`, `service_maintenance` | JobClassification, Requisition |
| **FLSA Status** (`helix/flsa-status`) | 3 | `exempt`, `non_exempt`, `exempt_teaching` | Employee, JobClassification |
| **Learning/Training Type** (`helix/learning-type`) | 9 | `course`, `workshop`, `certification`, `conference`, `webinar`, `self_paced`, `on_the_job`, `mentoring`, `compliance_training` | LearningRecord |

## Financial Operations

| Code Set | Codes | Values | Used By |
|----------|------:|--------|---------|
| **GL Transaction Type** (`helix/transaction-type`) | 11 | `journal_entry`, `standard`, `adjustment`, `accrual`, `reversal`, `closing`, `reclassification`, `elimination`, `statistical`, `budget_entry`, `encumbrance` | GLTransaction |
| **Payment Status** (`helix/payment-status`) | 9 | `pending`, `approved`, `scheduled`, `paid`, `voided`, `cancelled`, `returned`, `partially_paid`, `held` | APVoucher |
| **Budget Status** (`helix/budget-status`) | 9 | `proposed`, `submitted`, `approved`, `active`, `frozen`, `closed`, `revised`, `permanent_budget`, `temporary_budget` | Budget |
| **Purchase Order Status** (`helix/purchase-order-status`) | 9 | `draft`, `pending_approval`, `approved`, `dispatched`, `partially_received`, `received`, `closed`, `cancelled`, `change_order` | PurchaseOrder |
| **Grant/Sponsored Program Status** (`helix/grant-status`) | 10 | `pre_award`, `pending`, `negotiation`, `active`, `no_cost_extension`, `suspended`, `closed`, `final_reporting`, `audit`, `subaward_pending` | Grant |
| **Fixed Asset Status** (`helix/asset-status`) | 8 | `active`, `idle`, `under_repair`, `disposed`, `retired`, `lost`, `transferred`, `construction_in_progress` | Asset |
| **Asset Category** (`helix/asset-category`) | 12 | `land`, `buildings`, `building_improvements`, `equipment`, `vehicles`, `furniture`, `software`, `leasehold_improvements`, `construction_in_progress`, `library_collections`, `artwork_collections`, `infrastructure` | Asset |
| **Expense Report Status** (`helix/expense-status`) | 8 | `draft`, `submitted`, `pending_approval`, `approved`, `paid`, `returned`, `denied`, `under_audit` | ExpenseReport |
| **Contract Status** (`helix/contract-status`) | 9 | `draft`, `negotiation`, `pending_approval`, `pending_execution`, `active`, `suspended`, `expired`, `terminated`, `renewed` | Contract |
| **Fund Type** (`helix/fund-type`) | 12 | `unrestricted`, `temporarily_restricted`, `permanently_restricted`, `endowment`, `quasi_endowment`, `agency`, `loan`, `plant`, `auxiliary`, `grant_sponsored`, `designated`, `current_restricted` | FinancialOrg, Fund |
| **Chart of Accounts — Account Type** (`helix/account-type`) | 6 | `asset`, `liability`, `fund_balance`, `revenue`, `expenditure`, `transfer` | GLTransaction |

## Cross-Cutting

| Code Set | Codes | Values | Used By |
|----------|------:|--------|---------|
| **Data Classification** (`helix/data-classification`) | 4 | `public`, `internal`, `confidential`, `restricted` | All resources (meta block) |

Each file in `core/terminologies/` has the full definition of every code.

*HELIX v0.9.0, September 2026. Generated from core/terminologies/.*
