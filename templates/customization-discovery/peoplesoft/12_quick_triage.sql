/*
  HELIX Customization Discovery (PeopleSoft): Quick triage without a baseline
  ===========================================================================
  What it finds: A fast first look before the PUM image is ready: objects last changed by someone other than PPLSOFT (Oracle's delivered user). It misses delivered objects someone opened and saved without changing, and catches objects Oracle delivered under another ID, so use it to size the work, not to build the register.

  Run it twice, with the same SQL: once against the vanilla baseline (PUM
  image or patched DMO database) and once against production (a reporting
  copy is fine). Save each result as CSV and compare them with
  tools/diff_customizations.py.

  Output columns (same for every HELIX inventory query):
    object_type, object_name, sub_key, seq, owner, last_updated,
    last_updated_by, definition_text

  Platform: Oracle. On SQL Server replace || with +, NVL with ISNULL, and
  TO_CHAR(date, ...) with CONVERT(varchar, date, 120).
*/

SELECT 'RECORD'       AS object_type, COUNT(*) AS custom_or_touched FROM PSRECDEFN    WHERE LASTUPDOPRID <> 'PPLSOFT'
UNION ALL SELECT 'FIELD',        COUNT(*) FROM PSDBFIELD    WHERE LASTUPDOPRID <> 'PPLSOFT'
UNION ALL SELECT 'PEOPLECODE',   COUNT(*) FROM PSPCMPROG    WHERE LASTUPDOPRID <> 'PPLSOFT'
UNION ALL SELECT 'PAGE',         COUNT(*) FROM PSPNLDEFN    WHERE LASTUPDOPRID <> 'PPLSOFT'
UNION ALL SELECT 'COMPONENT',    COUNT(*) FROM PSPNLGRPDEFN WHERE LASTUPDOPRID <> 'PPLSOFT'
UNION ALL SELECT 'APP_ENGINE',   COUNT(*) FROM PSAEAPPLDEFN WHERE LASTUPDOPRID <> 'PPLSOFT'
UNION ALL SELECT 'SQL',          COUNT(*) FROM PSSQLDEFN    WHERE LASTUPDOPRID <> 'PPLSOFT'
UNION ALL SELECT 'PROCESS',      COUNT(*) FROM PS_PRCSDEFN  WHERE LASTUPDOPRID <> 'PPLSOFT'
UNION ALL SELECT 'PUBLIC_QUERY', COUNT(*) FROM PSQRYDEFN    WHERE OPRID = ' ' AND LASTUPDOPRID <> 'PPLSOFT';
