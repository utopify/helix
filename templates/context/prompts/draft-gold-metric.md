# Prompt: Draft a gold metric definition

**Use when:** your institution has a metric that isn't in `templates/context/gold-metrics.yaml` (or counts a standard one differently), and the owner wants a first draft to react to.

## Prompt

```
Draft a metric definition for {metric_name} at {institution_type}, owned by {owner_role}, in the
format of the HELIX gold metric file (id, name, domain, owner_role, grain, population, formula,
sources, standard, output_classification, suppression, notes).

What the owner told us:
{owner_notes}

Rules:
- sources must be HELIX silver columns from the list below (resource.attribute). If a needed column
  isn't there, say so in notes rather than inventing one.
- If a federal or accreditor definition exists (IPEDS, Common Data Set, CASE, NACE, a state
  system), name it in standard and say exactly where the institution's version differs.
- population lists inclusion and exclusion rules as separate bullet items.
- output_classification is at least as strict as the most sensitive source.
- suppression follows govern/ferpa-suppression-policy.json for anything built from education records.
- Write it so a new analyst could compute it from the definition alone.

Available HELIX columns:
{column_list}

Existing related metrics:
{related_metrics}
```

The owner reviews the draft, edits it, and signs it (`approved_by`, `approved_date`) before it goes into the file.
