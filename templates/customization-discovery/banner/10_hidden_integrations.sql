/*
  HELIX Customization Discovery (Banner): Hidden integrations
  ===========================================================================
  What it finds: Database links, directories, scheduler jobs, and code that calls out of the database (UTL_HTTP, UTL_FILE, UTL_SMTP, UTL_TCP, DBMS_SCHEDULER, external procedures). Every hit is an integration that has no place in Banner SaaS and needs a new home.

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

  Run against production only. Review each hit; some are delivered.
*/

SELECT 'DB_LINK' AS object_type, l.DB_LINK AS object_name, l.HOST AS sub_key, 1 AS seq, l.OWNER AS owner,
       TO_CHAR(l.CREATED, 'YYYY-MM-DD') AS last_updated, ' ' AS last_updated_by, l.USERNAME AS definition_text
FROM   DBA_DB_LINKS l
UNION ALL
SELECT 'DIRECTORY', d.DIRECTORY_NAME, d.DIRECTORY_PATH, 1, d.OWNER, ' ', ' ', ' '
FROM   DBA_DIRECTORIES d
UNION ALL
SELECT 'SCHEDULER_JOB', j.JOB_NAME, NVL(j.REPEAT_INTERVAL, ' '), 1, j.OWNER,
       TO_CHAR(j.LAST_START_DATE, 'YYYY-MM-DD HH24:MI:SS'), ' ', NVL(j.JOB_ACTION, ' ')
FROM   DBA_SCHEDULER_JOBS j
WHERE  j.OWNER IN ('SATURN','GENERAL','BANINST1','FIMSMGR','POSNCTL','PAYROLL','FAISMGR','ALUMNI','TAISMGR','WTAILOR','BANSECR','BANSSO')
UNION ALL
SELECT 'EXTERNAL_CALL', s.NAME, s.TYPE || ' line ' || s.LINE, s.LINE, s.OWNER, ' ', ' ', TRIM(s.TEXT)
FROM   DBA_SOURCE s
WHERE  s.OWNER IN ('SATURN','GENERAL','BANINST1','FIMSMGR','POSNCTL','PAYROLL','FAISMGR','ALUMNI','TAISMGR','WTAILOR','BANSECR','BANSSO')
  AND  REGEXP_LIKE(UPPER(s.TEXT), 'UTL_HTTP|UTL_FILE|UTL_SMTP|UTL_TCP|UTL_MAIL|DBMS_SCHEDULER|@[A-Z0-9_]+|EXTERNAL\s+NAME')
ORDER  BY 1, 5, 2;
