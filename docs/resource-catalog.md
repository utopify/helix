# HELIX Core: Resource Catalog

HELIX Core defines **64 resources** across 9 domains. This catalog is generated from the JSON Schemas in `core/resources/`, so it always matches them.

Each resource carries a `meta` block with version, source system, data owner, and a default classification. Education records also carry FERPA flags. Who can read each resource is in `govern/access-control-matrix.json`.

| Domain | Resources |
|--------|----------:|
| Identity | 3 |
| Academic Structure | 5 |
| Enrollment & Registration | 9 |
| Financial Aid | 10 |
| Outcomes | 9 |
| Student Services | 1 |
| Advancement | 4 |
| Financial Operations | 11 |
| Human Resources | 12 |

## Identity

### `Institution`
**File:** `core/resources/institution.json` · **Classification:** public · **FERPA education record:** no

A higher education institution — university, college, community college, or system office.

**Attributes (12):** `helix_id`, `name`, `short_name`, `identifiers`, `institution_type`, `carnegie_classification`, `country`, `state_province`, `timezone`, `erp_system`, `website`, `meta`

**Required:** `helix_id`, `name`, `institution_type`, `country`

### `Person`
**File:** `core/resources/person.json` · **Classification:** confidential · **FERPA education record:** yes

A human being known to the institution in any capacity — student, employee, applicant, alumnus, donor, or contact. The foundational identity resource. Student, Employee, and other role-specific resources reference a Person.

**Attributes (16):** `helix_id`, `institution_id`, `identifiers`, `name`, `birth_date`, `gender`, `gender_identity`, `pronouns`, `ethnicity`, `citizenship_countries`, `primary_language`, `is_deceased`, `deceased_date`, `contact`, `emergency_contacts`, `meta`

**Required:** `helix_id`, `institution_id`, `identifiers`, `name`

**Code sets:** `helix/ethnicity`, `helix/gender`, `helix/gender-identity`, `helix/identifier-type`

### `Student`
**File:** `core/resources/student.json` · **Classification:** confidential · **FERPA education record:** yes

A person in their capacity as a learner at an institution. References a Person resource for base identity. Contains student-specific attributes: status, academic level, GPA, program enrollment, and classification.

**Attributes (27):** `helix_id`, `institution_id`, `identifiers`, `name`, `birth_date`, `gender`, `status`, `first_generation_flag`, `citizenship_country`, `residency`, `demographics`, `meta`, `person_ref`, `student_type`, `academic_level`, `class_standing`, `full_part_time`, `cumulative_gpa`, `total_credits_earned`, `total_credits_attempted`, `admit_period_ref`, `matriculation_date`, `expected_graduation_date`, `primary_program_ref`, `cohort`, `veteran_status`, `international_student`

**Required:** `helix_id`, `institution_id`, `identifiers`, `status`

**Code sets:** `helix/gender`, `helix/student-status`, `helix/student-type`, `helix/veteran-status`

## Academic Structure

### `AcademicOrg`
**File:** `core/resources/academic_org.json` · **Classification:** internal · **FERPA education record:** no

An academic organizational unit within an institution — college, school, division, department, or program area. Forms a hierarchy (university → college → department).

**Attributes (12):** `helix_id`, `institution_id`, `code`, `name`, `short_name`, `org_type`, `parent_org_ref`, `dean_or_chair`, `is_active`, `effective_date`, `end_date`, `meta`

**Required:** `helix_id`, `institution_id`, `name`, `org_type`

### `AcademicPeriod`
**File:** `core/resources/academic_period.json` · **Classification:** public · **FERPA education record:** no

A defined period of academic activity (term, semester, quarter, session).

**Attributes (11):** `helix_id`, `institution_id`, `period_type`, `code`, `name`, `academic_year`, `start_date`, `end_date`, `census_date`, `is_active`, `meta`

**Required:** `helix_id`, `institution_id`, `period_type`, `code`, `start_date`, `end_date`

**Code sets:** `helix/period-type`

### `Course`
**File:** `core/resources/course.json` · **Classification:** internal · **FERPA education record:** no

A catalog-level course definition. Distinct from CourseSection, which is a specific offering in a term.

**Attributes (14):** `helix_id`, `institution_id`, `subject_code`, `course_number`, `title`, `description`, `credit_hours_min`, `credit_hours_max`, `level`, `academic_org_ref`, `is_active`, `effective_date`, `end_date`, `meta`

**Required:** `helix_id`, `institution_id`, `subject_code`, `course_number`, `title`

**Code sets:** `helix/course-level`

### `CourseSection`
**File:** `core/resources/course_section.json` · **Classification:** internal · **FERPA education record:** no

A specific offering of a course in an academic period — with instructor, schedule, location, and capacity.

**Attributes (24):** `helix_id`, `institution_id`, `course_ref`, `academic_period_ref`, `section_number`, `crn`, `title_override`, `delivery_mode`, `campus`, `building`, `room`, `instructors`, `max_enrollment`, `actual_enrollment`, `waitlist_capacity`, `credit_hours`, `section_status`, `schedule`, `meta`, `fees`, `cross_listed_sections`, `final_exam_date`, `syllabus_url`, `academic_org_ref`

**Required:** `helix_id`, `institution_id`, `course_ref`, `academic_period_ref`, `section_number`

**Code sets:** `helix/delivery-mode`

### `Program`
**File:** `core/resources/program.json` · **Classification:** internal · **FERPA education record:** no

An academic program — degree, certificate, or credential track that a student pursues.

**Attributes (18):** `helix_id`, `institution_id`, `code`, `name`, `degree_type`, `degree_level`, `program_type`, `cip_code`, `academic_org_ref`, `total_credit_hours_required`, `is_active`, `accreditation_body`, `meta`, `delivery_mode`, `program_length_terms`, `admission_selectivity`, `stackable_credentials`, `gainful_employment_flag`

**Required:** `helix_id`, `institution_id`, `name`, `program_type`, `degree_level`

**Code sets:** `helix/degree-level`, `helix/delivery-mode`

## Enrollment & Registration

### `AcademicTermRecord`
**File:** `core/resources/academic_term_record.json` · **Classification:** confidential · **FERPA education record:** yes

A student's academic summary for a single academic period: term GPA, cumulative GPA, units attempted/earned, academic standing, and enrollment status. One record per student per period.

