# Prompt: Extract business rules from PeopleCode for a Workday rebuild

**Use when:** the register says `rebuild` on Workday for modified or custom PeopleCode. PeopleCode doesn't convert to Workday; the goal is a clear list of rules the Workday team can configure.

**Inputs:** the PeopleCode text (from `04_peoplecode.sql`), the record and field definitions it touches, and any translate values it checks.

## Before you run it

- Send code and table definitions only. Never paste student, employee, donor, or financial aid rows. If the model needs examples, write synthetic ones.
- Include the register row (`customization_id`, disposition, target) so the output can be traced back.
- Run it in Amazon Bedrock inside your own AWS account, so the code stays within your account.
- Commit the original source and the output side by side for review.

## Prompt

```
Read this PeopleSoft PeopleCode from {module} (customization {customization_id}, event {event_path})
and write down every business rule it enforces, in plain English, for a functional analyst
rebuilding it in Workday {workday_area}.

For each rule give:
- Rule: one sentence a registrar, HR partner, or controller would understand
- Trigger: when it runs (on save, on field change, during a batch, on page load)
- Data: the records and fields it reads and changes, with the HELIX resource and attribute from the
  bridge mappings provided
- Outcome: what happens (error, warning, default value, field hidden, row inserted, email sent)
- Workday approach: the most likely Workday mechanism (business process condition or validation,
  calculated field, custom validation, eligibility rule, integration, report), with a confidence of
  high, medium, or low
- Questions: anything the business owner has to answer before rebuilding

Also list:
- Code that does nothing useful (dead branches, commented-out logic, hardcoded test IDs)
- Hardcoded values (terms, codes, operator IDs, dollar amounts) that should become configuration
- Calls to other PeopleCode, SQL objects, or Integration Broker that need their own register rows

Don't describe syntax line by line. Describe what the code means for the people using it.

PeopleCode:
{peoplecode_text}

Record and field definitions:
{record_definitions}

Bridge mappings:
{bridge_mapping_excerpts}
```

## Review checklist

- [ ] Business owner confirmed each rule is still wanted
- [ ] Each kept rule has a Workday design item
- [ ] Hardcoded values moved into Workday configuration, not into a new hardcoded rule
