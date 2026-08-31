# HELIX Bridge: PeopleSoft HCM (Human Capital Management)

Human resources mappings from Oracle PeopleSoft HCM to HELIX planned resources.

## Mappings (7 areas)

| Area | Mapping File | Key PS Tables |
|------|-------------|---------------|
| Employee / Core HR | `employee_mapping.json` | PS_JOB, PS_EMPLOYMENT, PS_PERSONAL_DATA |
| Position Management | `position_mapping.json` | PS_POSITION_DATA |
| Compensation | `compensation_mapping.json` | PS_COMPENSATION, PS_JOB, PS_SAL_GRADE_TBL |
| Benefits Administration | `benefits_mapping.json` | PS_HEALTH_BENEFIT, PS_SAVINGS_PLAN, PS_LIFE_ADD_BEN, PS_FSA_BENEFIT |
| Payroll | `payroll_mapping.json` | PS_PAY_EARNINGS, PS_PAY_DEDUCTION, PS_PAY_CHECK, PS_PAY_TAX |
| Time & Labor | `time_labor_mapping.json` | PS_TL_RPTD_TIME, PS_TL_PAYABLE_TIME |
| Recruiting | `recruiting_mapping.json` | PS_HRS_JO_I, PS_HRS_APP_I |

## Key PeopleSoft HCM Concepts

- **PS_JOB**: The single most important HCM table. Effective-dated with action/reason history. Every employment event (hire, promotion, transfer, termination) creates a new row. Current row = max EFFDT ≤ today, max EFFSEQ.
- **EMPLID + EMPL_RCD**: Person key + employment record number. EMPL_RCD 0 = primary job, higher numbers = concurrent/additional jobs (common for faculty with administrative appointments).
- **Shared Person Model**: PeopleSoft uses the same EMPLID and PS_PERSONAL_DATA/PS_NAMES tables across HCM and Campus Solutions. A faculty member who is also a student has one EMPLID with records in both modules.
- **IPEDS Reporting**: Employee data feeds IPEDS HR Survey (faculty counts, tenure status, salary by rank), S&E (salaries of full-time instructional staff), and Fall Staff.

## Status

These mappings target **planned HELIX Core v0.2 resources** (HR/Workforce domain). The source table references and transformation logic are production-ready; the target HELIX resource definitions will be formalized in v0.2.