# HELIX Bridge (Reverse): HELIX -> Banner SaaS

Write-back mappings for loading HELIX Core data INTO Ellucian Banner SaaS
(Ellucian Platform / Ellucian Student). This is the **reverse direction** of
the `bridge/banner/` source-schema mappings.

## Direction matters

| Bridge | Direction | Use |
|--------|-----------|-----|
| `bridge/banner/` | Banner -> HELIX | Read/extract. Source-schema (Oracle table/column) mappings. Works for on-prem direct SQL and for SaaS reads (same logical schema via Ethos/EDC). |
| `bridge/banner-saas/` (this folder) | HELIX -> Banner SaaS | Write/load. Maps HELIX resources to Ethos API payloads for writing into a SaaS tenant. |

## The SaaS access model (no direct database)

Banner SaaS removes direct Oracle access. There is no SQL, no stored
procedures, no ODBC/JDBC into the database. All data movement goes through
governed interfaces:

| Interface | Role |
|-----------|------|
| **Ethos Integration API** | Governed REST/JSON canonical resources (`persons`, `students`, `sections`, `courses`, `academic-periods`, `section-registrations`, `academic-programs`, `student-academic-programs`, ...). GUID-keyed. Primary write path for reference and person data. |
| **Banner Integration API (BIA)** | Banner-specific process and integration endpoints. Used for operations Ethos does not expose directly. |
| **Ellucian Data Connect (EDC)** | Managed pipelines for bulk/batch movement. Native relational extract target is PostgreSQL. |

## The Ethos resource model

Ethos exposes a canonical data model as REST resources. Every resource is
identified by a **GUID**, and resources reference each other by GUID (not by
Banner code). Two consequences for write-back:

1. You maintain a **crosswalk** between `helix_id` and the Ethos GUID for every
   object. HELIX never writes `helix_id` into Ethos.
2. Referenced values (race, ethnicity, gender identity, academic level, degree,
   subject, instructional method, registration status, ...) are themselves
   GUID-referenced validation resources that must be **resolved from the tenant**
   before a write.

## Reverse mapping files (8)

| HELIX Resource | Ethos Resource | File |
|----------------|----------------|------|
| Person | `persons` | `person_reverse_mapping.json` |
| Student | `students` | `student_reverse_mapping.json` |
| AcademicPeriod | `academic-periods` | `academic_period_reverse_mapping.json` |
| Course | `courses` | `course_reverse_mapping.json` |
| CourseSection | `sections` | `section_reverse_mapping.json` |
| Enrollment | `section-registrations` | `enrollment_reverse_mapping.json` |
| Program | `academic-programs` | `program_reverse_mapping.json` |
| StudentProgram | `student-academic-programs` | `student_program_reverse_mapping.json` |

## What you can and cannot write

- **Person data** (`persons`) is one of the few resources with reliable direct
  create/update.
- **Reference/config data** (academic-periods, courses, academic-programs) is
  often curriculum- or Banner-config-governed and may be read-mostly via Ethos.
- **Operational events** (registration especially) are **business processes**,
  not simple resource writes. They validate holds, prerequisites, capacity, and
  time tickets server-side and can reject a write.
- On-prem patterns (direct SQL INSERT, stored procedures) do **not** port. The
  business logic they carried must be rebuilt against these APIs.

See `WRITEBACK_PATTERNS.md` for the write-path decision guide, GUID correlation,
idempotency, ordering, and reconciliation. See
`../../docs/banner-saas-landing-architecture.md` for where SaaS data should land
on the read side (PostgreSQL staging vs. S3 Tables / Iceberg) and why storage is
never a write target for SaaS.
