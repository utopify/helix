# Banner SaaS Landing Architecture

Where should Banner SaaS data land? The answer depends on **direction**. Reads
(extract for analytics) and writes (load into SaaS) have completely different
landing targets, and conflating them is the most common design mistake teams
make when moving off Banner on-prem.

> One-line recommendation: **Land Banner SaaS reads in PostgreSQL for
> operational staging, promote to Amazon S3 Tables (managed Apache Iceberg) as
> the strategic HELIX analytics lakehouse, and write back only through
> Ethos / BIA / Data Connect - never through storage.**

## The direction split

+----------------------------------------------------------------------+
| READS  (Banner SaaS -> analytics/HELIX)                              |
|   Ethos / EDC  ->  PostgreSQL (staging)  ->  S3 Tables / Iceberg      |
|                                                                      |
| WRITES (HELIX -> Banner SaaS)                                        |
|   HELIX  ->  Ethos / BIA / Data Connect  ->  Banner SaaS             |
|   (no database, no bucket - storage is never a write target)         |
+----------------------------------------------------------------------+

## Reads: the two-stage landing

### Stage 1 - PostgreSQL (operational staging)

Ellucian Data Connect's native relational extract target is PostgreSQL, and
reference implementations land in AWS RDS for PostgreSQL. Postgres is the right
home for:

- EDC's native relational output (least-friction target).
- Near-real-time operational sync where a relational store is expected.
- Relational/transactional workloads and point lookups.
- A landing/staging tier before analytical promotion.

### Stage 2 - Amazon S3 Tables / Apache Iceberg (analytics lakehouse)

For the HELIX medallion lakehouse (bronze -> silver -> gold), the strategic
landing is Amazon S3 Tables (managed Apache Iceberg). Versus self-managed
Iceberg in general-purpose S3 buckets, S3 Tables provides managed compaction,
snapshot and orphan-file cleanup, and materially better performance
(approximately 3x query performance and up to 10x transactions/sec in AWS's
published guidance). This is where HELIX Core canonical data and consumption
models live.

Why not stop at Postgres? Postgres does not scale economically for
full-history, multi-domain analytical workloads, and it is not the HELIX
canonical analytics layer. Why not skip Postgres and land straight in Iceberg?
Because EDC's native target is relational, and operational/near-real-time
consumers expect a relational store; Postgres is the pragmatic staging tier.

## Writes: neither storage option applies

You cannot load Banner SaaS through a database connection or an S3 bucket.
Every write goes through Ethos Integration API, Banner Integration API (BIA), or
a Data Connect pipeline, with server-side validation (holds, prerequisites,
capacity, curriculum rules). See `../bridge/banner-saas/WRITEBACK_PATTERNS.md`.

## Decision matrix

+---------------------------+----------------------------+-------------------------+
| Workload                  | Landing / path             | Why                     |
+---------------------------+----------------------------+-------------------------+
| EDC native extract        | PostgreSQL (RDS)           | EDC's native relational |
|                           |                            | target                  |
+---------------------------+----------------------------+-------------------------+
| Operational sync,         | PostgreSQL (RDS)           | Relational, low-latency |
| near-real-time            |                            | point access            |
+---------------------------+----------------------------+-------------------------+
| Analytics / BI            | S3 Tables (Iceberg)        | HELIX canonical         |
|                           |                            | lakehouse; scale + perf |
+---------------------------+----------------------------+-------------------------+
| ML / feature engineering  | S3 Tables (Iceberg)        | Open format, scalable   |
|                           |                            | reads, time travel      |
+---------------------------+----------------------------+-------------------------+
| Statutory / longitudinal  | S3 Tables (Iceberg)        | Full history, snapshot  |
| reporting                 |                            | isolation               |
+---------------------------+----------------------------+-------------------------+
| Write-back into SaaS      | Ethos / BIA / Data Connect | No storage write path   |
|                           |                            | exists for SaaS         |
+---------------------------+----------------------------+-------------------------+

## Reference architecture

+-------------------+        reads         +----------------------------------------+
|   Banner SaaS     |  ----------------->  |  Ethos Integration API / Data Connect  |
| (Ellucian Platform|                      +----------------------------------------+
|  / Ellucian       |                                   |
|  Student)         |                                   v
|                   |                        +-----------------------+
|                   |                        | PostgreSQL (RDS)      |  operational
|                   |                        | staging               |  staging tier
|                   |                        +-----------------------+
|                   |                                   |
|                   |                                   v
|                   |                        +-----------------------+
|                   |                        | S3 Tables / Iceberg   |  HELIX medallion
|                   |                        |  bronze -> silver ->  |  (canonical +
|                   |                        |  gold                 |   consumption)
|                   |                        +-----------------------+
|                   |                                   |
|                   |                                   v
|                   |                        +-----------------------+
|                   |                        | BI / ML / reporting   |
|                   |                        +-----------------------+
|                   |
|                   |        writes        +----------------------------------------+
|                   |  <-----------------  | HELIX -> Ethos / BIA / Data Connect    |
+-------------------+                      +----------------------------------------+
        ^                                                   |
        +---------------------------------------------------+
             writes are API-only; never storage

## Mapping to HELIX layers

+----------+-------------------------------------------------------------+
| Layer    | Content                                                     |
+----------+-------------------------------------------------------------+
| Bronze   | Raw Ethos/EDC extracts landed as-is (Postgres staging       |
|          | and/or raw Iceberg), native GUIDs and codes intact          |
+----------+-------------------------------------------------------------+
| Silver   | HELIX Core canonical resources; identity resolved to HELIX  |
|          | Person; codes bound to HELIX terminologies                  |
+----------+-------------------------------------------------------------+
| Gold     | Consumption models, marts, reporting, ML features           |
+----------+-------------------------------------------------------------+

## Caveats

These are current best-practice patterns (2025-2026). Validate against your
Ellucian licensing and entitlements: Ethos and Data Connect access, which Ethos
resources your tenant exposes as writable, and any Banner-config-governed
reference data. Confirm S3 Tables availability in your AWS region and your
warehouse/engine's Iceberg support before committing.