**Attributes (17):** `helix_id`, `student_ref`, `period_ref`, `enrollment_status`, `academic_level`, `units_attempted`, `units_earned`, `units_passed`, `quality_points`, `term_gpa`, `cumulative_gpa`, `cumulative_units_earned`, `cumulative_units_attempted`, `academic_standing`, `dean_list`, `academic_load`, `meta`

**Required:** `helix_id`, `student_ref`, `period_ref`

### `AdmissionApplication`
**File:** `core/resources/admission_application.json` · **Classification:** confidential · **FERPA education record:** yes

An application for admission to the institution. Tracks the applicant's journey from submission through decision and enrollment intent.

**Attributes (20):** `helix_id`, `student_ref`, `institution_id`, `application_number`, `application_type`, `admit_period_ref`, `program_ref`, `application_status`, `decision_date`, `enrollment_deposit_paid`, `enrollment_deposit_date`, `enrollment_intent`, `submitted_date`, `application_source`, `high_school_gpa`, `transfer_gpa`, `test_scores`, `residency_at_application`, `first_generation_flag`, `meta`

**Required:** `helix_id`, `student_ref`, `institution_id`, `application_type`, `application_status`, `admit_period_ref`

**Code sets:** `helix/admission-status`

### `DegreeAudit`
**File:** `core/resources/degree_audit.json` · **Classification:** confidential · **FERPA education record:** yes

A point-in-time evaluation of a student's progress toward completing their program requirements. Links courses taken to requirements satisfied.

**Attributes (20):** `helix_id`, `student_ref`, `program_ref`, `catalog_year`, `audit_date`, `overall_status`, `completion_percentage`, `total_requirements`, `satisfied_count`, `in_progress_count`, `unsatisfied_count`, `units_required`, `units_completed`, `units_in_progress`, `units_remaining`, `gpa_required`, `gpa_current`, `projected_completion_date`, `requirements`, `meta`

**Required:** `helix_id`, `student_ref`, `program_ref`, `audit_date`

### `Enrollment`
**File:** `core/resources/enrollment.json` · **Classification:** confidential · **FERPA education record:** yes

A student's registration in a specific course section during an academic period.

**Attributes (20):** `helix_id`, `student_ref`, `course_section_ref`, `academic_period_ref`, `enrollment_status`, `enrollment_date`, `drop_date`, `credit_hours_attempted`, `credit_hours_earned`, `grade`, `grade_points`, `grade_mode`, `repeat_flag`, `meta`, `midterm_grade`, `last_attendance_date`, `attendance_verified`, `final_exam_grade`, `instructional_method`, `billing_hours`

**Required:** `helix_id`, `student_ref`, `course_section_ref`, `academic_period_ref`, `enrollment_status`

**Code sets:** `helix/enrollment-status`, `helix/grade-mode`

### `FERPARestriction`
**File:** `core/resources/ferpa_restriction.json` · **Classification:** confidential · **FERPA education record:** yes

A student's FERPA directory information restriction. When active, directory information must be withheld from any disclosure not covered by a FERPA exception. Every downstream consumer of HELIX student data MUST check this resource before disclosing directory information.

**Attributes (10):** `helix_id`, `student_ref`, `restriction_type`, `restricted_categories`, `restrict_directory`, `effective_date`, `end_date`, `is_active`, `requested_date`, `meta`

**Required:** `helix_id`, `student_ref`, `restriction_type`, `is_active`

### `InternationalStudent`
**File:** `core/resources/international_student.json` · **Classification:** restricted · **FERPA education record:** yes

Immigration and visa data for a non-citizen student. Covers F-1, J-1, M-1 visa holders, SEVIS tracking, I-20/DS-2019 program dates, and work authorization (CPT/OPT). Classified as restricted due to immigration data sensitivity.

**Attributes (19):** `helix_id`, `student_ref`, `country_of_citizenship`, `country_of_birth`, `visa_type`, `visa_status`, `visa_issue_date`, `visa_expiry_date`, `sevis_id`, `sevis_status`, `i20_program_start_date`, `i20_program_end_date`, `work_authorization`, `work_auth_start_date`, `work_auth_end_date`, `english_proficiency_test`, `english_proficiency_score`, `sponsor`, `meta`

**Required:** `helix_id`, `student_ref`, `country_of_citizenship`, `visa_type`

### `StudentGroup`
**File:** `core/resources/student_group.json` · **Classification:** confidential · **FERPA education record:** yes

A student's membership in an institutional group or cohort. Used for population management, IPEDS cohort tracking, targeted communications, and service delivery. Examples: student athletes, honors students, first-generation, veterans, TRIO participants.

**Attributes (12):** `helix_id`, `student_ref`, `group_code`, `group_name`, `group_category`, `start_date`, `end_date`, `is_active`, `ipeds_cohort_id`, `sport_code`, `scholarship_ref`, `meta`

**Required:** `helix_id`, `student_ref`, `group_code`

### `StudentProgram`
**File:** `core/resources/student_program.json` · **Classification:** confidential · **FERPA education record:** yes

A student's enrollment in an academic program (major, minor, concentration, certificate). A student may have multiple active program enrollments simultaneously (e.g., double major, major + minor).

**Attributes (17):** `helix_id`, `student_ref`, `program_ref`, `academic_level`, `program_status`, `is_primary`, `start_period_ref`, `expected_completion_period_ref`, `actual_completion_date`, `catalog_year`, `advisor_name`, `advisor_ref`, `class_standing`, `cumulative_gpa`, `total_credits_earned`, `total_credits_attempted`, `meta`

**Required:** `helix_id`, `student_ref`, `program_ref`, `program_status`, `start_period_ref`

### `TransferCredit`
**File:** `core/resources/transfer_credit.json` · **Classification:** confidential · **FERPA education record:** yes

Credit earned at another institution and accepted for transfer. Links the external course to the equivalent internal course and tracks how the credit applies.

**Attributes (21):** `helix_id`, `student_ref`, `institution_id`, `source_institution_name`, `source_institution_id`, `source_course_subject`, `source_course_number`, `source_course_title`, `source_credit_hours`, `source_grade`, `source_term`, `equivalent_course_ref`, `equivalent_subject`, `equivalent_course_number`, `credit_hours_accepted`, `transfer_status`, `applies_to`, `evaluation_date`, `evaluated_by`, `counts_toward_gpa`, `meta`

**Required:** `helix_id`, `student_ref`, `institution_id`, `transfer_status`

## Financial Aid

### `AidApplication`
**File:** `core/resources/aid_application.json` · **Classification:** restricted · **FERPA education record:** yes

