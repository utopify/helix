# HELIX Bridge: Banner HR (Human Resources)

Human resources mappings from Ellucian Banner HR to HELIX planned resources.

## Mappings (2 areas)

| Area | Mapping File | Key Banner Tables | Attrs |
|------|-------------|-------------------|-------|
| Employee / Job | `employee_mapping.json` | PEBEMPL, NBRBJOB, NBBPOSN, PTRECLS, SPRIDEN, SPBPERS, FTVORGN | 22 |
| Position Management | `position_mapping.json` | NBBPOSN, NBRPTOT, FTVORGN, PTRECLS | 14 |

## Key Banner HR Table Prefixes

| Prefix | Module | Examples |
|--------|--------|---------|
| **PEB** | Employee Base | PEBEMPL (employee record) |
| **NBR/NBB** | Position/Job | NBRBJOB (employee job), NBBPOSN (position base), NBRPTOT (position budget) |
| **PTR** | HR Validation | PTRECLS (employee class), PTRJCRE (job change reasons), PTREMST (employment status) |
| **FTV** | Finance Validation | FTVORGN (organization), FTVFUND (fund) |

## Banner HR vs. PeopleSoft HCM

| Concept | Banner HR | PeopleSoft HCM |
|---------|-----------|----------------|
| Core model | Position-centric (NBBPOSN → NBRBJOB) | Employee/job-centric (PS_JOB) |
| History tracking | NBRBJOB effective dates | PS_JOB EFFDT + EFFSEQ |
| Person key | PIDM (shared with student) | EMPLID (shared with CS) |
| Faculty tracking | Via PTRECLS employee class codes | Dedicated PS_FACULTY_RANK table |
| Tenure | Custom fields (no standard table) | PS_FACULTY_TENURE (HE add-on) |
| Benefits | Separate BANNER HR module (PDRBDED, etc.) | Integrated PS_HEALTH_BENEFIT, etc. |
| Payroll | Banner Finance integration (PHRHIST, etc.) | Integrated PS_PAY_EARNINGS, etc. |
