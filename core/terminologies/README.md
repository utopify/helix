# HELIX Core Terminologies

**67 standardized code sets** providing machine-readable, interoperable value lists for every HELIX Core resource.

Each terminology file follows JSON Schema draft 2020-12 and includes:
- `code_system` — unique identifier (e.g., `helix/worker-type`)
- `codes[]` — array of `{code, display, definition}` entries
- Institutional systems map their local codes to these standard values

---

## Student Lifecycle (13 code sets)

| File | Title | Codes | Description |
|------|-------|------:|-------------|
| `admission-status.json` | Admission Status | 10 | Standard statuses for admission applications. |
| `award-type.json` | Financial Aid Award Type | 11 | Standard types of financial aid awards. Used by the FinAidAward resource 'award_... |
| `course-level.json` | Course Level | 8 | Academic level classification for catalog courses. |
| `degree-level.json` | Degree Level | 12 | Standard degree levels. Used by Program and Degree resources. |
| `delivery-mode.json` | Delivery Mode | 11 | Standard instructional delivery modes for course sections and programs. |
| `enrollment-funnel-stage.json` | Enrollment Funnel Stage | 10 |  |
| `enrollment-status.json` | Enrollment Status | 8 | Standard statuses for a student's registration in a course section. Used by the ... |
| `grade-mode.json` | Grade Mode | 5 | Standard grading modes for course enrollments. Used by the Enrollment resource '... |
| `hold-type.json` | Hold Type | 12 | Standard types of holds/restrictions placed on student records. |
| `period-type.json` | Academic Period Type | 7 | Standard types of academic periods. Used by the AcademicPeriod resource 'period_... |
| `sap-status.json` | Satisfactory Academic Progress (SAP) Status | 6 | Federal financial aid eligibility status based on academic performance and pace ... |
| `student-status.json` | Student Status | 8 | Standard lifecycle statuses for a student at an institution. Used by the Student... |
| `student-type.json` | Student Type | 10 | Classification of a student's entry pathway to the institution. |

## Financial Aid (9 code sets) — *New in v0.4.0*