The FAFSA/ISIR (or institutional aid) application record for a student for a given aid year. Carries the Student Aid Index (SAI) that replaced EFC under FAFSA Simplification (2024-25), dependency status, Pell eligibility, verification selection, and NSLDS match flags. GLBA-covered customer information; classified restricted.

**Attributes (27):** `helix_id`, `student_ref`, `academic_year`, `application_type`, `aid_application_status`, `submission_date`, `sai`, `efc_legacy`, `dependency_status`, `dependency_override_flag`, `pell_eligible_flag`, `pell_lifetime_eligibility_used`, `verification_selected_flag`, `verification_tracking_group`, `isir_transaction_number`, `isir_received_date`, `comment_codes`, `c_flags`, `nslds_match_flags`, `professional_judgment_flag`, `expected_enrollment_status`, `citizenship_status`, `sar_received_flag`, `fafsa_signature_flag`, `homeless_youth_flag`, `foster_care_flag`, `meta`

**Required:** `helix_id`, `student_ref`, `academic_year`, `application_type`, `aid_application_status`

**Code sets:** `helix/aid-application-status`, `helix/dependency-status`

### `AidPackage`
**File:** `core/resources/aid_package.json` · **Classification:** restricted · **FERPA education record:** yes

Need analysis and packaging for a student for an aid year/period: full Cost of Attendance (COA) components, computed need, offered aid totals, unmet need, and professional judgment adjustments. GLBA-covered; classified restricted.

**Attributes (27):** `helix_id`, `student_ref`, `aid_application_ref`, `academic_year`, `academic_period_ref`, `cost_of_attendance_total`, `coa_tuition_fees`, `coa_room_board`, `coa_books_supplies`, `coa_transportation`, `coa_personal`, `coa_loan_fees`, `coa_other`, `sai`, `need`, `total_aid_offered`, `total_grant_aid`, `total_self_help`, `unmet_need`, `packaging_status`, `packaging_date`, `professional_judgment_applied_flag`, `pj_reason`, `pj_adjustment_amount`, `cost_of_attendance_adjusted_flag`, `enrollment_intensity_assumed`, `meta`

**Required:** `helix_id`, `student_ref`, `academic_year`, `packaging_status`

### `Disbursement`
**File:** `core/resources/disbursement.json` · **Classification:** restricted · **FERPA education record:** yes

An actual disbursement of a financial aid award to a student account for a term: scheduled vs actual dates, gross/net amounts, holds, refunds, and COD reporting status. Distinct from the FinAidAward offer. GLBA-covered; classified restricted.

**Attributes (24):** `helix_id`, `student_ref`, `fin_aid_award_ref`, `academic_period_ref`, `academic_year`, `fund_name`, `fund_code`, `disbursement_status`, `scheduled_date`, `actual_disbursement_date`, `gross_amount`, `net_amount`, `fees_deducted`, `disbursement_number`, `disbursement_sequence`, `hold_flag`, `hold_reason`, `refund_generated_flag`, `refund_amount`, `refund_date`, `cod_reported_flag`, `cod_response_date`, `ledger_posted_flag`, `meta`

**Required:** `helix_id`, `student_ref`, `fin_aid_award_ref`, `disbursement_status`

**Code sets:** `helix/disbursement-status`

### `FederalAidReport`
**File:** `core/resources/federal_aid_report.json` · **Classification:** confidential · **FERPA education record:** no

An institution-level Title IV reporting artifact (COD, NSLDS enrollment reporting, FISAP, Pell/Direct Loan reconciliation): submission status, record counts, disbursement totals, and reconciliation variance. Aggregate institutional reporting — not a student education record.

**Attributes (21):** `helix_id`, `institution_id`, `academic_year`, `report_type`, `reporting_period_start`, `reporting_period_end`, `submission_date`, `submission_status`, `records_submitted_count`, `records_accepted_count`, `records_rejected_count`, `error_codes`, `total_pell_disbursed`, `total_dl_disbursed`, `total_fseog_disbursed`, `total_fws_disbursed`, `reconciliation_variance`, `reconciliation_status`, `cod_batch_id`, `submitted_by`, `meta`

**Required:** `helix_id`, `institution_id`, `academic_year`, `report_type`

### `FinAidAward`
**File:** `core/resources/fin_aid_award.json` · **Classification:** restricted · **FERPA education record:** yes

A financial aid award offered or disbursed to a student for an academic period.

**Attributes (25):** `helix_id`, `student_ref`, `academic_period_ref`, `award_type`, `fund_source`, `fund_name`, `fund_code`, `award_status`, `amount_offered`, `amount_accepted`, `amount_disbursed`, `currency`, `disbursement_date`, `academic_year`, `need_based_flag`, `merit_based_flag`, `efc`, `meta`, `program_ref`, `renewal_criteria`, `is_renewable`, `award_year_total`, `cost_of_attendance`, `unmet_need`, `satisfactory_academic_progress`

**Required:** `helix_id`, `student_ref`, `academic_period_ref`, `award_type`, `fund_source`, `award_status`

**Code sets:** `helix/award-type`, `helix/fund-source`

### `LoanRecord`
**File:** `core/resources/loan_record.json` · **Classification:** restricted · **FERPA education record:** yes

A Direct Loan, Perkins, or other education loan originated for a student: type, status, loan period, MPN and counseling status, amounts, rate, and COD/servicer linkage. GLBA-covered; classified restricted.

**Attributes (27):** `helix_id`, `student_ref`, `academic_year`, `loan_type`, `loan_status`, `loan_period_start`, `loan_period_end`, `mpn_flag`, `mpn_date`, `mpn_expiration_date`, `entrance_counseling_flag`, `entrance_counseling_date`, `exit_counseling_flag`, `exit_counseling_date`, `gross_loan_amount`, `net_loan_amount`, `origination_fee`, `interest_rate`, `subsidized_flag`, `loan_disbursement_count`, `cod_loan_id`, `servicer_name`, `grade_level`, `dependency_at_origination`, `aggregate_loan_limit_check_flag`, `annual_loan_limit_check_flag`, `meta`

**Required:** `helix_id`, `student_ref`, `academic_year`, `loan_type`, `loan_status`

**Code sets:** `helix/loan-status`, `helix/loan-type`

### `ReturnOfTitleIV`
**File:** `core/resources/return_of_title_iv.json` · **Classification:** restricted · **FERPA education record:** yes

A Return of Title IV (R2T4) calculation when a student withdraws, per 34 CFR 668.22: percent enrolled/earned, earned vs unearned aid, amounts returned by school and student, and any post-withdrawal disbursement. GLBA-covered; classified restricted.

