/*
  HELIX Customization Discovery (Banner): All objects in Banner schemas
  ===========================================================================
  What it finds: Every table, view, package, procedure, function, trigger, sequence, and synonym owned by a Banner schema. Objects not in vanilla are local; Ellucian's naming standard reserves names starting with Z for client objects, so most local objects start with Z, but check your own standard.

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

SELECT o.OBJECT_TYPE                              AS object_type,
       o.OBJECT_NAME                              AS object_name,
       ' '                                        AS sub_key,
       1                                          AS seq,
       o.OWNER                                    AS owner,
       TO_CHAR(o.LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS last_updated,
       ' '                                        AS last_updated_by,
       o.STATUS                                   AS definition_text,
       CASE WHEN o.OBJECT_NAME LIKE 'Z%' THEN 'Y' ELSE 'N' END AS local_name_flag
FROM   DBA_OBJECTS o
WHERE  o.OWNER IN ('SATURN','GENERAL','BANINST1','FIMSMGR','POSNCTL','PAYROLL','FAISMGR','ALUMNI','TAISMGR','WTAILOR','BANSECR','BANSSO')
  AND  o.OBJECT_TYPE NOT IN ('INDEX PARTITION','TABLE PARTITION','LOB','LOB PARTITION')
  AND  o.OBJECT_NAME NOT LIKE 'BIN$%'
ORDER  BY 1, 5, 2;
