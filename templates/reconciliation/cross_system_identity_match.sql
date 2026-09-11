/*
  HELIX Reconciliation: Cross-System Identity Resolution
  ===========================================================================
  What it checks: How well the identity resolution process matched source
                  records to HELIX Person records. Unmatched records need
                  manual stewardship.

  When to run: After initial migration, after each new source onboarded.

  What passing looks like:
    - match_rate >= 98% (most source records should resolve)
    - orphaned_records < 2% of total
    - Zero duplicate HELIX IDs (each source record maps to exactly one person)

  Parameters:
    :source_schema — Bronze layer schema
    :helix_schema  — HELIX Silver schema
*/

-- Count source records vs matched records
with source_records as (
    select
        'PeopleSoft' as source_system,
        count(*) as total_source,
        count(distinct source_id) as distinct_source
    from :source_schema.src_person
),

helix_records as (
    select
        _helix_source_system as source_system,
        count(*) as total_helix,
        count(distinct helix_id) as distinct_helix
    from :helix_schema.helix_person
    group by _helix_source_system
),

-- Check for duplicate helix_ids (should be zero)
duplicates as (
    select helix_id, count(*) as dup_count
    from :helix_schema.helix_person
    group by helix_id
    having count(*) > 1
)

select
    s.source_system,
    s.total_source,
    s.distinct_source,
    h.total_helix,
    h.distinct_helix,
    s.distinct_source - h.distinct_helix as orphaned_records,
    round(100.0 * h.distinct_helix / nullif(s.distinct_source, 0), 1) as match_rate_pct,
    (select count(*) from duplicates) as duplicate_helix_ids,
    case
        when (select count(*) from duplicates) > 0 then 'FAIL: Duplicate HELIX IDs'
        when 100.0 * h.distinct_helix / nullif(s.distinct_source, 0) < 95 then 'WARN: Match rate < 95%'
        when 100.0 * h.distinct_helix / nullif(s.distinct_source, 0) < 98 then 'INFO: Match rate < 98%'
        else 'PASS'
    end as status
from source_records s
left join helix_records h on s.source_system = h.source_system;
