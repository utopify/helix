# HELIX Connect: API Reference Overview

HELIX Connect defines a REST API specification (OpenAPI 3.1) for exposing HELIX-conformant data. Any institution can implement a conformant server in front of their ERP or data lake.

**Full spec:** `connect/openapi.json`

## Endpoints (51)

Generated from `connect/openapi.json` (API version 0.2.0).

### Metadata (1)

| Endpoint | Method | Description | Scopes |
|----------|--------|-------------|--------|
| `/metadata` | GET | Server capability statement |  |

### Students (5)

| Endpoint | Method | Description | Scopes |
|----------|--------|-------------|--------|
| `/students` | GET | List or search students |  |
| `/students/{helix_id}` | GET | Get a single student |  |
| `/students/{helix_id}/enrollments` | GET | Get enrollments for a student |  |
| `/students/{helix_id}/financial-aid` | GET | Get financial aid awards for a student |  |
| `/students/{helix_id}/degrees` | GET | Get degrees conferred to a student |  |

### Enrollment (1)

| Endpoint | Method | Description | Scopes |
|----------|--------|-------------|--------|
| `/enrollments` | GET | List or search enrollments |  |

### Academic Structure (4)

| Endpoint | Method | Description | Scopes |
|----------|--------|-------------|--------|
| `/academic-periods` | GET | List academic periods |  |
| `/courses` | GET | List catalog courses |  |
| `/course-sections` | GET | List course sections |  |
| `/programs` | GET | List academic programs |  |

### Financial Aid (1)

| Endpoint | Method | Description | Scopes |
|----------|--------|-------------|--------|
| `/financial-aid-awards` | GET | List financial aid awards |  |

### Outcomes (1)

| Endpoint | Method | Description | Scopes |
|----------|--------|-------------|--------|
| `/degrees` | GET | List conferred degrees |  |

### Bulk Export (2)

| Endpoint | Method | Description | Scopes |
|----------|--------|-------------|--------|
| `/$export` | GET | Bulk export resources for data lake ingestion |  |
| `/$export-status/{export_id}` | GET | Check bulk export status |  |

### Validation (1)

| Endpoint | Method | Description | Scopes |
|----------|--------|-------------|--------|
| `/validate` | POST | Validate a resource against HELIX Core schemas |  |

### Financial Operations (23)

| Endpoint | Method | Description | Scopes |
|----------|--------|-------------|--------|
| `/gl-transactions` | GET | List or search gltransaction records | helix:read:financial |
| `/gl-transactions` | POST | Create a general ledger transaction | helix:write:financial |
| `/gl-transactions/{id}` | GET | Get a single gltransaction by HELIX ID | helix:read:financial |
| `/ap-vouchers` | GET | List or search apvoucher records | helix:read:financial |
| `/ap-vouchers/{id}` | GET | Get a single apvoucher by HELIX ID | helix:read:financial |
| `/ar-transactions` | GET | List or search artransaction records | helix:read:financial |
| `/ar-transactions/{id}` | GET | Get a single artransaction by HELIX ID | helix:read:financial |
| `/budgets` | GET | List or search budget records | helix:read:financial |
| `/budgets/{id}` | GET | Get a single budget by HELIX ID | helix:read:financial |
| `/purchase-orders` | GET | List or search purchaseorder records | helix:read:financial |
| `/purchase-orders/{id}` | GET | Get a single purchaseorder by HELIX ID | helix:read:financial |
| `/grants` | GET | List or search grant records | helix:read:financial |
| `/grants/{id}` | GET | Get a single grant by HELIX ID | helix:read:financial |
| `/assets` | GET | List or search asset records | helix:read:financial |
| `/assets/{id}` | GET | Get a single asset by HELIX ID | helix:read:financial |
| `/expense-reports` | GET | List or search expensereport records | helix:read:financial |
| `/expense-reports/{id}` | GET | Get a single expensereport by HELIX ID | helix:read:financial |
| `/contracts` | GET | List or search contract records | helix:read:financial |
| `/contracts/{id}` | GET | Get a single contract by HELIX ID | helix:read:financial |
| `/funds` | GET | List or search fund records | helix:read:financial |
| `/funds/{id}` | GET | Get a single fund by HELIX ID | helix:read:financial |
| `/financial-orgs` | GET | List or search financialorg records | helix:read:financial |
| `/financial-orgs/{id}` | GET | Get a single financialorg by HELIX ID | helix:read:financial |

### Human Resources (12)

| Endpoint | Method | Description | Scopes |
|----------|--------|-------------|--------|
| `/employees` | GET | List or search employee records | helix:read:hr |
| `/employees/{id}` | GET | Get a single employee by HELIX ID | helix:read:hr |
| `/positions` | GET | List or search position records | helix:read:hr |
| `/positions/{id}` | GET | Get a single position by HELIX ID | helix:read:hr |
| `/requisitions` | GET | List or search requisition records | helix:read:hr |
| `/requisitions/{id}` | GET | Get a single requisition by HELIX ID | helix:read:hr |
| `/time-entries` | GET | List or search timeentry records | helix:read:hr |
| `/time-entries/{id}` | GET | Get a single timeentry by HELIX ID | helix:read:hr |
| `/absence-records` | GET | List or search absencerecord records | helix:read:hr |
| `/absence-records/{id}` | GET | Get a single absencerecord by HELIX ID | helix:read:hr |
| `/job-classifications` | GET | List or search jobclassification records | helix:read:hr |
| `/job-classifications/{id}` | GET | Get a single jobclassification by HELIX ID | helix:read:hr |

Connect covers the student, financial operations, and HR resources most institutions expose first. Resources without an endpoint yet (the Financial Aid lifecycle, Outcomes, Advancement, and a few student records) can still be exchanged through the bulk `/$export` endpoint.

## Security

- **OAuth 2.0** (recommended) with scopes mapped to data classification levels
- **API Key** for development and internal use

| Scope | Access Level |
|-------|-------------|
| `helix:read` | Public and internal classified resources |
| `helix:read:confidential` | Confidential resources (student PII, grades) |
| `helix:read:restricted` | Restricted resources (SSN, health records) |
| `helix:export` | Bulk export access |
| `helix:write` | Write access (optional) |
| `helix:validate` | Resource validation |

## Bulk Export

Async bulk export operation:
1. `GET /$export?_type=Student,Enrollment&_since=2026-01-01` → 202 Accepted
2. Poll `/$export-status/{id}` until complete
3. Download NDJSON or Parquet files per resource type

Supports incremental exports via `_since` parameter for delta lake loads.
