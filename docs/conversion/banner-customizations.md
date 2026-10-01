# Banner Customization Discovery

How to find every change your institution made to Ellucian Banner, decide what happens to each one, and convert what's worth keeping. Read [`customization-discovery.md`](customization-discovery.md) first for the method; this page is the Banner detail.

This matters most for **Banner on-prem to Banner SaaS**. Banner SaaS has no direct database access and doesn't allow customer objects in the database, so every local table, column, trigger, package, and job needs a decision before cutover. Confirm the specifics of what's supported with Ellucian for your contract.

---

## 1. Build the baseline

The vanilla baseline is a clean Banner database built from Ellucian's release deliverables at the **same release levels** you have installed, module by module (Student, Financial Aid, Finance, HR, Advancement, General). If a clean database isn't practical, the delivered source files for those releases work for PL/SQL and job programs; use the object list from the release documentation for tables and columns.

Releases matter: a delivered package at a newer release than production looks "modified" when it isn't.

## 2. Inventory

Queries are in [`templates/customization-discovery/banner/`](../../templates/customization-discovery/banner/). They read the Oracle data dictionary (`DBA_` views), so they need `SELECT_CATALOG_ROLE`. Edit the owner list in each query to match your installation and add any local schemas.

| Query | Finds |
|-------|-------|
| `01_objects.sql` | Every object in the Banner schemas, with a flag for names starting with Z (Ellucian's naming standard reserves Z for client objects) |
| `02_source.sql` | PL/SQL source line by line, so modified delivered packages show up |
| `03_columns.sql` | Columns added to delivered tables |
| `04_triggers.sql` | Triggers, with the table each fires on |
| `05_views.sql` | Views, with full DDL |
| `06_dependencies.sql` | What each local object reads and calls (production only) |
| `07_job_submission.sql` | Job Submission processes in `GJBJOBS`, including local Z jobs |
| `08_validation_values.sql` | Generates extraction SQL for every validation table (STV, GTV, RTV, FTV, PTV and others) to find local codes |
| `09_self_service.sql` | Banner 8 Self-Service packages and WTAILOR menus |
| `10_hidden_integrations.sql` | Database links, directories, scheduler jobs, and code calling `UTL_HTTP`, `UTL_FILE`, `UTL_SMTP`, or other databases (production only) |

Then fingerprint the job server: COBOL, Pro*C, SQL*Plus scripts, shell scripts, and SQL*Loader control files under `$BANNER_HOME`, compared with the release deliverables:

```
python tools/inventory_source_files.py --root <release_media>   --owner DELIVERED   --out baseline_files.csv
python tools/inventory_source_files.py --root <BANNER_HOME>     --owner BANNER_HOME --out production_files.csv
```

**What the queries don't see:** Banner 9 Extensibility and Page Builder customizations (inventory those through the Extensibility tools), Argos, Evisions, or other reporting tools pointed at Banner, and Ethos or Banner Integration API consumers already in place.

## 3. Diff

```
python tools/diff_customizations.py --baseline baseline_all.csv --production production_all.csv \
  --source-system banner --source-release "Student 9.x / FinAid 9.x / ... (fill in)" \
  --case-insensitive --out customization-register.csv
```

Use `--case-insensitive` for Banner, since PL/SQL isn't case-sensitive and formatting changes from tools would otherwise show as modifications. The sample in `templates/customization-discovery/sample/` shows the output.

## 4. Enrich

| Field | Where it comes from |
|-------|---------------------|
| Usage | Job Submission run history, Oracle auditing if enabled, and the owners. (Oracle's AWR history can show which SQL ran, but it's a separately licensed pack; check before using it.) |
| Owner | The module (first letter of the object name: S student, R financial aid, F finance, P HR and payroll, A advancement, T accounts receivable, G general) points to the office |
| HELIX resources | Query 06 lists the delivered tables each local object touches; look them up in `bridge/banner/` |
| Complexity | Lines of PL/SQL, number of tables written, whether it fires on every transaction (triggers) |

## 5. Decide

### Banner on-prem to Banner SaaS

| Banner customization | What happens | Disposition |
|----------------------|--------------|-------------|
| Local tables (Z tables) with data | Data moves to the HELIX lakehouse; if it's still collected, rebuild as a supported Banner field, extension, or a separate app | `preserve_as_data` + `rebuild` |
| Columns added to delivered tables | Same as local tables. Many end up as a HELIX attribute or StudentGroup membership | `preserve_as_data` + `rebuild` |
| Modified delivered packages and forms | SaaS runs delivered code. Re-check whether the change is still needed; rebuild through supported extensibility if so | `retire` or `rebuild` |
| Local packages that only read (reports, extracts) | Convert to SQL on Aurora PostgreSQL against the Data Connect copy, or to dbt on the lakehouse | `convert` |
| Local packages that write to Banner | Rebuild as Ethos or Banner Integration API calls (`bridge/banner-saas/WRITEBACK_PATTERNS.md`) | `rebuild` |
| Triggers on delivered tables | Audit triggers become change data capture in the lakehouse; business-rule triggers become Ethos-driven integrations or are retired | `convert` or `rebuild` |
| Local views | Convert to views or dbt models on the Data Connect copy or the lakehouse | `convert` |
| Local Job Submission jobs (COBOL, Pro*C, SQL*Plus) | Reporting jobs convert to Glue or dbt; jobs that update Banner become integrations | `convert` or `rebuild` |
| Database links, `UTL_HTTP`, `UTL_FILE`, scheduler jobs | Integrations. Each needs a new home (Ethos, an integration platform, AWS Lambda or Step Functions) | `rebuild` |
| Local validation codes | Carry into SaaS as configuration if still used; add HELIX crosswalk rows either way | `crosswalk` |
| Self-Service Banner 8 customizations | Banner 9 Self-Service and Extensibility, or retired | `rebuild` or `retire` |

### Banner to a lakehouse (keeping Banner on-prem or moving to another ERP)

Read-only logic converts: PL/SQL report packages and views become dbt models on HELIX silver (`plsql-to-dbt.md`), batch jobs become Glue jobs (`app-engine-to-glue.md`), and PL/SQL that still needs a transactional database moves to Aurora PostgreSQL with AWS DMS Schema Conversion (`plsql-to-postgres.md` finishes what it leaves).

## 6. Convert and prove

The usual Banner conversion path:
1. **AWS DMS Schema Conversion** on the local packages, procedures, functions, views, and triggers marked `convert`, targeting Aurora PostgreSQL or Redshift. Turn on the generative AI conversion option.
2. **Amazon Bedrock** with `plsql-to-postgres.md` for the action items Schema Conversion leaves.
3. **Amazon Bedrock** with `plsql-to-dbt.md` for report logic going to the lakehouse instead of a database.
4. **Prove it:** run the original on on-prem Banner and the conversion on the target for the same term and inputs, and compare row for row. Keep the on-prem copy in bronze until every converted report has matched for at least one full term.

## Things that trip people up

- **Wrapped delivered code.** Wrapped packages can be compared but not converted. If one differs from the baseline, check the release level before calling it a customization.
- **Columns hiding on delivered tables.** They don't show up as local objects. Query 03 catches them.
- **Triggers nobody remembers.** They fire on every transaction. Query 04 lists them all, and every one needs a decision before SaaS.
- **Integrations in code.** A `UTL_HTTP` call in a package is an integration as real as any interface file. Query 10 finds them.
- **Reporting tools pointed straight at Oracle.** Argos and similar tools lose their source at SaaS cutover. Inventory their datablocks along with everything else.

*HELIX v0.9.0, October 2026*
