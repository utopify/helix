# HELIX Bridge: ERP Mapping Reference

HELIX Bridge provides pre-built mapping templates for **4 ERP systems**, covering the 3 highest-priority resources (Student, Enrollment, AcademicPeriod).

Each mapping documents the source-to-HELIX attribute transformation at the column/field level, including transformation logic, data type conversions, and institution-specific notes.

| ERP | Vendor | Architecture | Mappings |
|-----|--------|-------------|----------|
| **Ellucian Banner** | Ellucian | Relational (Oracle RDBMS) | 3 resources |
| **Ellucian Colleague** | Ellucian | Multi-Valued (UniData/UniVerse) | 3 resources |
| **Oracle PeopleSoft Campus Solutions** | Oracle | Relational (Oracle RDBMS), effective-dated | 3 resources |
| **Workday Student** | Workday | Cloud-native (REST API, business objects) | 3 resources |

## Ellucian Banner
**Architecture:** Relational (Oracle RDBMS)

### AcademicPeriod
**File:** `bridge/banner/academic_period_mapping.json`  
**Source tables/objects:** `STVTERM`, `SOBPTRM`  
**Attribute mappings:** 12

### Enrollment
**File:** `bridge/banner/enrollment_mapping.json`  
**Source tables/objects:** `SFRSTCR`, `SHRTCKN`, `SSBSECT`  
**Attribute mappings:** 15

### Student
**File:** `bridge/banner/student_mapping.json`  
**Source tables/objects:** `SPRIDEN`, `SPBPERS`, `SGBSTDN`, `GOBINTL`, `GORADID`  
**Attribute mappings:** 18

## Ellucian Colleague
**Architecture:** Multi-Valued (UniData/UniVerse)

### AcademicPeriod
**File:** `bridge/colleague/academic_period_mapping.json`  
**Source tables/objects:** `TERMS`, `TERM.SESSIONS`  
**Attribute mappings:** 12

### Enrollment
**File:** `bridge/colleague/enrollment_mapping.json`  
**Source tables/objects:** `STUDENT.ACAD.CRED`, `STUDENT.COURSE.SEC`, `COURSE.SECTIONS`  
**Attribute mappings:** 15

### Student
**File:** `bridge/colleague/student_mapping.json`  
**Source tables/objects:** `PERSON`, `STUDENTS`, `STUDENT.ACAD.LEVELS`, `FOREIGN.PERSON`, `PERSON.ALT.IDS`  
**Attribute mappings:** 19

## Oracle PeopleSoft Campus Solutions
**Architecture:** Relational (Oracle RDBMS), effective-dated

### AcademicPeriod
**File:** `bridge/peoplesoft/academic_period_mapping.json`  
**Source tables/objects:** `PS_TERM_TBL`, `PS_SESSION_TBL`  
**Attribute mappings:** 12

### Enrollment
**File:** `bridge/peoplesoft/enrollment_mapping.json`  
**Source tables/objects:** `PS_STDNT_ENRL`, `PS_CLASS_TBL`, `PS_TERM_TBL`  
**Attribute mappings:** 15

### Student
**File:** `bridge/peoplesoft/student_mapping.json`  
**Source tables/objects:** `PS_PERSONAL_DATA`, `PS_NAMES`, `PS_STDNT_CAR_TERM`, `PS_RESIDENCY`, `PS_CITIZENSHIP`, `PS_PERSON`  
**Attribute mappings:** 18

## Workday Student
**Architecture:** Cloud-native (REST API, business objects)

### AcademicPeriod
**File:** `bridge/workday/academic_period_mapping.json`  
**Source tables/objects:** `Academic Period`, `Academic Calendar`  
**Attribute mappings:** 12

### Enrollment
**File:** `bridge/workday/enrollment_mapping.json`  
**Source tables/objects:** `Student Course Registration`, `Student Course Grade`, `Course Section`  
**Attribute mappings:** 15

### Student
**File:** `bridge/workday/student_mapping.json`  
**Source tables/objects:** `Person`, `Student`, `Academic Affiliation`, `Citizenship Status`, `Universal Identifier`  
**Attribute mappings:** 19
