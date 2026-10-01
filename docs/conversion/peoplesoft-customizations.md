# PeopleSoft Customization Discovery

How to find every change your institution made to PeopleSoft (Campus Solutions, HCM, or Financials), decide what happens to each one, and convert what's worth keeping. Read [`customization-discovery.md`](customization-discovery.md) first for the method; this page is the PeopleSoft detail.

---

## 1. Build the baseline

The vanilla baseline is the **PeopleSoft Update Manager (PUM) image** for your application at the image level you're on, or a demo (DMO) database patched to the same PeopleTools release and bundle level. If you've applied selective fixes, apply them to the baseline too, or they'll show up as customizations.

Oracle's own tool for this is the Application Designer compare report (through Change Assistant), and it's worth running. The HELIX queries add something it doesn't: the results land in one register, with usage and HELIX resource mapping, alongside every other system you're converting.

Land the baseline and production metadata in the same place. With AWS DMS you can copy the PeopleTools tables from both databases into bronze and run the comparison in Amazon Athena instead of on either database.

## 2. Inventory

Queries are in [`templates/customization-discovery/peoplesoft/`](../../templates/customization-discovery/peoplesoft/). Run each one against the baseline and production and save the results as CSV.

| Query | Finds | Key PeopleTools tables |
|-------|-------|------------------------|
| `01_records.sql` | Custom and modified records (tables, views, temp tables) | `PSRECDEFN` |
| `02_record_fields.sql` | Fields added to delivered records | `PSRECFIELD` |
| `03_fields.sql` | Custom fields, delivered fields with changed length or type | `PSDBFIELD` |
| `04_peoplecode.sql` | Custom and modified PeopleCode, with source | `PSPCMPROG`, `PSPCMTXT` |
| `05_sql_objects_and_views.sql` | SQL objects, view SQL, App Engine SQL | `PSSQLDEFN`, `PSSQLTEXTDEFN` |
| `06_app_engine.sql` | App Engine programs and steps | `PSAEAPPLDEFN`, `PSAESTEPDEFN` |
| `07_pages_components_menus.sql` | Online pages, components, menus | `PSPNLDEFN`, `PSPNLGRPDEFN`, `PSMENUDEFN` |
| `08_queries_and_usage.sql` | PS Query definitions and how often they run | `PSQRYDEFN`, `PSQRYSTATS` |
| `09_process_definitions_and_usage.sql` | Every scheduled process with 12-month run counts | `PS_PRCSDEFN`, `PSPRCSRQST` |
| `10_integration_broker.sql` | Service operations and routings to outside systems | `PSOPERATION`, `PSIBRTNGDEFN` |
| `11_translate_values.sql` | Local translate values on delivered fields | `PSXLATITEM` |
| `12_quick_triage.sql` | A fast count before the baseline is ready | All of the above |

Then fingerprint the files that live outside the database:

```
python tools/inventory_source_files.py --root <PS_HOME>/sqr      --owner PS_HOME      --out baseline_files.csv
python tools/inventory_source_files.py --root <PS_CUST_HOME>/sqr --owner PS_CUST_HOME --out production_files.csv
```

Do the same for COBOL (`src/cbl`), Crystal reports, and BI Publisher templates if you have them. AWS DataSync can copy those directories from campus servers to S3 first.

**What the queries don't see:** configuration-based changes made with newer PeopleTools features (Page and Field Configurator, Event Mapping, Drop Zones), nVision layouts, and Excel or Access tools that read PeopleSoft directly. Event Mapping is how many sites moved PeopleCode out of delivered objects, so ask the developers about it and inventory those configurations from the PeopleTools pages.

## 3. Diff

```
python tools/diff_customizations.py --baseline baseline_all.csv --production production_all.csv \
  --source-system peoplesoft --source-release "CS 9.2 PUM <n> / PeopleTools 8.<nn>" \
  --out customization-register.csv
```