**Attributes (24):** `helix_id`, `student_ref`, `academic_period_ref`, `academic_year`, `withdrawal_date`, `withdrawal_type`, `determination_date`, `percent_enrolled`, `percent_title_iv_earned`, `title_iv_disbursed_amount`, `title_iv_could_have_disbursed`, `title_iv_earned_amount`, `title_iv_unearned_amount`, `amount_returned_by_school`, `amount_returned_by_student`, `post_withdrawal_disbursement_flag`, `pwd_amount`, `pwd_offered_date`, `pwd_accepted_flag`, `return_calculation_date`, `return_deadline_date`, `institutional_charges`, `r2t4_status`, `meta`

**Required:** `helix_id`, `student_ref`, `academic_period_ref`, `withdrawal_date`, `r2t4_status`

**Code sets:** `helix/r2t4-status`

### `SAPEvaluation`
**File:** `core/resources/sap_evaluation.json` · **Classification:** confidential · **FERPA education record:** yes

A Satisfactory Academic Progress evaluation for a student for a term/aid year per 34 CFR 668.34: qualitative (GPA) and quantitative (pace) measures, max-timeframe (150% rule) usage, and the appeal/academic-plan lifecycle. Classified confidential (FERPA education record).

**Attributes (21):** `helix_id`, `student_ref`, `academic_period_ref`, `academic_year`, `evaluation_date`, `sap_status`, `quantitative_measure_pace`, `qualitative_measure_gpa`, `max_timeframe_pct`, `credits_attempted_cumulative`, `credits_completed_cumulative`, `appeal_filed_flag`, `appeal_date`, `appeal_status`, `appeal_reason`, `academic_plan_flag`, `academic_plan_terms`, `financial_aid_warning_flag`, `financial_aid_suspension_flag`, `probation_flag`, `meta`

**Required:** `helix_id`, `student_ref`, `evaluation_date`, `sap_status`

**Code sets:** `helix/sap-status`

### `StudentEmployment`
**File:** `core/resources/student_employment.json` · **Classification:** confidential · **FERPA education record:** yes

Federal Work-Study (FWS) or other student employment for an aid year: award, earnings tracking, community-service participation, job placement, and federal/institutional cost share. FWS/FISAP context. Classified confidential (FERPA education record).

**Attributes (22):** `helix_id`, `student_ref`, `academic_year`, `employment_type`, `fws_award_amount`, `fws_earnings_to_date`, `fws_remaining`, `community_service_flag`, `community_service_percent`, `job_title`, `employer_department`, `supervisor_ref`, `hourly_rate`, `hours_per_week_max`, `position_start_date`, `position_end_date`, `earnings_ytd`, `federal_share_percent`, `institutional_share_percent`, `off_campus_flag`, `job_placement_status`, `meta`

**Required:** `helix_id`, `student_ref`, `academic_year`, `employment_type`

**Code sets:** `helix/employment-type-aid`

### `Verification`
**File:** `core/resources/verification.json` · **Classification:** restricted · **FERPA education record:** yes

Tracks the FAFSA verification lifecycle for a student/aid year per 34 CFR 668.51-.61: tracking group, required/received documents, conflicting-information resolution, and the SAI change resulting from verification. GLBA-covered; classified restricted.

**Attributes (20):** `helix_id`, `student_ref`, `aid_application_ref`, `academic_year`, `verification_tracking_group`, `verification_status`, `selected_date`, `documents_required`, `documents_received`, `documents_outstanding`, `completion_date`, `conflicting_information_flag`, `conflicting_info_resolution`, `sai_before_verification`, `sai_after_verification`, `sai_change_amount`, `isir_correction_required_flag`, `correction_transaction_number`, `verification_outcome`, `meta`

**Required:** `helix_id`, `student_ref`, `academic_year`, `verification_status`

**Code sets:** `helix/verification-status`

## Outcomes

### `AlumniProfile`
**File:** `core/resources/alumni_profile.json` · **Classification:** confidential · **FERPA education record:** no

An outcomes- and career-focused profile of an alumnus. This resource is DISTINCT from the Advancement Constituent resource: Constituent is giving/advancement-focused (donor segment, giving capacity, prospect stage), while AlumniProfile is career/engagement-focused (employer, career progression, mentoring, career services). The two are cross-linked via constituent_ref for the same person and MUST NOT duplicate giving data — refer to the Constituent record for all philanthropy/solicitation attributes. Post-graduation alumni career data is generally NOT a FERPA education record once the person is an alumnus and the data is independently collected.

**Attributes (25):** `helix_id`, `person_ref`, `student_ref`, `constituent_ref`, `primary_degree_ref`, `graduation_year`, `current_employer`, `current_job_title`, `current_industry`, `current_location_city`, `current_location_state`, `current_location_country`, `career_level`, `industry_sector`, `linkedin_url`, `professional_certifications`, `career_progression_notes`, `mentor_flag`, `volunteer_flag`, `event_attendance_count`, `last_engagement_date`, `alumni_association_member_flag`, `geographic_chapter`, `career_services_opt_in_flag`, `meta`

**Required:** `helix_id`, `person_ref`

### `AwardHonor`
**File:** `core/resources/award_honor.json` · **Classification:** confidential · **FERPA education record:** yes

An honor, award, or distinction received by a student: Latin honors, dean's/president's list, departmental and institutional awards, national recognition, scholarships won, and honor-society memberships. NOTE: Honors and awards received are commonly designated as directory information under 34 CFR 99.3 and may be disclosable without consent unless the student has a directory-information restriction — see meta.ferpa_flags and the 'honors' category in restricted_categories.

**Attributes (20):** `helix_id`, `student_ref`, `person_ref`, `degree_ref`, `academic_period_ref`, `honor_type`, `honor_name`, `awarding_body`, `award_date`, `academic_year`, `description`, `latin_honors_designation`, `gpa_at_award`, `monetary_value`, `scholarship_flag`, `deans_list_flag`, `presidents_list_flag`, `departmental_flag`, `national_recognition_flag`, `meta`

**Required:** `helix_id`, `student_ref`, `honor_type`

**Code sets:** `helix/honor-type`

### `ContinuingEducation`
**File:** `core/resources/continuing_education.json` · **Classification:** confidential · **FERPA education record:** yes

