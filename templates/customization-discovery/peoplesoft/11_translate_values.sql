/*
  HELIX Customization Discovery (PeopleSoft): Translate values
  ===========================================================================
  What it finds: Every translate (XLAT) value. Local values added to delivered fields aren't code, but each one needs a crosswalk row before conversion (bridge/xref/).

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

SELECT 'XLAT_VALUE'                               AS object_type,
       x.FIELDNAME                                AS object_name,
       x.FIELDVALUE                               AS sub_key,
       1                                          AS seq,
       ' '                                        AS owner,
       TO_CHAR(x.LASTUPDDTTM, 'YYYY-MM-DD HH24:MI:SS') AS last_updated,
       x.LASTUPDOPRID                             AS last_updated_by,
       x.EFF_STATUS || '|' || NVL(x.XLATLONGNAME, ' ') AS definition_text
FROM   PSXLATITEM x
WHERE  x.EFFDT = (SELECT MAX(x2.EFFDT) FROM PSXLATITEM x2
                  WHERE x2.FIELDNAME = x.FIELDNAME AND x2.FIELDVALUE = x.FIELDVALUE AND x2.EFFDT <= SYSDATE)
ORDER  BY 2, 3;
