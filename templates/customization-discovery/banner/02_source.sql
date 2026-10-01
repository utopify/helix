/*
  HELIX Customization Discovery (Banner): PL/SQL source
  ===========================================================================
  What it finds: The source of every package, package body, procedure, function, trigger, and type, line by line. The diff tool joins lines back together and compares the whole object, so a one-line change to a delivered package shows up as modified.

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

  Some Ellucian packages are delivered wrapped. Wrapped source still
  compares correctly against the baseline, but it can't be read or
  converted; a wrapped object that differs from baseline means a different
  release or patch was applied, not a local change.
*/

SELECT s.TYPE                                     AS object_type,
       s.NAME                                     AS object_name,
       ' '                                        AS sub_key,
       s.LINE                                     AS seq,
       s.OWNER                                    AS owner,
       TO_CHAR(o.LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS last_updated,
       ' '                                        AS last_updated_by,
       s.TEXT                                     AS definition_text
FROM   DBA_SOURCE s
JOIN   DBA_OBJECTS o
  ON   o.OWNER = s.OWNER AND o.OBJECT_NAME = s.NAME AND o.OBJECT_TYPE = s.TYPE
WHERE  s.OWNER IN ('SATURN','GENERAL','BANINST1','FIMSMGR','POSNCTL','PAYROLL','FAISMGR','ALUMNI','TAISMGR','WTAILOR','BANSECR','BANSSO')
ORDER  BY 5, 2, 1, 4;
