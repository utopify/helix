# Prompt: Turn PL/SQL report logic into dbt models on HELIX silver

**Use when:** a Banner or PeopleSoft custom package, procedure, or view builds a report or extract, and the register says `convert` to the lakehouse.

**Inputs:** the Oracle source, and the HELIX bridge mappings for every table it reads (from `bridge/banner/` or `bridge/peoplesoft/`).

## Before you run it

- Send code and table definitions only. Never paste student, employee, donor, or financial aid rows. If the model needs examples, write synthetic ones.
- Include the register row (`customization_id`, disposition, target) so the output can be traced back.
- Run it in Amazon Bedrock inside your own AWS account, so the code stays within your account.
- Commit the original source and the output side by side for review.

## Prompt

```
Rewrite this Oracle report logic from {source_system} (customization {customization_id}) as dbt
models that read HELIX silver tables instead of the original ERP tables.

The bridge mappings below say which HELIX resource and attribute each source column became.
Use them to translate every column reference. Use the HELIX code values, not the ERP codes
(for example, use helix/enrollment-status values, not SFRSTCR_RSTS_CODE values).

Rules:
1. One model per logical step. Use CTEs, not temporary tables.
2. Use ref() for HELIX silver models named after the resource in snake_case (student, enrollment,
   academic_period, and so on).
3. Effective dating and term logic is already resolved in silver. Don't re-implement EFFDT/EFFSEQ
   or effective-term lookups; if the original depends on as-of logic silver doesn't carry, say so.
4. Apply the HELIX classification of every resource you read. If the output includes confidential
   or restricted attributes, add a model config tag for the classification.
5. If a column has no HELIX equivalent in the mappings, stop and list it rather than guessing.
6. Mark uncertain logic with -- REVIEW:.

Return:
A. The dbt model files, each with a header comment naming the customization_id.
B. A schema.yml with tests for keys and the business rules you found.
C. A column-by-column map: original column, HELIX attribute, transformation.
D. A reconciliation query that compares the old report output to the new model output.

Oracle source:
{oracle_source}

Bridge mappings for the tables it reads:
{bridge_mapping_excerpts}
```

## Review checklist

- [ ] Every column traced through a bridge mapping
- [ ] Reconciliation query returns zero differences on the same period
- [ ] Classification tags match `govern/access-control-matrix.json`