Combine the query outputs into one file per side first, or run the tool once per query and append the registers.

A quick reality check: `LASTUPDOPRID <> 'PPLSOFT'` (query 12) is the classic shortcut, and it's a good way to size the work. It overcounts objects someone opened and saved without changing, and it misses delivered objects changed by scripts that left the operator ID alone. The baseline compare is what goes in the register.

## 4. Enrich

| Field | Where it comes from |
|-------|---------------------|
| Usage | `PSPRCSRQST` (process runs, purged on a schedule), `PSQRYSTATS` (query runs, if logging is on), web server access logs for pages |
| Owner | The component's menu location and its security roles usually point to the office |
| HELIX resources | Match the records each object reads and writes to `bridge/peoplesoft/{cs,hcm,fin}/` |
| Complexity | Lines of PeopleCode or SQL, number of records touched, whether it writes data |

## 5. Decide

### PeopleSoft to Workday

PeopleSoft customizations don't move to Workday as code. Typical outcomes:

| PeopleSoft customization | Usually becomes in Workday | Disposition |
|--------------------------|----------------------------|-------------|
| PeopleCode validation or default on a delivered page | Business process condition, validation, or calculated field | `rebuild` |
| Custom record holding data entered by users | Custom object, or a field already in Workday; history goes to the lakehouse | `rebuild` + `preserve_as_data` |
| Fields added to delivered records | A delivered Workday field, a custom field on the business object, or retired | `configure` or `rebuild` |
| Custom pages and components | Workday tasks and business processes, or Workday Extend for true custom apps | `rebuild` or `retire` |
| SQR and PS Query reports | Workday custom reports, or dbt models and dashboards in the lakehouse | `rebuild` or `convert` |
| App Engine batch | Workday integration (EIB, Studio) if it changes Workday data; a Glue job if it only reads | `rebuild` or `convert` |
| Integration Broker routings | Workday integrations or an integration platform | `rebuild` |
| Local translate values | Crosswalk rows in `bridge/xref/ps-to-workday-*/` and Workday reference data | `crosswalk` |

Use `templates/customization-discovery/conversion-prompts/peoplecode-to-business-rules.md` to turn PeopleCode into rules the Workday team can configure. The PeopleSoft to Workday guide (`docs/ps-to-workday-migration.md`) has the cutover plan this feeds.

### PeopleSoft to a lakehouse (keeping or retiring PeopleSoft)

| Customization | Becomes | Tool |
|---------------|---------|------|
| Custom views and SQL objects | dbt models on HELIX silver | Amazon Bedrock with `plsql-to-dbt.md`; DMS Schema Conversion for straight SQL |
| SQR reports | dbt models plus a dashboard | Bedrock with `sqr-to-dbt.md` |
| App Engine programs that compute or extract | AWS Glue jobs | Bedrock with `app-engine-to-glue.md`; AWS Transform for analysis |
| Custom records with data | HELIX resources or local extension tables in silver | Bridge mappings plus a local extension per `govern/schema-evolution-policy.json` |

## 6. Convert and prove

See [section 6 and 7 of the method](customization-discovery.md#6-convert). For PeopleSoft specifically:
- Run converted reports for the same run control parameters in PeopleSoft and in the lakehouse; compare totals and row counts.
- For Workday rebuilds, test each rule extracted from PeopleCode as a Workday test case during each mock conversion.

## Things that trip people up

- **Comparing against the wrong image.** A baseline even one PUM image off produces hundreds of false positives.
- **Missing the custom fields on delivered records.** They don't show up as custom records. Query 02 catches them.
- **Trusting `PSPRCSRQST` alone.** It gets purged. A year-end process can look unused in October.
- **Converting PeopleCode line by line.** Extract the rule, then build it the target's way.
- **Forgetting public queries.** Offices run their operations on them. Ask before retiring any query with recent runs.

*HELIX v0.9.0, October 2026*