A graduate/professional continuing-education outcome for a graduate: enrollment in further study (master's, doctoral, professional school, second bachelor's, etc.) following completion of a program. Aligned with NACE First-Destination Standards, which count continuing education as a positive career outcome.

**Attributes (18):** `helix_id`, `student_ref`, `person_ref`, `degree_ref`, `academic_year_graduated`, `continuing_ed_level`, `institution_name`, `institution_ipeds_id`, `program_name`, `field_of_study`, `cip_code`, `enrollment_status`, `start_date`, `expected_completion_date`, `funding_type`, `outcome_date`, `data_collection_method`, `meta`

**Required:** `helix_id`, `student_ref`, `continuing_ed_level`

**Code sets:** `helix/continuing-ed-level`

### `Degree`
**File:** `core/resources/degree.json` · **Classification:** confidential · **FERPA education record:** yes

A degree, certificate, or credential conferred upon a student.

**Attributes (23):** `helix_id`, `student_ref`, `institution_id`, `program_ref`, `degree_type`, `degree_level`, `major`, `minor`, `concentration`, `conferral_date`, `conferral_period_ref`, `honors`, `cumulative_gpa`, `total_credit_hours_earned`, `thesis_title`, `meta`, `second_major`, `additional_minors`, `certifications`, `time_to_degree_terms`, `total_transfer_credits_applied`, `commencement_participation`, `degree_status`

**Required:** `helix_id`, `student_ref`, `institution_id`, `program_ref`, `conferral_date`

**Code sets:** `helix/degree-level`

### `EmploymentOutcome`
**File:** `core/resources/employment_outcome.json` · **Classification:** confidential · **FERPA education record:** yes

A first-destination or ongoing employment outcome for a graduate. Aligned with the NACE (National Association of Colleges and Employers) First-Destination Survey Standards, which define the standard for reporting career outcomes of graduating classes. Captures where and how a graduate is employed, salary, and relationship to the field of study. First-destination data is typically collected at or within six months of graduation.

**Attributes (26):** `helix_id`, `student_ref`, `person_ref`, `degree_ref`, `academic_year_graduated`, `outcome_type`, `outcome_date`, `employer_name`, `employer_industry`, `job_title`, `employment_relation_to_major`, `employment_type`, `salary_amount`, `salary_currency`, `salary_source`, `signing_bonus`, `employment_location_city`, `employment_location_state`, `employment_location_country`, `time_to_hire_days`, `hired_before_graduation_flag`, `continuing_education_flag`, `data_collection_method`, `data_collection_date`, `knowledge_source`, `meta`

**Required:** `helix_id`, `student_ref`, `outcome_type`

**Code sets:** `helix/employment-relation`, `helix/first-destination-status`

### `ExperientialLearning`
**File:** `core/resources/experiential_learning.json` · **Classification:** confidential · **FERPA education record:** yes

An experiential learning activity: internship, co-op, practicum, clinical rotation, student teaching, undergraduate research, service learning, field experience, or capstone. These are recognized High-Impact Practices (HIPs) per NSSE (National Survey of Student Engagement) and are increasingly tracked as part of student success and career-readiness outcomes.

**Attributes (26):** `helix_id`, `student_ref`, `academic_period_ref`, `experiential_type`, `title`, `organization_name`, `organization_industry`, `supervisor_name`, `supervisor_contact`, `start_date`, `end_date`, `hours_completed`, `credit_bearing_flag`, `credit_hours`, `course_ref`, `paid_flag`, `compensation_amount`, `location_city`, `location_state`, `location_country`, `learning_objectives`, `evaluation_completed_flag`, `evaluation_rating`, `reflection_completed_flag`, `high_impact_practice_flag`, `meta`

**Required:** `helix_id`, `student_ref`, `experiential_type`

**Code sets:** `helix/experiential-type`

### `FirstDestinationSurvey`
**File:** `core/resources/first_destination_survey.json` · **Classification:** confidential · **FERPA education record:** yes

A record of the NACE-standard First-Destination Survey instrument administered to a graduate. NACE defines a standard methodology: outcomes measured at six months post-graduation, with a reported 'knowledge rate' (the percentage of graduates for whom the institution has reasonable and verifiable outcome information). This resource tracks the survey lifecycle and the resulting outcome status.

**Attributes (21):** `helix_id`, `student_ref`, `person_ref`, `degree_ref`, `academic_year_graduated`, `survey_cohort`, `survey_status`, `outcome_status`, `survey_sent_date`, `survey_completed_date`, `response_method`, `knowledge_rate_included_flag`, `months_since_graduation`, `primary_outcome`, `seeking_employment_flag`, `seeking_continuing_ed_flag`, `not_seeking_flag`, `military_service_flag`, `volunteer_service_flag`, `data_source_verified_flag`, `meta`

**Required:** `helix_id`, `student_ref`, `survey_status`

**Code sets:** `helix/first-destination-status`, `helix/survey-status`

### `LearningOutcome`
**File:** `core/resources/learning_outcome.json` · **Classification:** confidential · **FERPA education record:** yes

A program-, course-, or institution-level learning outcome assessment result for a student. Supports institutional effectiveness and accreditation (regional and programmatic) assessment reporting: measuring attainment of Program Learning Outcomes (PLOs), general-education competencies, and professional competencies via direct and indirect assessment methods.

**Attributes (20):** `helix_id`, `student_ref`, `program_ref`, `course_ref`, `academic_period_ref`, `outcome_type`, `outcome_statement`, `competency_name`, `competency_framework`, `assessment_method`, `assessment_date`, `achievement_level`, `score`, `max_score`, `met_expectations_flag`, `assessment_instrument`, `assessor_ref`, `plo_reference`, `institutional_outcome_reference`, `meta`

**Required:** `helix_id`, `student_ref`, `outcome_type`

**Code sets:** `helix/achievement-level`, `helix/outcome-type`

### `Licensure`
**File:** `core/resources/licensure.json` · **Classification:** confidential · **FERPA education record:** yes

A professional licensure or certification exam outcome (e.g., NCLEX for nursing, CPA, bar exam, Praxis for teaching, USMLE for medicine). Licensure pass rates are a core programmatic accreditation reporting requirement for many professional programs and a key student outcome metric.

**Attributes (22):** `helix_id`, `student_ref`, `person_ref`, `degree_ref`, `program_ref`, `licensure_type`, `exam_name`, `credential_name`, `licensing_body`, `exam_date`, `licensure_result`, `score`, `passing_score`, `scaled_score`, `attempt_number`, `first_time_pass_flag`, `license_number`, `license_issue_date`, `license_expiration_date`, `license_state`, `program_pass_rate_cohort`, `meta`

