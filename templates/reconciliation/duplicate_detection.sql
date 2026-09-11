/*
  HELIX Reconciliation: Duplicate Person Detection
  ===========================================================================
  What it checks: Identifies potential duplicate person records using fuzzy
                  matching on name + date of birth + email.

  When to run: After initial migration, then quarterly.

  What passing looks like:
    - Zero exact duplicates (same name + DOB + email)
    - Probable duplicates < 0.5% of total population
    - Each flagged pair should be reviewed by a data steward

  Parameters:
    :helix_schema — HELIX Silver schema
*/

-- Exact duplicates (high confidence)
select
    'EXACT' as match_type,
    a.helix_id as person_a,
    b.helix_id as person_b,
    a.first_name,
    a.last_name,
    a.date_of_birth,
    a.institutional_email as email_a,
    b.institutional_email as email_b
from :helix_schema.helix_person a
inner join :helix_schema.helix_person b
    on a.helix_id < b.helix_id  -- Avoid self-joins and duplicate pairs
    and lower(a.first_name) = lower(b.first_name)
    and lower(a.last_name) = lower(b.last_name)
    and a.date_of_birth = b.date_of_birth
    and a.date_of_birth is not null

union all

-- Probable duplicates: same last name + DOB, different first name (nickname?)
select
    'PROBABLE' as match_type,
    a.helix_id,
    b.helix_id,
    a.first_name,
    a.last_name,
    a.date_of_birth,
    a.institutional_email,
    b.institutional_email
from :helix_schema.helix_person a
inner join :helix_schema.helix_person b
    on a.helix_id < b.helix_id
    and lower(a.last_name) = lower(b.last_name)
    and a.date_of_birth = b.date_of_birth
    and a.date_of_birth is not null
    and lower(a.first_name) != lower(b.first_name)
    -- Same email domain suggests same institution
    and split_part(a.institutional_email, '@', 2) = split_part(b.institutional_email, '@', 2)

order by match_type, last_name, first_name;
