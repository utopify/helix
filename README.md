# HELIX

### Higher Education Linked Information eXchange

> What if every university spoke the same data language?

HELIX is an open framework of foundational data models, governance standards, and ERP mapping templates that eliminate integration friction in higher education, worldwide.

---

**Founded by:** Dallas Maddox
**Version:** 0.1 (August 2026)
**License:** Apache 2.0

---

## The Problem

Every university on the planet runs some version of the same core data domains: students, courses, enrollment, financial aid, HR, research, and advancement. Yet every ERP migration, every data lake build, and every analytics modernization project treats the mapping of these domains as a bespoke engineering effort.

The mapping logic from Banner to a lakehouse is 80% identical to the mapping logic from PeopleSoft to a lakehouse. But nobody has codified that shared 80% into something reusable.

The result: billions of dollars spent globally on redundant integration work, inconsistent definitions that erode trust in institutional data, and an inability to benchmark or collaborate across institutions because everyone speaks a different data dialect.

## The Vision

HELIX provides higher education with a shared, open, technology-neutral vocabulary of linked data objects that any system can produce, consume, and trust.

When an institution adopts HELIX:

- **ERP choice becomes an implementation detail**, not an architecture-defining constraint
- **Data lake ingestion is pre-mapped**, not hand-built from scratch
- **Analytics and AI models are portable** across institutions
- **Data governance has a shared vocabulary**, so "enrolled student" means the same thing everywhere
- **Inter-institutional data sharing** becomes a configuration exercise, not a negotiation

---

## The HELIX Ecosystem

HELIX is not a single spec. It's an ecosystem of interconnected layers, each serving a different audience and a different part of the problem.

```
  +===============================================================+
  |                                                               |
  |                        H E L I X                              |
  |          Higher Education Linked Information eXchange         |
  |                                                               |
  |   +-----------------+  +-----------------+  +---------------+ |
  |   | HELIX Core      |  | HELIX Connect   |  | HELIX Govern  | |
  |   |                 |  |                 |  |               | |
  |   | The data model. |  | The API &       |  | The governance| |
  |   |                 |  | exchange        |  | framework.    | |
  |   | 19 resources,   |  | standard.       |  |               | |
  |   | 23 terminology  |  |                 |  | Roles, rules, | |
  |   | code sets.      |  | 16 REST endpts, |  | quality, and  | |
  |   |                 |  | bulk export,    |  | maturity      | |
  |   |                 |  | validation.     |  | assessment.   | |
  |   +-----------------+  +-----------------+  +---------------+ |
  |                                                               |
  |   +---------------------------------------------------------+ |
  |   | HELIX Bridge                                            | |
  |   |                                                         | |
  |   | ERP-to-HELIX mapping accelerators for Banner,           | | 
  |   | PeopleSoft, Workday, and Colleague.                     | |
  |   +---------------------------------------------------------+ |
  |                                                               |
  +===============================================================+
```

| Layer | What It Is | Who It's For |
|-------|-----------|-------------|
| **HELIX Core** | 19 foundational resource definitions (JSON Schema), 23 terminology code sets, and a comprehensive glossary | Data architects, data engineers, analytics teams |
| **HELIX Connect** | OpenAPI 3.1 spec with 16 REST endpoints for real-time and bulk data exchange | Integration engineers, application developers |
| **HELIX Govern** | Governance roles, quality rule library (22 rules), maturity model, domain taxonomy | CDOs, data stewards, compliance officers |
| **HELIX Bridge** | ERP-specific mapping templates: PeopleSoft (40), Banner (13), Workday (3), Colleague (3) — 59 total | Implementation teams, system integrators |

---

## HELIX Core: Resources (v0.1)

19 foundational resources across 7 domains:

| Domain | Resources |
|--------|-----------|
| **Identity** | `Person`, `Student`, `Institution` |
| **Academic Structure** | `AcademicOrg`, `Course`, `CourseSection`, `Program`, `AcademicPeriod` |
| **Enrollment & Registration** | `Enrollment`, `StudentProgram`, `AdmissionApplication`, `TransferCredit` |
| **Financial Aid** | `FinAidAward` |
| **Outcomes** | `Degree` |
| **Student Services** | `Hold` |
| **Advancement** | `Constituent`, `Gift`, `Campaign`, `EngagementActivity` |

Each resource includes a `meta` block with embedded governance: version, source system, data owner, and classification level.

See the [Resource Catalog](docs/resource-catalog.md) for full attribute details.

