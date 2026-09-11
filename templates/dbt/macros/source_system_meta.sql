{% macro source_system_meta() %}
{#
  Adds standard HELIX metadata columns to every staging model.
  These columns track data lineage from source through the medallion layers.
  
  Usage: {{ source_system_meta() }}
  
  Place at the end of your SELECT column list in staging models.
#}

'{{ var("source_system", "unknown") }}'  as _helix_source_system,
current_timestamp                        as _helix_loaded_at

{% endmacro %}
