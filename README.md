# HELIX

### Higher Education Linked Information eXchange

> An open framework for eliminating data integration friction in higher education, worldwide.

---

**Founded by:** Dallas Maddox
**Status:** Draft v0.1 — Founding Charter
**License:** Apache 2.0 (proposed)

---

## The Problem

Every university on the planet runs some version of the same core data domains: students, courses, enrollment, financial aid, HR, research, and advancement. Yet every ERP migration, every data lake build, and every analytics modernization project treats the mapping of these domains as a bespoke engineering effort.

The mapping logic from Banner to a lakehouse is 80% identical to the mapping logic from PeopleSoft to a lakehouse. But nobody has codified that shared 80% into something reusable.

The result: billions of dollars spent globally on redundant integration work, inconsistent definitions that erode trust in institutional data, and an inability to benchmark or collaborate across institutions because everyone speaks a different data dialect.

**What if every university spoke the same data language?**

## The Vision

HELIX provides higher education with what FHIR gave healthcare: a shared, open, technology-neutral vocabulary of linked data objects that any system can produce, consume, and trust.

When an institution adopts HELIX:

- **ERP choice becomes an implementation detail**, not an architecture-defining constraint
- **Data lake ingestion is pre-mapped**, not hand-built from scratch
- **Analytics and AI models are portable** across institutions
- **Data governance has a shared vocabulary**, so "enrolled student" means the same thing everywhere
- **Inter-institutional data sharing** becomes a configuration exercise, not a negotiation

---

## The HELIX Ecosystem

HELIX is not a single spec. It's an ecosystem of interconnected layers, each serving a different audience and a different part of the problem. Institutions adopt what they need, when they need it.

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│                        H E L I X                                │
│           Higher Education Linked Information eXchange          │
│                                                                 │
│   ┌───────────────┐  ┌───────────────┐  ┌───────────────────┐  │
│   │               │  │               │  │                   │  │
│   │  HELIX Core   │  │ HELIX Connect │  │  HELIX Govern     │  │
│   │               │  │               │  │                   │  │
│   │  The data     │  │  The API &    │  │  The governance   │  │
│   │  model.       │  │  exchange     │  │  framework.       │  │
│   │               │  │  standard.    │  │                   │  │
│   │  Canonical    │  │               │  │  Roles, rules,    │  │
│   │  resource     │  │  OpenAPI &    │  │  classification,  │  │
│   │  definitions, │  │  AsyncAPI     │  │  quality, and     │  │
│   │  terminologies│  │  specs for    │  │  maturity         │  │
│   │  & schemas.   │  │  real-time &  │  │  assessment.      │  │
│   │               │  │  bulk         │  │                   │  │
│   │               │  │  exchange.    │  │                   │  │
│   └───────────────┘  └───────────────┘  └───────────────────┘  │
│                                                                 │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │                                                         │   │
│   │                    HELIX Bridge                         │   │
│   │                                                         │   │
│   │   ERP-to-HELIX mapping accelerators.                    │   │
│   │   Pre-built transformation templates for Banner,        │   │
│   │   PeopleSoft, Workday, Colleague, and others.           │   │
│   │   The on-ramp that makes adoption real.                 │   │
│   │                                                         │   │
│   └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

| Layer | What It Is | Who It's For |
|-------|-----------|-------------|
| **HELIX Core** | Canonical resource definitions (JSON Schema), terminology code sets, and relationship models | Data architects, data engineers, analytics teams |
| **HELIX Connect** | OpenAPI and AsyncAPI specifications for real-time and bulk data exchange between systems | Integration engineers, application developers, ERP teams |
| **HELIX Govern** | Governance templates: domain taxonomy, role definitions, data classification, quality rule libraries, lineage standards | CDOs, data stewards, compliance officers, institutional research |
| **HELIX Bridge** | ERP-specific mapping templates that transform source system data into HELIX Core resources | Implementation teams, system integrators, consultants |

Each layer is independently adoptable. An institution can start with **HELIX Core** (just the data model) and never touch the others. Or they can go all-in across the ecosystem. The layers reinforce each other but don't require each other.

---

## Design Principles

1. **Spec over software.** HELIX is a standard, not a product. It defines the shape of data, not how to store or query it.

2. **80/20 pragmatism.** Start with the most common, most exchanged data domains. Cover the 80% that's universal. Let extensions handle the 20% that's institution-specific.

