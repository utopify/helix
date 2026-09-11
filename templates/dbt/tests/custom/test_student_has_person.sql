/*
  HELIX Quality Rule: QR-SI-004
  Every student record must link to a valid person record.
  
  Severity: ERROR
  Remediation: Investigate orphaned student records. 
  Common causes: person record not yet loaded, identity resolution failure.
  
  This test returns rows that FAIL — if any rows are returned, the test fails.
*/

select
    s.helix_id as student_helix_id,
    s.person_ref,
    s.student_id,
    s._helix_source_system
from {{ ref('helix_student') }} s
left join {{ ref('helix_person') }} p
    on s.person_ref = p.helix_id
where p.helix_id is null
  and s.person_ref is not null
