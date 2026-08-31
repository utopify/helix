# HELIX Lakehouse Architecture Guide

### Medallion Architecture, FERPA/GLBA Compliance, and Resource-to-Layer Mapping

> A soup-to-nuts reference for building a HELIX-conformant data lake using the medallion (Bronze → Silver → Gold) pattern with regulatory compliance baked into every layer.

---

## Architecture Overview

```
  +============================================================+
  |                     SOURCE SYSTEMS                         |
  |                                                            |
  |  Banner    PeopleSoft    Workday    Colleague    Slate     |
  |  Raiser's Edge    Blackbaud    Salesforce    Canvas LMS    |
  +============================================================+
          |              |              |              |
          v              v              v              v
      HELIX Bridge Mappings (source-to-foundational transforms)
          |              |              |              |
          v              v              v              v
  +============================================================+
  |                                                            |
  |   BRONZE LAYER  (Raw Ingestion)                            |
  |   Format: Parquet on S3 / ADLS / GCS                      |
  |   Schema: Source-native (ERP table shapes)                 |
  |   Governance: Classified, access-logged, immutable         |
  |                                                            |
  +============================================================+
          |
          v  (HELIX Bridge transforms applied here)
  +============================================================+
  |                                                            |
  |   SILVER LAYER  (HELIX Foundational Model)                 |
  |   Format: Apache Iceberg tables                            |
  |   Schema: HELIX Core resource definitions                  |
  |   Governance: FERPA/GLBA enforced, PII masked/tokenized    |
  |                                                            |
  +============================================================+
          |
          v  (business logic, aggregation, metrics)
  +============================================================+
  |                                                            |
  |   GOLD LAYER  (Consumption-Ready)                          |
  |   Format: Iceberg tables, materialized views               |
  |   Schema: Star schemas, metric definitions, AI features    |
  |   Governance: Role-based access, anonymized where needed   |
  |                                                            |
  +============================================================+
          |
          v
  +============================================================+
  |                     CONSUMPTION                            |
  |                                                            |
  |  Dashboards    Reports    AI/ML    APIs    Ad Hoc SQL      |
  |  (QuickSight, Tableau, Power BI, Jupyter, HELIX Connect)   |
  +============================================================+
```

---

## Layer-by-Layer Detail

### Bronze Layer: Raw Ingestion

**Purpose:** Land source data exactly as it comes from the ERP, CRM, or SIS. No transformation, no filtering, no deduplication. The bronze layer is your audit trail and recovery point.

**What goes here:**

| Source System | What Lands in Bronze | Format |
|--------------|---------------------|--------|
| PeopleSoft CS | PS_PERSONAL_DATA, PS_NAMES, PS_STDNT_ENRL, PS_STDNT_AWARDS, etc. | Parquet files partitioned by extract date |
| Banner | SPRIDEN, SPBPERS, SFRSTCR, STVTERM, etc. | Parquet files partitioned by extract date |
| Workday | RaaS report output, REST API payloads, Prism datasets | JSON → Parquet, partitioned by extract date |
| Colleague | PERSON, STUDENTS, STUDENT.ACAD.CRED MV file extracts | Parquet (MV fields exploded to rows) |
| Slate (CRM) | Application records, inquiry records, event registrations | Parquet or JSON |
| Advancement CRM | Constituent, gift, event records from Raiser's Edge / Blackbaud | Parquet |

**Bronze Rules:**
1. **Immutable** — never modify bronze data after landing. Append-only.
2. **Full fidelity** — preserve all columns, all rows, including NULLs and source system codes. No filtering.
3. **Extract metadata** — every bronze record carries: `_extract_timestamp`, `_source_system`, `_source_table`, `_batch_id`.
4. **Classified immediately** — tag every bronze table with its HELIX `data-classification` level (public, internal, confidential, restricted). This happens at ingestion, not later.
5. **Encrypted at rest** — all bronze data encrypted (S3 SSE-KMS, ADLS encryption, etc.).
6. **Access logged** — every read against bronze is logged for FERPA/GLBA audit.

