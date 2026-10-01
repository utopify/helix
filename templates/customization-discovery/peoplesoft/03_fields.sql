/*
  HELIX Customization Discovery (PeopleSoft): Field definitions
  ===========================================================================
  What it finds: Every field definition. Custom fields, and delivered fields whose length or type was changed.

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

SELECT 'FIELD'                                    AS object_type,
       d.FIELDNAME                                AS object_name,
       ' '                                        AS sub_key,
       1                                          AS seq,
       ' '                                        AS owner,
       TO_CHAR(d.LASTUPDDTTM, 'YYYY-MM-DD HH24:MI:SS') AS last_updated,
       d.LASTUPDOPRID                             AS last_updated_by,
       d.FIELDTYPE || '|' || d.LENGTH || '|' || d.DECIMALPOS AS definition_text
FROM   PSDBFIELD d
ORDER  BY d.FIELDNAME;
