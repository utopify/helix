# HELIX Core: Terminology Catalog

**HELIX Core v0.1** defines **18 terminology code sets** that standardize the values used across resources.

Terminologies eliminate the 'what does this code mean?' problem. When a HELIX resource binds an attribute to a terminology (e.g., `enrollment_status` is bound to `helix/enrollment-status`), every institution uses the same codes with the same definitions.

| Terminology | Code System | Codes | Used By |
|-------------|------------|-------|---------|
| **Admission Status** | `helix/admission-status` | 10 | AdmissionApplication |
| **Financial Aid Award Type** | `helix/award-type` | 11 | FinAidAward |
| **Course Level** | `helix/course-level` | 8 | Course |
| **Data Classification** | `helix/data-classification` | 4 | All resources (meta block) |
| **Degree Level** | `helix/degree-level` | 12 | Program, Degree |
| **Delivery Mode** | `helix/delivery-mode` | 11 | CourseSection, Program |
| **Enrollment Status** | `helix/enrollment-status` | 8 | Enrollment |
| **Ethnicity/Race** | `helix/ethnicity` | 10 | Person |
| **Gender Identity** | `helix/gender-identity` | 10 | Person |
| **Gender** | `helix/gender` | 5 | Person |
| **Grade Mode** | `helix/grade-mode` | 5 | Enrollment |
| **Hold Type** | `helix/hold-type` | 12 | Hold |
| **Identifier Type** | `helix/identifier-type` | 12 | Person, Student |
| **Academic Period Type** | `helix/period-type` | 7 | AcademicPeriod |
| **Satisfactory Academic Progress (SAP) Status** | `helix/sap-status` | 6 | FinAidAward |
| **Student Status** | `helix/student-status` | 8 | Student |
| **Student Type** | `helix/student-type` | 10 | Student |
| **Veteran Status** | `helix/veteran-status` | 6 | Student |

## Full Code Set Details

### Admission Status
**Code system:** `helix/admission-status`  
**File:** `core/terminologies/admission-status.json`

| Code | Display |
|------|---------|
| `submitted` | Submitted |
| `in_review` | In Review |
| `incomplete` | Incomplete |
| `admitted` | Admitted |
| `conditionally_admitted` | Conditionally Admitted |
| `denied` | Denied |
| `waitlisted` | Waitlisted |
| `deferred` | Deferred |
| `cancelled` | Cancelled |
| `withdrawn` | Withdrawn |

### Financial Aid Award Type
**Code system:** `helix/award-type`  
**File:** `core/terminologies/award-type.json`

| Code | Display |
|------|---------|
| `grant` | Grant |
| `scholarship` | Scholarship |
| `loan_subsidized` | Subsidized Loan |
| `loan_unsubsidized` | Unsubsidized Loan |
| `loan_plus` | PLUS Loan |
| `loan_private` | Private Loan |
| `work_study` | Work-Study |
| `waiver` | Tuition Waiver |
| `fellowship` | Fellowship |
| `assistantship` | Assistantship |
| `other` | Other |

### Course Level
**Code system:** `helix/course-level`  
**File:** `core/terminologies/course-level.json`

| Code | Display |
|------|---------|
| `developmental` | Developmental/Remedial |
| `undergraduate_lower` | Undergraduate Lower Division |
| `undergraduate_upper` | Undergraduate Upper Division |
| `graduate` | Graduate |
| `doctoral` | Doctoral |
| `professional` | Professional |
| `non_credit` | Non-Credit |
| `other` | Other |

*Course number ranges (100/200/300/etc.) are a common convention but not universal. Institution-specific number-to-level mappings should be documented in Bridge implementations.*

### Data Classification
**Code system:** `helix/data-classification`  
**File:** `core/terminologies/data-classification.json`

| Code | Display |
|------|---------|
| `public` | Public |
| `internal` | Internal |
| `confidential` | Confidential |
| `restricted` | Restricted |

### Degree Level
**Code system:** `helix/degree-level`  
**File:** `core/terminologies/degree-level.json`