**Storage pattern:**
```
s3://institution-datalake/bronze/
  peoplesoft/
    ps_personal_data/
      extract_date=2026-08-31/
        part-00000.parquet
    ps_stdnt_enrl/
      extract_date=2026-08-31/
        part-00000.parquet
  banner/
    spriden/
      extract_date=2026-08-31/
        part-00000.parquet
  slate/
    applications/
      extract_date=2026-08-31/
        part-00000.parquet
```

---

### Silver Layer: HELIX Foundational Model

**Purpose:** This is where HELIX lives. Bronze data is transformed through HELIX Bridge mappings into HELIX Core resource shapes. The silver layer is the single source of truth for governed, standardized institutional data.

**What goes here:**

Every HELIX Core resource becomes an Iceberg table in silver:

| HELIX Resource | Iceberg Table | Source Bronze Tables | Classification |
|---------------|--------------|---------------------|----------------|
| `Person` | `silver.person` | ps_personal_data, ps_names, ps_addresses, ps_email_addresses | **Confidential** |
| `Student` | `silver.student` | ps_personal_data, sgbstdn, ps_stdnt_car_term | **Confidential** |
| `Enrollment` | `silver.enrollment` | ps_stdnt_enrl, sfrstcr, student_acad_cred | **Confidential** |
| `AcademicPeriod` | `silver.academic_period` | ps_term_tbl, stvterm, terms | **Internal** |
| `Course` | `silver.course` | ps_crse_catalog, scbcrse | **Public** |
| `CourseSection` | `silver.course_section` | ps_class_tbl, ssbsect, course_sections | **Internal** |
| `Program` | `silver.program` | ps_acad_plan_tbl, smrprle | **Public** |
| `StudentProgram` | `silver.student_program` | ps_acad_prog, ps_acad_plan | **Confidential** |
| `FinAidAward` | `silver.fin_aid_award` | ps_stdnt_awards, rfrbase | **Restricted** |
| `Degree` | `silver.degree` | ps_acad_degr, shrdgmr | **Confidential** |
| `AdmissionApplication` | `silver.admission_application` | ps_adm_appl_data, saradap | **Confidential** |
| `TransferCredit` | `silver.transfer_credit` | ps_trns_crse_dtl, shrtrce | **Confidential** |
| `Hold` | `silver.hold` | ps_srvc_ind_data, sprhold | **Confidential** |
| `AcademicOrg` | `silver.academic_org` | ps_acad_org_tbl, stvdept | **Internal** |
| `Institution` | `silver.institution` | configuration | **Public** |
| `Constituent` | `silver.constituent` | re_constituent, advancement CRM | **Confidential** |
| `Gift` | `silver.gift` | re_gift, gift transactions | **Confidential** |
| `Campaign` | `silver.campaign` | re_campaign, campaign config | **Internal** |
| `EngagementActivity` | `silver.engagement_activity` | event registrations, email tracking, meetings | **Internal** |

**Silver Rules:**
1. **HELIX-shaped** — every table conforms to the corresponding HELIX Core JSON Schema. Validated on write.
2. **`helix_id` assigned** — deterministic UUID generation per the Bridge mapping specification.
3. **`meta` block populated** — every record carries `source_system`, `classification`, `data_owner`, `created_at`, `updated_at`.
4. **Terminology-bound** — enum fields contain only valid HELIX terminology codes. Invalid source codes are mapped or flagged.
5. **Quality rules enforced** — HELIX Govern quality rules run as dbt tests or Great Expectations suites on every load. Critical failures block promotion to gold.
6. **PII handling applied** — see FERPA/GLBA section below.
7. **Iceberg schema evolution** — when HELIX Core versions up (e.g., v0.1 → v0.2), Iceberg's schema evolution adds new columns without rewriting data.

