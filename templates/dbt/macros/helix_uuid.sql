{% macro helix_uuid(source_key_column) %}
{#
  Generates a deterministic HELIX UUID from a source system key.
  Uses MD5 hash of (source_system + source_key) to produce a repeatable UUID.
  This ensures the same source record always gets the same HELIX ID.
  
  Usage: {{ helix_uuid('source_person_id') }} as helix_id
#}

{% set source_system = var('source_system', 'unknown') %}

cast(
    md5(cast('{{ source_system }}' || '::' || cast({{ source_key_column }} as varchar) as varchar))
    as varchar(36)
)

{% endmacro %}
