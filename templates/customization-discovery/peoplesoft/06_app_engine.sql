/*
  HELIX Customization Discovery (PeopleSoft): Application Engine programs and steps
  ===========================================================================
  What it finds: Every App Engine program, section, and step. Pair with 04 (PeopleCode actions) and 05 (SQL actions) for the full program.

  Run it twice, with the same SQL: once against the vanilla baseline (PUM
  image or patched DMO database) and once against production (a reporting
  copy is fine). Save each result as CSV and compare them with
  tools/diff_customizations.py.

  Output columns (same for every HELIX inventory query):
    object_type, object_name, sub_key, seq, owner, last_updated,
    last_updated_by, definition_text

  Platform: Oracle. On SQL Server replace || with +, NVL with ISNULL, and
  TO_CHAR(date, ...) with CONVERT(varchar, date, 120).
*/

SELECT 'APP_ENGINE'                               AS object_type,
       a.AE_APPLID                                AS object_name,
       NVL(s.AE_SECTION, ' ') || '.' || NVL(s.AE_STEP, ' ') AS sub_key,
       NVL(s.AE_SEQ_NUM, 0)                       AS seq,
       ' '                                        AS owner,
       TO_CHAR(a.LASTUPDDTTM, 'YYYY-MM-DD HH24:MI:SS') AS last_updated,
       a.LASTUPDOPRID                             AS last_updated_by,
       NVL(s.AE_STEP, ' ') || '|' || NVL(s.MARKET, ' ') || '|' || NVL(s.DBTYPE, ' ')
         || '|' || TO_CHAR(s.EFFDT, 'YYYY-MM-DD') AS definition_text
FROM   PSAEAPPLDEFN a
LEFT   JOIN PSAESTEPDEFN s ON s.AE_APPLID = a.AE_APPLID
ORDER  BY 2, 3, 4;
/* FLAG: confirm PSAESTEPDEFN column names (AE_SEQ_NUM in particular) for your release. */
