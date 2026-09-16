# HELIX

### Higher Education Linked Information eXchange

> What if every university spoke the same data language?

HELIX is an open framework of foundational data models, governance standards, and ERP mapping templates that eliminate integration friction in higher education — worldwide.

---

**Founded by:** Dallas Maddox
**Version:** 0.3.2 (September 2026)
**License:** Apache 2.0

--- 

## The Problem

Every university runs some version of the same core data domains: students, courses, enrollment, financial aid, HR, research, and advancement. Yet every ERP migration, every data lake build, and every analytics modernization project treats the mapping of these domains as a bespoke engineering effort.

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
  |   | 47 resources,   |  | standard.       |  |               | |
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
| **HELIX Core** | 47 foundational resource definitions (JSON Schema), 23 terminology code sets, and a comprehensive glossary | Data architects, data engineers, analytics teams |
| **HELIX Connect** | OpenAPI 3.1 spec with 16 REST endpoints for real-time and bulk data exchange | Integration engineers, application developers |
| **HELIX Govern** | Governance roles, quality rule library (22 rules), maturity model, domain taxonomy | CDOs, data stewards, compliance officers |
| **HELIX Bridge** | ERP-specific mapping templates: PeopleSoft (42), Banner (13), Workday (42), Colleague (3) — 100 total | Implementation teams, system integrators |

---

## HELIX Core: Resources (v0.2)

47 foundational resources across 9 domains:

| Domain | Resources |
|--------|-----------|
| **Identity** | `Person`, `Student`, `Institution` |
| **Academic Structure** | `AcademicOrg`, `Course`, `CourseSection`, `Program`, `AcademicPeriod` |
| **Enrollment & Registration** | `Enrollment`, `StudentProgram`, `AdmissionApplication`, `TransferCredit`, `AcademicTermRecord` |
| **Financial Aid** | `FinAidAward` |
| **Outcomes** | `Degree`, `DegreeAudit` |
| **Student Services** | `Hold`, `FERPARestriction`, `InternationalStudent`, `StudentGroup` |
| **Advancement** | `Constituent`, `Gift`, `Campaign`, `EngagementActivity` |
| **Human Resources** | `Employee`, `Position`, `Compensation`, `BenefitEnrollment`, `PayrollResult`, `TimeEntry`, `Requisition`, `AbsenceRecord`, `PerformanceReview`, `JobClassification`, `LearningRecord`, `PositionBudget` |
| **Financial Operations** | `GLTransaction`, `APVoucher`, `ARTransaction`, `Budget`, `PurchaseOrder`, `Grant`, `Asset`, `ExpenseReport`, `Contract`, `Fund`, `FinancialOrg` |

Each resource includes a `meta` block with embedded governance: version, source system, data owner, and classification level.

See the [Resource Catalog](docs/resource-catalog.md) for full attribute details.

## HELIX Core: Glossary

A 113,000-character comprehensive taxonomy covering the complete student lifecycle (web visitor through alumni/donor), all student types, the full administrative infrastructure (Business Affairs/Bursar, Grants Management, HR, Registrar, Academic Structure & Governance), auxiliary services, a deep dive on athletics (NCAA structure, compliance, NIL, APR, Title IX, financial structure), a deep dive on advancement and alumni relations (gift types, campaigns, stewardship, endowment, prospect research, moves management, annual fund), and information technology and institutional research.

See the [Glossary](core/glossary.md) for the full reference.

## HELIX Core: Terminologies (v0.2)

48 standardized code sets across student lifecycle, human resources, and financial operations:

**Student Lifecycle (23):** `student-status` · `enrollment-status` · `period-type` · `grade-mode` · `award-type` · `data-classification` · `gender` · `gender-identity` · `ethnicity` · `identifier-type` · `degree-level` · `delivery-mode` · `course-level` · `admission-status` · `hold-type` · `student-type` · `veteran-status` · `sap-status` · `constituent-type` · `gift-type` · `donor-segment` · `prospect-stage` · `enrollment-funnel-stage`

