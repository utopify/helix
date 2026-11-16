# Prompt: Draft definitions for a custom or historical table

**Use when:** step 4 of the Context Route. `tools/draft_custom_table_context.py` has produced a review sheet with candidate HELIX matches, and you want plain-English definitions for the steward to review.

## Before you run it

- Send the review sheet rows, the table's DDL, and bridge mapping excerpts. **Never send data rows.** The profile summary already holds the counts and the steward-approved code values.
- Run it in Amazon Bedrock in your own AWS account.
- The output goes back into `drafted_definition`. A steward writes the final `steward_definition`.

## Prompt

```
You are helping a university data steward document a {source_system} table that HELIX doesn't
define: {table_name}. It is register row {register_id}, disposition {disposition}.

For each column below you have its data type, a profile (counts, null rate, distinct count, and
for approved code columns a few example values), and up to three candidate HELIX attributes with
match scores. HELIX is an open higher education data model; candidate definitions are included.

For each column, return:
1. drafted_definition: one or two plain sentences a registrar, controller, or HR partner would
   understand. Say what the value means, not how it's stored. If it's a code, say what the codes
   represent and, if the examples allow, list them.
2. helix_link: the best candidate (Resource.attribute) if it truly means the same thing, or
   "extension:<suggested_name>" if HELIX has no equivalent, or "none" for columns that shouldn't
   carry forward. Explain the choice in one sentence.
3. proposed_classification: public, internal, confidential, or restricted. Never lower than the
   value already proposed. Education records, employment records, pay, aid, health, immigration,
   and national IDs are at least confidential; GLBA-covered aid, pay, health, and national IDs are
   restricted.
4. grain_and_keys (once for the table): what one row represents and which columns identify it.
5. questions: anything the steward must answer before approving (ambiguous codes, columns that
   look unused, columns that seem to duplicate a delivered field).

Rules:
- Use only what's in the inputs. If you can't tell what a column means, say so and ask.
- Don't invent code values, business rules, or history.
- Audit columns (ACTIVITY_DATE, USER_ID, LASTUPDDTTM, and similar) map to the HELIX meta block.
- Plain language. No jargon the steward wouldn't use.

Return CSV rows with columns: column_name, drafted_definition, helix_link, link_reason,
proposed_classification, questions. Then a short paragraph for grain_and_keys.

Table DDL:
{ddl}

Review sheet rows:
{review_rows}

Candidate HELIX definitions:
{candidate_definitions}

Bridge mapping excerpts for this source system:
{bridge_excerpts}
```

## Review checklist

- [ ] Every row has a `steward_definition` written or edited by the steward
- [ ] `helix_link` checked against the HELIX schema
- [ ] Classification is the same or higher than proposed
- [ ] Questions answered or row left in `needs_info`
