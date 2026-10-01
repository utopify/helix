/*
  HELIX Customization Discovery (PeopleSoft): PS Query definitions and usage
  ===========================================================================
  What it finds: Every public and private PS Query, with how often and how recently it ran. Queries are customizations users create without developers, and many feed spreadsheets the business depends on.

  Run it twice, with the same SQL: once against the vanilla baseline (PUM
  image or patched DMO database) and once against production (a reporting
  copy is fine). Save each result as CSV and compare them with
  tools/diff_customizations.py.

  Output columns (same for every HELIX inventory query):
    object_type, object_name, sub_key, seq, owner, last_updated,
    last_updated_by, definition_text

  Platform: Oracle. On SQL Server replace || with +, NVL with ISNULL, and
  TO_CHAR(date, ...) with CONVERT(varchar, date, 120).

  OPRID blank = public query. PSQRYSTATS only has rows if query statistics
  logging is turned on. FLAG: confirm PSQRYSTATS columns for your release.
*/

SELECT 'QUERY'                                    AS object_type,
       q.QRYNAME                                  AS object_name,
       CASE WHEN q.OPRID = ' ' THEN 'PUBLIC' ELSE 'PRIVATE:' || q.OPRID END AS sub_key,
       1                                          AS seq,
       q.OPRID                                    AS owner,
       TO_CHAR(q.LASTUPDDTTM, 'YYYY-MM-DD HH24:MI:SS') AS last_updated,
       q.LASTUPDOPRID                             AS last_updated_by,
       q.QRYTYPE || '|' || NVL(q.DESCR, ' ')      AS definition_text,
       st.EXECCOUNT                               AS usage_runs,
       TO_CHAR(st.LASTEXECDTTM, 'YYYY-MM-DD')     AS usage_last_run
FROM   PSQRYDEFN q
LEFT   JOIN (SELECT OPRID, QRYNAME, SUM(EXECCOUNT) AS EXECCOUNT, MAX(LASTEXECDTTM) AS LASTEXECDTTM
             FROM PSQRYSTATS GROUP BY OPRID, QRYNAME) st
  ON   st.OPRID = q.OPRID AND st.QRYNAME = q.QRYNAME
ORDER  BY 2, 3;
