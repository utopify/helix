# HELIX Core: Resource Catalog

**HELIX Core v0.1** defines **15 canonical resources** across 6 domains.

Each resource is a JSON Schema definition that describes a standardized data object any higher education institution can map to, regardless of their ERP system.

## Identity

### `Person`
**File:** `core/resources/person.json`

A human being known to the institution in any capacity — student, employee, applicant, alumnus, donor, or contact. The foundational identity resource. Student, Employee, and other role-specific resources reference a Person.

**Attributes (16):** `helix_id`, `institution_id`, `identifiers`, `name`, `birth_date`, `gender`, `gender_identity`, `pronouns`, `ethnicity`, `citizenship_countries`, `primary_language`, `is_deceased`, `deceased_date`, `contact`, `emergency_contacts`, `meta`

**Required:** `helix_id`, `institution_id`, `identifiers`, `name`

### `Student`
**File:** `core/resources/student.json`

A person in their capacity as a learner at an institution. References a Person resource for base identity. Contains student-specific attributes: status, academic level, GPA, program enrollment, and classification.

**Attributes (27):** `helix_id`, `institution_id`, `identifiers`, `name`, `birth_date`, `gender`, `status`, `first_generation_flag`, `citizenship_country`, `residency`, `demographics`, `meta`, `person_ref`, `student_type`, `academic_level`, `class_standing`, `full_part_time`, `cumulative_gpa`, `total_credits_earned`, `total_credits_attempted`, `admit_period_ref`, `matriculation_date`, `expected_graduation_date`, `primary_program_ref`, `cohort`, `veteran_status`, `international_student`

**Required:** `helix_id`, `institution_id`, `identifiers`, `status`

### `Institution`
**File:** `core/resources/institution.json`

A higher education institution — university, college, community college, or system office.

**Attributes (12):** `helix_id`, `name`, `short_name`, `identifiers`, `institution_type`, `carnegie_classification`, `country`, `state_province`, `timezone`, `erp_system`, `website`, `meta`

**Required:** `helix_id`, `name`, `institution_type`, `country`

## Academic Structure

### `AcademicOrg`
**File:** `core/resources/academic_org.json`

An academic organizational unit within an institution — college, school, division, department, or program area. Forms a hierarchy (university → college → department).

**Attributes (12):** `helix_id`, `institution_id`, `code`, `name`, `short_name`, `org_type`, `parent_org_ref`, `dean_or_chair`, `is_active`, `effective_date`, `end_date`, `meta`

**Required:** `helix_id`, `institution_id`, `name`, `org_type`

### `Course`
**File:** `core/resources/course.json`

A catalog-level course definition. Distinct from CourseSection, which is a specific offering in a term.

**Attributes (14):** `helix_id`, `institution_id`, `subject_code`, `course_number`, `title`, `description`, `credit_hours_min`, `credit_hours_max`, `level`, `academic_org_ref`, `is_active`, `effective_date`, `end_date`, `meta`

**Required:** `helix_id`, `institution_id`, `subject_code`, `course_number`, `title`

### `CourseSection`
**File:** `core/resources/course_section.json`

A specific offering of a course in an academic period — with instructor, schedule, location, and capacity.

**Attributes (24):** `helix_id`, `institution_id`, `course_ref`, `academic_period_ref`, `section_number`, `crn`, `title_override`, `delivery_mode`, `campus`, `building`, `room`, `instructors`, `max_enrollment`, `actual_enrollment`, `waitlist_capacity`, `credit_hours`, `section_status`, `schedule`, `meta`, `fees`, `cross_listed_sections`, `final_exam_date`, `syllabus_url`, `academic_org_ref`

**Required:** `helix_id`, `institution_id`, `course_ref`, `academic_period_ref`, `section_number`

### `Program`
**File:** `core/resources/program.json`

An academic program — degree, certificate, or credential track that a student pursues.

**Attributes (18):** `helix_id`, `institution_id`, `code`, `name`, `degree_type`, `degree_level`, `program_type`, `cip_code`, `academic_org_ref`, `total_credit_hours_required`, `is_active`, `accreditation_body`, `meta`, `delivery_mode`, `program_length_terms`, `admission_selectivity`, `stackable_credentials`, `gainful_employment_flag`

**Required:** `helix_id`, `institution_id`, `name`, `program_type`, `degree_level`

### `AcademicPeriod`
**File:** `core/resources/academic_period.json`

A defined period of academic activity (term, semester, quarter, session).

**Attributes (11):** `helix_id`, `institution_id`, `period_type`, `code`, `name`, `academic_year`, `start_date`, `end_date`, `census_date`, `is_active`, `meta`

**Required:** `helix_id`, `institution_id`, `period_type`, `code`, `start_date`, `end_date`

## Enrollment & Registration

### `Enrollment`
**File:** `core/resources/enrollment.json`

