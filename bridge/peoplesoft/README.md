# HELIX Bridge: Oracle PeopleSoft

Comprehensive mapping templates from Oracle PeopleSoft to HELIX Core resources, organized by PeopleSoft module.

## Modules

| Module | Sub-Folder | Mappings | Coverage | Description |
|--------|-----------|----------|----------|-------------|
| **Campus Solutions (SIS)** | `cs/` | 19 | 83% | Student identity, enrollment, financial aid, admissions, academics, degree audit, international, FERPA |
| **Financials (FSCM)** | `fin/` | 9 | 82% | General ledger, AP, AR/student financials, purchasing, budgets, grants, assets, expenses, contracts |
| **Human Capital Management** | `hcm/` | 12 | 80% | Employee records, positions, compensation, benefits, payroll, time, recruiting, absence, performance, job classification, position budgeting, learning |

**Total: 40 PeopleSoft mappings** — the most comprehensive open PeopleSoft-to-foundational mapping library available.

## Architecture Notes

- **Relational Database**: PeopleSoft runs on Oracle RDBMS (or DB2, SQL Server for some modules)
- **Effective Dating**: Most tables use EFFDT + EFFSEQ for point-in-time history
- **Unified Person Model**: EMPLID is shared across CS and HCM. PS_PERSONAL_DATA, PS_NAMES, PS_ADDRESSES serve both modules
- **PeopleTools Version**: Mappings are based on PeopleSoft 9.2 with PeopleTools 8.59+. Most field names are stable across recent versions

## Getting Started

1. Identify your PeopleSoft modules: CS only? CS + FIN? All three?
2. Browse the relevant sub-folder for your modules
3. Each mapping file documents source tables, attribute-level transformations, and institution-specific notes
4. Adapt the mappings to your PeopleSoft configuration (custom fields, institution-defined codes)
5. Use the [Migration Adventure Guide](../../docs/migration-adventure-guide.md) for step-by-step migration paths
