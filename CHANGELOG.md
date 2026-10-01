# HELIX Changelog

## v0.8.1 (September 2026): Every resource has a mapping

Closes the last coverage gap. All 64 Core resources now have at least one bridge mapping.

**Added**
- **Institution** from all four ERPs: PeopleSoft (`PS_INSTITUTION_TBL`, `PS_EXT_ORG_TBL`), Banner (`GUBINST`, `STVSBGI`, `SOBSBGI`), Workday (Academic Unit, Educational Institution), and Colleague (`INSTITUTIONS`). External schools load as Institution rows so transfer credit and continuing education resolve to real records.
- **AwardHonor** from PeopleSoft (`PS_ACAD_DEGR_HONS`, `PS_HONOR_AWARD_CS`), Banner (`SHRDGIH`, `SHRDGDH`, `SHRTTRM` dean's list), and Workday (Academic Honor).
- **ExperientialLearning** for credit-bearing internships, practicums, clinicals, student teaching, and research from PeopleSoft, Banner, and Workday registrations.
- **AlumniProfile** from Banner Advancement (`APBCONS`, `APREHIS`, `APRACTY`, `AARMEMB`, `GERATTD`).
- **New `bridge/outcomes/` folder** with 8 mappings for sources outside the ERP: Handshake first-destination survey, employment, continuing education, and experiences; National Student Clearinghouse StudentTracker; state UI wage records; licensure exam results; and Canvas learning outcomes. Its README lists the primary source for each Outcomes resource and the rules for all of them: identity through the HELIX token, a missing match is never a negative outcome, and salary stays masked and suppressed.

**Changed**
- Bridge: 144 to 163 mappings. PeopleSoft 54 (CS 31), Banner 35 (SIS 14, Advancement 5), Workday 54 (SIS 31), Colleague 4, Outcomes 8, Banner SaaS reverse 8.
- `tools/check_governance_coverage.py` now scans `bridge/outcomes/` and reports 64 of 64 resources mapped.
- Root README: "What's in the box" moved to the top, "Press GO" renamed "Getting Started" (here, in START_HERE.md, CONTRIBUTING, the reference guide, and the Migration Companion's menu), and "About the Founder" restored at the bottom (it moved to the reference guide in v0.7.0).
- Agents: the Companion explains where outcomes data comes from; the SIS agent covers Institution, honors, and experiential learning conversion; the Banner agent covers the four new Banner mappings; the advancement agent covers alumni career data; the enrollment analytics agent covers outcomes reporting rules. All agents at v0.8.1.
- Updated: bridge, PeopleSoft, CS, Banner, Banner SIS, Banner Advancement, Workday, and Colleague READMEs, `docs/bridge-reference.md`, `docs/helix-reference.md`, the executive summary, the cornerstone guide, the adventure guide, and the root README.

**Still to confirm locally**
- Vendor export layouts (Handshake, StudentTracker, state wage files, Canvas) change with configuration and contract. Each outcomes file carries a `validate` note.
- A few ERP names are marked FLAG: `PS_HONOR_AWARD_CS` and PeopleSoft term honors, the `GUBINST` name column, the `SHRTTRM` dean's list column, and Banner advancement SIC and chapter fields.

**Known limit**
- AlumniProfile has no PeopleSoft or Workday mapping. Those schools usually run advancement in a separate CRM (Raiser's Edge NXT, Salesforce Education Cloud, CRM Advance); map from there.

## v0.8.0 (September 2026): PeopleSoft to Workday financial aid

The PeopleSoft to Workday Student track used to stop at the aid award. It now covers the whole aid lifecycle, from ISIR to COD reconciliation, on both sides.

**Added**
- 9 PeopleSoft Campus Solutions mappings in `bridge/peoplesoft/cs/` and 9 matching Workday Student mappings in `bridge/workday/sis/`: AidApplication, AidPackage, Verification, SAPEvaluation, Disbursement, LoanRecord, ReturnOfTitleIV, StudentEmployment, and FederalAidReport. Attribute names match one for one and cover every attribute in each Core schema. Each PeopleSoft file names its source records; each Workday file names its business objects and points at its PeopleSoft counterpart.
- 4 crosswalks in `bridge/xref/ps-to-workday-sis/` (JSON and CSV): `sap-status-xref` (8 rows), `verification-status-xref` (12), `loan-type-xref` (9), `disbursement-status-xref` (8).
- 4 aid tie-outs in `templates/ps-to-workday/reconciliation/`: `sap_status_carryover_check.sql` (hard gate before the first Workday disbursement), `aid_award_total_tieout.sql`, `loan_record_tieout.sql`, and `disbursement_cod_tieout.sql` (compares both systems to COD). The reconciliation README has a new Aid track with order, tolerances, parallel-run cadence, and sign-off.
- 6 Student conversion rules (STU-008 to STU-013) in `worktag-conversion-rules.json`: AID_YEAR handling, reload ISIRs from FPS instead of converting them, SAP carryover, COD loan IDs carried unchanged, disbursement history for open award years only, and in-flight verification.
- A financial aid sub-track in `docs/ps-to-workday-migration.md` section 7.

**Changed**
- Bridge: 126 to 144 mappings. PeopleSoft 51 (CS 28), Workday 51 (SIS 28). PS to Workday crosswalks: 29 to 33 dimensions, 369 to 406 rows. Tie-outs: 18 to 22.
- `bridge/xref/VALIDATE_REGISTER.md`: 66 to 83 rows. The 17 new rows are local SAP, verification, and loan codes.
- `ps-to-workday-sis-agent` knows the aid sub-track and its gates. The Companion routes aid conversion questions to it. The FIN agent covers the disbursement handoff to Student Financials. All agents at v0.8.0.
- Updated: bridge, PeopleSoft, Workday, CS, and Student crosswalk READMEs, `docs/bridge-reference.md`, `docs/helix-reference.md`, the executive summary, templates READMEs, and the adventure guide.

**Still to confirm locally**
- Several PeopleSoft aid records (COD, Return of Title IV, the SAP engine, work-study earnings) differ by release and are marked FLAG in the mappings. Workday aid object names vary by tenant; each Workday aid file carries a VALIDATE note.

**Coverage**
- 9 Core resources still have no bridge mapping: Institution and the 8 Outcomes resources. *(Fixed in v0.8.1.)*

## v0.7.1 (September 2026): Access control for every resource

Closes the gap logged in v0.7.0. Governance now covers all 64 Core resources, and a new check keeps it that way.

**Fixed**
- `govern/access-control-matrix.json`: added grants for the 17 Financial Aid and Outcomes resources added in v0.4.0 (was 47 resources, now 64). Six GLBA-covered aid resources use the restricted template; the rest use the confidential template. Every domain now lists each resource's classification.
- Column rules pointed at columns that don't exist in the schemas (for example `person.ssn`, `fin_aid_award.sai`, `compensation.annual_salary`). All 11 original rules now point at real columns, and 15 new rules cover the new resources, for 26 in total.
- `govern/lakehouse-rbac-model.json`: masking policies rewritten to real column names and extended to the new resources. The platform SQL examples now mask `aid_application.sai` instead of a column that doesn't exist.
- `govern/glba-compliance-scanner.json`: every audit query now checks all nine GLBA tables (`scope.glba_tables`), not just `fin_aid_award`, `person`, and `ar_transaction`.
- `govern/domain-taxonomy.json`: still listed HR, Finance, Research, and Advancement resources as "future". Now assigns all 64 resources to a domain.
- `docs/lakehouse-architecture-guide.md`: the classification map covered 19 resources and disagreed with the schemas in a few places. It's now generated from the schemas and covers all 64.

**Added**
- `tools/check_governance_coverage.py`: fails if any Core resource is missing from the access control matrix or the domain taxonomy, if a resource lacks grants for a role, if a masking rule names a column that doesn't exist, or if a restricted resource gives standard or research analysts row-level read.
- `helix_mask_outcomes_salary` masking policy: individual graduate salary is visible to career services and restricted analysts, banded for research, and hidden from standard analysts.
- Access rules ACM-SPECIAL-009 (alumni and graduate outcomes), ACM-SPECIAL-010 (aggregate federal aid reporting), and ACM-SPECIAL-011 (student employment pay). ACM-SPECIAL-002 (GLBA) now names all seven aid resources.

**Changed**
- `govern/agent-guardrails.json`: the confidential and restricted tiers list the new resources, and the GLBA output filter covers ISIR, loan, R2T4, and circumstance fields.
- `govern/ferpa-disclosure-framework.json`: now says 31 resources carry FERPA flags (29 education records plus AlumniProfile and FederalAidReport). It used to say 14.
- `govern/glba-safeguards-framework.json`: names all seven GLBA-covered aid resources.
- The Migration Companion and all six specialist agents now answer "who can see what" from the matrix, and the ones that touch aid, outcomes, or pay each carry the rules that apply to them.
- The govern README, reference doc, START_HERE step 6, README, and CONTRIBUTING point to the matrix and the coverage check.

**Found in the pre-push verification**
- 36 bridge mappings were fully built but still labeled "(planned)", including every Workday Financials and HCM mapping. Labels removed; the bridge reference no longer shows them as planned.
- 30 HR, finance, and student attributes were bound to their code sets (for example `employee.worker_type` to `helix/worker-type`). Only `enrollment-funnel-stage` and `pay-frequency` have no Core attribute yet. The data dictionary's terminology column is now filled from the schemas.
- `docs/resource-catalog.md` (covered 15 resources) and `docs/terminology-catalog.md` (covered 18 code sets) are now generated from the schemas and cover all 64 resources and 67 code sets.
- `docs/connect-overview.md` listed 16 endpoints; it's now generated from the spec and lists all 51.
- `docs/govern-overview.md` described 4 of 17 governance artifacts and showed HR, Finance, Research, and Advancement as planned. It now covers all 17.
- The dbt seed had 435 codes from 43 code sets; regenerated with all 595 codes from 67.
- Stale numbers fixed in the executive summary (19 resources, 23 code sets), CDO Quick Start (537 dictionary entries), CONTRIBUTING and the Migration Companion (16 endpoints), and the Colleague bridge README.
- Seven file paths in the adventure guide pointed at files that moved in v0.2.
- `tools/check_governance_coverage.py` now also fails on bridge mappings whose target isn't a Core resource and on bindings to code sets that don't exist, and it lists resources no bridge maps yet.

## v0.7.0 (September 2026): Press GO

HELIX gets a clear starting line. The README was reading like a brochure, so it now leads with what to do.

**Added**
- `START_HERE.md`: six steps from zero to a proven first slice (describe what you have, pick a goal, pick one slice, land it, map and prove it, own it), each with the file to use and what "done" looks like, plus a worked example for a PeopleSoft school on six Oracle databases and a legacy warehouse.
- `templates/intake/`: the institution profile (fill-in markdown, machine-readable YAML, and a filled-in PeopleSoft example).
- `bridge/peoplesoft/PS_EXTRACTION.md`: the missing PeopleSoft extraction playbook. Reporting copies vs production, EMPLID across pillars, EFFDT/EFFSEQ, SETID and TableSets, translate values, records vs views, what to extract for each first slice, incremental options, bronze landing, and security before the first extract.
- `docs/helix-reference.md`: the full inventory that used to live in the README, with stale counts corrected (the ecosystem diagram still said 47 resources, 23 code sets, 16 endpoints) and the Financial Aid and Outcomes code sets added.
- Migration Companion "help me start" flow (menu option 0) that walks the six steps in order.

**Changed**
- `README.md` rewritten from about 400 lines to about 80: what HELIX is, a Press GO table, pick your goal, what's in the box, and links.
- Adventure guide opens with a pointer to START_HERE; PeopleSoft chapters point to the extraction playbook.
- PeopleSoft to Workday guide now says what to do before you start it.
- All specialist agents point new users to the starting point before conversion work.

**Known gap (fixed in v0.7.1)**
- `govern/access-control-matrix.json` still covered only the 47 resources that existed in v0.3.2.

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