**Human Resources (14):** `worker-type` · `employment-status` · `position-status` · `compensation-type` · `benefit-plan-type` · `pay-frequency` · `absence-type` · `requisition-status` · `performance-rating` · `faculty-rank` · `tenure-status` · `eeo-category` · `flsa-status` · `learning-type`

**Financial Operations (11):** `transaction-type` · `payment-status` · `budget-status` · `purchase-order-status` · `grant-status` · `asset-status` · `asset-category` · `expense-status` · `contract-status` · `fund-type` · `account-type`

See the [Terminology Catalog](docs/terminology-catalog.md) for every valid code and definition.

## HELIX Bridge: ERP Mappings

Column-level mapping templates from 4 major ERP systems:

| ERP | Architecture | Mappings | Coverage |
|-----|-------------|----------|----------|
| **Oracle PeopleSoft** | Relational, effective-dated | **42 mappings** across CS (19), FIN (11), HCM (12) | 96-100% parity with Workday |
| **Ellucian Banner** | Relational (Oracle) | **13 mappings** across SIS (11), HR (2) | Core + extended SIS |
| **Workday** | Cloud-native (REST/business objects) | **42 mappings** across SIS (19), FIN (11), HR (12) | 96-100% parity with PeopleSoft |
| **Ellucian Colleague** | Multi-valued (UniData/UniVerse) | 3 mappings | Core SIS resources |

PeopleSoft and Workday are the two deepest Bridges with 42 mappings each and near-perfect parity across all three modules: SIS 100%, FIN 96%, HCM 100%. Every PeopleSoft resource has a matching Workday target and vice versa. PeopleSoft mappings include full PS table/record references (69 FIN source tables, 60 HCM source tables) so data engineers know exactly which PS tables to query. Workday mappings include source object inventories and 4 documented extraction methods (RaaS, REST API, Prism, Data Cloud).

See the [Bridge Reference](docs/bridge-reference.md) and [Migration Adventure Guide](docs/migration-adventure-guide.md) for details.

## HELIX Govern

| Component | Contents |
|-----------|----------|
| **Roles** | 6 governance roles (Data Trustee, CDO, Data Steward, Data Custodian, Data Consumer, HELIX Champion) with RACI matrix |
| **Quality Rules** | 22 rules across 5 domains with severity, testable expressions, and remediation |
| **Maturity Model** | 5 dimensions × 5 levels, aligned to conformance levels |
| **Maturity Scorecard** | Fillable self-assessment scorecard with evidence fields and priority actions per dimension |
| **Domain Taxonomy** | 9 data domains with steward assignments and regulatory context |
| **RACI Matrix** | 18 activities × 5 roles with Responsible/Accountable/Consulted/Informed assignments |
| **Classification Handling** | 4 tiers (Public, Internal, Confidential, Restricted) with encryption, access, audit, masking, retention, and disposal rules — FERPA and GLBA specific |
| **GLBA Safeguards Framework** | All 9 FTC Safeguards Rule elements (16 CFR 314) mapped to Bronze/Silver/Gold controls: Qualified Individual, risk assessment, access controls, encryption, MFA, monitoring, disposal, incident response, annual board report |
| **FERPA Disclosure Framework** | Disclosure-basis enforcement for 99.31(a)(1) legitimate interest, (a)(6) studies, and (a)(11) directory information; Bronze→Silver identity resolution; per-row FERPA flag model (embedded as `meta.ferpa_flags` on all 14 education-record resources) and canonical enforcement views |
| **Committee Charter** | Fillable charter template for Data Governance Council with membership roles, cadence, responsibilities, and success metrics |
| **Data Sharing Agreement** | Template with FERPA/GLBA provisions, security requirements, breach notification, and audit rights |
| **Schema Evolution Policy** | Versioning rules (MAJOR.MINOR.PATCH), backward compatibility guarantees, deprecation process, and institutional extension patterns |
| **Data Dictionary** | 1,258-entry structured dictionary (JSON + CSV) covering all 47 resources — importable into Collibra, Alation, Atlan, Purview, AWS Glue |
| **GLBA Compliance Scanner** | 21 executable audit rules across 7 categories (encryption at rest/in transit, access control, data inventory, monitoring, disposal, service-provider oversight) with platform-specific SQL and a 10-section annual board report template per 16 CFR 314.4(i) |
| **FERPA Suppression Policy** | 8 small-cell suppression rules (primary N<5, complementary, rate, dominance, cross-tab depth, longitudinal, rounding, derived-metric) with a `helix_suppress()` SQL function, complementary-suppression CTE, dbt macro, and 6 IPEDS survey guides |
| **Lakehouse RBAC Model** | 9 database roles mapped to governance roles across Bronze/Silver/Gold, 3 column-masking policies, 5 row-level-security patterns, grant lifecycle, and 5 platform guides (Snowflake, Databricks Unity Catalog, AWS Lake Formation, Redshift, BigQuery) |
| **Access Control Matrix** | Enforceable truth table: 9 roles × 3 layers across all 47 resources, 11 column-level exceptions, 8 special rules (FERPA directory, GLBA, HR restricted, steward scoping, research de-identification, admin separation of duties) |
| **Agent Guardrails** | AI agent & NLQ governance: 5 core principles, 4 classification-tier rules, 7 prohibited query patterns, 3 architecture patterns (text-to-SQL, RAG, tool-calling), 5 output filters, 21-field audit schema, 12-step implementation checklist |

