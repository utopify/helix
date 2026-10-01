# Prompt: Convert an Application Engine or batch program to AWS Glue

**Use when:** a PeopleSoft App Engine program, Banner COBOL or Pro*C job, or a scheduled PL/SQL batch is marked `convert` to the lakehouse.

**Inputs:** the program's steps in order (App Engine sections and steps with their SQL and PeopleCode actions from queries 04 to 06, or the batch source), and bridge mappings for the tables it touches.

## Before you run it

- Send code and table definitions only. Never paste student, employee, donor, or financial aid rows. If the model needs examples, write synthetic ones.
- Include the register row (`customization_id`, disposition, target) so the output can be traced back.
- Run it in Amazon Bedrock inside your own AWS account, so the code stays within your account.
- Commit the original source and the output side by side for review.

## Prompt

```
Convert this batch program (customization {customization_id}) into an AWS Glue PySpark job that reads
and writes HELIX silver tables in Amazon S3 Tables (Apache Iceberg).

Rules:
- Keep step order and restart behavior. If the original is restartable (App Engine checkpoints,
  commit intervals), say how the Glue job restarts safely (idempotent MERGE, job bookmarks, or a
  run-state table).
- Replace temporary tables and state records with DataFrames or Iceberg staging tables.
- Replace row-by-row loops with set-based Spark operations where the result is the same; flag any
  loop where order matters.
- Writes to silver use MERGE INTO keyed on helix_id.
- Anything the program wrote back into the ERP is an integration, not a lakehouse job. List it
  separately; it needs Ethos (Banner SaaS) or a Workday integration.
- Keep secrets out of code; read connection details from AWS Secrets Manager.
- Mark uncertain logic with # REVIEW:.

Return the Glue job script, the list of input and output tables with HELIX resources, a Step
Functions or EventBridge schedule suggestion, and a reconciliation query comparing old and new results.

Program steps and source:
{program_source}

Bridge mappings:
{bridge_mapping_excerpts}
```

## Review checklist

- [ ] Parallel run on the same input data; outputs match
- [ ] Restart tested by stopping the job midway
- [ ] Writes back to the ERP moved to the integration list
