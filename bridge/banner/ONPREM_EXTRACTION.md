# Banner On-Prem Extraction Playbook

How to extract data from a self-managed Ellucian Banner Oracle database (on-prem, or Oracle running on EC2) into the HELIX bronze layer.

This guide applies to the **on-prem / self-managed** deployment model, where you have direct SQL access to the Banner Oracle schema. For Banner SaaS (Ellucian Platform / Ellucian Student), direct database access does not exist -- see `bridge/banner-saas/` and `docs/banner-saas-landing-architecture.md`.

---

## 1. Access Methods

Banner on-prem exposes the full Oracle schema. Extraction options, from most to least direct:

| Method | Use When |
|--------|----------|
| Direct Oracle SQL (JDBC/ODBC) | Batch extract windows against a read replica or standby |
| Oracle Data Guard standby | Read-only physical standby isolates extraction from production OLTP |
| Materialized view logs / CDC | Incremental change capture (see Section 5) |
| GoldenGate / LogMiner | Low-latency streaming CDC into bronze |

Recommended pattern: extract from a **Data Guard standby or read replica**, never the primary production instance during business hours.

```
+-------------------+      redo apply     +----------------------+
|  Banner Oracle    | ==================>  |  Data Guard Standby  |
|  (production)     |                     |  (read-only extract) |
+-------------------+                     +----------------------+
                                                    |
                                            JDBC/ODBC batch
                                                    v
                                          +----------------------+
                                          |  HELIX Bronze (raw)  |
                                          +----------------------+
```

---

## 2. PIDM: The Universal Join Key

Every person-related Banner record links through **PIDM** (Person Internal Master ID) -- an internal integer, never shown to users.

- `SPRIDEN_PIDM` -- internal master key. Joins across student, HR, finance, and advancement modules.
- `SPRIDEN_ID` -- the visible institution-assigned ID (e.g. `900123456`).
- One person = one PIDM, even across roles (a faculty member who is also a student shares one PIDM).

**Always resolve the current identity record.** SPRIDEN keeps name/ID history; the current row has a null change indicator:

```sql
SELECT spriden_pidm, spriden_id, spriden_last_name, spriden_first_name
FROM   spriden
WHERE  spriden_change_ind IS NULL;   -- current record only
```

Carry `SPRIDEN_PIDM` and `SPRIDEN_ID` into bronze on every person-linked row. Identity resolution to a single HELIX Person happens Bronze -> Silver (see `govern/ferpa-disclosure-framework.json`); do not attempt matching in bronze.

---

## 3. STV* Validation-Table Decode

Banner stores codes on transaction tables and defines the human-readable values in **STV** (and RTV/FTV for aid/finance) validation tables. Hundreds exist: STVTERM, STVMAJR, STVDEPT, STVCOLL, RTVFTYP, FTVFUND, and so on.

**Keep the raw code AND the decoded value.** HELIX terminology binding operates on the raw code; the decoded label is for readability.

```sql
SELECT s.sgbstdn_pidm,
       s.sgbstdn_majr_code_1        AS major_code,     -- raw code -> HELIX terminology
       m.stvmajr_desc               AS major_desc      -- decoded label
FROM   sgbstdn s
JOIN   stvmajr m ON m.stvmajr_code = s.sgbstdn_majr_code_1;
```

Land the raw code in bronze. Map the raw code to the relevant HELIX terminology (e.g. `helix/fund-type`, `helix/loan-type`) at the Silver transformation.

---

## 4. Effective-Term vs Calendar Dating

Many Banner tables are **effective-term dated** using term codes (`YYYYMM`, e.g. `202510`) rather than calendar effective dates. The current record is the one with the greatest term code less than or equal to the term of interest.

```sql
-- Current student record as of a given term
SELECT *
FROM   sgbstdn a
WHERE  a.sgbstdn_pidm = :pidm
AND    a.sgbstdn_term_code_eff = (
         SELECT MAX(b.sgbstdn_term_code_eff)
         FROM   sgbstdn b
         WHERE  b.sgbstdn_pidm = a.sgbstdn_pidm
         AND    b.sgbstdn_term_code_eff <= :as_of_term);
```

Some tables (finance, advancement) use calendar `ACTIVITY_DATE` instead. Know which model each source table uses before writing incremental logic.

---

## 5. Incremental Extraction / CDC

Full extracts are simple but expensive. For large tables, extract incrementally.

| Technique | Notes |
|-----------|-------|
| `ACTIVITY_DATE` high-watermark | Most Banner tables carry an `*_ACTIVITY_DATE`. Pull rows where activity date > last run. Simple, but misses hard deletes. |
| Materialized view logs | Oracle MV logs capture change deltas for refresh. |
| GoldenGate | Log-based CDC, near-real-time, captures deletes. Best for streaming bronze. |
| LogMiner | Redo-log mining without GoldenGate licensing. |

High-watermark pattern:

```sql
SELECT *
FROM   sfrstcr
WHERE  sfrstcr_activity_date > :last_high_watermark
ORDER  BY sfrstcr_activity_date;
-- persist MAX(sfrstcr_activity_date) as the new high watermark
```

**Tradeoff:** activity-date incrementals are cheap and cover inserts/updates but not physical deletes. If referential accuracy matters (e.g. dropped registrations), reconcile periodically with a full snapshot or use log-based CDC.

---

## 6. Landing Into HELIX Bronze

- Land **raw Banner rows** with native keys intact: `SPRIDEN_PIDM`, `SPRIDEN_ID`, term codes, document codes.
- Capture `_source_system = 'banner'` and the source table name on every row.
- Do **not** transform, decode, or match identities in bronze -- that is a Silver concern.
- Identity resolution (PIDM -> one HELIX Person) and FERPA flag attachment happen Bronze -> Silver per `govern/ferpa-disclosure-framework.json`.

```
Banner Oracle  -->  Bronze (raw, PIDM intact)  -->  Silver (HELIX Core, identity resolved, FERPA flags)  -->  Gold (consumption)
```

---

## 7. Extraction Isolation & Performance

- Extract from a **standby/replica**, not the production primary.
- Schedule heavy pulls in off-peak batch windows.
- For very large tables (SFRSTCR, SHRTCKN, FGBTRND), paginate or partition by term/fiscal year.
- Avoid correlated subqueries against production; stage validation tables (STV/RTV/FTV) once per run and join in the transform layer.
- Monitor redo apply lag on the standby so extracts reflect a known consistency point.

---

## 8. Module Table Prefixes (quick reference)

| Prefix | Module |
|--------|--------|
| SPR/SPB/GOR | Person / biographical |
| SGB/SFR/SFB/SHR/SSB/SSR/SCB | Student / registration / section / catalog |
| STV | Student validation tables |
| FGB/FTV/FAB/FPB/FRB | Finance (GL, validation, AP, PO, grants) |
| APB/AGB/AFB/APR | Advancement (constituent, gift, campaign, contact) |
| RPR/RCR/RRR/ROR/RFR/RTV | Financial aid (award, application, requirements, status, fund, validation) |
| NBB/NBR/PEB/PPR | Human resources / payroll |

See the module sub-folder READMEs for the specific tables behind each HELIX resource mapping.
