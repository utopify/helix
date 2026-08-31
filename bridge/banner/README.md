# HELIX Bridge: Ellucian Banner

Comprehensive mapping templates from Ellucian Banner to HELIX Core resources, organized by module.

## SaaS vs. On-Prem

Banner SaaS (Ellucian Cloud) and Banner on-prem use the **same underlying Oracle database schema**. Table names and column names are identical. What differs is the access method:

| Deployment | Access Method |
|-----------|--------------|
| **On-Prem** | Direct Oracle SQL, ODBC/JDBC connections |
| **SaaS** | Ellucian Data Connect (EDC), Ethos Integration API, Banner Integration API (BIA) |

HELIX Bridge mappings work with both — they reference the logical table/column structure, not the access method.

## Modules

| Module | Sub-Folder | Mappings | Description |
|--------|-----------|----------|-------------|
| **Student Information (SIS)** | `sis/` | 11 | Person, student records, enrollment, courses, sections, programs, degrees, GPA, academic org, athletics |
| **Human Resources** | `hr/` | 2 | Employee/job records, position management |

**Total: 13 Banner mappings**

## Key Banner Concepts

- **PIDM**: Person Internal Master ID. The invisible integer key that links ALL Banner records for a person across student, HR, finance, and advancement. Never displayed to users, but critical for all joins.
- **SPRIDEN_ID**: The visible, institution-assigned ID (e.g., '900123456'). This is what users see.
- **CRN**: Course Reference Number. Unique identifier for a section within a term.
- **Effective-Term Dating**: Many Banner tables use term codes (YYYYMM) for effective dating rather than calendar dates. Current record = max term code ≤ current term.
- **Validation Tables (STV*)**: Banner uses hundreds of validation tables prefixed with STV (STVTERM, STVMAJR, STVDEPT, etc.). These define valid codes for every dropdown and field.
- **Position-Centric HR**: Banner HR centers on positions (NBBPOSN) with employees assigned to positions (NBRBJOB). This differs from PeopleSoft's employee-centric job record model.
- **Shared Person Model**: PIDM is shared across student and HR modules. A faculty member who is also a student has one PIDM with records in both areas.

## Getting Started

1. Identify your Banner modules and deployment model (SaaS vs. on-prem)
2. Browse the relevant sub-folder (sis/ or hr/)
3. Each mapping file documents source tables, column-level transformations, and institution-specific notes
4. For SaaS institutions: map the Ethos/EDC field names to the same underlying columns
5. Use the [Migration Adventure Guide](../../docs/migration-adventure-guide.md) for step-by-step migration paths