| Code | Display |
|------|---------|
| `certificate_undergraduate` | Undergraduate Certificate |
| `associate` | Associate Degree |
| `bachelors` | Bachelor's Degree |
| `certificate_post_baccalaureate` | Post-Baccalaureate Certificate |
| `masters` | Master's Degree |
| `certificate_post_masters` | Post-Master's Certificate |
| `doctoral_research` | Doctoral Degree - Research/Scholarship |
| `doctoral_professional` | Doctoral Degree - Professional Practice |
| `professional` | First Professional Degree |
| `non_degree` | Non-Degree / Non-Credit |
| `micro_credential` | Micro-Credential / Badge |
| `other` | Other |

*Aligned with IPEDS degree level classifications. International profiles may map to ISCED levels (e.g., ISCED 5 = short-cycle, ISCED 6 = bachelor's, ISCED 7 = master's, ISCED 8 = doctoral).*

### Delivery Mode
**Code system:** `helix/delivery-mode`  
**File:** `core/terminologies/delivery-mode.json`

| Code | Display |
|------|---------|
| `in_person` | In Person |
| `online_synchronous` | Online Synchronous |
| `online_asynchronous` | Online Asynchronous |
| `hybrid` | Hybrid |
| `hyflex` | HyFlex |
| `competency_based` | Competency-Based |
| `correspondence` | Correspondence |
| `clinical` | Clinical/Practicum |
| `internship` | Internship/Co-op |
| `independent_study` | Independent Study |
| `other` | Other |

### Enrollment Status
**Code system:** `helix/enrollment-status`  
**File:** `core/terminologies/enrollment-status.json`

| Code | Display |
|------|---------|
| `registered` | Registered |
| `waitlisted` | Waitlisted |
| `enrolled` | Enrolled |
| `dropped` | Dropped |
| `withdrawn` | Withdrawn |
| `completed` | Completed |
| `incomplete` | Incomplete |
| `auditing` | Auditing |

### Ethnicity/Race
**Code system:** `helix/ethnicity`  
**File:** `core/terminologies/ethnicity.json`

| Code | Display |
|------|---------|
| `hispanic_latino` | Hispanic or Latino |
| `american_indian_alaska_native` | American Indian or Alaska Native |
| `asian` | Asian |
| `black_african_american` | Black or African American |
| `native_hawaiian_pacific_islander` | Native Hawaiian or Other Pacific Islander |
| `white` | White |
| `two_or_more` | Two or More Races |
| `nonresident_alien` | Nonresident Alien |
| `unknown` | Race/Ethnicity Unknown |
| `other` | Other |

*IPEDS requires institutions to first ask about Hispanic/Latino ethnicity, then ask about race (multi-select). For IPEDS reporting, 'two_or_more' is derived from the selections. Non-US institutions should define country-specific ethnicity/race profiles as HELIX Implementation Profiles (e.g., UK uses different categories for HESA).*

### Gender Identity
**Code system:** `helix/gender-identity`  
**File:** `core/terminologies/gender-identity.json`

| Code | Display |
|------|---------|
| `man` | Man |
| `woman` | Woman |
| `nonbinary` | Non-Binary |
| `transgender_man` | Transgender Man |
| `transgender_woman` | Transgender Woman |
| `genderqueer` | Genderqueer/Gender Non-Conforming |
| `two_spirit` | Two-Spirit |
| `prefer_not_to_say` | Prefer Not to Say |
| `not_listed` | A Gender Not Listed Here |
| `unknown` | Unknown |

*This terminology is intentionally expansive. Institutions should adopt the subset appropriate to their regulatory and cultural context via Implementation Profiles. The US IPEDS currently requires binary reporting; this terminology supports richer collection while enabling rollup to binary for compliance.*

### Gender
**Code system:** `helix/gender`  
**File:** `core/terminologies/gender.json`

| Code | Display |
|------|---------|
| `male` | Male |
| `female` | Female |
| `nonbinary` | Non-Binary |
| `unknown` | Unknown |
| `other` | Other |

*This is legal/administrative gender for reporting purposes (IPEDS, HESA). Institutions tracking self-reported gender identity should use the helix/gender-identity terminology on Person.gender_identity.*

### Grade Mode
**Code system:** `helix/grade-mode`  
**File:** `core/terminologies/grade-mode.json`

