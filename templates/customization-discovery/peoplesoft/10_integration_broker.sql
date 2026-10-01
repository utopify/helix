/*
  HELIX Customization Discovery (PeopleSoft): Integration Broker service operations and routings
  ===========================================================================
  What it finds: Every service operation and routing. Custom or active routings to outside nodes are integrations that need a new home in Workday or the lakehouse.

  Run it twice, with the same SQL: once against the vanilla baseline (PUM
  image or patched DMO database) and once against production (a reporting
  copy is fine). Save each result as CSV and compare them with
  tools/diff_customizations.py.

  Output columns (same for every HELIX inventory query):
    object_type, object_name, sub_key, seq, owner, last_updated,
    last_updated_by, definition_text

  Platform: Oracle. On SQL Server replace || with +, NVL with ISNULL, and
  TO_CHAR(date, ...) with CONVERT(varchar, date, 120).

  FLAG: column names in PSOPERATION and PSIBRTNGDEFN vary by PeopleTools
  release; confirm before running.
*/

SELECT 'IB_OPERATION' AS object_type, o.IB_OPERATIONNAME AS object_name, ' ' AS sub_key, 1 AS seq, ' ' AS owner,
       TO_CHAR(o.LASTUPDDTTM, 'YYYY-MM-DD HH24:MI:SS') AS last_updated, o.LASTUPDOPRID AS last_updated_by,
       NVL(o.DESCR, ' ') AS definition_text
FROM   PSOPERATION o
UNION ALL
SELECT 'IB_ROUTING', r.ROUTINGDEFNNAME, r.IB_OPERATIONNAME, 1, ' ',
       TO_CHAR(r.LASTUPDDTTM, 'YYYY-MM-DD HH24:MI:SS'), r.LASTUPDOPRID,
       NVL(r.SENDERNODENAME, ' ') || '>' || NVL(r.RECEIVERNODENAME, ' ') || '|' || r.EFF_STATUS
FROM   PSIBRTNGDEFN r
ORDER  BY 1, 2, 3;
