/*
  HELIX Quality Rule: QR-EN-004
  Cumulative GPA must be between 0.0 and 4.0 (standard US scale).
  
  Severity: WARN (some institutions use 5.0 or 4.3 scales)
  Remediation: If your institution uses a non-4.0 scale, adjust the 
  max_value or add a scale conversion in your staging model.
*/

select
    helix_id,
    student_id,
    cumulative_gpa,
    _helix_source_system
from {{ ref('helix_student') }}
where cumulative_gpa is not null
  and (cumulative_gpa < 0.0 or cumulative_gpa > 4.0)