**Storage pattern:**
```
s3://institution-datalake/silver/
  person/              ← Iceberg table (metadata in Iceberg catalog)
  student/
  enrollment/
  fin_aid_award/
  constituent/
  gift/
  ...
```

---

### Gold Layer: Consumption-Ready

**Purpose:** Business-specific views, aggregations, metrics, and feature sets built from silver. Gold tables answer specific institutional questions. Multiple gold tables can draw from the same silver resource.

**What goes here:**

| Gold Table | Built From (Silver) | Purpose | Audience |
|-----------|-------------------|---------|----------|
| `gold.enrollment_census_snapshot` | enrollment, student, academic_period | Official enrollment counts at census. IPEDS-ready. | IR, Provost |
| `gold.retention_cohort` | student, enrollment, academic_period | Fall-to-fall retention by cohort, demographic, program | IR, Student Success |
| `gold.graduation_rates` | degree, student, student_program | 4/6-year graduation rates by cohort. IPEDS-ready. | IR, Accreditation |
| `gold.enrollment_funnel` | admission_application, student, enrollment, engagement_activity | Full funnel: suspect → inquiry → app → admit → confirm → enrolled → melt | Enrollment Mgmt |
| `gold.financial_aid_summary` | fin_aid_award, student | Aid package summaries by type, source, need/merit. Federal reporting. | Financial Aid, CFO |
| `gold.donor_360` | constituent, gift, engagement_activity, campaign | Complete donor view: giving history, engagement, capacity, pipeline stage | Advancement |
| `gold.giving_dashboard` | gift, campaign, constituent | Real-time fundraising totals by campaign, fund, designation | VP Advancement |
| `gold.course_demand` | enrollment, course_section, course, academic_period | Section fill rates, waitlist analysis, demand forecasting | Registrar, Deans |
| `gold.student_risk_score` | student, enrollment, fin_aid_award, hold, engagement_activity | Predictive risk model for retention/melt interventions | Student Success |
| `gold.marketing_channel_roi` | admission_application, enrollment, engagement_activity | Cost-per-enrolled-student by marketing channel | Enrollment Marketing |
| `gold.coa_xref` | GL transactions (bronze/silver fin) | Chart of accounts cross-reference for migration reporting | Finance |
| `gold.gl_summary` | GL transactions | Revenue/expense summary by fund, department, program | CFO, Budget Office |
| `gold.hr_ipeds` | employee, position, job_classification | IPEDS HR survey data: faculty by rank, tenure, gender, race | IR, HR |
| `gold.position_vacancy` | position, employee, position_budget | Open positions with budget, time-to-fill, department | HR, Budget |
| `gold.student_anonymized` | student (anonymized) | De-identified dataset for institutional research and sharing | IR, Researchers |

**Gold Rules:**
1. **Pre-aggregated or pre-joined** — gold tables minimize query complexity for consumers.
2. **Metric definitions documented** — every gold metric (retention rate, graduation rate, yield rate) has a version-controlled definition in the HELIX semantic layer.
3. **Access controlled by role** — gold tables enforce HELIX Govern data classification via table/column-level permissions.
4. **Anonymized gold for research** — sensitive gold tables have anonymized counterparts (k-anonymity, suppression) for broader access.

---

## FERPA Compliance Architecture

### What FERPA Requires

The **Family Educational Rights and Privacy Act** (20 U.S.C. § 1232g) governs access to student education records at institutions receiving federal funding.

**Key requirements for the data lake:**

