/*
  HELIX Reconciliation: Financial Aid Disbursement Totals
  ===========================================================================
  What it checks: Total financial aid disbursed by term and award type must
                  match between source and HELIX. Critical for federal
                  reporting (FISAP, IPEDS Student Financial Aid survey).

  When to run: After each aid disbursement cycle, before term close.

  What passing looks like:
    - source_total = helix_total per award_type per term (zero tolerance)
    - Total disbursement variance = $0.00

  Parameters:
    :source_schema    — Source financial aid schema
    :helix_schema     — HELIX Silver schema
    :academic_period  — Term code

  GLBA Note: This query accesses GLBA-covered financial data.
  Results should not be shared outside authorized personnel.
*/

with source_totals as (
    select
        award_type_code as award_type,
        cast(sum(disbursed_amount) as decimal(18,2)) as total_disbursed,
        count(*) as award_count
    from :source_schema.fin_aid_awards
    where term_code = :academic_period
      and disbursed_amount > 0
    group by award_type_code
),

helix_totals as (
    select
        award_type,
        cast(sum(disbursed_amount) as decimal(18,2)) as total_disbursed,
        count(*) as award_count
    from :helix_schema.helix_fin_aid_award
    where period_ref = :academic_period
      and disbursed_amount > 0
    group by award_type
)

select
    coalesce(s.award_type, h.award_type) as award_type,
    s.total_disbursed as source_disbursed,
    h.total_disbursed as helix_disbursed,
    coalesce(s.total_disbursed, 0) - coalesce(h.total_disbursed, 0) as variance,
    s.award_count as source_count,
    h.award_count as helix_count,
    case
        when abs(coalesce(s.total_disbursed, 0) - coalesce(h.total_disbursed, 0)) = 0 then 'PASS'
        else 'FAIL: Financial variance (must be $0.00)'
    end as status
from source_totals s
full outer join helix_totals h on s.award_type = h.award_type
order by abs(coalesce(s.total_disbursed, 0) - coalesce(h.total_disbursed, 0)) desc;
