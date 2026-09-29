# PeopleSoft Extraction Playbook

Step 4 of [START_HERE](../../START_HERE.md): how to get data out of PeopleSoft and into the HELIX bronze layer.

This covers self-managed PeopleSoft on Oracle (on-prem, Oracle on EC2, or OCI), which is where nearly every PeopleSoft campus is today. It assumes the common setup where Campus Solutions, HCM, and Financials (FSCM) each run on their own database, often with reporting copies and an older warehouse on the side.

---

## 1. Map your databases first

Most PeopleSoft schools have more databases than people remember. Before extracting anything, list them in the [institution profile](../../templates/intake/institution-profile.md).

```
  Production (never extract from these)      Extract from these
  +-----------+                              +-----------+
  |  CSPRD    |  -- nightly refresh -------> |  CSRPT    |  Campus Solutions reporting copy
  +-----------+                              +-----------+
  +-----------+                              +-----------+
  |  HRPRD    |  -- nightly refresh -------> |  HRRPT    |  HCM reporting copy
  +-----------+                              +-----------+
  +-----------+                              +-----------+
  |  FSPRD    |  -- nightly refresh -------> |  FSRPT    |  Financials reporting copy
  +-----------+                              +-----------+

  Legacy warehouse (fed from the copies): a second opinion for reconciliation, not your source
```

Rules of thumb:

- **Extract from reporting copies, Data Guard standbys, or read replicas.** Never from production during business hours, and ideally never at all.
- **Land each pillar separately.** CS, HCM, and FSCM go into their own bronze areas. Don't join across databases with DB links at extraction time. Joining happens in silver.
- **Write down each copy's refresh time.** If CSRPT refreshes at 2am and HRRPT at 4am, a 3am extract gives you two different points in time.
- **The legacy warehouse is useful but not trusted.** Its star schemas already applied someone's business rules. Use it to cross-check your HELIX numbers in step 5, not as the source.

If you run **PeopleSoft EPM** (the Operational Warehouse Staging layer), it can be a shortcut for history, since it already holds snapshots. Treat it the same way as the legacy warehouse: helpful, but confirm against the source records.

---

## 2. Five PeopleSoft concepts that decide whether your extract is right

### EMPLID is the person, across pillars

EMPLID identifies a person in both Campus Solutions and HCM. A faculty member who takes a class has one EMPLID in both databases. Carry EMPLID into bronze untouched on every person-related row. Identity resolution to a single HELIX Person happens on the way to silver (see [`govern/ferpa-disclosure-framework.json`](../../govern/ferpa-disclosure-framework.json)). If admissions sometimes creates duplicate EMPLIDs, note that in the profile; it's the most common identity problem on PeopleSoft campuses.

### Effective dating: EFFDT and EFFSEQ

Most PeopleSoft setup and history records are effective-dated. A record like `PS_JOB` or `PS_ACAD_PLAN` holds every version, and the current one is the row with the greatest `EFFDT` that isn't in the future, then the greatest `EFFSEQ` on that date.

```sql
-- Current row per key, as of a date
SELECT j.*
FROM   ps_job j
WHERE  j.effdt = (SELECT MAX(j2.effdt) FROM ps_job j2
                  WHERE  j2.emplid = j.emplid AND j2.empl_rcd = j.empl_rcd
                  AND    j2.effdt <= :as_of_date)
AND    j.effseq = (SELECT MAX(j3.effseq) FROM ps_job j3
                   WHERE  j3.emplid = j.emplid AND j3.empl_rcd = j.empl_rcd
                   AND    j3.effdt = j.effdt);
```

**In bronze, land all effective-dated rows, not just the current one.** Current-row logic belongs in silver, where it's visible and testable. If you're migrating to Workday later, you'll need the history anyway.

Also check `EFF_STATUS`. An effective-dated row with `EFF_STATUS = 'I'` is inactive as of that date, not deleted.

### SETID and TableSets

Setup tables in HCM and FSCM (departments, job codes, accounts, funds) are often shared through **SETID**, and each business unit points to a SETID through `PS_SET_CNTRL_REC`. If you extract `PS_DEPT_TBL` without SETID you'll see what look like duplicate departments. Always extract SETID with setup tables and extract `PS_SET_CNTRL_REC` so silver can resolve which set applies to which business unit.

### Translate values (XLAT)

Many short codes (for example `HR_STATUS`, `ACAD_CAREER` status flags) are decoded through the translate table, `PSXLATITEM`. Extract it once per run. Land the raw code in bronze and decode in silver. HELIX terminology bindings work on the raw code; the translate label is for people.

### Records vs views

Tables are named `PS_<RECORD>`. Many things people query day to day are views (often ending in `_VW`) that already filter or join. Prefer the underlying records for extraction so you see everything, then rebuild any view logic you rely on in silver where it's documented.

---

## 3. What to extract for each first slice