| FERPA Requirement | Lake Implementation |
|------------------|-------------------|
| **Legitimate educational interest** | Role-based access control (RBAC). Users access only the data their role requires. |
| **Minimum necessary** | Column-level access. Analysts who need enrollment data don't see SSN or financial aid details. |
| **Directory information opt-out** | `silver.ferpa_restriction` table checked before any directory info disclosure. Any query joining Person/Student checks FERPA flags. |
| **Audit trail** | All data access logged with user, timestamp, query, and tables accessed. Retained for 7+ years. |
| **Consent for disclosure** | No student PII leaves the lake without either legitimate educational interest OR documented consent. Third-party data sharing requires a data sharing agreement. |
| **Annual notification** | Institutional policy (not a lake feature, but the lake supports the notification tracking). |

### FERPA Implementation by Layer

**Bronze:**
- All student records tagged `classification: confidential` or `classification: restricted` at ingestion
- Raw PII (SSN, birth date, addresses) encrypted with separate KMS keys
- Access limited to data engineers with signed FERPA acknowledgment

**Silver:**
- **PII tokenization**: SSN, full birth date, and other direct identifiers tokenized in silver. Original values retained only in bronze (encrypted, audit-logged).
- **FERPA restriction enforcement**: A view layer checks `silver.hold` (FERPA type) and `silver.person` before returning directory information. If a student has a total FERPA restriction, their record is excluded from any query that could be disclosed outside the institution.
- **Classification tags in `meta` block**: Every silver record carries `meta.classification`. Access policies reference this field.

```sql
-- Example: FERPA-safe directory query
-- Only returns students who have NOT restricted their directory info
SELECT s.helix_id, p.name.given, p.name.family, s.status, sp.class_standing
FROM silver.student s
JOIN silver.person p ON s.person_ref = p.helix_id
LEFT JOIN silver.student_program sp ON s.helix_id = sp.student_ref AND sp.is_primary = true
WHERE s.status = 'enrolled'
  AND NOT EXISTS (
    SELECT 1 FROM silver.hold h
    WHERE h.student_ref = s.helix_id
      AND h.hold_type = 'ferpa'
      AND h.hold_status = 'active'
  )
```

**Gold:**
- Role-based views: a dean sees their college's students; the registrar sees all; a department chair sees their majors.
- Anonymized gold tables for research: direct identifiers removed, quasi-identifiers generalized (age bands instead of birth dates, zip3 instead of zip5).
- No gold table exposes SSN, full birth date, or financial aid details to any role below Financial Aid Director.

### FERPA Access Control Matrix

| Role | Bronze | Silver (PII) | Silver (Non-PII) | Gold (Identified) | Gold (Anonymized) |
|------|--------|-------------|-----------------|------------------|------------------|
| Data Engineer | Read | Read | Read | Read | Read |
| DBA / Admin | Read | Read | Read | Read | Read |
| Registrar | No | Read | Read | Read (all students) | Read |
| Financial Aid Director | No | Read (aid data) | Read | Read (aid data) | Read |
| Dean / Department Chair | No | No | Read (their college) | Read (their college) | Read |
| Advisor | No | No | Read (their advisees) | Read (their advisees) | Read |
| Institutional Researcher | No | No | Read (aggregated) | No | Read |
| External Auditor | No | No | No | As authorized | As authorized |
| Student (self-service) | No | No | No | Own record only | No |

---

## GLBA Compliance Architecture

### What GLBA Requires

The **Gramm-Leach-Bliley Act** (15 U.S.C. §§ 6801-6809) applies to higher education institutions because they engage in financial activities (student loans, payment plans, institutional lending). GLBA protects **customer financial information** (CFI).

**Data covered by GLBA in higher education:**

| Data Element | HELIX Resource | Classification |
|-------------|---------------|----------------|
| Student account balances | StudentAccount (planned) / AR | **Restricted** |
| Financial aid award details | `FinAidAward` | **Restricted** |
| EFC / Student Aid Index | `FinAidAward.efc` | **Restricted** |
| Bank account / routing numbers (for refunds) | Payment records | **Restricted** |
| SSN (used for financial aid processing) | `Person.identifiers` (tokenized) | **Restricted** |
| Student loan information | `FinAidAward` (loan types) | **Restricted** |
| Tax return information (from FAFSA) | ISIR data | **Restricted** |
| Tuition payment plan details | AR / Student Financials | **Restricted** |
| Perkins loan records | Legacy loan system | **Restricted** |
| Institutional loan records | Finance system | **Restricted** |

