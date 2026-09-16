# HELIX Govern

17 governance artifacts:

**Foundational**
- `roles.json` — 6 governance roles
- `domain-taxonomy.json` — 9 data domains with steward assignments
- `raci-matrix.json` — 18 activities × 5 roles (R/A/C/I)
- `governance-committee-charter.json` — Council charter template

**Data Quality & Maturity**
- `quality-rules.json` — 22 data quality rules across 5 domains
- `maturity-model.json` — 5-dimension × 5-level maturity assessment
- `maturity-assessment-scorecard.json` — Fillable self-assessment scorecard

**Classification & Lifecycle**
- `classification-handling-rules.json` — 4-tier handling rules (FERPA/GLBA)
- `data-sharing-agreement-template.json` — DSA with FERPA/GLBA provisions
- `schema-evolution-policy.json` — Versioning, deprecation, extensions

**Compliance Frameworks (policy — what must be done)**
- `glba-safeguards-framework.json` — FTC Safeguards Rule (16 CFR 314) mapped to lakehouse layers
- `ferpa-disclosure-framework.json` — 99.31(a)(1)/(a)(6)/(a)(11) enforcement with identity resolution

**Enforcement & Operations (executable — how it's detected and enforced)**
- `glba-compliance-scanner.json` — 21 executable audit rules across 7 categories (encryption at rest/in transit, access control, data inventory, monitoring, disposal, service-provider oversight) with platform-specific SQL and a 10-section annual board report template per 16 CFR 314.4(i)
- `ferpa-suppression-policy.json` — 8 small-cell suppression rules (primary N<5, complementary, rate, dominance, cross-tab depth, longitudinal, rounding, derived-metric) with `helix_suppress()` SQL function, complementary-suppression CTE, dbt macro, and 6 IPEDS survey guides
- `lakehouse-rbac-model.json` — 9 database roles mapped to governance roles across Bronze/Silver/Gold, 3 column-masking policies, 5 row-level-security patterns, grant lifecycle, and platform guides (Snowflake, Databricks Unity Catalog, AWS Lake Formation, Redshift, BigQuery)
- `access-control-matrix.json` — Enforceable truth table: 9 roles × 3 layers across all 47 resources, 11 column-level exceptions, 8 special rules (FERPA directory, GLBA, HR restricted, steward scoping, research de-identification, admin separation of duties)
- `agent-guardrails.json` — AI agent & NLQ governance: 5 core principles, 4 classification-tier rules, 7 prohibited query patterns, 3 architecture patterns (text-to-SQL, RAG, tool-calling), 5 output filters, 21-field audit schema, 12-step implementation checklist