**Required:** `helix_id`, `student_ref`, `licensure_type`, `licensure_result`

**Code sets:** `helix/licensure-result`, `helix/licensure-type`

## Student Services

### `Hold`
**File:** `core/resources/hold.json` · **Classification:** confidential · **FERPA education record:** yes

A restriction placed on a student's record that prevents specific actions (registration, transcript release, graduation, etc.) until resolved.

**Attributes (14):** `helix_id`, `student_ref`, `hold_type`, `hold_status`, `reason`, `hold_code`, `placed_date`, `released_date`, `expiration_date`, `placed_by_office`, `prevents`, `amount_owed`, `currency`, `meta`

**Required:** `helix_id`, `student_ref`, `hold_type`, `hold_status`

**Code sets:** `helix/hold-type`

## Advancement

### `Campaign`
**File:** `core/resources/campaign.json` · **Classification:** internal · **FERPA education record:** no

A fundraising campaign with goals, timelines, and progress tracking. May be a comprehensive campaign, annual fund, giving day, or targeted initiative.

**Attributes (13):** `helix_id`, `institution_id`, `name`, `campaign_type`, `goal_amount`, `raised_amount`, `donor_count`, `gift_count`, `start_date`, `end_date`, `status`, `priorities`, `meta`

**Required:** `helix_id`, `institution_id`, `name`, `campaign_type`, `goal_amount`, `start_date`

### `Constituent`
**File:** `core/resources/constituent.json` · **Classification:** confidential · **FERPA education record:** no

A person or organization with a relationship to the institution for advancement purposes: alumni, donors, parents, friends, corporate partners, foundations. Extends Person with advancement-specific attributes.

**Attributes (25):** `helix_id`, `institution_id`, `person_ref`, `student_ref`, `constituent_type`, `status`, `class_year`, `degrees`, `affinity_groups`, `giving_capacity`, `lifetime_giving`, `last_gift_date`, `last_gift_amount`, `consecutive_giving_years`, `largest_gift_amount`, `donor_segment`, `engagement_score`, `solicitation_codes`, `assigned_officer`, `prospect_stage`, `employer`, `job_title`, `industry`, `communication_preferences`, `meta`

**Required:** `helix_id`, `institution_id`, `constituent_type`, `status`

**Code sets:** `helix/constituent-type`, `helix/donor-segment`, `helix/prospect-stage`

### `EngagementActivity`
**File:** `core/resources/engagement_activity.json` · **Classification:** internal · **FERPA education record:** no

A trackable interaction between a constituent and the institution: event attendance, email engagement, volunteer activity, social media interaction, campus visit, or meeting with a development officer.

**Attributes (13):** `helix_id`, `constituent_ref`, `activity_type`, `activity_date`, `event_name`, `event_type`, `channel`, `location`, `notes`, `engagement_points`, `linked_gift_ref`, `officer_ref`, `meta`

**Required:** `helix_id`, `constituent_ref`, `activity_type`, `activity_date`

### `Gift`
**File:** `core/resources/gift.json` · **Classification:** confidential · **FERPA education record:** no

A philanthropic transaction: gift, pledge, pledge payment, matching gift, planned gift, or in-kind donation to the institution.

**Attributes (25):** `helix_id`, `institution_id`, `constituent_ref`, `gift_number`, `gift_type`, `amount`, `currency`, `gift_date`, `receipt_date`, `designation`, `campaign_ref`, `appeal_code`, `gift_source`, `payment_method`, `pledge_ref`, `pledge_balance`, `matching_company`, `matching_ratio`, `tax_deductible_amount`, `anonymous_flag`, `soft_credit_constituents`, `acknowledgment_status`, `acknowledgment_date`, `stewardship_actions`, `meta`

**Required:** `helix_id`, `institution_id`, `constituent_ref`, `gift_type`, `amount`, `gift_date`

**Code sets:** `helix/gift-type`

## Financial Operations

### `APVoucher`
**File:** `core/resources/ap_voucher.json` · **Classification:** internal · **FERPA education record:** no

An accounts payable voucher — a supplier invoice approved for payment. Carries vendor, invoice, amount, payment, and worktag/chartfield distribution.

**Attributes (18):** `helix_id`, `voucher_id`, `business_unit`, `vendor_id`, `vendor_name`, `invoice_number`, `invoice_date`, `gross_amount`, `voucher_status`, `payment_date`, `payment_method`, `line_account`, `line_fund`, `line_department`, `line_amount`, `spend_category`, `po_reference`, `meta`

**Required:** `helix_id`, `voucher_id`

**Code sets:** `helix/payment-status`

### `ARTransaction`
**File:** `core/resources/ar_transaction.json` · **Classification:** confidential · **FERPA education record:** no

An accounts receivable / student financials transaction — a charge, payment, or refund on a student account. FERPA/GLBA-relevant when linked to a student and financial aid.

**Attributes (18):** `helix_id`, `transaction_id`, `student_ref`, `transaction_type`, `charge_code`, `description`, `amount`, `currency`, `transaction_date`, `due_date`, `term_ref`, `payment_method`, `invoice_status`, `balance_due`, `fund_code`, `department`, `third_party_ref`, `meta`

**Required:** `helix_id`, `transaction_id`

### `Asset`
**File:** `core/resources/asset.json` · **Classification:** internal · **FERPA education record:** no

A capital asset — land, buildings, equipment, software. Carries acquisition cost, depreciation, location, custodian, and grant funding source.

**Attributes (19):** `helix_id`, `asset_id`, `description`, `asset_category`, `acquisition_date`, `acquisition_cost`, `useful_life_months`, `salvage_value`, `depreciation_method`, `accumulated_depreciation`, `net_book_value`, `location_building`, `location_room`, `custodian`, `department`, `fund_code`, `grant_ref`, `status`, `meta`

**Required:** `helix_id`, `asset_id`

**Code sets:** `helix/asset-category`, `helix/asset-status`

### `Budget`
**File:** `core/resources/budget.json` · **Classification:** internal · **FERPA education record:** no

A budget line — planned, encumbered, expended, and available amounts by account/fund/department for a fiscal year.

**Attributes (13):** `helix_id`, `budget_id`, `business_unit`, `fiscal_year`, `account`, `fund_code`, `department`, `budget_amount`, `encumbered`, `expended`, `available_balance`, `budget_status`, `meta`

**Required:** `helix_id`, `budget_id`

