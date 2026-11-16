# Workday Landing Zone

How to land Workday HCM, Financials, and Student in a HELIX lakehouse using what your Workday subscription already includes, enrich it in silver and gold, and point AI agents at the result.

Read [`../own-your-intelligence.md`](../own-your-intelligence.md) first for the why. This page is the how.

---

## 1. Ways to get data out of Workday

| Method | What it is | Included in the base subscription? | Best for |
|--------|------------|------------------------------------|----------|
| **Reports as a Service (RaaS)** | Any custom report exposed as a web service returning JSON, XML, or CSV | Yes | Most extracts. One report per HELIX resource or slice |
| **Workday Web Services (SOAP) and REST APIs** | Business object APIs such as Get_Workers and the REST endpoints | Yes | Large or detailed pulls RaaS can't shape, and write-back |
| **Outbound EIBs and Workday Studio integrations** | Scheduled file outputs to SFTP | Yes | Bulk nightly files when the team already runs EIBs |
| **Workday Prism Analytics** | Brings outside data **into** Workday for reporting there | No, an add-on | Blending outside data into Workday reports and dashboards |
| **Workday Data Cloud** (Data Lake, Data Connect, Live Data Query) | Bi-directional zero-copy access over Apache Iceberg, live SQL, and a semantic layer; integration with AWS announced June 2026, in early access | No, a separately priced package (platform fee plus Flex Credits) | Schools that want zero-copy reads or Workday's semantic layer |

Status worth knowing, from Workday's own published guidance: Data Cloud general availability was targeted for 26R2 (October 2026), with financial data, Workday Student, and Adaptive Planning reaching general availability in 27R1. Check current status with Workday before planning around it.

**The HELIX default is RaaS plus Web Services.** It works for HCM, Financials, and Student today, needs no add-on, and lands data you fully control. Data Cloud is a reasonable option for schools that already own it or decide to buy it; treat it as one more way to fill bronze, and keep your definitions on your side.

## 2. Architecture

```
  Workday tenant
    |  RaaS (JSON/CSV)      Web Services / REST      Outbound EIB (SFTP)
    v                         v                        v
  Amazon EventBridge schedule -> AWS Lambda or AWS Glue Python shell job
    |  (ISU credentials in AWS Secrets Manager; OAuth refresh token or WS-Security)
    v
  s3://<lake>/bronze/workday/<report_or_object>/extract_date=YYYY-MM-DD/   (JSON or Parquet)
    |  AWS Glue (PySpark): flatten, effective-date logic, Universal ID to HELIX ID
    v
  S3 Tables: silver.employee, silver.position, silver.gl_transaction, silver.student, ...
    |  dbt or Glue: gold metrics from templates/context/gold-metrics.yaml
    v
  gold.* in S3 Tables or Redshift Serverless
    |  Context layer: Glue business context, skills, ontology (docs/context/)
    v
  Agents on Bedrock AgentCore or Amazon Quick, through Lake Formation permissions
```

## 3. Bronze: one report per resource

Build one RaaS report per HELIX resource, named so the pipeline can find it:

| Report name (suggested) | Data source | HELIX resource | Bridge mapping |
|-------------------------|-------------|----------------|----------------|
| `HELIX_Worker` | All Workers (current and terminated in window) | Employee, Person | `bridge/workday/hr/worker_mapping.json` |
| `HELIX_Position` | Positions | Position | `bridge/workday/hr/position_mapping.json` |
| `HELIX_Compensation` | Worker compensation | Compensation | `bridge/workday/hr/compensation_mapping.json` |
| `HELIX_Payroll_Result` | Payroll Results (by pay period) | PayrollResult | `bridge/workday/hr/payroll_mapping.json` |
| `HELIX_Journal_Line` | Journal Lines (by accounting date) | GLTransaction | `bridge/workday/fin/general_ledger_mapping.json` |
| `HELIX_Supplier_Invoice` | Supplier Invoices | APVoucher | `bridge/workday/fin/accounts_payable_mapping.json` |
| `HELIX_Grant` | Grants and awards | Grant | `bridge/workday/fin/grants_mapping.json` |
| `HELIX_Student` | Students | Student, Person | `bridge/workday/sis/student_mapping.json` |
| `HELIX_Registration` | Student Course Registrations | Enrollment | `bridge/workday/sis/enrollment_mapping.json` |
| `HELIX_FA_Award` | Financial Aid Awards | FinAidAward | `bridge/workday/sis/fin_aid_award_mapping.json` |

