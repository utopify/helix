/*
  HELIX Customization Discovery (PeopleSoft): SQL objects, view text, and App Engine SQL
  ===========================================================================
  What it finds: Every stored SQL definition: SQL objects, the SQL behind views, and App Engine step SQL. Text is split across rows by SEQNUM; the diff tool joins them back together.

  Run it twice, with the same SQL: once against the vanilla baseline (PUM
  image or patched DMO database) and once against production (a reporting
  copy is fine). Save each result as CSV and compare them with
  tools/diff_customizations.py.

  Output columns (same for every HELIX inventory query):
    object_type, object_name, sub_key, seq, owner, last_updated,
    last_updated_by, definition_text

  Platform: Oracle. On SQL Server replace || with +, NVL with ISNULL, and
  TO_CHAR(date, ...) with CONVERT(varchar, date, 120).

  SQLTYPE: 0 SQL object, 1 App Engine statement, 2 record view text.
  FLAG: confirm SQLTYPE values for your PeopleTools release.
  Platform-specific SQL appears once per DBTYPE; keep the rows for your
  database platform and the generic (blank) DBTYPE.
*/

SELECT CASE d.SQLTYPE WHEN 0 THEN 'SQL_OBJECT' WHEN 1 THEN 'AE_SQL' WHEN 2 THEN 'VIEW_SQL' ELSE 'SQL_OTHER' END AS object_type,
       d.SQLID                                    AS object_name,
       t.DBTYPE || '.' || TO_CHAR(t.EFFDT, 'YYYY-MM-DD') AS sub_key,
       t.SEQNUM                                   AS seq,
       ' '                                        AS owner,
       TO_CHAR(d.LASTUPDDTTM, 'YYYY-MM-DD HH24:MI:SS') AS last_updated,
       d.LASTUPDOPRID                             AS last_updated_by,
       t.SQLTEXT                                  AS definition_text
FROM   PSSQLDEFN d
JOIN   PSSQLTEXTDEFN t ON t.SQLID = d.SQLID AND t.SQLTYPE = d.SQLTYPE
ORDER  BY 2, 3, 4;