### GLBA Implementation by Layer

**Bronze:**
- All financial records (PS_STDNT_AWARDS, PS_ITEM, PS_ISIR_COMPUTED, payment tables) classified as `restricted` at ingestion
- Encrypted with dedicated KMS keys separate from general confidential data
- Access requires both FERPA acknowledgment AND GLBA-specific authorization

**Silver:**
- `FinAidAward` records carry `meta.classification: restricted`
- EFC/SAI values tokenized or encrypted at rest with column-level encryption
- Bank account and routing numbers **never promoted to silver** — retained in bronze only, accessed via secure API when needed for processing
- GLBA-covered fields in silver require an additional access grant beyond standard FERPA authorization

**Gold:**
- Financial aid gold tables (`gold.financial_aid_summary`) contain aggregated/summarized data only — no individual loan amounts, no EFC, no bank details
- Per-student financial detail gold views are restricted to Financial Aid Director role and above
- Any gold table combining financial data with identifiable student data requires both FERPA and GLBA access authorization

### GLBA Safeguards Rule Alignment

| Safeguards Rule Requirement | Lake Implementation |
|---------------------------|-------------------|
| **Designate a coordinator** | HELIX Govern role: Data Steward (Financial Aid domain) + GLBA Compliance Officer |
| **Risk assessment** | Annual assessment of lake access patterns, data flows, and third-party integrations |
| **Design safeguards** | Column-level encryption for restricted financial fields, separate KMS keys, MFA for access |
| **Oversee service providers** | Data sharing agreements with any third-party that receives GLBA-covered data. Cloud provider (AWS/Azure/GCP) BAA equivalent. |
| **Evaluate and adjust** | Quarterly review of access logs for GLBA-covered tables. Annual penetration test. |

---

## HELIX Resource Classification Map

Every HELIX resource has a default classification. Institutions may elevate (never downgrade) based on their policies.

