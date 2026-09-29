# HELIX Bridge: Colleague (Ellucian)

Mapping templates from Ellucian Colleague to HELIX Core resources. Colleague stores data in multi-valued UniData/UniVerse files, so each mapping notes how to explode multi-valued fields into rows.

## Mappings (4)

| HELIX Resource | Mapping File | Key Colleague Files | Attrs |
|---|---|---|---:|
| AcademicPeriod | `academic_period_mapping.json` | TERMS, TERM.SESSIONS | 12 |
| Enrollment | `enrollment_mapping.json` | STUDENT.ACAD.CRED, STUDENT.COURSE.SEC, COURSE.SECTIONS | 15 |
| Institution | `institution_mapping.json` | INSTITUTIONS, CORP / PERSON, DEFAULTS | 11 |
| Student | `student_mapping.json` | PERSON, STUDENTS, STUDENT.ACAD.LEVELS +2 more | 19 |

Colleague is the thinnest bridge in HELIX. Contributions for courses, programs, financial aid, HR, and finance are especially welcome; see [CONTRIBUTING.md](../../CONTRIBUTING.md).
