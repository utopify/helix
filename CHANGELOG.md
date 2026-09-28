# HELIX Changelog

## v0.6.0 (September 2026): PeopleSoft to Workday Cornerstone

PeopleSoft to Workday becomes the foundation of HELIX, with the same depth across HCM, Financials, and Student.

**Added**
- `bridge/xref/ps-to-workday-hr/`: 10 HCM crosswalks (121 rows): worker type, employment status, job actions to business processes, compensation, pay frequency, deductions and benefits, absence, FLSA/EEO, job code to job profile, positions.
- `bridge/xref/ps-to-workday-sis/`: 11 Student crosswalks (128 rows): identity and Universal ID, academic career, program and plan, terms and sessions, enrollment status, grading basis, program status, admit type, holds, instruction mode, financial aid item types.
- `bridge/xref/ps-to-workday-fin/`: 4 new FIN crosswalks (business unit to company, project to grant, revenue and spend category, vendor to supplier), bringing FIN to 8 dimensions and 120 rows.
- `bridge/xref/VALIDATE_REGISTER.md`: every tenant-specific value in one review list (66 rows).
- `templates/ps-to-workday/worktag-conversion-rules.json`: 20 chartfield to worktag rules with precedence, fallbacks, suspense handling, validation checks, and 5 worked examples, plus 10 HCM and 7 Student field rules.
- `templates/ps-to-workday/reconciliation/`: 18 tie-outs (6 FIN, 6 HCM, 6 Student), including payroll parallel compare, GPA recompute, and a zero-miss FERPA restriction carryover gate.
- `agents/ps-to-workday-hcm-agent.json` and `agents/ps-to-workday-sis-agent.json`: every PeopleSoft module now has a Workday specialist.
- `docs/ps-to-workday-migration.md`: the cornerstone guide, with sequencing, worked examples, conversion strategy, parallel runs, and a T-90 to T+30 cutover checklist.
- Adventure guide Chapter 7 (PeopleSoft to Workday) and Chapter 8 (Banner on-prem to Banner SaaS).

**Changed**
- Migration Companion routes PeopleSoft to Workday users to the cornerstone path and knows all 6 specialists.
- PS to Workday FIN agent references the new crosswalks, ruleset, and reconciliation pack.
- `docs/bridge-reference.md` regenerated from the actual bridge files (it still showed v0.1 counts).
- Adventure guide Chapter 4 now reflects the 31-mapping Banner bridge.

## v0.5.0 (September 2026): Banner On-Prem and Banner SaaS

**Added**
- Banner on-prem bridge grows from 13 to 31 mappings: Finance (7), Advancement (4), Financial Aid (7).
- `bridge/banner/ONPREM_EXTRACTION.md`: PIDM joins, STV decode, effective-term dating, CDC options.
- `bridge/banner-saas/`: 8 reverse mappings (HELIX to Ethos) and `WRITEBACK_PATTERNS.md`.
- `docs/banner-saas-landing-architecture.md`: Ethos as the only write path, PostgreSQL for Data Connect staging, S3 Tables (Iceberg) for analytics.

## v0.4.0 (September 2026)

Financial Aid (1 to 10 resources) and Outcomes (2 to 9 resources) expansion, 19 new terminologies, 1,870-entry data dictionary, and the Core comb-over.