These match the slices in [START_HERE, Step 3](../../START_HERE.md#step-3-good-first-slices). The bridge files in [`cs/`](cs/), [`hcm/`](hcm/), and [`fin/`](fin/) list every field.

| Slice | Database | Records to extract (starting set) | Bridge files |
|-------|----------|-----------------------------------|--------------|
| **Student census, one term** | CS | `PS_PERSON`, `PS_NAMES`, `PS_PERSONAL_DATA`, `PS_STDNT_CAR_TERM`, `PS_ACAD_PROG`, `PS_ACAD_PLAN`, `PS_STDNT_ENRL`, `PS_CLASS_TBL`, `PS_TERM_TBL`, `PS_ACAD_PROG_TBL`, `PS_ACAD_PLAN_TBL`, `PSXLATITEM` | `cs/person_mapping.json`, `student_mapping.json`, `academic_period_mapping.json`, `student_program_mapping.json`, `enrollment_mapping.json` |
| **GL, one fiscal year** | FSCM | `PS_JRNL_HEADER`, `PS_JRNL_LN`, `PS_LEDGER`, `PS_GL_ACCOUNT_TBL`, `PS_FUND_TBL`, `PS_DEPT_TBL`, `PS_PROGRAM_TBL`, `PS_SET_CNTRL_REC` | `fin/general_ledger_mapping.json`, `fund_mapping.json`, `cost_center_mapping.json` |
| **Active workforce, one date** | HCM | `PS_PERSON`, `PS_NAMES`, `PS_JOB`, `PS_EMPLOYMENT`, `PS_POSITION_DATA`, `PS_JOBCODE_TBL`, `PS_DEPT_TBL`, `PS_SET_CNTRL_REC`, `PSXLATITEM` | `hcm/worker_mapping.json`, `position_mapping.json`, `job_classification_mapping.json` |

Record names are the delivered PeopleSoft names. Campuses customize, so VALIDATE against your own PeopleTools metadata (`PSRECDEFN`, `PSRECFIELD`) before building the extract.

---

## 4. Full load first, then incremental

For the first slice, just do a **full extract** of the records above for the time window you picked. It's simpler and it gives you a clean baseline.

When you move to scheduled loads, pick an incremental approach per record:

| Technique | Works when | Watch out for |
|-----------|------------|---------------|
| **Timestamp high-watermark** (`LASTUPDDTTM` or similar) | The record has a reliable last-updated column | Many PeopleSoft records don't have one, and it misses hard deletes |
| **Effective-date window** | Effective-dated records where you only need rows dated recently | Back-dated corrections (new rows with old EFFDT) get missed unless the window looks back far enough |
| **Log-based CDC** (Oracle GoldenGate, LogMiner, or AWS DMS reading the reporting copy) | You need near-real-time and deletes | Needs DBA involvement and supplemental logging |
| **Full snapshot and diff** | Small setup tables (departments, job codes, terms) | Gets expensive on big records like `PS_STDNT_ENRL` or `PS_JRNL_LN` |

A common, sane pattern: log-based CDC or high-watermark for the big transaction records, full snapshot and diff for setup tables, and a periodic full reconcile to catch anything the incrementals missed.

---

## 5. Landing it in bronze

- Land **raw rows**, keys and codes exactly as PeopleSoft has them: EMPLID, EMPL_RCD, EFFDT, EFFSEQ, SETID, BUSINESS_UNIT, STRM, ACAD_CAREER.
- Add `_source_system = 'peoplesoft'`, `_source_database` (CSRPT, HRRPT, FSRPT), `_source_record`, and `_extracted_at` on every row.
- **Don't clean, decode, or dedupe in bronze.** That's silver's job, where it's visible.
- Name bronze tables so the dbt starter can find them. For the student census slice, the starter expects `src_person`, `src_student`, `src_academic_period`, `src_student_program`, and `src_enrollment` (see [`templates/dbt/models/staging/_staging_models.yml`](../../templates/dbt/models/staging/_staging_models.yml)). You can land the PS records as-is and build these as views, or land directly into them.

```
Reporting copy (CSRPT)  -->  bronze.ps_cs_*  -->  staging (src_*)  -->  silver (HELIX Core)  -->  gold
                                  raw, untouched      renamed, typed        identity resolved,
                                                                             FERPA flags applied
```

---

## 6. Security before the first extract

- **SSN and national IDs** (`PS_PERS_NID`) are restricted data. Leave them out of the first slice unless identity matching needs them, and if it does, tokenize before they leave the reporting copy. See [`govern/classification-handling-rules.json`](../../govern/classification-handling-rules.json).
- **Financial aid and student account data** are GLBA covered. Keep them out of the first slice unless aid is the slice.
- **FERPA** applies from the first student row. Carry PeopleSoft's FERPA indicator into bronze with every student record.
- Use a **read-only extraction account** scoped to the records you need. Security teams approve narrow requests faster.

---

## 7. You're done with step 4 when

- Every record for your slice is in bronze with its native keys.
- Bronze row counts match the source counts for the same window (`templates/reconciliation/row_count_reconciliation.sql`).
- You wrote down the refresh time of every reporting copy you read from.

Next: [START_HERE, Step 5](../../START_HERE.md#the-six-steps), map it and prove it.

*HELIX v0.7.0, September 2026*