## HELIX Core: Glossary

A 34,000-word comprehensive taxonomy covering the complete student lifecycle (web visitor through alumni/donor), all student types (workers, athletes, international, first-gen, veteran), the administrative infrastructure (registrar, student financial services, FERPA, GLBA), and the full faculty taxonomy (10 employment types, 9 academic ranks, tenure system, IPEDS faculty categories).

See the [Glossary](core/glossary.md) for the full reference.

## HELIX Core: Terminologies (v0.1)

23 standardized code sets that eliminate "what does this code mean?" across institutions:

`student-status` · `enrollment-status` · `period-type` · `grade-mode` · `award-type` · `data-classification` · `gender` · `gender-identity` · `ethnicity` · `identifier-type` · `degree-level` · `delivery-mode` · `course-level` · `admission-status` · `hold-type` · `student-type` · `veteran-status` · `sap-status` · `constituent-type` · `gift-type` · `donor-segment` · `prospect-stage` · `enrollment-funnel-stage`

See the [Terminology Catalog](docs/terminology-catalog.md) for every valid code and definition.

## HELIX Bridge: ERP Mappings

Column-level mapping templates from 4 major ERP systems:

| ERP | Architecture | Mappings | Coverage |
|-----|-------------|----------|----------|
| **Oracle PeopleSoft** | Relational, effective-dated | **40 mappings** across CS (19), FIN (9), HCM (12) | 80-83% per module |
| **Ellucian Banner** | Relational (Oracle) | **13 mappings** across SIS (11), HR (2) | Core + extended SIS |
| **Workday Student** | Cloud-native (REST/business objects) | 3 mappings | Core SIS resources |
| **Ellucian Colleague** | Multi-valued (UniData/UniVerse) | 3 mappings | Core SIS resources |

PeopleSoft is the deepest Bridge — 40 mappings covering Student Records, Financial Aid, Admissions, Degree Audit, International/SEVIS, FERPA, General Ledger, AP, AR, Purchasing, Budgets, Grants, Assets, Expenses, Contracts, Core HR, Position Management, Compensation, Benefits, Payroll, Time & Labor, Recruiting, Absence/FMLA, Performance, Job Classification, Position Budgeting, and Learning Management.

See the [Bridge Reference](docs/bridge-reference.md) and [Migration Adventure Guide](docs/migration-adventure-guide.md) for details.

## HELIX Govern

| Component | Contents |
|-----------|----------|
| **Roles** | 6 governance roles (Data Trustee, CDO, Data Steward, Data Custodian, Data Consumer, HELIX Champion) |
| **Quality Rules** | 22 rules across 5 domains with severity, testable expressions, and remediation guidance |
| **Maturity Model** | 5 dimensions × 5 levels, aligned to HELIX conformance levels |
| **Domain Taxonomy** | 9 data domains with steward assignments and regulatory context |

See the [Govern Overview](docs/govern-overview.md) for details.

## HELIX Connect

OpenAPI 3.1 spec with 16 endpoints covering all core resources, bulk export (NDJSON + Parquet), resource validation, and OAuth 2.0 security with classification-aware scopes.

See the [Connect Overview](docs/connect-overview.md) for the full API reference.

---

## Conformance Levels

Institutions adopt HELIX progressively:

| Level | Name | What It Means |
|-------|------|---------------|
| **1** | **Explorer** | Reviewing HELIX resources as a reference model |
| **2** | **Aligned** | Data lake silver layer maps to HELIX Core schemas; passes validation |
| **3** | **Governed** | HELIX Govern templates implemented (roles, quality rules, classification) |
| **4** | **Contributor** | Publishing ERP mappings, profiles, or extensions back to the community |
| **5** | **Champion** | Certified conformance; serving as a reference implementation site |

---

## Design Principles

1. **Spec over software.** HELIX is a standard, not a product.
2. **80/20 pragmatism.** Cover the universal 80%. Let extensions handle the rest.
3. **Technology-neutral at the spec layer.** JSON Schema. No vendor lock-in.
4. **Platform-aware at the implementation layer.** Generators for Iceberg, dbt, Parquet, OpenAPI.
5. **Developer-friendly.** JSON + REST. Any web developer can implement it.
6. **Governance-native.** Every resource carries classification, ownership, and quality metadata.
7. **Evolutionary by design.** Versioned releases. Schema evolution without data rewrites.
8. **Globally scoped, locally profiled.** Base spec is international. Country profiles handle the rest.