The remaining Workday mappings in `bridge/workday/` follow the same pattern. Field names in each mapping's `source` column are the fields to put on the report.

Rules for Workday bronze:
- **Use an Integration System User (ISU)** with a security group scoped to exactly the reports it runs. Store credentials in AWS Secrets Manager; rotate them.
- **Prompt for an effective date or date range** on every report so incremental pulls are possible. Pull by "updated since" where the data source supports it; otherwise pull a rolling window and let silver deduplicate.
- **Version-control report definitions.** Export each report definition (or at least its field list) into the repo next to the pipeline. A report someone edits in the tenant silently changes your bronze.
- **Land Universal ID and Employee or Student ID** on every row. Identity resolution in silver depends on it.
- **Restricted data in its own prefix.** Compensation, payroll, benefits, and aid reports go to a restricted bronze prefix with its own KMS key.

## 4. Silver: shape it into HELIX

The Workday bridges (`bridge/workday/hr/`, `fin/`, `sis/`) say which Workday field becomes which HELIX attribute. In silver:
- Resolve Universal ID to a HELIX `helix_id`, the same one the student, aid, and CRM records use for that person.
- Translate Workday reference IDs (job profiles, worktags, academic levels) to HELIX codes with the crosswalks and terminologies.
- Keep effective-dated history as rows with `effective_start` and `effective_end`, not just the current state.
- Stamp `meta.classification` and FERPA flags; Lake Formation reads them.

## 5. Gold and context: where the value is

Once Workday data sits in silver with everything else, gold can answer questions Workday alone can't:

| Gold table | Silver resources | Question it answers |
|------------|------------------|---------------------|
| `gold.student_employee_risk` | Student, Enrollment, StudentEmployment, PayrollResult, FinAidAward | Which students work so many hours their academic progress is at risk? |
| `gold.grant_effort_vs_payroll` | Grant, PayrollResult, Employee, Position | Does effort charged to each grant match payroll? |
| `gold.faculty_load_and_cost` | Employee, JobClassification, CourseSection, Enrollment, Compensation | Instructional cost per credit hour by department |
| `gold.position_vacancy_impact` | Position, PositionBudget, CourseSection | Which open positions leave sections unstaffed? |

Definitions for these live in `templates/context/gold-metrics.yaml`. The context layer (`docs/context/context-route.md`) attaches those definitions, plus join paths and usage rules, so an agent can use gold correctly.

## 6. Security: rebuild it once

This is the real cost of the approach, so plan it:
- Map Workday security groups to the nine HELIX database roles in `govern/access-control-matrix.json`.
- Apply them in Lake Formation with LF-tags from each resource's classification, plus row filters for supervisory organization or cost center where managers see only their own.
- Pay data (Compensation, PayrollResult, BenefitEnrollment) stays restricted, masked for everyone outside HR and payroll (`govern/lakehouse-rbac-model.json`).

## 7. If you do own Workday Data Cloud

Use it as a bronze source: read the Iceberg tables Data Connect exposes, copy what you need into bronze or reference it directly, and run the same bridges. Keep metric definitions, join paths, and agent rules in your context layer, not only in Workday's semantic layer, so they survive a change of vendor and cover non-Workday data too.

## Things that trip people up

- **Report row explosion.** Multi-instance fields (worktags, positions, phone numbers) multiply rows. Decide which fields are 1:1 and use separate reports for the many-to-one ones.
- **Terminated workers missing.** "All Active Workers" leaves out history. Use a data source that includes terminations within your window.
- **Timeouts on big reports.** Page RaaS output, or split by date, organization, or company.
- **Student at a different maturity.** Student data sources differ from HCM. Test Student extracts separately and early.

*HELIX v0.10.0, November 2026*