See the [Govern Overview](docs/govern-overview.md) for details.

## HELIX Connect (v0.2)

OpenAPI 3.1 spec with 51 endpoints across student, financial, and HR resources:

| Category | Endpoints | OAuth Scope |
|----------|-----------|-------------|
| **Student & Academic** | 16 endpoints (resources, enrollment, financial aid, bulk export, validation) | `helix:read`, `helix:read:confidential`, `helix:read:restricted` |
| **Financial Operations** | 23 endpoints (GL, AP, AR, budgets, POs, grants, assets, expenses, contracts, funds) | `helix:read:financial` |
| **Human Resources** | 12 endpoints (employees, positions, requisitions, time, absence, job classification) | `helix:read:hr`, `helix:read:hr:restricted` |

See the [Connect Overview](docs/connect-overview.md) for the full API reference.

## HELIX Agents: Downloadable AI Assistants

Ready-to-use AI agent templates that work with any LLM platform:

| Agent | What It Does | Best For |
|-------|-------------|----------|
| **[HELIX Migration Companion](agents/helix-migration-companion.json)** | Interactive guide to the entire HELIX framework with a 9-option menu. Combines all specialist knowledge into one conversational entry point. | Anyone starting with HELIX. Drop into ChatGPT, Gemini, Claude, Grok, Amazon Q, or Bedrock. |
| [PS-to-Workday FIN Agent](agents/ps-to-workday-fin-agent.json) | Chartfield-to-worktag mapping, GLBA guardrails, reconciliation | Finance teams migrating PeopleSoft to Workday |
| [Enrollment Analytics Agent](agents/enrollment-analytics-agent.json) | Funnel analysis, marketing ROI, melt prediction, interventions | Enrollment management and student success |
| [Advancement & Donor Agent](agents/advancement-donor-agent.json) | Stewardship acceleration, prospect identification, event briefings | Advancement and fundraising teams |
| [Banner-to-Lakehouse Agent](agents/banner-to-lakehouse-agent.json) | PIDM handling, STV lookups, dbt model generation | Banner institutions building data lakes |

**Setup:** Copy the `system_prompt` field from any agent JSON into your platform's system prompt / custom instructions. Upload the HELIX repository (or relevant files) as knowledge. Each agent template includes platform-specific setup guides for ChatGPT, Gemini, Claude, Grok, Amazon Q, and Bedrock.

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

## Repository Structure (299 files)

