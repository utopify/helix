/*
  HELIX Context Route, step 2: profile a custom or historical table
  ===========================================================================
  Returns one row per column with counts and shapes, in the input format for
  tools/draft_custom_table_context.py. Never returns raw values from
  confidential or restricted columns, and never returns free text.

  How to use (Amazon Athena or any Trino/Presto engine):
    1. Land the table in bronze (DMS, Glue, or a file) and register it in the
       Glue Data Catalog.
    2. Copy the block below once per column, replacing :table, :column, and
       :data_type. Set :allow_top_values to 'Y' only for short code columns the
       steward agrees are safe (status codes, sport codes, term codes). Leave
       'N' for names, IDs, dates of birth, amounts, comments, and anything
       classified confidential or restricted.
    3. UNION ALL the blocks and save the result as CSV.

  The Glue Data Catalog lists the columns: SELECT column_name, data_type FROM
  information_schema.columns WHERE table_schema = ':database' AND table_name = ':table'.
*/

SELECT
  ':table'                                              AS table_name,
  ':column'                                             AS column_name,
  ':data_type'                                          AS data_type,
  COUNT(*)                                              AS row_count,
  COUNT(*) - COUNT(":column")                           AS null_count,
  approx_distinct(":column")                            AS distinct_count,
  CASE WHEN ':allow_top_values' = 'Y' THEN CAST(MIN(":column") AS VARCHAR) END AS min_value,
  CASE WHEN ':allow_top_values' = 'Y' THEN CAST(MAX(":column") AS VARCHAR) END AS max_value,
  CASE WHEN ':allow_top_values' = 'Y' THEN
    array_join(slice(map_keys(histogram(CAST(":column" AS VARCHAR))), 1, 10), ';')
  END                                                   AS top_values,
  ''                                                    AS register_id
FROM ":database".":table";

/*
  Notes
  - histogram() returns values in no guaranteed order; it's a list of examples,
    not a ranking. For a ranked list, run a GROUP BY on approved columns only.
  - min_value and max_value are useful for dates and terms (the table's time
    range). Keep them off for amounts tied to people.
  - Add the customization register row id in register_id so the draft links
    back to docs/conversion/ decisions.
*/
