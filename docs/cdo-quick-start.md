# HELIX CDO Quick Start Guide

### Your 90-Day Plan for Standing Up Data Governance Using HELIX

---

## Who This Is For

You're a new (or newly empowered) Chief Data Officer, VP of Data & Analytics, or Data Governance Director at a higher education institution. You've been given a mandate to "fix the data problem." HELIX gives you the building blocks to do it systematically rather than reinventing the wheel.

## The 90-Day Roadmap

### Days 1-30: Foundation

**Week 1: Learn the Landscape**
1. Read the [HELIX Glossary](../core/glossary.md) — understand the full student lifecycle and institutional data taxonomy in the language your stakeholders speak
2. Review [govern/domain-taxonomy.json](../govern/domain-taxonomy.json) — see the 9 data domains with typical steward/trustee assignments
3. Review [govern/roles.json](../govern/roles.json) — understand the 6 governance roles you'll need to fill

**Week 2: Assess Your Current State**
1. Use [govern/maturity-model.json](../govern/maturity-model.json) to assess your institution across 5 dimensions:
   - Data Model & Standards
   - Governance Organization
   - Data Quality
   - Data Classification & Security
   - Data Literacy & Culture
2. Be honest. Most institutions starting out score Level 1-2 on most dimensions. That's the expected starting point.
3. Document your scores and the evidence behind them.

**Week 3: Map Your Domains and Stakeholders**
1. Take the 9 domains from the HELIX domain taxonomy
2. For each domain, identify:
   - Who is the natural **Data Trustee**? (Senior exec with accountability — Provost, CFO, VP for Student Affairs, etc.)
   - Who is the natural **Data Steward**? (Functional expert — Registrar, Financial Aid Director, HR Director, etc.)
   - What **ERP/systems** hold this data? (PeopleSoft? Banner? Workday? A shadow spreadsheet?)
   - What **regulations** apply? (FERPA? GLBA? HIPAA? State-specific?)
3. Use the HELIX resource classification map ([Lakehouse Architecture Guide](lakehouse-architecture-guide.md)) to assign default classification levels.

**Week 4: Secure Executive Sponsorship**
1. Use the [Executive Summary](helix-executive-summary.md) to brief your president/provost/CIO
2. Ask for three things:
   - Authorization to form a Data Governance Council
   - Named Data Trustees from the leadership team
   - A standing meeting (monthly to start)
3. Frame it as: "We're not building something new. We're adopting an open standard that hundreds of institutions are moving toward."

### Days 31-60: Structure

**Week 5-6: Form the Data Governance Council**
1. Invite the Data Trustees (one per major domain) + CDO (you) + CIO + key Data Stewards
2. First meeting agenda:
   - Present the maturity assessment results
   - Adopt the HELIX domain taxonomy as the institutional framework
   - Assign Data Trustees to each domain
   - Set cadence: monthly council meetings, quarterly steward meetings
3. Use the HELIX committee charter template as your starting document (see [govern/](../govern/))

**Week 7-8: Establish the Shared Vocabulary**
1. Take the [HELIX Data Dictionary](../core/data-dictionary.json) (537 entries)
2. Review it with each Data Steward for their domain:
   - "Does 'enrolled student' match our institutional definition?"
   - "Are these enrollment status codes complete for our institution?"
   - "What's missing that's unique to us?"
3. Customize where needed, but start from HELIX defaults rather than blank paper
4. If you have a data catalog tool (Collibra, Alation, Purview), import the data dictionary CSV ([core/data-dictionary.csv](../core/data-dictionary.csv))

### Days 61-90: Quick Wins

**Week 9-10: Implement First Quality Rules**
1. Take the HELIX quality rules ([govern/quality-rules.json](../govern/quality-rules.json))
2. Start with the **critical-severity** rules only (there are ~8):
   - Student must have at least one identifier (SI-001)
   - Enrollment must reference a valid student (EN-001)
   - Award amount must be non-negative (FA-001)
3. Have your data engineering team implement these as automated tests (dbt tests, SQL assertions, Great Expectations)
4. Run them against your current data. **Report the results to the Council.** This is your first data quality baseline.

**Week 11-12: Classify and Protect**
1. Apply HELIX data classification tiers to your most sensitive datasets:
   - Student PII → **Confidential** (FERPA)
   - Financial aid data → **Restricted** (GLBA)
   - Course catalog → **Public**
2. Verify that access controls match the classification:
   - Who can currently see financial aid data? Is it everyone with database access?
   - Are there audit logs?
3. Document any gaps as your first remediation backlog

**Day 90: Report to Leadership**
Present to the Council:
1. Maturity baseline (where we started)
2. Governance structure (who owns what)
3. Shared vocabulary (the data dictionary)
4. Quality baseline (first rule results)
5. Classification gaps (what we need to fix)
6. Roadmap for the next 90 days

## HELIX Files to Download First

| File | Why You Need It |
|------|----------------|
| [govern/domain-taxonomy.json](../govern/domain-taxonomy.json) | Your domain map — what to govern |
| [govern/roles.json](../govern/roles.json) | Your org chart — who governs what |
| [govern/quality-rules.json](../govern/quality-rules.json) | Your first quality implementation |
| [govern/maturity-model.json](../govern/maturity-model.json) | Your diagnostic tool |
| [core/data-dictionary.json](../core/data-dictionary.json) | Your shared vocabulary (machine-readable) |
| [core/data-dictionary.csv](../core/data-dictionary.csv) | Same vocabulary in spreadsheet format |
| [core/glossary.md](../core/glossary.md) | Plain-language reference for your team |
| [docs/helix-executive-summary.md](helix-executive-summary.md) | Your leadership brief |
| [docs/lakehouse-architecture-guide.md](lakehouse-architecture-guide.md) | Classification map + FERPA/GLBA reference |

## Common Mistakes to Avoid

1. **Don't try to govern everything at once.** Start with 2-3 domains (typically Student Identity + Enrollment + Financial Aid). Expand after you have a working rhythm.
2. **Don't make governance a committee that only talks.** Implement quality rules in the first 90 days. Measurable outcomes build credibility.
3. **Don't write your own glossary from scratch.** Start from HELIX and customize. You'll spend months writing definitions that already exist.
4. **Don't skip executive sponsorship.** Governance without authority is a suggestion box. You need named Trustees with real accountability.
5. **Don't wait for perfect data to start governing.** Governance isn't about having clean data — it's about having a system for making data cleaner over time.

---

*HELIX CDO Quick Start Guide v0.1 — September 2026*
*Part of the [HELIX Open Framework](https://github.com/utopify/helix)*
