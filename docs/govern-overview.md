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

| Domain | Typical Steward | Default Classification | Resources |
|--------|----------------|----------------------|-----------|
| Student Identity | University Registrar | confidential | 2 |
| Enrollment & Registration | University Registrar | confidential | 10 |
| Academic Structure | Director of Curriculum / Registrar | internal | 6 |
| Financial Aid | Director of Financial Aid | confidential | 10 |
| Outcomes & Credentials | University Registrar | confidential | 9 |
| Human Resources | Director of HR Systems / HRIS Manager | confidential | 12 |
| Finance & General Ledger | Controller / Director of Financial Systems | internal | 10 |
| Research Administration | Director of Sponsored Programs / Research Compliance Officer | confidential | 1 |
| Advancement & Alumni | Director of Advancement Services / CRM Manager | confidential | 4 |

All 64 Core resources are assigned to a domain.

### 5. Access Control (`govern/access-control-matrix.json`, `govern/lakehouse-rbac-model.json`)

Who can see what, for every resource. The matrix gives 9 database roles a grant at each layer (bronze, silver, gold) for all 64 resources, plus 26 column rules for restricted and personally identifying fields and 11 special rules (FERPA directory opt-outs, GLBA, HR pay, steward scoping, research de-identification, alumni data, and more). The RBAC model turns that into platform SQL: role definitions, 4 masking policies, 5 row-level security patterns, and a grant lifecycle, with examples for Snowflake, Databricks, Lake Formation, Redshift, and BigQuery.

Run `tools/check_governance_coverage.py` after adding or renaming any resource. It fails if a resource has no access rules or a masking rule points at a column that doesn't exist.

### 6. Classification and Handling (`govern/classification-handling-rules.json`)

Four tiers (public, internal, confidential, restricted), each with rules for encryption, access, audit logging, masking, retention, and disposal. Every resource's default tier is set in its schema.

### 7. FERPA (`govern/ferpa-disclosure-framework.json`, `govern/ferpa-suppression-policy.json`)

The disclosure framework covers the 99.31(a)(1), (a)(6), and (a)(11) exceptions and the per-row FERPA flags carried by 31 resources. The suppression policy gives 8 small-cell rules (minimum N of 5, complementary suppression, and others) with a `helix_suppress()` SQL function and a dbt macro.

### 8. GLBA (`govern/glba-safeguards-framework.json`, `govern/glba-compliance-scanner.json`)

The safeguards framework maps all 9 elements of the FTC Safeguards Rule (16 CFR 314) to lakehouse controls. The compliance scanner has 21 audit queries that check all nine GLBA-covered tables for encryption, access, logging, and disposal, plus an annual board report template.

### 9. AI Agents (`govern/agent-guardrails.json`)

Rules for AI assistants and natural-language query tools: what each classification tier allows in a response, 7 prohibited query patterns, output filters for PII and GLBA values, and a 21-field audit log.

### 10. Operating the Program

| File | Use it for |
|------|-----------|
| `govern/raci-matrix.json` | Who is responsible, accountable, consulted, and informed for 18 governance activities |
| `govern/governance-committee-charter.json` | A fill-in charter for your data governance council |
| `govern/maturity-assessment-scorecard.json` | A fill-in version of the maturity model for self-assessment |
| `govern/data-sharing-agreement-template.json` | A data sharing agreement with FERPA and GLBA terms |
| `govern/schema-evolution-policy.json` | Versioning, deprecation, and how to extend HELIX locally |

New to governance? Start with the [CDO Quick Start](cdo-quick-start.md).

*HELIX v0.9.0, September 2026*
