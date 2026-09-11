/*
  HELIX Reconciliation: Student Record Completeness
  ===========================================================================
  What it checks: Required and critical fields in HELIX Student and Person
                  resources are populated. Missing data = missing reporting.

  When to run: After initial migration, then weekly.

  What passing looks like:
    - completeness_pct >= 95% for required fields
    - completeness_pct >= 80% for recommended fields
    - Zero rows with person_ref completeness < 100%

  Parameters:
    :helix_schema — HELIX Silver schema
*/

select
    'helix_person' as resource,
    count(*) as total_records,
    round(100.0 * count(last_name) / count(*), 1) as last_name_pct,
    round(100.0 * count(first_name) / count(*), 1) as first_name_pct,
    round(100.0 * count(date_of_birth) / count(*), 1) as dob_pct,
    round(100.0 * count(institutional_email) / count(*), 1) as email_pct,
    round(100.0 * count(gender) / count(*), 1) as gender_pct,
    round(100.0 * count(ethnicity) / count(*), 1) as ethnicity_pct
from :helix_schema.helix_person

union all

select
    'helix_student',
    count(*),
    round(100.0 * count(person_ref) / count(*), 1),      -- MUST be 100%
    round(100.0 * count(student_status) / count(*), 1),
    round(100.0 * count(student_type) / count(*), 1),
    round(100.0 * count(academic_level) / count(*), 1),
    round(100.0 * count(full_part_time) / count(*), 1),
    round(100.0 * count(cumulative_gpa) / count(*), 1)
from :helix_schema.helix_student;
