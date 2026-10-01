/*
  HELIX Customization Discovery (Banner): Validation table values
  ===========================================================================
  What it finds: Generates one SELECT per validation table (STV, GTV, RTV, FTV, PTV, ATV, TTV and similar). Run the generated script against baseline and production. Local codes aren't code, but every one needs a crosswalk row before conversion.

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

  Step 1: run this query; it writes the extraction SQL.
  Step 2: run the generated SQL and save the output as the inventory CSV.
  Banner validation tables follow the pattern <table>_CODE and <table>_DESC.
  Tables that don't will error; drop them from the generated script.
*/

SELECT 'SELECT ''VALIDATION_CODE'' AS object_type, ''' || t.TABLE_NAME || ''' AS object_name, '
       || t.TABLE_NAME || '_CODE AS sub_key, 1 AS seq, ''' || t.OWNER || ''' AS owner, '
       || 'TO_CHAR(' || t.TABLE_NAME || '_ACTIVITY_DATE, ''YYYY-MM-DD'') AS last_updated, '' '' AS last_updated_by, '
       || t.TABLE_NAME || '_DESC AS definition_text FROM ' || t.OWNER || '.' || t.TABLE_NAME || ' UNION ALL' AS generated_sql
FROM   DBA_TABLES t
WHERE  t.OWNER IN ('SATURN','GENERAL','BANINST1','FIMSMGR','POSNCTL','PAYROLL','FAISMGR','ALUMNI','TAISMGR','WTAILOR','BANSECR','BANSSO')
  AND  REGEXP_LIKE(t.TABLE_NAME, '^[A-Z]TV[A-Z0-9]{4}$')
  AND  EXISTS (SELECT 1 FROM DBA_TAB_COLUMNS c WHERE c.OWNER = t.OWNER AND c.TABLE_NAME = t.TABLE_NAME
               AND c.COLUMN_NAME = t.TABLE_NAME || '_CODE')
ORDER  BY t.TABLE_NAME;
/* Remove the final UNION ALL from the generated script before running it. */
