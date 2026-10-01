# HELIX on AWS: Services Guide for Conversions and Lakehouses

This guide maps AWS services to the work HELIX describes: pulling data out of PeopleSoft, Banner, Workday, and Colleague, landing it in a lakehouse, shaping it into HELIX, converting custom code, governing it, and putting it to use. It's organized by phase, then by migration path.

The HELIX data model, bridges, and governance stay platform-neutral. This guide is the AWS implementation of them.

---

## Contents

1. [The short version](#1-the-short-version)
2. [Services by phase](#2-services-by-phase)
3. [Path recipes](#3-path-recipes)
4. [HELIX controls on AWS](#4-helix-controls-on-aws)
5. [Converting custom code](#5-converting-custom-code)
6. [Where Amazon Translate fits](#6-where-amazon-translate-fits)
7. [Running the HELIX agents on AWS](#7-running-the-helix-agents-on-aws)
8. [Things that trip people up](#8-things-that-trip-people-up)

---

## 1. The short version

| Layer | Default choice | Why |
|-------|---------------|-----|
| Pull from Oracle (PeopleSoft, Banner on-prem) | AWS DMS, full load plus CDC, from a reporting copy | Handles Oracle change data capture without touching production |
| Pull from Workday | Workday Data Cloud zero-copy integration with AWS, RaaS or Web Services through AWS Glue | Zero-copy covers HR and finance; Student still needs RaaS or the API |
| Pull from Banner SaaS | Ellucian Data Connect into Amazon RDS for PostgreSQL, then AWS Glue | SaaS has no direct database access |
| Bronze | Amazon S3, one prefix per source system | Cheap, immutable, replayable |
| Silver (HELIX) | Amazon S3 Tables (managed Apache Iceberg) | Iceberg with compaction and snapshot cleanup handled for you |
| Transform | AWS Glue (PySpark) or dbt on Amazon Athena or Amazon Redshift | The `templates/dbt/` starter runs on either |
| Catalog and access | AWS Glue Data Catalog plus AWS Lake Formation | Lake Formation tags carry the HELIX classification tiers |
| Convert custom code | AWS DMS Schema Conversion, AWS Transform, Amazon Bedrock | Rules first, AI for the rest, people for review |
| Query and report | Amazon Athena, Amazon Redshift Serverless, Amazon Quick Sight | Pay per query to start, warehouse when it's busy |
| AI and agents | Amazon Bedrock (Knowledge Bases, Guardrails, AgentCore) | Load HELIX as knowledge; enforce `govern/agent-guardrails.json` |

---

## 2. Services by phase

### Extract

| Service | What it does for HELIX | Watch out for |
|---------|------------------------|---------------|
| **AWS DMS** | Full load and ongoing change data capture from Oracle (PeopleSoft and Banner on-prem) into S3. Writes Parquet. | Point it at a reporting copy or standby, not production. Supplemental logging must be on for CDC. Large LOBs (PeopleCode text, long comments) need LOB settings tuned. |
| **AWS Glue (JDBC jobs)** | Scheduled pulls where CDC is overkill: setup tables, small validation tables, monthly snapshots. | Glue reads through a VPC connection; plan network access to the campus data center first. |
| **Workday Data Cloud integration with AWS** | Announced June 2026: bi-directional, zero-copy access to Workday's governed HR and finance data from AWS services, with no pipelines to build. | Covers HR and finance. Workday Student data still comes through RaaS reports or Workday Web Services. Confirm what your tenant is licensed for. |
| **Workday RaaS and Web Services through Glue or Lambda** | Pull Workday Student and anything zero-copy doesn't cover. | Report-based extracts depend on the report definition. Version-control the report definitions with the pipeline. |
| **Third-party Glue connectors (AWS Marketplace)** | Prebuilt connectors exist for Workday and other SaaS sources, for example from CData. | Third-party licensing and support. Check FERPA and GLBA terms before routing student or aid data through them. |
| **Ellucian Data Connect to Amazon RDS for PostgreSQL** | The supported read path out of Banner SaaS (see `docs/banner-saas-landing-architecture.md`). | Treat the PostgreSQL copy as operational staging, not the lakehouse. |
| **AWS DataSync** | Copies file-based source code off campus servers: SQR, COBOL, Pro*C, shell scripts, `PS_HOME` and Banner job server directories. | This is where a lot of undocumented customization lives. Copy it before anyone decommissions a server. |
| **AWS Transfer Family** | Managed SFTP for files that already move by SFTP: ISIR batches, Clearinghouse returns, EIB loads into Workday. | Land straight into a restricted bronze prefix with its own KMS key. |

### Store

| Service | Use |
|---------|-----|
| **Amazon S3** | Bronze. One prefix per source and extract date. Turn on versioning and Object Lock for anything regulators might ask about later. |
| **Amazon S3 Tables** | Silver. Managed Apache Iceberg tables, with compaction, snapshot management, and unreferenced file cleanup run automatically. Store one HELIX resource per table. |
| **AWS Glue Data Catalog** | The table catalog every engine reads (Athena, Redshift, Glue, EMR). |
| **Amazon RDS / Aurora PostgreSQL** | Operational staging (Banner SaaS via Data Connect) and the target for converted PL/SQL that still needs a transactional database. |
| **Amazon Redshift** | Gold, when dashboards and reporting volume outgrow Athena. Redshift can query the lakehouse in place. |

### Transform

| Service | Use |
|---------|-----|
| **AWS Glue (PySpark)** | Bronze to silver at scale: effective-date logic (EFFDT/EFFSEQ, Banner effective term), identity resolution, code translation through the crosswalks. |
| **dbt on Athena or Redshift** | The `templates/dbt/` starter. SQL models, tests from `govern/quality-rules.json`, and the terminology seed. |
| **Amazon EMR Serverless** | One-time history loads too big for a Glue job budget, such as 20 years of enrollment or GL detail. |
| **AWS Glue Data Quality** | Runs the HELIX quality rules as checks on each load and stops promotion to silver when critical rules fail. |
| **AWS Step Functions / Amazon MWAA** | Orchestration. Step Functions for simple chains; MWAA (managed Airflow) if the team already knows Airflow. |

### Convert code

| Service | Use |
|---------|-----|
| **AWS DMS Schema Conversion** | Converts Oracle schemas and code (Banner PL/SQL packages, PeopleSoft custom views and triggers) to Aurora PostgreSQL, RDS for PostgreSQL, or Redshift. Includes a generative AI conversion option for code the rules can't handle. |
| **AWS Schema Conversion Tool (desktop)** | Same family, run locally. Useful for assessment reports and air-gapped environments. |
| **AWS Transform** | Agentic AI modernization: codebase analysis to inventory and explain legacy code, plus custom transformations you define for repeating patterns. |
| **Amazon Bedrock** | Foundation models for what no converter handles: PeopleCode, App Engine, SQR, COBOL, and the leftover PL/SQL from Schema Conversion. Prompt templates are in `templates/customization-discovery/conversion-prompts/`. |
| **Kiro and Amazon Q Developer** | AI-assisted IDEs for the people reviewing and finishing converted code. |

### Govern and secure

| Service | Use |
|---------|-----|
| **AWS Lake Formation** | Table, column, row, and cell-level access. LF-tags carry the HELIX classification (`public`, `internal`, `confidential`, `restricted`). |
| **AWS KMS** | Separate keys per classification tier. GLBA data gets its own key, as `govern/glba-safeguards-framework.json` requires. |
| **Amazon Macie** | Scans bronze for SSNs, bank numbers, and other sensitive data that shouldn't be there. |
| **AWS CloudTrail and CloudTrail Lake** | Access logging for FERPA and GLBA audits. |
| **AWS IAM Identity Center** | Campus SSO into the AWS console, SageMaker Unified Studio, and Quick Sight. |
| **AWS Secrets Manager** | Database and API credentials for every extract. Nothing in code. |
| **AWS Clean Rooms** | Joins with outside parties (state agencies, research partners) without either side handing over row-level data. Fits FERPA studies disclosures under 99.31(a)(6). |
| **Amazon DataZone / SageMaker Catalog** | Business catalog and data sharing requests, using the HELIX data dictionary as the glossary. |

### Analyze and use

| Service | Use |
|---------|-----|
| **Amazon Athena** | SQL on the lakehouse. Runs the reconciliation and tie-out queries. |
| **Amazon Redshift Serverless** | Gold layer and heavy reporting. |
| **Amazon SageMaker Unified Studio** | One workspace over S3 and Redshift data for analysts and data scientists (the lakehouse architecture of Amazon SageMaker). |
| **Amazon Quick Sight** | Dashboards on gold. Row-level security follows the HELIX access matrix. |
| **Amazon Bedrock Knowledge Bases** | Load the HELIX repo so the agents answer from the files, not memory. |
| **Amazon Bedrock Guardrails** | Implements the output filters in `govern/agent-guardrails.json` (PII and GLBA field blocking). |
| **Amazon Comprehend** | Finds PII in free text (advising notes, appeal reasons, comments) before it reaches an analytics zone. |
| **Amazon Textract** | Pulls data from scanned documents in imaging systems (transcripts, verification documents) when conversion includes them. |
| **Amazon Translate** | Multilingual content. See [section 6](#6-where-amazon-translate-fits). |

---

## 3. Path recipes

### Banner on-prem to a HELIX lakehouse

1. **Extract:** AWS DMS from a Banner reporting copy into `s3://.../bronze/banner/`, CDC on the tables in `bridge/banner/`.
2. **Decode:** Glue job joins STV validation tables and applies effective-term logic (`bridge/banner/ONPREM_EXTRACTION.md`).
3. **Silver:** Glue or dbt writes HELIX resources to S3 Tables, keyed by HELIX ID with PIDM kept in the restricted identity zone.
4. **Govern:** LF-tags from each resource's classification; KMS key per tier; Macie on bronze.
5. **Prove:** Run the reconciliation templates in Athena against a number the registrar trusts.

### Banner on-prem to Banner SaaS

1. **Inventory first.** Run the Banner customization discovery (`docs/conversion/banner-customizations.md`). Banner SaaS doesn't allow database modifications, so every local object needs a decision.
2. **Keep history:** DMS full load of on-prem Banner into bronze before cutover. That copy is your permanent record of pre-SaaS data and custom tables.
3. **Convert what still needs a database:** custom reports, batch jobs, and PL/SQL logic that worked on Banner tables move to Aurora PostgreSQL or the lakehouse, running against the Data Connect copy. AWS DMS Schema Conversion does the first pass.
4. **Rebuild what changes Banner:** anything that wrote to Banner tables goes through Ethos or Banner Integration API (`bridge/banner-saas/WRITEBACK_PATTERNS.md`).
5. **Read after cutover:** Data Connect into RDS for PostgreSQL, Glue into S3 Tables.

### PeopleSoft to Workday

1. **Inventory first.** Run the PeopleSoft customization discovery (`docs/conversion/peoplesoft-customizations.md`). Customizations don't move to Workday as code; each becomes Workday configuration, an extension, a lakehouse job, or nothing.
2. **Extract:** AWS DMS from a PeopleSoft reporting copy into bronze (`bridge/peoplesoft/PS_EXTRACTION.md`).
3. **Silver:** HELIX resources in S3 Tables. This is the conversion hub: PeopleSoft lands in HELIX shape, the crosswalks translate codes, and EIB files for Workday come out of gold.
4. **Load Workday:** write EIB files from gold to S3, deliver through AWS Transfer Family or Workday's integration endpoints.
5. **Reconcile:** run the 22 tie-outs in `templates/ps-to-workday/reconciliation/` in Athena, comparing PeopleSoft silver to Workday silver.
6. **After cutover:** read HR and finance through the Workday Data Cloud zero-copy integration; Workday Student through RaaS or Web Services.
7. **Keep PeopleSoft history** in the lakehouse. Most schools never load more than a few years into Workday.

### Any ERP to analytics only (keep the ERP)

Steps 1 to 5 of the Banner lakehouse recipe, with the PeopleSoft or Colleague extraction playbook in place of Banner's. Start with one slice from `START_HERE.md`.

---

## 4. HELIX controls on AWS

| HELIX artifact | AWS implementation |
|----------------|--------------------|
| Resource classification (`meta.classification`) | Lake Formation LF-tag `helix_classification` on every silver table |
| `govern/access-control-matrix.json` grants | Lake Formation permissions by IAM role, one role per HELIX database role |
| Column rules and masking (`govern/lakehouse-rbac-model.json`) | Lake Formation column filters; Redshift dynamic data masking in gold |
| Row-level rules (steward scoping, FERPA directory opt-out) | Lake Formation data cell filters; Quick Sight row-level security |
| GLBA restricted tier | Dedicated KMS key, separate S3 prefix and S3 Tables bucket, Macie scanning, CloudTrail data events |
| `govern/glba-compliance-scanner.json` | Athena queries over the Glue Data Catalog, S3 inventory, and KMS settings, scheduled with EventBridge |
| `govern/ferpa-suppression-policy.json` | `helix_suppress()` as a Redshift UDF or a dbt macro on Athena |
| `govern/agent-guardrails.json` | Bedrock Guardrails: denied topics, PII filters, and output checks |
| Quality rules (`govern/quality-rules.json`) | Glue Data Quality rulesets and dbt tests |

---

## 5. Converting custom code

The full method is in `docs/conversion/customization-discovery.md`. The AWS tool for each kind of code:

| Source code | Where it's going | First pass | Second pass | Human review |
|-------------|-----------------|------------|-------------|--------------|
| Banner PL/SQL packages, procedures, triggers, views | Aurora PostgreSQL or Redshift | DMS Schema Conversion (rules) | DMS Schema Conversion generative AI, then Bedrock for what's left | Always. Run old and new against the same data and compare results. |
| Banner PL/SQL report logic | Lakehouse (dbt or Glue) | Bedrock with `plsql-to-dbt.md` | Kiro or Q Developer | Compare output row for row |
| PeopleSoft custom views and SQL objects | Lakehouse or PostgreSQL | DMS Schema Conversion | Bedrock | Same |
| PeopleCode business rules | Workday (as requirements) | Bedrock with `peoplecode-to-business-rules.md` | AWS Transform codebase analysis for the inventory | Functional owner signs off on each rule |
| App Engine programs | Glue PySpark or Step Functions | Bedrock with `app-engine-to-glue.md` | Kiro or Q Developer | Parallel run |
| SQR reports | dbt models plus Quick Sight | Bedrock with `sqr-to-dbt.md` | Kiro or Q Developer | Compare report output |
| COBOL and Pro*C (Banner batch, older PeopleSoft) | Glue PySpark or Lambda | AWS Transform | Bedrock | Parallel run |

Three rules for every conversion:
- **Convert only what you're keeping.** The register decides that before anyone runs a converter.
- **Never send production data to a model to "help it understand."** Send code and table definitions. If an example is needed, use synthetic rows.
- **A conversion is done when outputs match**, not when the code compiles. Use the same reconciliation discipline HELIX uses for data.

---

## 6. Where Amazon Translate fits

Amazon Translate translates between human languages. It doesn't convert code. In a conversion it's useful for:

- **International student records:** names of foreign institutions, program names, and document text in other languages, for transfer credit and admissions.
- **Multilingual student-facing content:** course catalog descriptions, program pages, and financial aid letters for families who don't read English.
- **Code comments and documentation written in another language:** common at institutions that used offshore contractors. Translate the comments before a Bedrock or AWS Transform pass so the analysis has context.

Use **custom terminology** so HELIX and campus terms come out consistently. Translate accepts CSV, TSV, or TMX terminology files, though it decides in context whether to apply each term. A starter file built from the HELIX glossary is a good first step.

---

## 7. Running the HELIX agents on AWS

- **Amazon Bedrock Agents or AgentCore:** paste the agent's `system_prompt` as instructions, load the repo into a Knowledge Base, attach Guardrails from `govern/agent-guardrails.json`.
- **Amazon Quick:** create an agent with the system prompt and attach the repo as a space.
- **Tools the agents expect:** read-only SQL (Athena or Redshift Data API through a Lambda action), a file writer for dbt and Glue code, and the HELIX validator.
- Agents never get credentials to production ERP databases. Give them the reporting copy or the lakehouse.

---

## 8. Things that trip people up

- **Glue crawlers need a folder, not a file.** Point table locations at an S3 prefix. A crawler that read a file directly, or a CSV without "has header" set, gives you `col0, col1` columns. Delete the tables and the crawler, then create a new crawler with the right classifier.
- **DMS against production.** Run it against a standby or reporting copy. CDC on a busy registration day will be noticed.
- **One KMS key for everything.** GLBA needs its own key and its own access path.
- **Converting dead code.** Customizations that haven't run in years are common in long-lived PeopleSoft and Banner installs. Check run history before converting anything.
- **Treating zero-copy as a full extract.** Workday's AWS integration covers governed HR and finance data. Plan Student separately.

*HELIX v0.9.0, October 2026*