| Code | Display |
|------|---------|
| `standard` | Standard Letter Grade |
| `pass_fail` | Pass/Fail |
| `audit` | Audit |
| `satisfactory_unsatisfactory` | Satisfactory/Unsatisfactory |
| `other` | Other |

### Hold Type
**Code system:** `helix/hold-type`  
**File:** `core/terminologies/hold-type.json`

| Code | Display |
|------|---------|
| `registration` | Registration Hold |
| `financial` | Financial Hold |
| `academic` | Academic Hold |
| `disciplinary` | Disciplinary Hold |
| `transcript` | Transcript Hold |
| `graduation` | Graduation Hold |
| `library` | Library Hold |
| `health_compliance` | Health Compliance Hold |
| `admissions` | Admissions Hold |
| `international` | International Hold |
| `parking` | Parking Hold |
| `other` | Other |

### Identifier Type
**Code system:** `helix/identifier-type`  
**File:** `core/terminologies/identifier-type.json`

| Code | Display |
|------|---------|
| `institutional_id` | Institutional ID |
| `national_id` | National ID |
| `ssn_last4` | SSN Last 4 |
| `passport` | Passport Number |
| `drivers_license` | Driver's License Number |
| `login` | Login/Username |
| `email` | Email Address |
| `erp_internal_key` | ERP Internal Key |
| `prior_institution_id` | Prior Institution ID |
| `clearing_house_id` | Clearing House ID |
| `orcid` | ORCID |
| `other` | Other |

### Academic Period Type
**Code system:** `helix/period-type`  
**File:** `core/terminologies/period-type.json`

| Code | Display |
|------|---------|
| `semester` | Semester |
| `quarter` | Quarter |
| `trimester` | Trimester |
| `session` | Session |
| `mini_term` | Mini-Term |
| `academic_year` | Academic Year |
| `other` | Other |

### Satisfactory Academic Progress (SAP) Status
**Code system:** `helix/sap-status`  
**File:** `core/terminologies/sap-status.json`

| Code | Display |
|------|---------|
| `meeting` | Meeting SAP |
| `warning` | SAP Warning |
| `probation` | SAP Probation |
| `suspension` | SAP Suspension |
| `appeal_approved` | Appeal Approved |
| `not_evaluated` | Not Yet Evaluated |

*SAP is a federal (Title IV) requirement in the US. Institutions must evaluate SAP at least once per academic year. Three components: qualitative (GPA), quantitative (pace/completion rate), and maximum timeframe.*

### Student Status
**Code system:** `helix/student-status`  
**File:** `core/terminologies/student-status.json`

| Code | Display |
|------|---------|
| `prospective` | Prospective |
| `applicant` | Applicant |
| `admitted` | Admitted |
| `enrolled` | Enrolled |
| `leave_of_absence` | Leave of Absence |
| `withdrawn` | Withdrawn |
| `graduated` | Graduated |
| `deceased` | Deceased |

### Student Type
**Code system:** `helix/student-type`  
**File:** `core/terminologies/student-type.json`

| Code | Display |
|------|---------|
| `first_time_freshman` | First-Time Freshman |
| `transfer` | Transfer Student |
| `readmit` | Readmit |
| `continuing` | Continuing Student |
| `dual_enrollment` | Dual Enrollment |
| `transient` | Transient/Visiting |
| `non_degree` | Non-Degree Seeking |
| `post_baccalaureate` | Post-Baccalaureate |
| `audit_only` | Audit Only |
| `other` | Other |

### Veteran Status
**Code system:** `helix/veteran-status`  
**File:** `core/terminologies/veteran-status.json`

| Code | Display |
|------|---------|
| `none` | No Military Affiliation |
| `veteran` | Veteran |
| `active_duty` | Active Duty |
| `reserve_national_guard` | Reserve / National Guard |
| `dependent_spouse` | Military Dependent/Spouse |
| `other` | Other |

*US-specific. Drives VA benefits eligibility (GI Bill chapters), IPEDS Military Servicemember reporting, and state veteran tuition waivers. International profiles should define country-specific military/veteran codes.*
