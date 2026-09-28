/*
  HELIX PS to Workday Reconciliation: FERPA Restriction Carryover Check
  ===========================================================================
  What it checks: Every active PeopleSoft FERPA / directory restriction exists in Workday with the same restricted categories.

  When to run: Before ANY Workday Student data is visible to anyone outside the conversion team, and again at cutover. Hard gate.

  What passing looks like:
    Zero rows is the ONLY passing result. One miss means a student who opted out could have directory information disclosed (34 CFR 99.37).

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

with ps as (select student_ref, restrict_directory, restricted_categories from :ps_schema.ferpa_restriction where is_active = true),
     wd as (select student_ref, restrict_directory, restricted_categories from :wd_schema.ferpa_restriction where is_active = true)
select ps.student_ref, ps.restrict_directory as ps_restrict, wd.restrict_directory as wd_restrict,
       ps.restricted_categories as ps_categories, wd.restricted_categories as wd_categories,
       case when wd.student_ref is null then 'MISSING_IN_WORKDAY' else 'CATEGORY_MISMATCH' end as issue
from ps left join wd on ps.student_ref = wd.student_ref
where wd.student_ref is null
   or ps.restrict_directory <> wd.restrict_directory
   or cast(ps.restricted_categories as varchar) <> cast(wd.restricted_categories as varchar);