3. **Technology-neutral at the spec layer.** Core resources are defined in JSON Schema. They don't assume a storage format, query engine, or cloud provider.

4. **Platform-aware at the implementation layer.** Publish generators and templates for current technologies (Apache Iceberg, dbt, Parquet, OpenAPI) so institutions have a fast on-ramp. These are regenerable and disposable as technology evolves.

5. **Developer-friendly.** JSON + REST + schemas that any web developer can read. No proprietary tooling required.

6. **Governance-native.** Every resource carries metadata: ownership, classification, quality rules, lineage expectations. Governance isn't a bolt-on; it's woven into the DNA.

7. **Evolutionary by design.** Versioned spec releases. Schema evolution (via Iceberg) means upgrading doesn't require data rewrites. Extensions don't break the core.

8. **Globally scoped, locally profiled.** The base spec is international. Country- and system-specific constraints live in Implementation Profiles (US, UK, AU, EU, etc.).

---

## Future-Proofing Architecture

HELIX separates what's durable from what's disposable:

```
┌─────────────────────────────────────────────────────────────┐
│                    DURABLE SPEC LAYER                       │
│               (designed to last 15-20+ years)               │
│                                                             │
│    HELIX Core          HELIX Govern       HELIX Connect     │
│    JSON Schema         Role definitions   OpenAPI/AsyncAPI  │
│    resources           Quality rules      endpoint specs    │
│    Terminologies       Classification     event schemas     │
│                        Maturity model                       │
└───────────────────────────┬─────────────────────────────────┘
                            │
                     Auto-generated
                            │
┌───────────────────────────▼─────────────────────────────────┐
│                 REGENERABLE IMPLEMENTATION LAYER             │
│            (evolves with technology, 3-5 year cycles)        │
│                                                             │
│    Iceberg DDL    dbt model stubs    Validation suites      │
│    Parquet schemas   Metric definitions   Cloud bindings    │
│                                                             │
│                       HELIX Bridge                          │
│    Banner mappings   PeopleSoft mappings   Workday mappings │
└─────────────────────────────────────────────────────────────┘
```

The spec defines **what** the data looks like. The implementation layer handles **how** it's stored and moved. Today that's Apache Iceberg + Parquet + dbt. In five years it might be something else. The generators change; the spec doesn't.

| Layer | Expected Lifespan | Why |
|-------|-------------------|-----|
| JSON Schema resource definitions | 15-20+ years | Describes concepts, not technology |
| Terminology code sets | 10-15 years | Enrollment statuses don't change fast |
| OpenAPI / AsyncAPI specs | 10+ years | REST/HTTP isn't going anywhere |
| Apache Iceberg table format | 5-10 years | Current best bet, massive industry momentum |
| dbt / engine-specific code | 3-5 years | Tools churn, but they're generated, not hand-written |
| Specific cloud service bindings | 2-3 years | AWS/Azure/GCP SDKs evolve constantly |

---

## HELIX Core: First Canonical Resources (v0.1)

### Scope

HELIX Core v0.1 focuses on the domains that every institution shares and that cause the most integration pain:

| Domain | Key Resources | Why First |
|--------|--------------|-----------|
| **Student Identity** | `Student`, `Person`, `Identifier` | Foundation. Everything references a student. |
| **Academic Structure** | `Institution`, `AcademicOrg`, `Program`, `Course`, `CourseSection` | Defines what's offered. |
| **Enrollment** | `Enrollment`, `Registration`, `AcademicPeriod` | Highest-volume transactional domain. |
| **Financial Aid** | `FinAidAward`, `FinAidApplication`, `Disbursement` | Most regulated, most painful to integrate. |
| **Outcomes** | `Degree`, `GradeRecord`, `Credential` | The "so what." What institutions ultimately measure. |

Later versions: HR/workforce, research administration, advancement/alumni, finance/GL, facilities.

---

### Resource: `Student`