**Code sets:** `helix/budget-status`

### `Contract`
**File:** `core/resources/contract.json` · **Classification:** internal · **FERPA education record:** no

A supplier contract — blanket POs, rate contracts, service agreements. Carries term, value, spend-to-date, and owner.

**Attributes (15):** `helix_id`, `contract_id`, `contract_name`, `vendor_id`, `vendor_name`, `contract_type`, `start_date`, `end_date`, `total_value`, `amount_spent`, `contract_status`, `owner`, `department`, `fund_code`, `meta`

**Required:** `helix_id`, `contract_id`

**Code sets:** `helix/contract-status`

### `ExpenseReport`
**File:** `core/resources/expense_report.json` · **Classification:** internal · **FERPA education record:** no

An employee expense report — travel and reimbursable expenses with line detail and worktag/chartfield distribution.

**Attributes (15):** `helix_id`, `report_id`, `employee_ref`, `report_date`, `purpose`, `total_amount`, `report_status`, `expense_type`, `line_amount`, `line_date`, `account`, `fund_code`, `department`, `grant_ref`, `meta`

**Required:** `helix_id`, `employee_ref`

**Code sets:** `helix/expense-status`

### `FinancialOrg`
**File:** `core/resources/financial_org.json` · **Classification:** internal · **FERPA education record:** no

A financial organization unit — the cost center / department in the financial dimension (Workday Cost Center, PeopleSoft DeptID). Distinct from AcademicOrg, though the two often align. Used for financial reporting and budget ownership.

**Attributes (10):** `helix_id`, `org_code`, `org_name`, `org_type`, `parent_org`, `company`, `manager`, `is_active`, `fund_type`, `meta`

**Required:** `helix_id`, `org_code`

**Code sets:** `helix/fund-type`

### `Fund`
**File:** `core/resources/fund.json` · **Classification:** internal · **FERPA education record:** no

A fund — the fund-accounting dimension (GASB for public institutions, FASB ASU 2016-14 restriction classes for private). Normalizes GASB and FASB conventions into one taxonomy.

**Attributes (9):** `helix_id`, `fund_code`, `fund_name`, `fund_category`, `restriction_type`, `parent_fund`, `is_active`, `gasb_fund_type`, `meta`

**Required:** `helix_id`, `fund_code`

**Code sets:** `helix/fund-type`

### `GLTransaction`
**File:** `core/resources/gl_transaction.json` · **Classification:** internal · **FERPA education record:** no

A general ledger journal transaction — the atomic unit of financial accounting. Carries account, fund, department, program, amount, and ledger coding. Maps from PeopleSoft chartfields and Workday worktags.

**Attributes (21):** `helix_id`, `transaction_id`, `business_unit`, `journal_id`, `journal_date`, `fiscal_year`, `accounting_period`, `account`, `account_description`, `account_type`, `fund_code`, `department`, `program_code`, `project_id`, `amount`, `currency`, `description`, `journal_source`, `journal_status`, `ledger`, `meta`

**Required:** `helix_id`, `transaction_id`

**Code sets:** `helix/account-type`, `helix/transaction-type`

### `Grant`
**File:** `core/resources/grant.json` · **Classification:** internal · **FERPA education record:** no

A sponsored program / grant award — the full lifecycle record for research and other externally funded awards. Carries sponsor, PI, CFDA, budget (direct/indirect), F&A rate, and cost sharing. Subject to 2 CFR 200 (Uniform Guidance) for federal awards.

**Attributes (22):** `helix_id`, `grant_id`, `grant_name`, `sponsor_id`, `sponsor_name`, `sponsor_type`, `sponsor_award_number`, `cfda_number`, `principal_investigator`, `project_start_date`, `project_end_date`, `total_award_amount`, `total_budget`, `direct_costs_budget`, `indirect_costs_budget`, `idc_rate`, `cost_sharing_amount`, `grant_status`, `billing_type`, `department`, `fund_code`, `meta`

**Required:** `helix_id`, `grant_id`

**Code sets:** `helix/grant-status`

### `PurchaseOrder`
**File:** `core/resources/purchase_order.json` · **Classification:** internal · **FERPA education record:** no

A purchase order — a commitment to a supplier for goods or services. Carries lines, spend category, and worktag/chartfield distribution.

**Attributes (20):** `helix_id`, `po_id`, `business_unit`, `vendor_id`, `vendor_name`, `po_date`, `po_status`, `total_amount`, `line_description`, `line_quantity`, `line_unit_price`, `line_amount`, `spend_category`, `line_account`, `line_fund`, `line_department`, `requisition_ref`, `contract_ref`, `buyer`, `meta`

**Required:** `helix_id`, `po_id`

**Code sets:** `helix/purchase-order-status`

## Human Resources

### `AbsenceRecord`
**File:** `core/resources/absence_record.json` · **Classification:** confidential · **FERPA education record:** no

An absence / leave record — vacation, sick, FMLA, sabbatical, etc., with balances and FMLA tracking. FMLA medical certification stored separately with restricted access.

**Attributes (12):** `helix_id`, `employee_ref`, `absence_type`, `start_date`, `end_date`, `hours_requested`, `fmla_qualifying`, `fmla_hours_used`, `status`, `balance_vacation`, `balance_sick`, `meta`

**Required:** `helix_id`, `employee_ref`

**Code sets:** `helix/absence-type`

### `BenefitEnrollment`
**File:** `core/resources/benefit_enrollment.json` · **Classification:** restricted · **FERPA education record:** no

A benefit enrollment — an employee's election in a benefit plan (medical, dental, retirement, tuition waiver, etc.) with coverage level and contributions. Restricted; dependent PII tokenized.

**Attributes (13):** `helix_id`, `employee_ref`, `plan_name`, `plan_type`, `coverage_level`, `enrollment_date`, `termination_date`, `employee_contribution`, `employer_contribution`, `retirement_contribution_pct`, `employer_match_pct`, `dependent_count`, `meta`

**Required:** `helix_id`, `employee_ref`

**Code sets:** `helix/benefit-plan-type`

### `Compensation`
**File:** `core/resources/compensation.json` · **Classification:** restricted · **FERPA education record:** no

An employee compensation record — base pay, rate, grade/step, and compa-ratio. Restricted: individual pay data accessible only to HR and leadership.

**Attributes (15):** `helix_id`, `employee_ref`, `base_pay`, `pay_rate`, `pay_rate_type`, `currency`, `compensation_grade`, `compensation_step`, `grade_minimum`, `grade_midpoint`, `grade_maximum`, `compa_ratio`, `effective_date`, `change_reason`, `meta`