---

## Existing Standards: How HELIX Relates

| Standard | Scope | HELIX Relationship |
|----------|-------|-------------------|
| **CEDS** | K-20 data element dictionary | HELIX aligns terminology; extends for ERP/lake integration |
| **Ed-Fi** | K-12 data exchange | Complementary. HELIX focuses on postsecondary. |
| **PESC** | Transcript/enrollment XML | Narrow scope. HELIX is broader. |
| **1EdTech** | Learning tool interoperability | Complementary. Covers LMS, not ERP/SIS. |
| **HESA** (UK) / **TCSI** (AU) | Country-specific reporting | Natural HELIX Implementation Profiles |

HELIX fills the gap none of them cover: **the ERP-to-lake foundational data model with embedded governance.**

---

## Repository Structure

```
helix/
├── README.md                    ← You are here
├── CONTRIBUTING.md              ← How to participate
├── core/
│   ├── resources/               ← 19 JSON Schema resource definitions
│   ├── terminologies/           ← 23 standardized code sets
│   ├── glossary.md              ← Comprehensive higher ed taxonomy (34K words)
│   └── examples/                ← 3 post-migration use case examples
├── connect/
│   └── openapi.json             ← OpenAPI 3.1 API specification
├── govern/
│   ├── roles.json               ← Governance role definitions
│   ├── quality-rules.json       ← Data quality rule library
│   ├── maturity-model.json      ← Maturity assessment framework
│   └── domain-taxonomy.json     ← Data domain taxonomy
├── bridge/
│   ├── banner/                  ← Ellucian Banner mappings (3)
│   ├── peoplesoft/              ← Oracle PeopleSoft mappings (40)
│   │   ├── cs/                  ← Campus Solutions / SIS (19)
│   │   ├── fin/                 ← Financials / FSCM (9)
│   │   └── hcm/                 ← Human Capital Management (12)
│   ├── workday/                 ← Workday Student mappings (3)
│   └── colleague/               ← Ellucian Colleague mappings (3)
└── docs/                        ← Comprehensive documentation
    ├── resource-catalog.md
    ├── terminology-catalog.md
    ├── bridge-reference.md
    ├── govern-overview.md
    ├── connect-overview.md
    ├── migration-adventure-guide.md  ← "Choose your own adventure" migration paths
    └── lakehouse-architecture-guide.md  ← Medallion architecture, FERPA/GLBA compliance
```

---

## Getting Started

**New to higher ed data?** Start with the [Glossary](core/glossary.md) for a complete walkthrough of the student lifecycle, faculty taxonomy, and institutional infrastructure.

**Migrating ERPs or building a data lake?** Start with the [Migration Adventure Guide](docs/migration-adventure-guide.md) and the [Lakehouse Architecture Guide](docs/lakehouse-architecture-guide.md).

**Explore the data model:** Browse [core/resources/](core/resources/) or read the [Resource Catalog](docs/resource-catalog.md)

**Check the terminology:** Browse [core/terminologies/](core/terminologies/) or read the [Terminology Catalog](docs/terminology-catalog.md)

**See what's possible after migration:** Browse [core/examples/](core/examples/) for real-world use cases (advancement, COA cross-reference, enrollment analytics)

**Find your ERP mapping:** Browse [bridge/](bridge/) for Banner, PeopleSoft, Workday, or Colleague

**Review governance:** Browse [govern/](govern/) or read the [Govern Overview](docs/govern-overview.md)

**See the API:** Open [connect/openapi.json](connect/openapi.json) in [Swagger Editor](https://editor.swagger.io/) or read the [Connect Overview](docs/connect-overview.md)

**Contribute:** Read [CONTRIBUTING.md](CONTRIBUTING.md) and open an issue or pull request

---

## About the Founder

**Dallas Maddox** created HELIX from a straightforward observation: after years of working with higher education institutions on data modernization, the same integration patterns and the same governance gaps appeared everywhere, regardless of institution size, ERP vendor, or geography. The work to solve these problems was being duplicated thousands of times across the world, at enormous cost, with no shared benefit.

HELIX is an open, philanthropic effort. It is not a product, not a consultancy, and not owned by any vendor. It belongs to the higher education community.

The double helix is a fitting metaphor. Two strands, data and governance, wound together into a structure that carries the blueprint for something larger. HELIX is the blueprint. What the global higher education community builds from it is the point.

---

*HELIX v0.1.5 — August 2026*
*Licensed under Apache 2.0*