A student's registration in a specific course section during an academic period.

**Attributes (20):** `helix_id`, `student_ref`, `course_section_ref`, `academic_period_ref`, `enrollment_status`, `enrollment_date`, `drop_date`, `credit_hours_attempted`, `credit_hours_earned`, `grade`, `grade_points`, `grade_mode`, `repeat_flag`, `meta`, `midterm_grade`, `last_attendance_date`, `attendance_verified`, `final_exam_grade`, `instructional_method`, `billing_hours`

**Required:** `helix_id`, `student_ref`, `course_section_ref`, `academic_period_ref`, `enrollment_status`

### `StudentProgram`
**File:** `core/resources/student_program.json`

A student's enrollment in an academic program (major, minor, concentration, certificate). A student may have multiple active program enrollments simultaneously (e.g., double major, major + minor).

**Attributes (17):** `helix_id`, `student_ref`, `program_ref`, `academic_level`, `program_status`, `is_primary`, `start_period_ref`, `expected_completion_period_ref`, `actual_completion_date`, `catalog_year`, `advisor_name`, `advisor_ref`, `class_standing`, `cumulative_gpa`, `total_credits_earned`, `total_credits_attempted`, `meta`

**Required:** `helix_id`, `student_ref`, `program_ref`, `program_status`, `start_period_ref`

### `AdmissionApplication`
**File:** `core/resources/admission_application.json`

An application for admission to the institution. Tracks the applicant's journey from submission through decision and enrollment intent.

**Attributes (20):** `helix_id`, `student_ref`, `institution_id`, `application_number`, `application_type`, `admit_period_ref`, `program_ref`, `application_status`, `decision_date`, `enrollment_deposit_paid`, `enrollment_deposit_date`, `enrollment_intent`, `submitted_date`, `application_source`, `high_school_gpa`, `transfer_gpa`, `test_scores`, `residency_at_application`, `first_generation_flag`, `meta`

**Required:** `helix_id`, `student_ref`, `institution_id`, `application_type`, `application_status`, `admit_period_ref`

### `TransferCredit`
**File:** `core/resources/transfer_credit.json`

Credit earned at another institution and accepted for transfer. Links the external course to the equivalent internal course and tracks how the credit applies.

**Attributes (21):** `helix_id`, `student_ref`, `institution_id`, `source_institution_name`, `source_institution_id`, `source_course_subject`, `source_course_number`, `source_course_title`, `source_credit_hours`, `source_grade`, `source_term`, `equivalent_course_ref`, `equivalent_subject`, `equivalent_course_number`, `credit_hours_accepted`, `transfer_status`, `applies_to`, `evaluation_date`, `evaluated_by`, `counts_toward_gpa`, `meta`

**Required:** `helix_id`, `student_ref`, `institution_id`, `transfer_status`

## Financial Aid

### `FinAidAward`
**File:** `core/resources/fin_aid_award.json`

A financial aid award offered or disbursed to a student for an academic period.

**Attributes (25):** `helix_id`, `student_ref`, `academic_period_ref`, `award_type`, `fund_source`, `fund_name`, `fund_code`, `award_status`, `amount_offered`, `amount_accepted`, `amount_disbursed`, `currency`, `disbursement_date`, `academic_year`, `need_based_flag`, `merit_based_flag`, `efc`, `meta`, `program_ref`, `renewal_criteria`, `is_renewable`, `award_year_total`, `cost_of_attendance`, `unmet_need`, `satisfactory_academic_progress`

**Required:** `helix_id`, `student_ref`, `academic_period_ref`, `award_type`, `fund_source`, `award_status`

## Outcomes

### `Degree`
**File:** `core/resources/degree.json`

A degree, certificate, or credential conferred upon a student.

**Attributes (23):** `helix_id`, `student_ref`, `institution_id`, `program_ref`, `degree_type`, `degree_level`, `major`, `minor`, `concentration`, `conferral_date`, `conferral_period_ref`, `honors`, `cumulative_gpa`, `total_credit_hours_earned`, `thesis_title`, `meta`, `second_major`, `additional_minors`, `certifications`, `time_to_degree_terms`, `total_transfer_credits_applied`, `commencement_participation`, `degree_status`

**Required:** `helix_id`, `student_ref`, `institution_id`, `program_ref`, `conferral_date`

## Student Services

### `Hold`
**File:** `core/resources/hold.json`

A restriction placed on a student's record that prevents specific actions (registration, transcript release, graduation, etc.) until resolved.

**Attributes (14):** `helix_id`, `student_ref`, `hold_type`, `hold_status`, `reason`, `hold_code`, `placed_date`, `released_date`, `expiration_date`, `placed_by_office`, `prevents`, `amount_owed`, `currency`, `meta`

**Required:** `helix_id`, `student_ref`, `hold_type`, `hold_status`
