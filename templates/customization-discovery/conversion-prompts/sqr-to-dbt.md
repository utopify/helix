# Prompt: Convert an SQR report to dbt and a dashboard

**Use when:** a PeopleSoft SQR (or Banner report program) is marked `convert` to the lakehouse.

**Inputs:** the `.sqr` file and every `.sqc` it includes, plus bridge mappings for the records it reads.

## Before you run it

- Send code and table definitions only. Never paste student, employee, donor, or financial aid rows. If the model needs examples, write synthetic ones.
- Include the register row (`customization_id`, disposition, target) so the output can be traced back.
- Run it in Amazon Bedrock inside your own AWS account, so the code stays within your account.
- Commit the original source and the output side by side for review.

## Prompt

```
Convert this SQR report (customization {customization_id}) into:
1. dbt models over HELIX silver that produce the same rows and totals, and
2. a short spec for an Amazon Quick Sight dashboard or a CSV extract that replaces the printed layout.

Rules:
- Separate the data logic (begin-select blocks, procedures that compute values) from the layout
  (print positions, page headers, page breaks). Convert the data logic; describe the layout.
- Resolve every #include. If a .sqc wasn't provided, list it and stop at that point.
- Run control parameters (prompts, run control records) become dbt variables or dashboard filters.
  List them.
- Translate PeopleSoft effective-dated subqueries to the HELIX silver as-of columns, using the bridge
  mappings provided.
- Totals and subtotals must match the original. Put them in a final model so they can be reconciled.
- Mark uncertain logic with -- REVIEW:.

Return the dbt models, a schema.yml with tests, the parameter list, the layout spec, and a
reconciliation query comparing the SQR output file to the new model.

SQR source and includes:
{sqr_source}

Bridge mappings:
{bridge_mapping_excerpts}
```

## Review checklist

- [ ] Report run for the same parameters in PeopleSoft and from dbt; totals match
- [ ] Every run control parameter has a filter or variable
- [ ] Register row updated
