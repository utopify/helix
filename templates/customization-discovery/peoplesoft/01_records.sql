/*
  HELIX Customization Discovery (PeopleSoft): Records
  ===========================================================================
  What it finds: Every record definition (tables, views, derived, subrecords, temp tables). Records not in vanilla are custom; records in both with a different definition were modified.

  Run it twice, with the same SQL: once against the vanilla baseline (PUM
  image or patched DMO database) and once against production (a reporting
  copy is fine). Save each result as CSV and compare them with
  tools/diff_customizations.py.

  Output columns (same for every HELIX inventory query):
    object_type, object_name, sub_key, seq, owner, last_updated,
    last_updated_by, definition_text

  Platform: Oracle. On SQL Server replace || with +, NVL with ISNULL, and
  TO_CHAR(date, ...) with CONVERT(varchar, date, 120).

  RECTYPE: 0 table, 1 view, 2 derived/work, 3 subrecord, 5 dynamic view,
  6 query view, 7 temporary table.
*/

SELECT 'RECORD'                                   AS object_type,
       r.RECNAME                                  AS object_name,
       ' '                                        AS sub_key,
       1                                          AS seq,
       NVL(r.OBJECTOWNERID, ' ')                  AS owner,
       TO_CHAR(r.LASTUPDDTTM, 'YYYY-MM-DD HH24:MI:SS') AS last_updated,
       r.LASTUPDOPRID                             AS last_updated_by,
       r.RECTYPE || '|' || NVL(r.SQLTABLENAME, ' ') || '|' || NVL(r.PARENTRECNAME, ' ')
         || '|' || r.FIELDCOUNT                   AS definition_text
FROM   PSRECDEFN r
ORDER  BY r.RECNAME;
