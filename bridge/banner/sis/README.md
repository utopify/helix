# HELIX Bridge: Banner SIS (Student Information System)

Student Information System mappings from Ellucian Banner to HELIX Core resources.

## Mappings (14 resources)

| HELIX Resource | Mapping File | Key Banner Tables | Attrs |
|---------------|-------------|-------------------|-------|
| AcademicOrg | `academic_org_mapping.json` | STVCOLL, STVDEPT, FTVORGN | 8 |
| AcademicPeriod | `academic_period_mapping.json` | STVTERM, SOBPTRM | 11 |
| AcademicTermRecord | `academic_term_record_mapping.json` | SFBETRM, SHRLGPA, SGRSPRT | 14 |
| AwardHonor | `award_honor_mapping.json` | SHRDGIH, SHRDGDH, STVHONR +3 more | 19 |
| Course | `course_mapping.json` | SCBCRSE, SCBDESC | 13 |
| CourseSection | `course_section_mapping.json` | SSBSECT, SSRMEET, SIRASGN, SSRXLST, STVCAMP | 21 |
| Degree | `degree_mapping.json` | SHRDGMR, SHRLGPA, STVMAJR, STVHONR | 16 |
| Enrollment | `enrollment_mapping.json` | SFRSTCR, SHRTCKN, SSBSECT, STVRSTS | 15 |
| ExperientialLearning | `experiential_learning_mapping.json` | SFRSTCR, SSBSECT, STVSCHD +2 more | 25 |
| Institution | `institution_mapping.json` | GUBINST, STVCAMP, STVSBGI +2 more | 11 |
| Person | `person_mapping.json` | SPRIDEN, SPBPERS, GORPRAC, GOREMAL, SPRADDR, SPRTELE | 24 |
| Program | `program_mapping.json` | SMRPRLE, SOBCURR, STVMAJR, STVCOLL | 12 |
| Student | `student_mapping.json` | SPRIDEN, SPBPERS, SGBSTDN | 19 |
| StudentProgram | `student_program_mapping.json` | SGBSTDN, SORCMJR, SHRLGPA, SFBETRM | 14 |

## Key Banner Table Prefixes

| Prefix | Module | Examples |
|--------|--------|---------|
| **SPR/SPB** | Person/Biographical | SPRIDEN (names), SPBPERS (demographics), SPRADDR (addresses) |
| **GOR** | General | GOREMAL (email), GORRACE (race), GORPRAC (person race) |
| **SGB** | Student General | SGBSTDN (student record) |
| **SFR/SFB** | Student Registration | SFRSTCR (course registration), SFBETRM (enrollment term) |
| **SHR** | Student History | SHRLGPA (GPA), SHRDGMR (degree), SHRTCKN (transcript) |
| **SSB/SSR** | Section | SSBSECT (section base), SSRMEET (meeting times), SSRXLST (cross-list) |
| **SCB** | Course Catalog | SCBCRSE (course catalog) |
| **SMR/SOB/SOR** | Curriculum | SMRPRLE (program rules), SOBCURR (curriculum), SORCMJR (student major) |
| **SIR** | Instructor | SIRASGN (instructor assignment) |
| **SGR** | Student Groups | SGRSPRT (sport participation) |
| **STV** | Validation | STVTERM, STVMAJR, STVDEPT, STVCOLL, etc. (hundreds of code tables) |
