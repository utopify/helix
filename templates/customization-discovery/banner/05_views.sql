/*
  HELIX Customization Discovery (Banner): Views
  ===========================================================================
  What it finds: Every view with its full DDL. Local views are usually report logic; modified delivered views change what every report built on them returns.

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

  DBA_VIEWS.TEXT is a LONG column; DBMS_METADATA returns the DDL as a CLOB.
*/

SELECT 'VIEW'                                     AS object_type,
       v.VIEW_NAME                                AS object_name,
       ' '                                        AS sub_key,
       1                                          AS seq,
       v.OWNER                                    AS owner,
       TO_CHAR(o.LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS last_updated,
       ' '                                        AS last_updated_by,
       DBMS_METADATA.GET_DDL('VIEW', v.VIEW_NAME, v.OWNER) AS definition_text
FROM   DBA_VIEWS v
JOIN   DBA_OBJECTS o ON o.OWNER = v.OWNER AND o.OBJECT_NAME = v.VIEW_NAME AND o.OBJECT_TYPE = 'VIEW'
WHERE  v.OWNER IN ('SATURN','GENERAL','BANINST1','FIMSMGR','POSNCTL','PAYROLL','FAISMGR','ALUMNI','TAISMGR','WTAILOR','BANSECR','BANSSO')
ORDER  BY 5, 2;
