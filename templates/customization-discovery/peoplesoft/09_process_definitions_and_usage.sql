/*
  HELIX Customization Discovery (PeopleSoft): Process definitions and run history
  ===========================================================================
  What it finds: Every process the scheduler can run (SQR, App Engine, COBOL, Crystal, nVision, BI Publisher, and others) with run counts for the last 12 months. This is the best usage evidence PeopleSoft has.

  Run it twice, with the same SQL: once against the vanilla baseline (PUM
  image or patched DMO database) and once against production (a reporting
  copy is fine). Save each result as CSV and compare them with
  tools/diff_customizations.py.

  Output columns (same for every HELIX inventory query):
    object_type, object_name, sub_key, seq, owner, last_updated,
    last_updated_by, definition_text

  Platform: Oracle. On SQL Server replace || with +, NVL with ISNULL, and
  TO_CHAR(date, ...) with CONVERT(varchar, date, 120).

  PSPRCSRQST is purged on a schedule at most sites. A process with no rows
  here may simply have run before the purge window: record "no evidence,"
  not "unused." RUNSTATUS 9 = Success.
*/

SELECT 'PROCESS'                                  AS object_type,
       d.PRCSNAME                                 AS object_name,
       d.PRCSTYPE                                 AS sub_key,
       1                                          AS seq,
       ' '                                        AS owner,
       TO_CHAR(d.LASTUPDDTTM, 'YYYY-MM-DD HH24:MI:SS') AS last_updated,
       d.LASTUPDOPRID                             AS last_updated_by,
       NVL(d.DESCR, ' ')                          AS definition_text,
       NVL(h.RUNS_12MO, 0)                        AS usage_runs,
       TO_CHAR(h.LAST_RUN, 'YYYY-MM-DD')          AS usage_last_run
FROM   PS_PRCSDEFN d
LEFT   JOIN (SELECT PRCSTYPE, PRCSNAME,
                    SUM(CASE WHEN RUNDTTM >= ADD_MONTHS(SYSDATE, -12) THEN 1 ELSE 0 END) AS RUNS_12MO,
                    MAX(RUNDTTM) AS LAST_RUN
             FROM   PSPRCSRQST
             WHERE  RUNSTATUS = '9'
             GROUP  BY PRCSTYPE, PRCSNAME) h
  ON   h.PRCSTYPE = d.PRCSTYPE AND h.PRCSNAME = d.PRCSNAME
ORDER  BY 2, 3;
