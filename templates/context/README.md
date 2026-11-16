# HELIX Context Toolkit

Files for the [HELIX Context Route](../../docs/context/context-route.md): definitions, metadata, rules, and ontology for silver and gold, plus a route for historical and custom tables.

| Item | What it is |
|------|-----------|
| `gold-metrics.yaml` | 14 standard metric definitions (census headcount, FTE, retention, graduation, yield, melt, unmet need, Pell share, student work hours, section fill, instructional cost, IPEDS faculty, alumni participation, CASE dollars). Your institution's definition of truth once owners sign them |
| `generated/` | Built by `tools/build_context_pack.py`: Glue catalog context for all 64 silver tables, 64 resource skill files, 14 gold metric skill files, and the HELIX ontology (OWL plus SKOS for 67 code sets) |
| `profile-table.sql` | Step 2: profile a custom table without pulling sensitive values |
| `definition-review.csv` | Step 5: the steward review sheet (empty), with `definition-review.schema.json` |
| `prompts/draft-definitions.md` | Step 4: Bedrock prompt to draft definitions from the review sheet |
| `prompts/draft-gold-metric.md` | Draft a new gold metric for an owner to sign |
| `s3-annotation-template.json` | What HELIX attaches to a bronze object as an S3 annotation |
| `sample/` | A fictional Banner athletics table profile and the review sheet the drafter produced |

## Run it

```
# Context for every HELIX silver table and gold metric
python tools/build_context_pack.py --helix-version 0.10.0
python tools/apply_glue_context.py --pack templates/context/generated/glue-business-context.json --database helix_silver

# Custom or historical table
#   1. profile it with profile-table.sql, save as CSV
python tools/draft_custom_table_context.py --input profile.csv --source-system banner --out review.csv
#   2. draft definitions with prompts/draft-definitions.md; steward completes and approves rows
python tools/apply_glue_context.py --review review.csv --database legacy_bronze
```

Both publishing commands are dry runs until you add `--apply`. Add `--emit-sql` to get Spark SQL for Iceberg tables instead.

**About the generated definitions:** 394 of 1,122 silver columns don't yet have a written definition in HELIX Core. The generator fills them from the column name and marks them `helix.definition_status = pattern` so a steward can replace them. Written definitions are marked `written`.