| Resource | Default Classification | Regulatory Driver | Contains PII | Contains CFI (GLBA) |
|----------|----------------------|-------------------|-------------|-------------------|
| `Person` | **Confidential** | FERPA | Yes (name, DOB, contact, demographics) | No |
| `Student` | **Confidential** | FERPA | Yes (via person_ref + student-specific attributes) | No |
| `Enrollment` | **Confidential** | FERPA | Yes (student course-level records) | No |
| `AcademicPeriod` | Internal | None | No | No |
| `Course` | **Public** | None | No | No |
| `CourseSection` | Internal | None | No (instructor names are directory info) | No |
| `Program` | **Public** | None | No | No |
| `StudentProgram` | **Confidential** | FERPA | Yes (student's program, GPA, standing) | No |
| `FinAidAward` | **Restricted** | FERPA + GLBA | Yes (student financial data) | **Yes** |
| `Degree` | **Confidential** | FERPA | Yes (unless directory info and not restricted) | No |
| `AdmissionApplication` | **Confidential** | FERPA | Yes (applicant PII, test scores) | No |
| `TransferCredit` | **Confidential** | FERPA | Yes (student academic record) | No |
| `Hold` | **Confidential** | FERPA | Yes (nature of hold can reveal protected info) | Potentially (financial holds) |
| `AcademicOrg` | Internal | None | No | No |
| `Institution` | **Public** | None | No | No |
| `Constituent` | **Confidential** | State privacy laws, donor intent | Yes (donor PII, giving capacity) | No |
| `Gift` | **Confidential** | IRS, state solicitation laws, donor intent | Yes (linked to donor) | No |
| `Campaign` | Internal | None | No | No |
| `EngagementActivity` | Internal | FERPA (if student), CAN-SPAM (if email) | Indirectly (linked to person) | No |

---

## End-to-End Data Flow: From ERP to Dashboard

### Example: Fall Enrollment Dashboard

```
1. EXTRACT (Nightly at 2 AM)
   PeopleSoft CS → SFRSTCR, SGBSTDN, STVTERM, PS_STDNT_ENRL
   ↓
2. BRONZE LAND (2:05 AM)
   Raw Parquet files → s3://lake/bronze/peoplesoft/ps_stdnt_enrl/extract_date=2026-08-31/
   Tagged: classification=confidential, source=peoplesoft, batch=20260831-020500
   ↓
3. SILVER TRANSFORM (2:30 AM, via Spark/dbt)
   Apply HELIX Bridge: bridge/peoplesoft/cs/enrollment_mapping.json
   ↓ Validate: HELIX quality rules (EN-001 through EN-006)
   ↓ PII handling: tokenize identifiers, apply FERPA check
   ↓ Write: silver.enrollment (Iceberg table)
   ↓
4. GOLD BUILD (3:00 AM, via dbt)
   gold.enrollment_census_snapshot:
     JOIN silver.enrollment + silver.student + silver.academic_period
     FILTER: academic_period.census_date <= today
     AGGREGATE: headcount by college, program, level, demographic
   gold.enrollment_funnel:
     JOIN silver.admission_application + silver.student + silver.enrollment
     CALCULATE: conversion rates by stage
   ↓
5. CONSUME (8:00 AM, when VP opens dashboard)
   QuickSight dashboard reads from gold.enrollment_census_snapshot
   Shows: total headcount vs target, change from prior year, breakdown by college
   Drill-through: click "College of Engineering" → section-level enrollment detail
```

### Example: Donor Thank-You Agent

```
1. REAL-TIME TRIGGER
   Gift record created in Raiser's Edge → event stream → bronze land
   ↓
2. SILVER (near real-time, 5-minute micro-batch)
   Apply HELIX Bridge → silver.gift (new record)
   ↓
3. AGENT QUERY (triggered by new silver.gift record)
   SELECT gift.*, constituent.*, recent_engagement.*
   FROM silver.gift
   JOIN silver.constituent ON gift.constituent_ref = constituent.helix_id
   LEFT JOIN (SELECT ... FROM silver.engagement_activity WHERE ...) recent_engagement
   WHERE gift.acknowledgment_status = 'pending'
   ↓
4. AI GENERATION
   Agent drafts personalized thank-you using gift + constituent + engagement context
   ↓
5. HUMAN REVIEW
   Development officer reviews, edits, sends within 48 hours
   ↓
6. FEEDBACK LOOP
   Gift.acknowledgment_status updated to 'sent'
   Gift.acknowledgment_date populated
   EngagementActivity record created (type: 'thank_you_letter')
```

---

## Technology Stack Reference

HELIX is technology-neutral at the spec layer, but here's the recommended stack for each major cloud:

| Component | AWS | Azure | GCP |
|-----------|-----|-------|-----|
| Object Storage | S3 | ADLS Gen2 | GCS |
| Table Format | Apache Iceberg | Apache Iceberg | Apache Iceberg |
| Catalog | AWS Glue Data Catalog | Unity Catalog / Hive | BigLake Metastore |
| ETL / Transform | Glue, EMR (Spark), dbt | Synapse, Databricks, dbt | Dataproc, BigQuery, dbt |
| Quality | dbt tests, Great Expectations | dbt tests, Great Expectations | dbt tests, Great Expectations |
| Query Engine | Athena, Redshift Spectrum | Synapse Serverless, Databricks SQL | BigQuery |
| Dashboards | QuickSight | Power BI | Looker |
| Access Control | Lake Formation, IAM | Purview, RBAC | IAM, Data Catalog |
| Encryption | KMS (SSE-S3, SSE-KMS) | Azure Key Vault | Cloud KMS |
| Audit Logging | CloudTrail, S3 Access Logging | Monitor, Diagnostic Logs | Cloud Audit Logs |
| Event Stream (real-time) | Kinesis, EventBridge | Event Hubs | Pub/Sub |
| AI/ML | SageMaker, Bedrock | Azure ML, OpenAI Service | Vertex AI |

---

## Implementation Checklist

### Phase 1: Foundation (Weeks 1-4)
- [ ] Provision lake storage (S3/ADLS/GCS) with encryption enabled
- [ ] Set up Iceberg catalog (Glue/Unity/BigLake)
- [ ] Define bronze landing zones for each source system
- [ ] Implement bronze ingestion pipeline for primary ERP
- [ ] Apply HELIX data classification tags to all bronze tables
- [ ] Set up access logging and audit trail

### Phase 2: Silver (Weeks 5-10)
- [ ] Implement HELIX Bridge transforms (bronze → silver) for core resources
- [ ] Create Iceberg tables for each HELIX Core resource
- [ ] Implement PII tokenization and FERPA restriction logic
- [ ] Deploy HELIX quality rules as dbt tests / Great Expectations
- [ ] Set up RBAC aligned to HELIX Govern roles
- [ ] Validate silver output against HELIX JSON Schemas

### Phase 3: Gold (Weeks 11-16)
- [ ] Build gold tables for priority use cases (enrollment dashboard, retention cohort, donor 360)
- [ ] Implement metric definitions in semantic layer
- [ ] Create anonymized gold tables for research
- [ ] Deploy dashboards connected to gold
- [ ] Document access policies per gold table per role

### Phase 4: Compliance & Operations (Ongoing)
- [ ] Annual FERPA access review
- [ ] Quarterly GLBA safeguards review
- [ ] Monthly data quality report (HELIX Govern quality rule pass rates)
- [ ] HELIX Govern maturity self-assessment (annual)
- [ ] Schema evolution process when HELIX Core versions up

---

## HELIX Resources Referenced in This Guide

Every HELIX Core resource is mapped to a layer, classified, and compliance-tagged in this guide:

| Resource | Bronze | Silver | Gold | Classification | FERPA | GLBA |
|----------|--------|--------|------|---------------|-------|------|
| Person | ✅ | ✅ | ✅ | Confidential | ✅ | |
| Student | ✅ | ✅ | ✅ | Confidential | ✅ | |
| Enrollment | ✅ | ✅ | ✅ | Confidential | ✅ | |
| AcademicPeriod | ✅ | ✅ | ✅ | Internal | | |
| Course | ✅ | ✅ | ✅ | Public | | |
| CourseSection | ✅ | ✅ | ✅ | Internal | | |
| Program | ✅ | ✅ | ✅ | Public | | |
| StudentProgram | ✅ | ✅ | ✅ | Confidential | ✅ | |
| FinAidAward | ✅ | ✅ | ✅ | **Restricted** | ✅ | ✅ |
| Degree | ✅ | ✅ | ✅ | Confidential | ✅ | |
| AdmissionApplication | ✅ | ✅ | ✅ | Confidential | ✅ | |
| TransferCredit | ✅ | ✅ | ✅ | Confidential | ✅ | |
| Hold | ✅ | ✅ | ✅ | Confidential | ✅ | |
| AcademicOrg | ✅ | ✅ | ✅ | Internal | | |
| Institution | ✅ | ✅ | ✅ | Public | | |
| Constituent | ✅ | ✅ | ✅ | Confidential | | |
| Gift | ✅ | ✅ | ✅ | Confidential | | |
| Campaign | ✅ | ✅ | ✅ | Internal | | |
| EngagementActivity | ✅ | ✅ | ✅ | Internal | | |

---

*HELIX Lakehouse Architecture Guide v0.1 — August 2026*
*Part of the [HELIX Open Framework](https://github.com/utopify/helix)*
