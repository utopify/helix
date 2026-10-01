/*
  HELIX Customization Discovery (PeopleSoft): PeopleCode
  ===========================================================================
  What it finds: Every PeopleCode program (record, component, page, App Engine, application package, and others) with its source text. Modified delivered PeopleCode is the hardest customization to carry forward and the most important to find.

  Run it twice, with the same SQL: once against the vanilla baseline (PUM
  image or patched DMO database) and once against production (a reporting
  copy is fine). Save each result as CSV and compare them with
  tools/diff_customizations.py.

  Output columns (same for every HELIX inventory query):
    object_type, object_name, sub_key, seq, owner, last_updated,
    last_updated_by, definition_text

  Platform: Oracle. On SQL Server replace || with +, NVL with ISNULL, and
  TO_CHAR(date, ...) with CONVERT(varchar, date, 120).

  PSPCMTXT holds PeopleCode source as text in PeopleTools 8.52 and later.
  On older releases the text is only in PSPCMPROG.PROGTXT (binary) and must
  be exported with Application Designer. FLAG: confirm for your release.
  OBJECTID1 says what the program belongs to (1 record, 9 menu, 10 component,
  60 message, 66 App Engine, 104 application package, and others).
*/

SELECT 'PEOPLECODE'                               AS object_type,
       t.OBJECTVALUE1                             AS object_name,
       TRIM(t.OBJECTID1 || '.' || t.OBJECTVALUE2 || '.' || t.OBJECTVALUE3 || '.' || t.OBJECTVALUE4
         || '.' || t.OBJECTVALUE5 || '.' || t.OBJECTVALUE6 || '.' || t.OBJECTVALUE7) AS sub_key,
       t.PROGSEQ                                  AS seq,
       ' '                                        AS owner,
       TO_CHAR(p.LASTUPDDTTM, 'YYYY-MM-DD HH24:MI:SS') AS last_updated,
       p.LASTUPDOPRID                             AS last_updated_by,
       t.PCTEXT                                   AS definition_text
FROM   PSPCMTXT t
JOIN   PSPCMPROG p
  ON   p.OBJECTID1 = t.OBJECTID1 AND p.OBJECTVALUE1 = t.OBJECTVALUE1
 AND   p.OBJECTID2 = t.OBJECTID2 AND p.OBJECTVALUE2 = t.OBJECTVALUE2
 AND   p.OBJECTID3 = t.OBJECTID3 AND p.OBJECTVALUE3 = t.OBJECTVALUE3
 AND   p.OBJECTID4 = t.OBJECTID4 AND p.OBJECTVALUE4 = t.OBJECTVALUE4
 AND   p.OBJECTID5 = t.OBJECTID5 AND p.OBJECTVALUE5 = t.OBJECTVALUE5
 AND   p.OBJECTID6 = t.OBJECTID6 AND p.OBJECTVALUE6 = t.OBJECTVALUE6
 AND   p.OBJECTID7 = t.OBJECTID7 AND p.OBJECTVALUE7 = t.OBJECTVALUE7
 AND   p.PROGSEQ   = t.PROGSEQ
ORDER  BY 2, 3, 4;
