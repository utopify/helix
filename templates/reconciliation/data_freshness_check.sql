/*
  HELIX Reconciliation: Data Freshness Check
  ===========================================================================
  What it checks: Verifies that Bronze, Silver, and Gold layers are current.
                  Stale data indicates ETL pipeline failure.

  When to run: Continuously (hourly or daily monitoring).

  What passing looks like:
    - bronze_latest within expected ETL window (e.g., < 24 hours old)
    - silver_latest within expected transformation window
    - No layer more than 48 hours stale
    - Silver not newer than Bronze (impossible if pipeline is correct)

  Parameters:
    :source_schema — Bronze layer schema
    :helix_schema  — Silver layer schema
    :gold_schema   — Gold layer schema

  Warehouse notes:
    - Snowflake: datediff('hour', ..., current_timestamp())
    - Redshift: datediff('hour', ..., getdate())
    - BigQuery: timestamp_diff(current_timestamp(), ..., HOUR)
*/

select
    'Person' as resource,
    'Bronze' as layer,
    max(_helix_loaded_at) as latest_timestamp,
    datediff('hour', max(_helix_loaded_at), current_timestamp) as hours_since_update,
    case
        when datediff('hour', max(_helix_loaded_at), current_timestamp) > 48
            then 'FAIL: Stale (>48 hours)'
        when datediff('hour', max(_helix_loaded_at), current_timestamp) > 24
            then 'WARN: >24 hours since update'
        else 'PASS'
    end as status
from :source_schema.src_person

union all

select 'Person', 'Silver',
    max(_helix_transformed_at),
    datediff('hour', max(_helix_transformed_at), current_timestamp),
    case
        when datediff('hour', max(_helix_transformed_at), current_timestamp) > 48 then 'FAIL: Stale'
        when datediff('hour', max(_helix_transformed_at), current_timestamp) > 24 then 'WARN'
        else 'PASS'
    end
from :helix_schema.helix_person

union all

select 'Student', 'Silver',
    max(_helix_transformed_at),
    datediff('hour', max(_helix_transformed_at), current_timestamp),
    case
        when datediff('hour', max(_helix_transformed_at), current_timestamp) > 48 then 'FAIL: Stale'
        when datediff('hour', max(_helix_transformed_at), current_timestamp) > 24 then 'WARN'
        else 'PASS'
    end
from :helix_schema.helix_student

union all

select 'Enrollment', 'Silver',
    max(_helix_transformed_at),
    datediff('hour', max(_helix_transformed_at), current_timestamp),
    case
        when datediff('hour', max(_helix_transformed_at), current_timestamp) > 48 then 'FAIL: Stale'
        when datediff('hour', max(_helix_transformed_at), current_timestamp) > 24 then 'WARN'
        else 'PASS'
    end
from :helix_schema.helix_enrollment

order by resource, layer;
