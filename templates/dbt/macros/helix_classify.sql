{% macro helix_classify(classification, is_ferpa, is_glba) %}
{#
  Post-hook macro to apply HELIX data classification tags to a table.
  Creates a comment on the table with classification metadata.
  
  Usage in config:
    post_hook="{{ helix_classify('confidential', true, false) }}"
  
  Classification tiers: public, internal, confidential, restricted
  See: govern/classification-handling-rules.json
#}

{% set comment_text = 'HELIX Classification: ' ~ classification ~ ' | FERPA: ' ~ is_ferpa ~ ' | GLBA: ' ~ is_glba %}

{% if target.type == 'snowflake' %}
    comment on table {{ this }} is '{{ comment_text }}';
{% elif target.type == 'redshift' %}
    comment on table {{ this }} is '{{ comment_text }}';
{% elif target.type == 'bigquery' %}
    -- BigQuery uses table options for descriptions
    alter table {{ this }} set options (description='{{ comment_text }}');
{% else %}
    -- Generic: comment on table
    comment on table {{ this }} is '{{ comment_text }}';
{% endif %}

{% endmacro %}
