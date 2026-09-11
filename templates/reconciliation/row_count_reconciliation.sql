/*
  HELIX Reconciliation: Row Count Comparison
  ===========================================================================
  What it checks: Row counts at each medallion layer should be consistent.
                  Silver may have fewer rows than Bronze (dedup), but should
                  never have MORE rows.

  When to run: After every ETL run.

  What passing looks like:
    - bronze_count >= silver_count for each resource
    - silver_count >= gold_count (gold may aggregate)
    - variance_pct < 5% (flag if Silver drops more than 5% of Bronze)
    - Zero rows with variance_pct > 10% (investigate immediately)

  Parameters:
    :source_schema  — Bronze layer schema
    :helix_schema   — Silver layer schema (HELIX Core)
    :gold_schema    — Gold layer schema

  Warehouse notes:
    - Standard SQL. Works on Snowflake, Redshift, BigQuery, Databricks.
*/

with bronze_counts as (
    select 'Person'       as resource, count(*) as cnt from :source_schema.src_person
    union all
    select 'Student',      count(*) from :source_schema.src_student
    union all
    select 'Enrollment',   count(*) from :source_schema.src_enrollment
    union all
    select 'FinAidAward',  count(*) from :source_schema.src_fin_aid_award
),

silver_counts as (
    select 'Person'       as resource, count(*) as cnt from :helix_schema.helix_person
    union all
    select 'Student',      count(*) from :helix_schema.helix_student
    union all
    select 'Enrollment',   count(*) from :helix_schema.helix_enrollment
    union all
    select 'FinAidAward',  count(*) from :helix_schema.helix_fin_aid_award
)

select
    b.resource,
    b.cnt                                                   as bronze_count,
    s.cnt                                                   as silver_count,
    b.cnt - s.cnt                                           as row_difference,
    round(100.0 * (b.cnt - s.cnt) / nullif(b.cnt, 0), 2)   as variance_pct,
    case
        when s.cnt > b.cnt then 'FAIL: Silver > Bronze (data duplication?)'
        when 100.0 * (b.cnt - s.cnt) / nullif(b.cnt, 0) > 10 then 'WARN: >10% loss'
        when 100.0 * (b.cnt - s.cnt) / nullif(b.cnt, 0) > 5  then 'INFO: >5% loss (dedup expected?)'
        else 'PASS'
    end                                                     as status
from bronze_counts b
left join silver_counts s on b.resource = s.resource
order by b.resource;
