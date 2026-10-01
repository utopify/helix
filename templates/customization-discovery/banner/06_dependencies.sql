/*
  HELIX Customization Discovery (Banner): What local objects touch
  ===========================================================================
  What it finds: For every local object (name starts with Z, or owned by a local schema), the delivered objects it reads or calls. Map the referenced tables to HELIX resources with bridge/banner/ to see which conversions each customization depends on.

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

  This isn't a baseline comparison query; run it against production only.
*/

SELECT d.TYPE                                     AS object_type,
       d.NAME                                     AS object_name,
       d.REFERENCED_OWNER || '.' || d.REFERENCED_NAME AS sub_key,
       1                                          AS seq,
       d.OWNER                                    AS owner,
       ' '                                        AS last_updated,
       ' '                                        AS last_updated_by,
       d.REFERENCED_TYPE                          AS definition_text
FROM   DBA_DEPENDENCIES d
WHERE  d.OWNER IN ('SATURN','GENERAL','BANINST1','FIMSMGR','POSNCTL','PAYROLL','FAISMGR','ALUMNI','TAISMGR','WTAILOR','BANSECR','BANSSO')
  AND  d.NAME LIKE 'Z%'
  AND  d.REFERENCED_OWNER NOT IN ('SYS','PUBLIC')
ORDER  BY 5, 2, 3;
