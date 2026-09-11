/*
  HELIX Quality Rule: QR-EN-001
  Enrollment status must be from the HELIX enrollment-status terminology.
  
  Valid values: enrolled, dropped, withdrawn, completed, waitlisted, audit, incomplete
  
  Severity: ERROR
  Remediation: Map source system status codes to HELIX terminology values.
  Check bridge mapping files for your ERP (bridge/{erp}/sis/enrollment_mapping.json).
*/

select
    helix_id,
    student_ref,
    enrollment_status,
    _helix_source_system
from {{ ref('helix_enrollment') }}
where enrollment_status not in (
    'enrolled', 'dropped', 'withdrawn', 'completed',
    'waitlisted', 'audit', 'incomplete'
)
  and enrollment_status is not null
