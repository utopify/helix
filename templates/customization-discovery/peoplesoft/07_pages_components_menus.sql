/*
  HELIX Customization Discovery (PeopleSoft): Pages, components, and menus
  ===========================================================================
  What it finds: Every online object. Custom pages and components show where users entered data the delivered system didn't handle, which usually points at a custom record holding data you must preserve.

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

SELECT 'PAGE' AS object_type, PNLNAME AS object_name, ' ' AS sub_key, 1 AS seq, ' ' AS owner,
       TO_CHAR(LASTUPDDTTM, 'YYYY-MM-DD HH24:MI:SS') AS last_updated, LASTUPDOPRID AS last_updated_by,
       TO_CHAR(FIELDCOUNT) AS definition_text
FROM   PSPNLDEFN
UNION ALL
SELECT 'COMPONENT', PNLGRPNAME, MARKET, 1, ' ',
       TO_CHAR(LASTUPDDTTM, 'YYYY-MM-DD HH24:MI:SS'), LASTUPDOPRID,
       NVL(SEARCHRECNAME, ' ') || '|' || NVL(ADDSRCHRECNAME, ' ')
FROM   PSPNLGRPDEFN
UNION ALL
SELECT 'MENU', MENUNAME, ' ', 1, ' ',
       TO_CHAR(LASTUPDDTTM, 'YYYY-MM-DD HH24:MI:SS'), LASTUPDOPRID, NVL(MENUGROUP, ' ')
FROM   PSMENUDEFN
ORDER  BY 1, 2, 3;
