# HELIX Institution Profile

Step 1 of [START_HERE](../../START_HERE.md). Fill this in before anyone writes a query. It takes an afternoon, it saves weeks, and it's the first thing an AI assistant or implementation partner will ask for.

Copy this file, fill it in, and keep it with your project. A machine-readable version is in [`institution-profile.yaml`](institution-profile.yaml), and a filled-in example for a PeopleSoft school is in [`institution-profile.example.yaml`](institution-profile.example.yaml).

---

## 1. About the institution

| Question | Answer |
|----------|--------|
| Institution name | |
| Public or private | |
| Approximate student headcount | |
| Approximate employee headcount | |
| IPEDS Unit ID | |
| Fiscal year starts | |
| Academic calendar (semester, quarter, trimester) | |

## 2. Your goal

Pick one. See [START_HERE, Step 2](../../START_HERE.md#step-2-pick-your-goal).

- [ ] **A.** Build a lakehouse on HELIX (keep the ERP for now)
- [ ] **B.** Migrate PeopleSoft to Workday (which modules? HCM / FIN / Student)
- [ ] **C.** Migrate Banner on-prem to Banner SaaS
- [ ] **D.** Stand up data governance

| Question | Answer |
|----------|--------|
| Why now? What's driving this? | |
| Executive sponsor | |
| Target date for the first result | |

## 3. Source systems

One row per database or system. Include reporting copies, standbys, and old systems people still query. This is where the surprises usually are.

| Name | What it runs (module) | App / tools version | Database and version | Hosted where | Role (prod, reporting copy, standby, dev) | Refreshed how often | How you can connect | Owner |
|------|-----------------------|---------------------|----------------------|--------------|-------------------------------------------|---------------------|---------------------|-------|
| | | | | | | | | |
| | | | | | | | | |
| | | | | | | | | |

## 4. Existing warehouse and reporting

| Question | Answer |
|----------|--------|
| Is there a data warehouse today? Which platform? | |
| What feeds it, and how often? | |
| Who relies on it (IR, finance, HR, registrar)? | |
| Which reports are "the official number"? | |
| Will HELIX replace it, sit beside it, or feed it? | |

## 5. Identity

| Question | Answer |
|----------|--------|
| What's the person ID in each system (EMPLID, PIDM, Workday ID)? | |
| Is the same person ID shared across student, HR, and finance? | |
| Where does SSN live, and who can see it? | |
| Are there known duplicate-person problems? | |

## 6. Where HELIX will live

| Question | Answer |
|----------|--------|
| Cloud provider (or on-prem) | |
| Warehouse or lakehouse engine (Snowflake, Redshift, Databricks, BigQuery, S3 Tables/Iceberg, other) | |
| Orchestration (Airflow, Step Functions, Glue, other) | |
| Transformation (dbt, Spark, SQL) | |
| BI tool (QuickSight, Tableau, Power BI, other) | |

## 7. Governance and compliance

| Question | Answer |
|----------|--------|
| FERPA compliance officer | |
| GLBA Qualified Individual (16 CFR 314.4(a)) | |
| Is there a data classification policy? | |
| Known data stewards (registrar, controller, HR director, aid director) | |

## 8. Your first slice

See [Good first slices](../../START_HERE.md#step-3-good-first-slices).

| Question | Answer |
|----------|--------|
| Slice (student census, GL year, workforce, aid year) | |
| HELIX resources in scope | |
| Time window (one term, one fiscal year, one date) | |
| The trusted number it has to match | |
| Who signs off that it matches | |

## 9. People

| Role | Name |
|------|------|
| Project lead | |
| Data engineer(s) | |
| Functional experts (student, HR, finance, aid) | |

## 10. Constraints and risks

Anything that could slow you down: freeze windows, contract dates, staff turnover, security reviews, audits.

-
-
