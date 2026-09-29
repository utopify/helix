# HELIX Bridge: Outcomes (sources outside the ERP)

Most graduate outcome data never touches the ERP. Career services collects first-destination surveys and internships, the National Student Clearinghouse reports further study, state agencies hold wage records, licensing boards report exam results, and the learning management system holds learning outcome assessments. These 8 mappings bring each of those into the same HELIX Outcomes resources the ERP bridges feed.

## Mappings (8)

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

## Where each Outcomes resource comes from

| Resource | Primary source | Also from |
|---|---|---|
| FirstDestinationSurvey | Career services platform (Handshake, Symplicity, 12twenty, Qualtrics) | |
| EmploymentOutcome | First-destination survey | State UI wage records (verified earnings, no job titles) |
| ContinuingEducation | Clearinghouse StudentTracker | First-destination survey |
| ExperientialLearning | ERP registration for credit-bearing experiences (PeopleSoft, Banner, Workday) | Career services platform for employer, supervisor, pay, and evaluation |
| Licensure | Exam results sent to the program | Program-level pass rate reports, state license lookups |
| LearningOutcome | LMS outcomes (Canvas) | Assessment platforms (Watermark, Anthology) |
| AwardHonor | ERP (PeopleSoft, Banner, Workday) | |
| AlumniProfile | Advancement system (Banner Advancement) | Career services platform |

## Rules that apply to every file here

- **Identity first.** Resolve every row to HELIX Student through the institutional ID or the HELIX token you sent. Match on name and birth date only in the restricted identity zone, and send ambiguous matches to the stewardship queue.
- **Never send SSN when a token will do.** The Clearinghouse returns your Requester Return Field, so send the HELIX token. State wage matching needs SSN; do it in the restricted zone under a written agreement and drop SSN before silver.
- **A missing record isn't a negative outcome.** Wage records miss federal, military, self-employed, and out-of-state workers. The Clearinghouse misses students who blocked release. Never code a missing match as unemployed or not enrolled.
- **Salary is masked.** `helix_mask_outcomes_salary` shows cleartext to career services, $10K bands to research, and nothing to standard roles. Published figures are medians, suppressed below N of 5 (`govern/ferpa-suppression-policy.json`).
- **These are education records.** Every resource here except AlumniProfile is a FERPA education record and needs legitimate educational interest. Agreements with outside parties use `govern/data-sharing-agreement-template.json`.
- **Validate the layout.** Vendor exports change with configuration and contract. Each file carries a `validate` note; confirm columns against your own export before building a pipeline.

## Not covered

- AlumniProfile from PeopleSoft or Workday. Most PeopleSoft and Workday schools run advancement in a separate CRM (Blackbaud Raiser's Edge NXT, Salesforce Education Cloud, Ellucian CRM Advance). Map from that system; contributions welcome.
