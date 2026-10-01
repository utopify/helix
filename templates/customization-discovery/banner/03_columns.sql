/*
  HELIX Customization Discovery (Banner): Columns on every table
  ===========================================================================
  What it finds: Every column on every Banner table. Custom columns added to delivered tables are common and easy to miss; each one is data that needs a home after conversion.

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
*/

SELECT 'TABLE_COLUMN'                             AS object_type,
       c.TABLE_NAME                               AS object_name,
       c.COLUMN_NAME                              AS sub_key,
       c.COLUMN_ID                                AS seq,
       c.OWNER                                    AS owner,
       ' '                                        AS last_updated,
       ' '                                        AS last_updated_by,
       c.DATA_TYPE || '(' || NVL(TO_CHAR(c.DATA_PRECISION), TO_CHAR(c.DATA_LENGTH)) || ','
         || NVL(TO_CHAR(c.DATA_SCALE), ' ') || ')|' || c.NULLABLE AS definition_text
FROM   DBA_TAB_COLUMNS c
JOIN   DBA_TABLES t ON t.OWNER = c.OWNER AND t.TABLE_NAME = c.TABLE_NAME
WHERE  c.OWNER IN ('SATURN','GENERAL','BANINST1','FIMSMGR','POSNCTL','PAYROLL','FAISMGR','ALUMNI','TAISMGR','WTAILOR','BANSECR','BANSSO')
ORDER  BY 5, 2, 4;
