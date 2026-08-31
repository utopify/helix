# HELIX Bridge: PeopleSoft Campus Solutions (SIS)

Student Information System mappings from Oracle PeopleSoft Campus Solutions to HELIX Core resources.

## Mappings (14 resources)

| HELIX Resource | Mapping File | Key PS Tables |
|---------------|-------------|---------------|
| Person | `person_mapping.json` | PS_PERSONAL_DATA, PS_NAMES, PS_ADDRESSES, PS_EMAIL_ADDRESSES, PS_DIVERS_ETHNIC |
| Student | `student_mapping.json` | PS_PERSONAL_DATA, PS_NAMES, PS_STDNT_CAR_TERM, PS_RESIDENCY |
| Enrollment | `enrollment_mapping.json` | PS_STDNT_ENRL, PS_CLASS_TBL |
| AcademicPeriod | `academic_period_mapping.json` | PS_TERM_TBL, PS_SESSION_TBL |
| Course | `course_mapping.json` | PS_CRSE_CATALOG, PS_CRSE_OFFER |
| CourseSection | `course_section_mapping.json` | PS_CLASS_TBL, PS_CLASS_MTG_PAT, PS_CLASS_INSTR |
| Program | `program_mapping.json` | PS_ACAD_PROG_TBL, PS_ACAD_PLAN_TBL |
| StudentProgram | `student_program_mapping.json` | PS_ACAD_PROG, PS_ACAD_PLAN, PS_STDNT_CAR_TERM |
| FinAidAward | `fin_aid_award_mapping.json` | PS_STDNT_AWARDS, PS_ITEM_TYPE_FA, PS_ISIR_COMPUTED, PS_DISB_DETAIL |
| Degree | `degree_mapping.json` | PS_ACAD_DEGR, PS_ACAD_DEGR_PLAN, PS_ACAD_DEGR_HONS |
| AdmissionApplication | `admission_application_mapping.json` | PS_ADM_APPL_DATA, PS_ADM_APPL_PROG, PS_STDNT_TEST_COMP |
| TransferCredit | `transfer_credit_mapping.json` | PS_TRNS_CRSE_DTL, PS_TRNSFR_EQUIVLNC |
| Hold | `hold_mapping.json` | PS_SRVC_IND_DATA, PS_SRVC_IND_TBL, PS_SRVC_IND_RSLT |
| AcademicOrg | `academic_org_mapping.json` | PS_ACAD_ORG_TBL, PS_TREE_NODE |

## Key PeopleSoft CS Concepts

- **Effective Dating**: Most CS tables use EFFDT (effective date) + EFFSEQ (sequence) for point-in-time history. Current row = max EFFDT ≤ today, max EFFSEQ.
- **Career/Program/Plan Hierarchy**: ACAD_CAREER (UGRD, GRAD) → ACAD_PROG (program) → ACAD_PLAN (major/minor) → ACAD_SUB_PLAN (concentration).
- **STRM**: PeopleSoft term code. 4-digit: century + year + term-within-year (e.g., 2269 = Fall 2026).
- **EMPLID**: Universal person key shared with HCM. A single person has one EMPLID across all modules.