| File | Title | Codes | Description |
|------|-------|------:|-------------|
| `aid-application-status.json` | Aid Application Status | 8 | Lifecycle status of a financial aid application (FAFSA/ISIR or institutional). U |
| `verification-status.json` | Verification Status | 9 | Status of FAFSA verification per 34 CFR 668.51-.61. Used by the Verification res |
| `dependency-status.json` | Dependency Status | 4 | FAFSA dependency status determining whose financial information is required. Use |
| `loan-type.json` | Loan Type | 9 | Types of education loans. Used by the LoanRecord resource. |
| `loan-status.json` | Loan Status | 10 | Status of an education loan through origination and repayment. Used by LoanRecor |
| `disbursement-status.json` | Disbursement Status | 8 | Status of an aid disbursement to a student account. Used by the Disbursement res |
| `r2t4-status.json` | Return of Title IV (R2T4) Status | 7 | Status of a Return of Title IV calculation for a withdrawn student per 34 CFR 66 |
| `fund-source.json` | Aid Fund Source | 7 | Source of financial aid funds. Used by FinAidAward and Disbursement (fund_source |
| `employment-type-aid.json` | Student Employment Type (Aid) | 7 | Types of student employment tied to financial aid. Used by the StudentEmployment |

## Outcomes & Alumni (10 code sets) — *New in v0.4.0*

| File | Title | Codes | Description |
|------|-------|------:|-------------|
| `first-destination-status.json` | First-Destination Status | 12 | NACE-aligned first-destination career outcome categories for graduates. Used by  |
| `employment-relation.json` | Employment Relation to Major | 4 | The degree to which a graduate's employment is related to their field of study.  |
| `continuing-ed-level.json` | Continuing Education Level | 9 | Level of continuing/further education pursued by a graduate. Used by ContinuingE |
| `experiential-type.json` | Experiential Learning Type | 12 | Types of experiential learning and High-Impact Practices (HIPs). Used by Experie |
| `licensure-type.json` | Licensure/Certification Type | 13 | Categories of professional licensure and certification examinations. Used by Lic |
| `licensure-result.json` | Licensure Result | 8 | Outcome of a professional licensure or certification examination. Used by Licens |
| `outcome-type.json` | Learning Outcome Type | 6 | Types/levels of learning outcomes assessed for institutional effectiveness and a |
| `achievement-level.json` | Achievement Level | 9 | Levels of attainment for a learning-outcome assessment. Used by LearningOutcome. |
| `honor-type.json` | Honor/Award Type | 11 | Categories of honors, awards, and distinctions received by students. Used by Awa |
| `survey-status.json` | Survey Status | 7 | Lifecycle status of a survey instrument such as the NACE First-Destination Surve |

## Identity & Demographics (5 code sets)

| File | Title | Codes | Description |
|------|-------|------:|-------------|
| `ethnicity.json` | Ethnicity/Race | 10 | Self-reported race and ethnicity categories. Multi-select (a person may identify... |
| `gender.json` | Gender | 5 | Legal/administrative gender. Used by Person resource 'gender' attribute. For sel... |
| `gender-identity.json` | Gender Identity | 10 | Self-reported gender identity. Used by Person resource 'gender_identity' attribu... |
| `identifier-type.json` | Identifier Type | 12 | Types of identifiers that can be assigned to a person or entity across systems. |
| `veteran-status.json` | Veteran Status | 6 | Military/veteran classification for benefits eligibility and reporting. |

## Advancement & Alumni (4 code sets)

| File | Title | Codes | Description |
|------|-------|------:|-------------|
| `constituent-type.json` | Constituent Type | 10 |  |
| `donor-segment.json` | Donor Segment | 11 |  |
| `gift-type.json` | Gift Type | 14 |  |
| `prospect-stage.json` | Prospect Stage (Moves Management) | 6 |  |

## Human Resources (14 code sets) — *New in v0.3.1*

| File | Title | Codes | Description |
|------|-------|------:|-------------|
| `absence-type.json` | Absence Type | 13 | Categories of employee absence from work with associated leave policies. |
| `benefit-plan-type.json` | Benefit Plan Type | 15 | Types of employee benefit plans offered by higher education institutions. |
| `compensation-type.json` | Compensation Type | 12 | Types of compensation components in higher education institutions. |
| `eeo-category.json` | EEO/IPEDS Occupational Category | 7 | Employee occupational categories used for Equal Employment Opportunity (EEO) rep... |
| `employment-status.json` | Employment Status | 8 | Current status of a worker's employment relationship with the institution. |
| `faculty-rank.json` | Faculty Rank | 13 | Academic ranks within the higher education faculty hierarchy. Aligned with IPEDS... |
| `flsa-status.json` | FLSA Status | 3 | Fair Labor Standards Act classification determining overtime eligibility. |
| `learning-type.json` | Learning/Training Type | 9 | Categories of professional development and training activities for institutional... |
| `pay-frequency.json` | Pay Frequency | 6 | How often compensation is disbursed to employees. |
| `performance-rating.json` | Performance Rating | 7 | Standard performance evaluation ratings used in higher education staff appraisal... |
| `position-status.json` | Position Status | 6 | Status of a funded position in the institutional position management system. |
| `requisition-status.json` | Requisition Status | 10 | Status codes for position requisitions in the hiring process. |
| `tenure-status.json` | Tenure Status | 5 | Status of a faculty member within the academic tenure system. |
| `worker-type.json` | Worker Type | 12 | Classification of institutional workers by employment relationship. |

## Financial Operations (11 code sets) — *New in v0.3.1*

| File | Title | Codes | Description |
|------|-------|------:|-------------|
| `account-type.json` | Chart of Accounts — Account Type | 6 | Top-level account classifications in the higher education chart of accounts, ali... |
| `asset-category.json` | Asset Category | 12 | Categories of capital assets for financial reporting, aligned with GASB 34 requi... |
| `asset-status.json` | Fixed Asset Status | 8 | Status of capital assets tracked in the institutional fixed asset system. |
| `budget-status.json` | Budget Status | 9 | Status of operating and project budgets in the institutional financial planning ... |
| `contract-status.json` | Contract Status | 9 | Status of institutional contracts and agreements tracked in the contract managem... |
| `expense-status.json` | Expense Report Status | 8 | Status of employee expense reimbursement requests in the travel and expense syst... |
| `fund-type.json` | Fund Type | 12 | Classification of funds in the higher education fund accounting model, aligned w... |
| `grant-status.json` | Grant/Sponsored Program Status | 10 | Lifecycle status of externally funded grants and sponsored program awards in hig... |
| `payment-status.json` | Payment Status | 9 | Status of vendor payments, refunds, and disbursements in the accounts payable pr... |
| `purchase-order-status.json` | Purchase Order Status | 9 | Status of purchase orders in the institutional procurement process. |
| `transaction-type.json` | GL Transaction Type | 11 | Types of general ledger journal entries in higher education financial systems. |

## Cross-Cutting (1 code set)

| File | Title | Codes | Description |
|------|-------|------:|-------------|
| `data-classification.json` | Data Classification | 4 | Standard data classification tiers used in the HELIX meta block. Part of HELIX G... |

---

**Total: 67 terminologies, 595 codes**

## Usage

Resources reference terminologies via the `terminology_binding` field in the data dictionary.
For example, the `student_type` attribute on the Student resource binds to `helix/student-type`.

```json
{
  "student_type": {
    "type": "string",
    "description": "Primary student classification",
    "terminology_binding": "helix/student-type"
  }
}
```

Implementers map their institutional codes to the HELIX standard codes during the Bronze → Silver transformation.
