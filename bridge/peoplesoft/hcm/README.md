# HELIX Bridge: PeopleSoft HCM (Human Capital Management)

Human resources mappings from Oracle PeopleSoft HCM to HELIX planned resources.

**Coverage: 80%** of PeopleSoft HCM functional areas (12 of 15).

## Mappings (12 areas)

| Area | Mapping File | Key PS Tables | Attributes |
|------|-------------|---------------|------------|
| AbsenceRecord | `absence_management_mapping.json` | PS_ABSENCE_EVENT, PS_ABSENCE_DAILY, PS_LEAVE_ACCRUAL +3 more | 14 |
| BenefitEnrollment | `benefits_mapping.json` | PS_HEALTH_BENEFIT, PS_LIFE_ADD_BEN, PS_SAVINGS_PLAN +3 more | 15 |
| Compensation | `compensation_mapping.json` | PS_COMPENSATION, PS_JOB, PS_SAL_PLAN_TBL +1 more | 17 |
| Employee | `employee_mapping.json` | PS_PERSONAL_DATA, PS_NAMES, PS_EMPLOYMENT +3 more | 26 |
| JobClassification | `job_classification_mapping.json` | PS_JOBCODE_TBL, PS_SAL_PLAN_TBL, PS_SAL_GRADE_TBL +2 more | 18 |
| TrainingRecord | `learning_management_mapping.json` | PS_TRAINING, PS_LM_LEARN_COMPNT, PS_LM_ENRLMT +2 more | 15 |
| PayrollRecord | `payroll_mapping.json` | PS_PAY_EARNINGS, PS_PAY_DEDUCTION, PS_PAY_CHECK +3 more | 22 |
| PerformanceReview | `performance_management_mapping.json` | PS_EP_APPRAISAL, PS_EP_APPR_SECTION, PS_EP_APPR_ITEM +2 more | 14 |
| PositionBudget | `position_budget_mapping.json` | PS_POSITION_DATA, PS_POS_BUDGET, PS_DEPT_BUDGET_ERN +1 more | 12 |
| Position | `position_mapping.json` | PS_POSITION_DATA, PS_POS_DATA_EFFDT | 14 |
| JobOpening | `recruiting_mapping.json` | PS_HRS_JO_I, PS_HRS_APP_I, PS_HRS_APP_JO_I +1 more | 13 |
| TimeRecord | `time_labor_mapping.json` | PS_TL_RPTD_TIME, PS_TL_PAYABLE_TIME, PS_TL_EXCEPTION +1 more | 12 |

## Key PeopleSoft HCM Concepts

- **PS_JOB**: The single most important HCM table. Effective-dated with action/reason history. Every employment event (hire, promotion, transfer, termination) creates a new row. Current row = max EFFDT ≤ today, max EFFSEQ.
- **EMPLID + EMPL_RCD**: Person key + employment record number. EMPL_RCD 0 = primary job, higher numbers = concurrent/additional jobs (common for faculty with administrative appointments).
- **Shared Person Model**: PeopleSoft uses the same EMPLID and PS_PERSONAL_DATA/PS_NAMES tables across HCM and Campus Solutions. A faculty member who is also a student has one EMPLID with records in both modules.
- **IPEDS Reporting**: Employee data feeds IPEDS HR Survey (faculty counts, tenure status, salary by rank), S&E (salaries of full-time instructional staff), and Fall Staff.
- **Faculty-Specific**: Job classification includes faculty rank (professor, associate, assistant, instructor, lecturer, adjunct) and tenure status (tenured, tenure-track, non-tenure-track). These are critical for IPEDS and accreditation reporting.
- **FMLA Compliance**: Absence Management tracks FMLA eligibility, qualifying reasons, and protected leave hours. Institutions must track the 12-week (or 26-week military caregiver) entitlement.

## Not Yet Covered (planned for future versions)

- Workforce Analytics / Dashboards (PS_WA)
- Succession Planning
- Health & Safety / Workers Compensation
