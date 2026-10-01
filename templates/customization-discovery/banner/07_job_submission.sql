/*
  HELIX Customization Discovery (Banner): Job Submission processes
  ===========================================================================
  What it finds: Every process defined in Job Submission (GJBJOBS): reports, COBOL, Pro*C, and SQL*Plus jobs. Local jobs start with Z. The program files themselves live on the job server; fingerprint them with tools/inventory_source_files.py.

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

  FLAG: confirm GJBJOBS column names and job type codes at your release.
*/

SELECT 'JOB'                                      AS object_type,
       j.GJBJOBS_NAME                             AS object_name,
       NVL(j.GJBJOBS_SYSI_CODE, ' ')              AS sub_key,
       1                                          AS seq,
       'GENERAL'                                  AS owner,
       TO_CHAR(j.GJBJOBS_ACTIVITY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS last_updated,
       ' '                                        AS last_updated_by,
       NVL(j.GJBJOBS_JOB_TYPE_IND, ' ') || '|' || NVL(j.GJBJOBS_TITLE, ' ') AS definition_text
FROM   GENERAL.GJBJOBS j
ORDER  BY 2;
