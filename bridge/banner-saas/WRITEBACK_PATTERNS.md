# HELIX -> Banner SaaS: Write-Back Patterns

How to load or synchronize HELIX Core data into an Ellucian Banner SaaS tenant.
Banner SaaS has no direct database access, so every write goes through a
governed API. This guide covers the three write paths, identity correlation,
idempotency, ordering, and reconciliation.

## The three write paths

+----------------------+-------------------------------+---------------------------+
| Path                 | Best for                      | Notes                     |
+----------------------+-------------------------------+---------------------------+
| Ethos Integration    | Person and reference data;    | Canonical REST/JSON;      |
| API                  | GUID-keyed resource writes    | GUID-referenced; the      |
|                      | (persons, courses, sections)  | default write path        |
+----------------------+-------------------------------+---------------------------+
| Banner Integration   | Banner-specific operations    | Use when Ethos does not   |
| API (BIA)            | and process endpoints Ethos   | expose the operation      |
|                      | does not surface              | directly                  |
+----------------------+-------------------------------+---------------------------+
| Ellucian Data        | Bulk/batch movement,          | Managed pipelines; native |
| Connect (EDC)        | scheduled sync, large loads   | relational target is      |
|                      |                               | PostgreSQL                |
+----------------------+-------------------------------+---------------------------+

Rule of thumb: single-record and reference writes -> Ethos; process operations
(registration, admissions decisions) -> BIA / business-process APIs; bulk and
scheduled -> Data Connect.

## GUID identity correlation

Ethos identifies everything by GUID and correlates resources by GUID. HELIX
identifies everything by `helix_id`. You must maintain a crosswalk.

+-------------+----------------------+-------------------------+
| helix_id    | ethos_guid           | ethos_resource          |
+-------------+----------------------+-------------------------+
| person:1a2b | 5f3c...-a1 (GUID)    | persons                 |
| sect:9x8y   | 7d21...-c4 (GUID)    | sections                |
+-------------+----------------------+-------------------------+

- On create: POST returns the new GUID; capture and store it in the crosswalk.
- On update: look up the GUID from the crosswalk and PUT to that GUID.
- Never write `helix_id` into Ethos. It is HELIX-side provenance only.
- For records that already exist in the tenant (e.g., migrated persons), seed
  the crosswalk by querying Ethos on a natural key (Banner ID credential) first.

## Idempotency and upsert

- **Search before create.** For `persons`, query by Banner ID credential (or use
  matching requests) before POSTing to avoid duplicate GUIDs. Duplicate persons
  are expensive to unwind.
- **PUT for updates, POST for creates.** Decide by crosswalk hit/miss, not by
  assuming.
- **Change detection.** Only write attributes that changed; full-object PUTs can
  clobber tenant-owned fields not represented in HELIX.
- **Store the returned GUID immediately** so a retry does not create a second
  copy.

## Ordering and dependencies

Referential prerequisites must exist before dependent writes. Typical order:

+--------------------------------------------------------------+
| 1. persons                                                   |
| 2. students            (references person GUID)              |
| 3. academic-periods    (reference/config; often pre-exists)  |
| 4. courses             (references subject, units, levels)   |
| 5. sections            (references course + academic-period) |
| 6. academic-programs   (reference/config; often pre-exists)  |
| 7. student-academic-programs (references student + program)  |
| 8. section-registrations (references registrant + section;   |
|    business process, validates holds/prereqs/capacity)       |
+--------------------------------------------------------------+

Resolve every GUID reference (subject, academic-level, degree, race, ethnicity,
gender-identity, registration-status, ...) from the tenant before the write.

## Rate limiting, batching, retry

- Respect Ethos rate limits; back off on HTTP 429.
- Batch through Data Connect for large loads rather than hammering Ethos per row.
- Retry only idempotent operations, and only after confirming the prior attempt
  did not already create the record (check the crosswalk / re-query).
- Treat business-process rejections (hold, prerequisite, capacity) as terminal
  for that record, not as transient errors to retry.

## What you CANNOT write directly

- **Registration** is a process, not a field. Use the registration API which
  enforces holds, prerequisites, capacity, and time-ticketing.
- **Reference/config data** (terms, catalog, programs) is frequently governed by
  Banner configuration or curriculum management; Ethos may expose it read-mostly.
- **Derived/computed fields** (GPA, derived statuses) are produced by Banner and
  should not be pushed.
- Where a direct write is not available, invoke the corresponding business
  process (BIA) and let Banner produce the record.

## Why on-prem patterns do not port

On-prem integrations often INSERT/UPDATE Banner tables directly or run stored
procedures that embed eligibility and validation logic. In SaaS:

- Direct table writes are impossible (no database access).
- Stored-procedure logic has no host; the rules must be re-expressed as
  application logic that calls Ethos/BIA and honors server-side validation.
- The safe migration is: extract the hidden business rules first, rebuild them
  against the API, and reconcile results against the old outputs before cutover.

## Reconciliation

After a load, verify:

- Row/record counts written vs. confirmed present in the tenant (re-query Ethos).
- Crosswalk completeness: every intended helix_id has an ethos_guid.
- Rejected records logged with reason (hold, prereq, capacity, validation).
- A sample field-level comparison (HELIX value vs. Ethos value) per resource.