The core identity resource. Represents a person in their capacity as a learner at an institution.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "HELIX Student Resource",
  "description": "A person enrolled or admitted at a higher education institution.",
  "type": "object",
  "required": ["helix_id", "institution_id", "identifiers", "status"],
  "properties": {
    "helix_id": {
      "type": "string",
      "format": "uuid",
      "description": "Globally unique HELIX identifier"
    },
    "institution_id": {
      "type": "string",
      "description": "HELIX identifier for the institution (references Institution resource)"
    },
    "identifiers": {
      "type": "array",
      "description": "All known identifiers for this student across systems",
      "items": {
        "type": "object",
        "properties": {
          "system": {
            "type": "string",
            "description": "Source system (e.g., 'banner', 'peoplesoft', 'national_id')"
          },
          "value": { "type": "string" },
          "type": {
            "type": "string",
            "enum": ["institutional_id", "national_id", "ssn_last4", "login", "other"]
          }
        }
      }
    },
    "name": {
      "type": "object",
      "properties": {
        "family": { "type": "string" },
        "given": { "type": "string" },
        "middle": { "type": "string" },
        "prefix": { "type": "string" },
        "suffix": { "type": "string" },
        "preferred": { "type": "string" }
      }
    },
    "birth_date": { "type": "string", "format": "date" },
    "gender": {
      "type": "string",
      "description": "Bound to HELIX terminology: helix/gender"
    },
    "status": {
      "type": "string",
      "description": "Current lifecycle status. Bound to HELIX terminology: helix/student-status",
      "enum": [
        "prospective", "applicant", "admitted", "enrolled",
        "leave_of_absence", "withdrawn", "graduated", "deceased"
      ]
    },
    "first_generation_flag": { "type": "boolean" },
    "citizenship_country": { "type": "string", "format": "iso-3166-1-alpha-2" },
    "residency": {
      "type": "string",
      "enum": ["in_state", "out_of_state", "international", "unknown"]
    },
    "demographics": {
      "type": "object",
      "description": "Extension point for institution- or country-specific demographic attributes"
    },
    "meta": {
      "type": "object",
      "description": "HELIX metadata block — present on every resource",
      "properties": {
        "version": { "type": "integer" },
        "created_at": { "type": "string", "format": "date-time" },
        "updated_at": { "type": "string", "format": "date-time" },
        "source_system": { "type": "string" },
        "data_owner": { "type": "string" },
        "classification": {
          "type": "string",
          "enum": ["public", "internal", "confidential", "restricted"]
        }
      }
    }
  }
}
```

**Design notes:** The `identifiers` array handles the cross-system key problem (Banner PIDM, PeopleSoft EmplID, Workday Student ID). The `status` enum forces lifecycle consistency. The `meta` block embeds governance at the resource level. The `demographics` extension point lets institutions or country profiles add attributes without altering the core.

---

### Resource: `AcademicPeriod`

Time is the connective tissue of higher ed data. Every enrollment, grade, and financial aid record references a term.

```json
{
  "title": "HELIX AcademicPeriod Resource",
  "description": "A defined period of academic activity (term, semester, quarter, session).",
  "type": "object",
  "required": [
    "helix_id", "institution_id", "period_type",
    "code", "start_date", "end_date"
  ],
  "properties": {
    "helix_id": { "type": "string", "format": "uuid" },
    "institution_id": { "type": "string" },
    "period_type": {
      "type": "string",
      "enum": [
        "semester", "quarter", "trimester", "session",
        "mini_term", "academic_year", "other"
      ]
    },
    "code": {
      "type": "string",
      "description": "Institution's native term code (e.g., '202610', 'Fall 2026')"
    },
    "name": { "type": "string" },
    "academic_year": {
      "type": "string",
      "description": "Academic year in YYYY-YYYY format (e.g., '2026-2027')"
    },
    "start_date": { "type": "string", "format": "date" },
    "end_date": { "type": "string", "format": "date" },
    "census_date": { "type": "string", "format": "date" },
    "is_active": { "type": "boolean" },
    "meta": { "$ref": "#/definitions/helix_meta" }
  }
}
```

**Design notes:** Term definitions are the #1 source of mismatch in cross-institutional analytics. Banner's term codes (YYYYMM), PeopleSoft's STRM, and Workday's academic periods all encode time differently. HELIX normalizes them into a shared shape while preserving the native code for traceability.

---

### Resource: `Enrollment`

The transactional heart of the framework. Connects a student to a course section in a term.

```json
{
  "title": "HELIX Enrollment Resource",
  "description": "A student's registration in a specific course section during an academic period.",
  "type": "object",
  "required": [
    "helix_id", "student_ref", "course_section_ref",
    "academic_period_ref", "enrollment_status"
  ],
  "properties": {
    "helix_id": { "type": "string", "format": "uuid" },
    "student_ref": {
      "type": "string",
      "description": "HELIX ID of the Student resource"
    },
    "course_section_ref": {
      "type": "string",
      "description": "HELIX ID of the CourseSection resource"
    },
    "academic_period_ref": {
      "type": "string",
      "description": "HELIX ID of the AcademicPeriod resource"
    },
    "enrollment_status": {
      "type": "string",
      "enum": [
        "registered", "waitlisted", "enrolled", "dropped",
        "withdrawn", "completed", "incomplete", "auditing"
      ]
    },
    "enrollment_date": { "type": "string", "format": "date" },
    "drop_date": { "type": "string", "format": "date" },
    "credit_hours_attempted": { "type": "number" },
    "credit_hours_earned": { "type": "number" },
    "grade": {
      "type": "string",
      "description": "Final grade. Bound to institution's HELIX grade terminology profile."
    },
    "grade_points": { "type": "number" },
    "grade_mode": {
      "type": "string",
      "enum": [
        "standard", "pass_fail", "audit",
        "satisfactory_unsatisfactory", "other"
      ]
    },
    "repeat_flag": { "type": "boolean" },
    "meta": { "$ref": "#/definitions/helix_meta" }
  }
}
```

**Design notes:** Enrollment is the highest-volume, most-joined entity in any institutional data warehouse. This single resource shape unlocks retention analysis, enrollment reporting, credit hour production, student success modeling, and IPEDS reporting. Get this right and everything downstream benefits.

---

## HELIX Govern: Conformance Levels

Institutions adopt HELIX progressively:

| Level | Name | What It Means |
|-------|------|---------------|
| **1** | **Explorer** | Reviewing HELIX resources as a reference model for internal alignment |
| **2** | **Aligned** | Data lake silver layer maps to HELIX Core schemas; passes validation |
| **3** | **Governed** | HELIX Govern templates implemented (roles, quality rules, classification) |
| **4** | **Contributor** | Publishing ERP mappings, profiles, or extensions back to the community |
| **5** | **Champion** | Certified conformance; serving as a reference implementation site |

---

## Existing Standards: How HELIX Relates

HELIX does not replace existing standards. It fills the gap none of them cover: **the ERP-to-lake canonical data model with embedded governance.**

| Standard | Scope | HELIX Relationship |
|----------|-------|-------------------|
| **CEDS** (Common Education Data Standards) | K-20 data element dictionary | HELIX aligns terminology where possible; extends for the ERP/lake integration layer |
| **Ed-Fi** | K-12 data exchange | Covers K-12 transactional exchange; HELIX focuses on postsecondary analytics and integration |
| **PESC** (Postsecondary Electronic Standards Council) | Transcript/enrollment XML exchange | Narrow scope (transcripts, admissions); HELIX is broader |
| **1EdTech** (formerly IMS Global) | Learning tool interoperability (LTI, Caliper) | Complementary. Covers LMS, not ERP/SIS |
| **HESA** (UK) / **TCSI** (Australia) | Country-specific regulatory reporting | Natural candidates for HELIX Implementation Profiles |
| **FHIR** (HL7) | Healthcare interoperability | Architectural inspiration, not a competitor |

---

## What's Next

- [ ] Community review of this founding charter
- [ ] Refine first 5 HELIX Core resources (add `CourseSection`, `FinAidAward`)
- [ ] Draft the first HELIX Bridge template (Banner-to-HELIX)
- [ ] Define HELIX Core terminology code sets (enrollment status, student status, period type)
- [ ] Draft the HELIX Connect OpenAPI spec for a conformant server
- [ ] Sketch the HELIX Govern maturity assessment framework
- [ ] Establish GitHub repo structure and contribution guidelines
- [ ] Identify 3-5 institutional champions for early feedback

---

## About the Founder

**Dallas Maddox** created HELIX from a straightforward observation: after years of working with higher education institutions on data modernization, the same integration patterns and the same governance gaps appeared everywhere, regardless of institution size, ERP vendor, or geography. The work to solve these problems was being duplicated thousands of times across the world, at enormous cost, with no shared benefit.

HELIX is an open, philanthropic effort. It is not a product, not a consultancy, and not owned by any vendor. It belongs to the higher education community.

The double helix is a fitting metaphor. Two strands, data and governance, wound together into a structure that carries the blueprint for something larger. HELIX is the blueprint. What the global higher education community builds from it is the point.

---

*HELIX v0.1 Draft — August 2026*
*Licensed under Apache 2.0*
