# HELIX Connect: API Reference Overview

HELIX Connect defines a REST API specification (OpenAPI 3.1) for exposing HELIX-conformant data. Any institution can implement a conformant server in front of their ERP or data lake.

**Full spec:** `connect/openapi.json`

## Endpoints (16)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/metadata` | GET | Server capability statement |
| `/students` | GET | List/search students |
| `/students/{helix_id}` | GET | Get a single student |
| `/students/{helix_id}/enrollments` | GET | Enrollments for a student |
| `/students/{helix_id}/financial-aid` | GET | Financial aid awards for a student |
| `/students/{helix_id}/degrees` | GET | Degrees conferred to a student |
| `/enrollments` | GET | List/search enrollments |
| `/academic-periods` | GET | List academic periods |
| `/courses` | GET | List catalog courses |
| `/course-sections` | GET | List course sections |
| `/programs` | GET | List academic programs |
| `/financial-aid-awards` | GET | List financial aid awards |
| `/degrees` | GET | List conferred degrees |
| `/$export` | GET | Initiate bulk export (NDJSON or Parquet) |
| `/$export-status/{id}` | GET | Check bulk export status |
| `/validate` | POST | Validate a resource against schemas |

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

Modeled after FHIR's `$export` operation:
1. `GET /$export?_type=Student,Enrollment&_since=2026-01-01` → 202 Accepted
2. Poll `/$export-status/{id}` until complete
3. Download NDJSON or Parquet files per resource type

Supports incremental exports via `_since` parameter for delta lake loads.
