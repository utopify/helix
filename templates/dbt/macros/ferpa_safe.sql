{% macro ferpa_safe(table_ref, id_column='student_helix_id') %}
{#
  Creates a FERPA directory-information-safe view that:
  1. Joins to ferpa_restriction to check directory opt-out status
  2. Nullifies PII fields for students who have opted out
  3. Always requires a legitimate educational interest assertion
  
  Usage:
    {{ ferpa_safe(ref('dim_student'), 'student_helix_id') }}
  
  FERPA Reference:
  - 99.31(a)(11): Directory information may be disclosed unless student has opted out
  - 99.37: Student must be notified of directory info categories and given chance to opt out
  
  See: govern/ferpa-disclosure-framework.json
#}

select
    t.*,
    -- Override PII fields when student has directory restriction
    case
        when fr.directory_restricted = true then '** FERPA RESTRICTED **'
        else t.first_name
    end as safe_first_name,
    case
        when fr.directory_restricted = true then '** FERPA RESTRICTED **'
        else t.last_name
    end as safe_last_name,
    case
        when fr.directory_restricted = true then null
        else t.institutional_email
    end as safe_email,
    case
        when fr.directory_restricted = true then null
        else t.primary_phone
    end as safe_phone,
    coalesce(fr.directory_restricted, false) as is_directory_restricted
from {{ table_ref }} t
left join {{ ref('helix_ferpa_restriction') }} fr
    on t.{{ id_column }} = fr.student_ref

{% endmacro %}
