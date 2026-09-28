/*
  HELIX PS to Workday Reconciliation: Enrollment Credit Tie-Out
  ===========================================================================
  What it checks: Enrolled credit hours and headcount by term and section.

  When to run: After registration conversion, and daily during any live registration window that spans cutover.

  What passing looks like:
    Zero rows.

  Parameters:
    :ps_schema          HELIX Silver from PeopleSoft CS
    :wd_schema          HELIX Silver from Workday Student
    :term               Academic period code

  Model: both sides are compared through HELIX Silver. :ps_schema holds the
  PeopleSoft Campus Solutions extract mapped to HELIX; :wd_schema holds the
  Workday Student extract mapped to HELIX. These are FERPA education records:
  run under a role with legitimate educational interest (99.31(a)(1)) and
  never export row-level output outside the project team.

  Warehouse notes: Snowflake/Redshift: works as-is. BigQuery: replace DECIMAL with NUMERIC and :param with @param.
*/

with ps as (select course_section_ref, count(distinct student_ref) as enrolled, cast(sum(credit_hours) as decimal(10,2)) as credits
            from :ps_schema.enrollment where academic_period_code = :term and enrollment_status = 'enrolled' group by course_section_ref),
     wd as (select course_section_ref, count(distinct student_ref) as enrolled, cast(sum(credit_hours) as decimal(10,2)) as credits
            from :wd_schema.enrollment where academic_period_code = :term and enrollment_status = 'enrolled' group by course_section_ref)
select coalesce(ps.course_section_ref,wd.course_section_ref) as course_section_ref,
       ps.enrolled as ps_enrolled, wd.enrolled as wd_enrolled, ps.credits as ps_credits, wd.credits as wd_credits
from ps full outer join wd on ps.course_section_ref = wd.course_section_ref
where coalesce(ps.enrolled,0) <> coalesce(wd.enrolled,0) or coalesce(ps.credits,0) <> coalesce(wd.credits,0);
