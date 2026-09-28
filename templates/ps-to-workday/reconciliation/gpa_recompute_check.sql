/*
  HELIX PS to Workday Reconciliation: GPA Recompute Check
  ===========================================================================
  What it checks: Recomputes cumulative GPA from converted course history on both sides and compares to each system's stored GPA and to each other.

  When to run: After academic history conversion. This is the check that catches grade-point scale, repeat-rule, and transfer-credit differences.

  What passing looks like:
    Zero rows. Common causes of failure: repeat/forgiveness rules, grading-basis mapping (bridge/xref/ps-to-workday-sis/grading-basis-xref.json), and transfer credit counted in GPA on one side only.

  Parameters:
    :ps_schema          HELIX Silver from PeopleSoft CS
    :wd_schema          HELIX Silver from Workday Student
    :tolerance          GPA tolerance, e.g. 0.005

  Model: both sides are compared through HELIX Silver. :ps_schema holds the
  PeopleSoft Campus Solutions extract mapped to HELIX; :wd_schema holds the
  Workday Student extract mapped to HELIX. These are FERPA education records:
  run under a role with legitimate educational interest (99.31(a)(1)) and
  never export row-level output outside the project team.

  Warehouse notes: Snowflake/Redshift: works as-is. BigQuery: replace DECIMAL with NUMERIC and :param with @param.
*/

with ps_calc as (
    select student_ref, cast(sum(grade_points) / nullif(sum(gpa_credit_hours),0) as decimal(6,3)) as gpa_calc
    from :ps_schema.enrollment where counts_in_gpa = true group by student_ref
),
wd_calc as (
    select student_ref, cast(sum(grade_points) / nullif(sum(gpa_credit_hours),0) as decimal(6,3)) as gpa_calc
    from :wd_schema.enrollment where counts_in_gpa = true group by student_ref
),
stored as (
    select p.student_ref, p.cumulative_gpa as ps_stored, w.cumulative_gpa as wd_stored
    from :ps_schema.academic_term_record p join :wd_schema.academic_term_record w
      on w.student_ref = p.student_ref and w.academic_period_ref = p.academic_period_ref
    where p.is_latest_term = true
)
select s.student_ref, pc.gpa_calc as ps_calc, wc.gpa_calc as wd_calc, s.ps_stored, s.wd_stored
from stored s left join ps_calc pc on pc.student_ref = s.student_ref left join wd_calc wc on wc.student_ref = s.student_ref
where abs(coalesce(pc.gpa_calc,0) - coalesce(wc.gpa_calc,0)) > :tolerance
   or abs(coalesce(s.ps_stored,0) - coalesce(s.wd_stored,0)) > :tolerance;
