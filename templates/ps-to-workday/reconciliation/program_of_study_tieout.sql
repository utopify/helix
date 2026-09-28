/*
  HELIX PS to Workday Reconciliation: Program of Study Tie-Out
  ===========================================================================
  What it checks: Each active student's program, plan (major), and concentration land on the expected Workday Program of Study.

  When to run: After program conversion; rerun after any catalog-year remap.

  What passing looks like:
    Zero rows. PS plan stacks collapse to Program of Study plus Concentration (bridge/xref/ps-to-workday-sis/program-plan-xref.json).

  Parameters:
    :ps_schema          HELIX Silver from PeopleSoft CS
    :wd_schema          HELIX Silver from Workday Student

  Model: both sides are compared through HELIX Silver. :ps_schema holds the
  PeopleSoft Campus Solutions extract mapped to HELIX; :wd_schema holds the
  Workday Student extract mapped to HELIX. These are FERPA education records:
  run under a role with legitimate educational interest (99.31(a)(1)) and
  never export row-level output outside the project team.

  Warehouse notes: Snowflake/Redshift: works as-is. BigQuery: replace DECIMAL with NUMERIC and :param with @param.
*/

with ps as (select student_ref, program_ref, primary_major, concentration from :ps_schema.student_program where program_status = 'active'),
     wd as (select student_ref, program_ref, primary_major, concentration from :wd_schema.student_program where program_status = 'active')
select coalesce(ps.student_ref,wd.student_ref) as student_ref,
       ps.program_ref as ps_program, wd.program_ref as wd_program, ps.primary_major as ps_major, wd.primary_major as wd_major,
       ps.concentration as ps_conc, wd.concentration as wd_conc
from ps full outer join wd on ps.student_ref = wd.student_ref
where ps.student_ref is null or wd.student_ref is null
   or coalesce(ps.program_ref,'?') <> coalesce(wd.program_ref,'?')
   or coalesce(ps.primary_major,'?') <> coalesce(wd.primary_major,'?')
   or coalesce(ps.concentration,'?') <> coalesce(wd.concentration,'?');
