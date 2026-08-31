# HELIX Bridge: PeopleSoft Campus Solutions (SIS)

Student Information System mappings from Oracle PeopleSoft Campus Solutions to HELIX Core resources.

**Coverage: 83%** of PeopleSoft CS functional areas (19 of 23).

## Mappings (19 resources)

| HELIX Resource | Mapping File | Key PS Tables | Attributes |
|---------------|-------------|---------------|------------|
| AcademicOrg | `academic_org_mapping.json` | PS_ACAD_ORG_TBL | 10 |
| AcademicPeriod | `academic_period_mapping.json` | PS_TERM_TBL, PS_SESSION_TBL | 12 |
| AcademicTermRecord | `academic_term_record_mapping.json` | PS_STDNT_CAR_TERM, PS_STDNT_CAR_MLSTN, PS_ACAD_STDNG_TBL | 16 |
| AdmissionApplication | `admission_application_mapping.json` | PS_ADM_APPL_DATA, PS_ADM_APPL_PROG, PS_ADM_APPL_PLAN +3 more | 17 |
| Course | `course_mapping.json` | PS_CRSE_CATALOG, PS_CRSE_OFFER | 14 |
| CourseSection | `course_section_mapping.json` | PS_CLASS_TBL, PS_CLASS_MTG_PAT, PS_CLASS_INSTR | 21 |
| DegreeAudit | `degree_audit_mapping.json` | PS_AA_RQRMNT, PS_AA_RQRMNT_DESIG, PS_STDNT_ADVR +2 more | 16 |
| Degree | `degree_mapping.json` | PS_ACAD_DEGR, PS_ACAD_DEGR_PLAN, PS_ACAD_DEGR_HONS | 16 |
| Enrollment | `enrollment_mapping.json` | PS_STDNT_ENRL, PS_CLASS_TBL, PS_TERM_TBL | 15 |
| FERPARestriction | `ferpa_restriction_mapping.json` | PS_FERPA_INDC, PS_FERPA_TBL | 8 |
| FinAidAward | `fin_aid_award_mapping.json` | PS_STDNT_AWARDS, PS_ITEM_TYPE_FA, PS_STDNT_FA_TERM +2 more | 19 |
| Hold | `hold_mapping.json` | PS_SRVC_IND_DATA, PS_SRVC_IND_TBL, PS_SRVC_IND_RSLT | 14 |
| InternationalStudent | `international_student_mapping.json` | PS_VISA_PMT_DATA, PS_VISA_PERMIT_TBL, PS_SEVIS_DATA +3 more | 18 |
| Person | `person_mapping.json` | PS_PERSONAL_DATA, PS_NAMES, PS_ADDRESSES +6 more | 25 |
| Program | `program_mapping.json` | PS_ACAD_PROG_TBL, PS_ACAD_PLAN_TBL, PS_ACAD_SUBPLAN_TBL | 13 |
| StudentGroup | `student_group_mapping.json` | PS_STDNT_GRPS, PS_STDNT_GRP_TBL | 8 |
| Student | `student_mapping.json` | PS_PERSONAL_DATA, PS_NAMES, PS_STDNT_CAR_TERM +3 more | 18 |
| StudentProgram | `student_program_mapping.json` | PS_ACAD_PROG, PS_ACAD_PLAN, PS_STDNT_CAR_TERM | 15 |
| TransferCredit | `transfer_credit_mapping.json` | PS_TRNS_CRSE_DTL, PS_TRNS_CRSE_TERM, PS_TRNSFR_EQUIVLNC +1 more | 16 |

## Key PeopleSoft CS Concepts

- **Effective Dating**: Most CS tables use EFFDT (effective date) + EFFSEQ (sequence) for point-in-time history. Current row = max EFFDT ≤ today, max EFFSEQ.
- **Career/Program/Plan Hierarchy**: ACAD_CAREER (UGRD, GRAD) → ACAD_PROG (program) → ACAD_PLAN (major/minor) → ACAD_SUB_PLAN (concentration).
- **STRM**: PeopleSoft term code. 4-digit: century + year + term-within-year (e.g., 2269 = Fall 2026).
- **EMPLID**: Universal person key shared with HCM. A single person has one EMPLID across all modules.
- **Service Indicators**: PeopleSoft's term for holds. Can be positive (honors) or negative (restrictions). Filter to negative for HELIX Hold mapping.
- **SEVIS**: Student and Exchange Visitor Information System. Federal compliance requirement for F-1/J-1 international students.
- **FERPA**: Family Educational Rights and Privacy Act. Student directory information restrictions tracked in PS_FERPA_INDC.

## Not Yet Covered (planned for future versions)

- Communication Management (PS_COMM_MGMT)
- Tuition Calculation Rules (PS_ITEM_TYPE_TBL configuration)
- Housing / Residence Life (PS_HOUSING_APPL)
- Student Activities / Organizations
