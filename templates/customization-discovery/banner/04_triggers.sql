/*
  HELIX Customization Discovery (Banner): Triggers
  ===========================================================================
  What it finds: Every trigger, with the table it fires on and its full DDL. Local triggers on delivered tables are business rules hiding in the database; none of them can exist in Banner SaaS.

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

  Uses DBMS_METADATA, which needs SELECT_CATALOG_ROLE. Trigger source also
  appears in 02_source.sql; this query adds the table and timing context.
*/

SELECT 'TRIGGER'                                  AS object_type,
       t.TRIGGER_NAME                             AS object_name,
       t.TABLE_OWNER || '.' || t.TABLE_NAME       AS sub_key,
       1                                          AS seq,
       t.OWNER                                    AS owner,
       TO_CHAR(o.LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS last_updated,
       ' '                                        AS last_updated_by,
       t.TRIGGER_TYPE || '|' || t.TRIGGERING_EVENT || '|' || t.STATUS || '|'
         || DBMS_METADATA.GET_DDL('TRIGGER', t.TRIGGER_NAME, t.OWNER) AS definition_text
FROM   DBA_TRIGGERS t
JOIN   DBA_OBJECTS o ON o.OWNER = t.OWNER AND o.OBJECT_NAME = t.TRIGGER_NAME AND o.OBJECT_TYPE = 'TRIGGER'
WHERE  t.OWNER IN ('SATURN','GENERAL','BANINST1','FIMSMGR','POSNCTL','PAYROLL','FAISMGR','ALUMNI','TAISMGR','WTAILOR','BANSECR','BANSSO') OR t.TABLE_OWNER IN ('SATURN','GENERAL','BANINST1','FIMSMGR','POSNCTL','PAYROLL','FAISMGR','ALUMNI','TAISMGR','WTAILOR','BANSECR','BANSSO')
ORDER  BY 3, 2;
