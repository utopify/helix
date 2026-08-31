# HELIX Govern: Governance Framework Overview

HELIX Govern provides the organizational, procedural, and quality management layer that makes data trustworthy.

## Components

### 1. Governance Roles (`govern/roles.json`)

6 standard roles with responsibilities, scope, and typical titles:

| Role | Scope | Purpose |
|------|-------|---------|
| **Data Trustee** | Institution | Senior executive with ultimate accountability for a data domain |
| **Chief Data Officer** | Institution | Overall data strategy, governance program, and HELIX adoption |
| **Data Steward** | Domain | Functional expert who defines and maintains data definitions and quality rules |
| **Data Custodian** | System/Technical | Technical implementation of governance policies in systems and the data lake |
| **Data Consumer** | Individual/Team | Anyone who accesses HELIX-governed data for analysis or decisions |
| **HELIX Champion** | Community | Advocate who contributes back to the open framework |

### 2. Data Quality Rule Library (`govern/quality-rules.json`)

**22 rules** across 5 domains, each with:
- Rule ID and name
- Severity level (critical, high, medium, low)
- Plain-language description
- Machine-testable expression (translatable to dbt tests, Great Expectations, SQL assertions)
- Remediation guidance

| Domain | Rules | Critical | High | Medium |
|--------|-------|----------|------|--------|
| Student Identity | 5 | 3 | 1 | 1 |
| Enrollment | 6 | 2 | 3 | 1 |
| Financial Aid | 5 | 3 | 2 | 0 |
| Academic Structure | 3 | 1 | 0 | 2 |
| Outcomes | 3 | 1 | 1 | 1 |

### 3. Maturity Model (`govern/maturity-model.json`)

5-dimension self-assessment with 5 levels each:

| Dimension | What It Measures |
|-----------|-----------------|
| Data Model & Standards | Adoption of shared data definitions |
| Governance Organization | Roles, councils, and decision processes |
| Data Quality | Systematic measurement and improvement |
| Data Classification & Security | Classification, access control, compliance |
| Data Literacy & Culture | Skills, decision-making, governance culture |

Levels align to HELIX conformance: Explorer (1-2) → Aligned (3) → Governed (3+) → Contributor (4) → Champion (4-5)

### 4. Domain Taxonomy (`govern/domain-taxonomy.json`)

9 standard data domains with typical trustee/steward assignments and regulatory context:

| Domain | Typical Steward | Default Classification | Status |
|--------|----------------|----------------------|--------|
| Student Identity | University Registrar | confidential | In HELIX Core v0.1 |
| Enrollment & Registration | University Registrar | confidential | In HELIX Core v0.1 |
| Academic Structure | Director of Curriculum / Registrar | internal | In HELIX Core v0.1 |
| Financial Aid | Director of Financial Aid | confidential | In HELIX Core v0.1 |
| Outcomes & Credentials | University Registrar | confidential | In HELIX Core v0.1 |
| Human Resources | Director of HR Systems / HRIS Manager | confidential | Planned for HELIX Core v0.2 |
| Finance & General Ledger | Controller / Director of Financial Systems | internal | Planned for HELIX Core v0.2 |
| Research Administration | Director of Sponsored Programs / Research Compliance Officer | confidential | Planned for HELIX Core v0.3 |
| Advancement & Alumni | Director of Advancement Services / CRM Manager | confidential | Planned for HELIX Core v0.3 |
