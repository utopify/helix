# HELIX Govern

Data governance templates for higher education institutions adopting HELIX.

HELIX Govern provides the organizational, procedural, and quality management layer that makes data trustworthy, not just available. Governance is not a bolt-on — it's woven into every HELIX resource through the `meta` block (classification, ownership, lineage) and reinforced by the frameworks below.

## Contents

| File | What It Is | Who It's For |
|------|-----------|-------------|
| **roles.json** | Standard governance role definitions (Data Trustee, CDO, Data Steward, Data Custodian, Data Consumer, HELIX Champion) | CDOs, governance program leads, HR/org design |
| **quality-rules.json** | Starter library of data quality rules by domain with severity levels, plain-language descriptions, and testable expressions | Data engineers, quality analysts, Data Stewards |
| **maturity-model.json** | Five-dimension self-assessment framework aligned to HELIX conformance levels | CDOs, CIOs, governance councils |
| **domain-taxonomy.json** | Standard data domains with typical trustee/steward roles, regulatory context, and HELIX resource alignment | Governance councils, organizational design |

## How to Use

1. **Start with the Domain Taxonomy** — identify which data domains your institution manages and who the natural stewards are.
2. **Map the Roles** — assign governance roles to real people. One person may hold multiple roles; one role may be shared.
3. **Adopt Quality Rules** — start with the critical-severity rules for your most important domains. Adapt the expressions to your data platform (SQL, dbt tests, Great Expectations, etc.).
4. **Assess Maturity** — use the maturity model as a baseline diagnostic. Repeat annually.
5. **Contribute Back** — if you develop governance patterns that could help other institutions, submit them to the HELIX community.

## Design Philosophy

- **Practical over theoretical.** Every role has typical titles. Every quality rule has a remediation. The maturity model has concrete descriptions, not abstract ideals.
- **Adoptable in pieces.** An institution can use just the quality rules without the full role framework, or just the maturity model for a self-assessment.
- **Globally applicable, locally adaptable.** Regulatory context notes reference US (FERPA, IPEDS), EU (GDPR), and AU (Privacy Act) frameworks, but the governance structures themselves are universal.
