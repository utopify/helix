/*
  HELIX Customization Discovery (Banner): Self-Service Banner packages and menus
  ===========================================================================
  What it finds: Banner 8 Self-Service packages in BANINST1 (BWCK, BWSK, BWGK, BWPK, BWRK and similar prefixes) and the WTAILOR menu tables. Modified self-service pages are customizations students and employees see every day.

  Run it twice, with the same SQL: once against the vanilla baseline (a
  clean database built from Ellucian's release deliverables at your
  installed release levels) and once against production (a reporting copy
  is fine). Save each result as CSV and compare them with
  tools/diff_customizations.py.

  Output columns (same for every HELIX inventory query):
    object_type, object_name, sub_key, seq, owner, last_updated,
    last_updated_by, definition_text

  Needs SELECT on the DBA_ views (SELECT_CATALOG_ROLE). Edit the owner list
  to match your installation; add any local schemas your site uses.
  Oracle doesn't record who changed an object, so last_updated_by is blank.

  Banner 9 Self-Service and Page Builder customizations live in Banner
  Extensibility, not in these packages. FLAG: inventory those through the
  Extensibility tools for your release.
*/

SELECT o.OBJECT_TYPE AS object_type, o.OBJECT_NAME AS object_name, ' ' AS sub_key, 1 AS seq, o.OWNER AS owner,
       TO_CHAR(o.LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS last_updated, ' ' AS last_updated_by, o.STATUS AS definition_text
FROM   DBA_OBJECTS o
WHERE  o.OWNER = 'BANINST1'
  AND  REGEXP_LIKE(o.OBJECT_NAME, '^(BW|ZW)[A-Z]K')
UNION ALL
SELECT 'SSB_MENU_ITEM', m.TWGRMENU_NAME, m.TWGRMENU_URL, m.TWGRMENU_SEQUENCE, 'WTAILOR',
       TO_CHAR(m.TWGRMENU_ACTIVITY_DATE, 'YYYY-MM-DD HH24:MI:SS'), ' ',
       NVL(m.TWGRMENU_URL_TEXT, ' ') || '|' || NVL(m.TWGRMENU_ENABLED, ' ')
FROM   WTAILOR.TWGRMENU m
ORDER  BY 1, 2, 4;
/* FLAG: confirm TWGRMENU column names at your release. */
