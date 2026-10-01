/*
  HELIX Customization Discovery (PeopleSoft): Fields on records
  ===========================================================================
  What it finds: Every field on every record. This is how you find custom fields added to delivered records, which is one of the most common and most missed customizations.

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

SELECT 'RECORD_FIELD'                             AS object_type,
       f.RECNAME                                  AS object_name,
       f.FIELDNAME                                AS sub_key,
       1                                          AS seq,
       ' '                                        AS owner,
       TO_CHAR(f.LASTUPDDTTM, 'YYYY-MM-DD HH24:MI:SS') AS last_updated,
       f.LASTUPDOPRID                             AS last_updated_by,
       f.FIELDNUM || '|' || f.USEEDIT || '|' || NVL(f.EDITTABLE, ' ') || '|' || NVL(f.DEFRECNAME, ' ')
         || '|' || NVL(f.DEFFIELDNAME, ' ')       AS definition_text
FROM   PSRECFIELD f
ORDER  BY f.RECNAME, f.FIELDNUM;