```
helix/
+-- README.md                          <-- You are here
+-- CONTRIBUTING.md                    <-- How to participate
+-- core/
|   +-- resources/                     <-- 47 JSON Schema resource definitions
|   +-- terminologies/                 <-- 48 standardized code sets (student, HR, FIN)
|   +-- glossary.md                    <-- Comprehensive higher ed taxonomy (113K chars, 125 terms)
|   +-- data-dictionary.json           <-- 1,258-entry structured data dictionary
|   +-- data-dictionary.csv            <-- Same dictionary in spreadsheet format
|   +-- examples/                      <-- 3 post-migration use case examples
+-- connect/
|   +-- openapi.json                   <-- OpenAPI 3.1 spec (51 endpoints, v0.2)
+-- govern/
|   +-- roles.json                     <-- Governance role definitions
|   +-- quality-rules.json             <-- Data quality rule library (22 rules)
|   +-- maturity-model.json            <-- 5-dimension maturity assessment
|   +-- maturity-assessment-scorecard.json  <-- Fillable self-assessment
|   +-- domain-taxonomy.json           <-- 9 data domains with steward assignments
|   +-- raci-matrix.json               <-- 18 activities x 5 roles (R/A/C/I)
|   +-- classification-handling-rules.json  <-- 4-tier handling (FERPA/GLBA)
|   +-- governance-committee-charter.json   <-- Council charter template
|   +-- data-sharing-agreement-template.json <-- DSA with FERPA/GLBA
|   +-- schema-evolution-policy.json   <-- Versioning + extension rules
|   +-- glba-safeguards-framework.json <-- FTC Safeguards Rule (16 CFR 314) — policy
|   +-- glba-compliance-scanner.json   <-- 21 executable audit rules + board report
|   +-- ferpa-disclosure-framework.json <-- 99.31(a)(1)/(6)/(11) enforcement — policy
|   +-- ferpa-suppression-policy.json  <-- Small-cell suppression (N<5) + helix_suppress()
|   +-- lakehouse-rbac-model.json      <-- 9 DB roles, masking, RLS, platform guides
|   +-- access-control-matrix.json     <-- Role x Resource x Layer truth table (47 resources)
|   +-- agent-guardrails.json          <-- AI agent & NLQ guardrails
+-- bridge/
|   +-- peoplesoft/                    <-- Oracle PeopleSoft mappings (42)
|   |   +-- cs/                        <-- Campus Solutions / SIS (19)
|   |   +-- fin/                       <-- Financials / FSCM (11)
|   |   +-- hcm/                       <-- Human Capital Management (12)
|   +-- banner/                        <-- Ellucian Banner mappings (13)
|   |   +-- sis/                       <-- Student Information System (11)
|   |   +-- hr/                        <-- Human Resources (2)
|   +-- workday/                       <-- Workday mappings (42)
|   |   +-- sis/                       <-- Student Information System (19)
|   |   +-- fin/                       <-- Financial Management (11)
|   |   +-- hr/                        <-- Human Capital Management (12)
|   +-- colleague/                     <-- Ellucian Colleague mappings (3)
|   +-- xref/                          <-- Machine-readable cross-references
|       +-- ps-to-workday-fin/         <-- 4 dimensions, JSON + CSV
|           +-- account-xref.*         <-- 31 account mappings
|           +-- fund-xref.*            <-- 14 fund mappings
|           +-- department-xref.*      <-- 15 dept/cost center mappings
|           +-- program-xref.*         <-- 12 functional classifications
+-- templates/
|   +-- dbt/                           <-- dbt starter project (27 files)
|   |   +-- dbt_project.yml            <-- Project configuration
|   |   +-- profiles.yml.example       <-- Snowflake/Redshift/Databricks/BigQuery
|   |   +-- packages.yml              <-- dbt-utils, dbt-expectations
|   |   +-- models/staging/            <-- Bronze -> Staging (5 models)
|   |   +-- models/silver/             <-- Staging -> HELIX Core (5 models)
|   |   +-- models/gold/               <-- Silver -> Consumption (4 models)
|   |   +-- macros/                    <-- HELIX UUID, classification, FERPA-safe views
|   |   +-- tests/                     <-- Quality rules from govern/quality-rules.json
|   |   +-- seeds/                     <-- All 48 terminology code sets as CSV
|   +-- reconciliation/                <-- Post-migration validation queries (10)
|       +-- row_count_reconciliation.sql
|       +-- financial_balance_reconciliation.sql
|       +-- enrollment_headcount_reconciliation.sql
|       +-- student_record_completeness.sql
|       +-- cross_system_identity_match.sql
|       +-- financial_aid_disbursement_reconciliation.sql
|       +-- grade_distribution_reconciliation.sql
|       +-- duplicate_detection.sql
|       +-- data_freshness_check.sql
+-- agents/                            <-- Downloadable AI assistant templates
|   +-- helix-migration-companion.json <-- START HERE: unified guide
|   +-- ps-to-workday-fin-agent.json
|   +-- enrollment-analytics-agent.json
|   +-- advancement-donor-agent.json
|   +-- banner-to-lakehouse-agent.json
+-- tools/
|   +-- validate.py                    <-- Schema validation (JSON/NDJSON/CSV)
+-- docs/
    +-- helix-executive-summary.md     <-- One-pager for CIOs and leadership
    +-- cdo-quick-start.md             <-- 90-day governance quickstart guide
    +-- resource-catalog.md
    +-- terminology-catalog.md
    +-- bridge-reference.md
    +-- govern-overview.md
    +-- connect-overview.md
    +-- migration-adventure-guide.md        <-- "Choose your own adventure"
    +-- lakehouse-architecture-guide.md     <-- Medallion, FERPA/GLBA
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

**New CDO?** Read the [CDO Quick Start Guide](docs/cdo-quick-start.md) for a 90-day governance implementation plan.

**Briefing leadership?** Share the [Executive Summary](docs/helix-executive-summary.md) — a non-technical one-pager for CIOs, provosts, and presidents.

**Validating your data?** Use the [validation script](tools/validate.py) to check JSON, NDJSON, or CSV files against HELIX schemas.

**Building a dbt project?** Clone the [dbt starter](templates/dbt/) — pre-built staging, silver, and gold models with HELIX quality rules as tests and a FERPA-safe view macro.

**Reconciling after migration?** Use the [reconciliation queries](templates/reconciliation/) — 10 SQL templates covering row counts, financial balances, enrollment headcounts, identity matching, and data freshness.

**Contribute:** Read [CONTRIBUTING.md](CONTRIBUTING.md) and open an issue or pull request

---

## About the Founder

**Dr. Dallas Maddox, PhD** created HELIX from years spent at the intersection of higher education and technology. With doctoral research focused on the systems and structures that power colleges and universities, Dallas saw the same pattern repeat at every institution: brilliant people solving the same data problems in isolation, duplicating millions of dollars in integration work with no shared benefit and no shared language.

HELIX exists because higher education deserves better tools — tools that accelerate innovation instead of consuming it, tools that free institutions to focus on what actually matters: the student experience, groundbreaking research, and community impact.

At its core, HELIX is about the human element. Behind every data record is a student navigating their future, a faculty member advancing knowledge, a financial aid counselor changing someone's life trajectory, a donor investing in a mission they believe in. The data infrastructure we build should honor that reality — not obscure it beneath layers of technical complexity. When we eliminate the friction of data integration, we give people back the time and clarity to do the work that drew them to higher education in the first place.

HELIX is an open, philanthropic effort. It is not a product, not a consultancy, and not owned by any vendor. It belongs to the higher education community.

The double helix is a fitting metaphor. Two strands — data and governance — wound together into a structure that carries the blueprint for something larger. HELIX is the blueprint.

---

*HELIX v0.3.2 — September 2026*
*Licensed under Apache 2.0*
