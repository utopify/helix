# Prompt: Finish a PL/SQL to PostgreSQL conversion

**Use when:** AWS DMS Schema Conversion (including its generative AI option) converted most of a Banner or PeopleSoft Oracle object to PostgreSQL but flagged items it couldn't finish.

**Inputs:** the original Oracle source, the partial PostgreSQL output, and the Schema Conversion action items for the object.

## Before you run it

- Send code and table definitions only. Never paste student, employee, donor, or financial aid rows. If the model needs examples, write synthetic ones.
- Include the register row (`customization_id`, disposition, target) so the output can be traced back.
- Run it in Amazon Bedrock inside your own AWS account, so the code stays within your account.
- Commit the original source and the output side by side for review.

## Prompt

```
You are converting Oracle PL/SQL from {source_system} (customization {customization_id}) to
{target} (Aurora PostgreSQL or RDS for PostgreSQL, version {pg_version}).

AWS DMS Schema Conversion produced the partial conversion below and listed these unresolved
action items:
{action_items}

Rules:
1. Change only what the action items require. Keep everything Schema Conversion already converted.
2. Keep behavior identical, including NULL handling, empty string vs NULL (Oracle treats '' as NULL;
   PostgreSQL does not), date arithmetic, implicit conversions, rounding, and exception behavior.
3. Translate transaction control carefully. PostgreSQL procedures commit differently than Oracle
   packages; say exactly where behavior could change.
4. Replace Oracle packages with a schema of functions and procedures; replace package state with
   explicit parameters or a table, and say which you chose.
5. Don't invent tables. If the code references an object that isn't in the inputs, list it.
6. Mark anything you aren't sure about with -- REVIEW: and a one-line reason.

Return:
A. The complete converted object.
B. A table of every change you made: Oracle construct, PostgreSQL replacement, behavior risk.
C. Three to five test cases (inputs and expected outputs) that would prove the old and new versions match.

Original Oracle source:
{oracle_source}

Partial PostgreSQL from Schema Conversion:
{partial_postgres}
```

## Review checklist

- [ ] Every `-- REVIEW:` resolved by a developer
- [ ] Empty string and NULL behavior tested
- [ ] The test cases run against both versions with the same data and match
- [ ] Register row updated: `conversion_status`, `reviewer`, `verified_date`