**Required:** `helix_id`, `employee_ref`

**Code sets:** `helix/compensation-type`

### `Employee`
**File:** `core/resources/employee.json` · **Classification:** confidential · **FERPA education record:** no

An employee / worker — the core HR identity. Links to a HELIX Person (a single human may be both Employee and Student). Carries hire/termination, worker type, FTE, FLSA, citizenship/visa, and contact info. SSN/national ID tokenized at silver.

**Attributes (25):** `helix_id`, `employee_id`, `person_ref`, `legal_name`, `preferred_name`, `date_of_birth`, `gender`, `national_id`, `citizenship_status`, `visa_type`, `ethnicity`, `hire_date`, `original_hire_date`, `continuous_service_date`, `termination_date`, `termination_reason`, `worker_type`, `employee_type`, `fte`, `flsa_status`, `primary_work_email`, `primary_work_phone`, `home_address`, `employment_status`, `meta`

**Required:** `helix_id`, `person_ref`

**Code sets:** `helix/employment-status`, `helix/flsa-status`, `helix/worker-type`

### `JobClassification`
**File:** `core/resources/job_classification.json` · **Classification:** internal · **FERPA education record:** no

A job classification — the job profile/code with EEO/SOC classification and, for faculty, academic rank, tenure status, and IPEDS faculty category. Documents the recommended approach for faculty data Workday lacks natively.

**Attributes (15):** `helix_id`, `job_code`, `job_title`, `job_family`, `job_family_group`, `eeo_category`, `soc_code`, `cip_code`, `academic_rank`, `tenure_status`, `tenure_date`, `faculty_status`, `ipeds_faculty_category`, `flsa_status`, `meta`

**Required:** `helix_id`, `job_code`

**Code sets:** `helix/eeo-category`, `helix/faculty-rank`, `helix/flsa-status`, `helix/tenure-status`

### `LearningRecord`
**File:** `core/resources/learning_record.json` · **Classification:** internal · **FERPA education record:** no

A learning record — an employee's enrollment/completion of a training course (compliance, safety, professional development). Completion tracking is audit-sensitive for compliance training.

**Attributes (13):** `helix_id`, `employee_ref`, `course_id`, `course_title`, `course_type`, `delivery_method`, `enrollment_date`, `completion_date`, `status`, `score`, `required`, `due_date`, `meta`

**Required:** `helix_id`, `employee_ref`

**Code sets:** `helix/learning-type`

### `PayrollResult`
**File:** `core/resources/payroll_result.json` · **Classification:** restricted · **FERPA education record:** no

A payroll result — a processed pay statement for one pay period: gross, taxes, deductions, net, and labor distribution across funds/grants. Restricted; contains tax-linked data.

**Attributes (18):** `helix_id`, `employee_ref`, `pay_period_start`, `pay_period_end`, `pay_date`, `gross_pay`, `total_taxes`, `total_deductions`, `net_pay`, `regular_earnings`, `overtime_earnings`, `supplemental_earnings`, `retirement_deduction`, `benefit_deductions`, `cost_center`, `fund_code`, `grant_ref`, `meta`

**Required:** `helix_id`, `employee_ref`

### `PerformanceReview`
**File:** `core/resources/performance_review.json` · **Classification:** restricted · **FERPA education record:** no

A performance review — rating, goals, and 9-box talent placement. Restricted: accessible only to the employee, their management chain, HR, and leadership.

**Attributes (14):** `helix_id`, `employee_ref`, `review_period_start`, `review_period_end`, `overall_rating`, `numeric_rating`, `reviewer`, `review_status`, `goals_count`, `goals_achieved`, `nine_box_performance`, `nine_box_potential`, `flight_risk`, `meta`

**Required:** `helix_id`, `employee_ref`

**Code sets:** `helix/performance-rating`

### `Position`
**File:** `core/resources/position.json` · **Classification:** internal · **FERPA education record:** no

A position — the organizational 'seat' defined independently of who fills it. Carries job profile, supervisory org, compensation grade, EEO category, and funding source. Workday position-management model.

**Attributes (19):** `helix_id`, `position_id`, `position_title`, `job_profile`, `job_family`, `job_level`, `management_level`, `supervisory_org`, `department`, `location`, `compensation_grade`, `worker_type`, `time_type`, `position_status`, `incumbent_ref`, `headcount`, `eeo_job_category`, `fund_code`, `meta`

**Required:** `helix_id`, `position_id`

**Code sets:** `helix/position-status`, `helix/worker-type`

### `PositionBudget`
**File:** `core/resources/position_budget.json` · **Classification:** internal · **FERPA education record:** no

A position budget — funded amount, actuals, variance, and split funding across funds/grants for a position and fiscal year. Captures higher-ed split-funding and backfill patterns.

**Attributes (14):** `helix_id`, `position_ref`, `fiscal_year`, `budgeted_amount`, `actual_spend`, `variance`, `funding_splits`, `primary_fund`, `primary_cost_center`, `department`, `org_headcount_budget`, `org_headcount_actual`, `org_headcount_open`, `meta`

**Required:** `helix_id`, `position_ref`

### `Requisition`
**File:** `core/resources/requisition.json` · **Classification:** confidential · **FERPA education record:** no

A job requisition — a position opening in recruiting, with applicant pipeline, disposition, and EEO data. Candidate PII is confidential; EEO data kept separate from hiring decisions.

**Attributes (16):** `helix_id`, `requisition_id`, `requisition_title`, `job_profile`, `department`, `hiring_manager`, `recruiter`, `target_start_date`, `requisition_status`, `applicant_count`, `candidate_name`, `application_stage`, `application_disposition`, `candidate_source`, `eeo_category`, `meta`

**Required:** `helix_id`, `requisition_id`

**Code sets:** `helix/eeo-category`, `helix/requisition-status`

### `TimeEntry`
**File:** `core/resources/time_entry.json` · **Classification:** confidential · **FERPA education record:** no

A time entry — reported hours for a non-exempt employee or student worker, with worktag/chartfield distribution and approval status.

**Attributes (13):** `helix_id`, `employee_ref`, `date`, `hours`, `time_type`, `in_time`, `out_time`, `cost_center`, `fund_code`, `grant_ref`, `approval_status`, `approver`, `meta`

**Required:** `helix_id`, `employee_ref`

*HELIX v0.9.0, September 2026. Generated from core/resources/.*
