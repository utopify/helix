/*
  HELIX PS to Workday Reconciliation: Active Student Tie-Out
  ===========================================================================
  What it checks: Active students by academic level, program, and term.

  When to run: After each student conversion mock and at cutover.

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

with ps as (
    select sp.academic_level, sp.program_ref, count(distinct sp.student_ref) as students
    from :ps_schema.student_program sp join :ps_schema.academic_period ap on ap.helix_id = sp.academic_period_ref
    where ap.code = :term and sp.program_status = 'active' group by sp.academic_level, sp.program_ref
),
wd as (
    select sp.academic_level, sp.program_ref, count(distinct sp.student_ref) as students
    from :wd_schema.student_program sp join :wd_schema.academic_period ap on ap.helix_id = sp.academic_period_ref
    where ap.code = :term and sp.program_status = 'active' group by sp.academic_level, sp.program_ref
)
select coalesce(ps.academic_level,wd.academic_level) as academic_level, coalesce(ps.program_ref,wd.program_ref) as program_ref,
       ps.students as ps_count, wd.students as wd_count, coalesce(ps.students,0)-coalesce(wd.students,0) as variance
from ps full outer join wd on ps.academic_level=wd.academic_level and ps.program_ref=wd.program_ref
where coalesce(ps.students,0) <> coalesce(wd.students,0);
