# HELIX Connect

The API and exchange layer of the HELIX ecosystem. Defines how institutions expose HELIX-conformant data to applications, peer institutions, and data lake ingestion pipelines.

## Contents

| File | What It Is |
|------|-----------|
| **openapi.json** | OpenAPI 3.1 specification for a HELIX Connect server |

## API Overview

A HELIX Connect server exposes REST endpoints for all HELIX Core resources. Any institution can implement a conformant server in front of their ERP or data lake.

### Endpoints (16 total)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/metadata` | GET | Server capability statement (conformance level, supported resources, ERP type) |
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
| `/validate` | POST | Validate a resource against HELIX Core schemas |

### Key Design Decisions

- **Pagination**: Token-based (not offset-based) for consistency across large datasets
- **Incremental sync**: `updated_since` parameter on list endpoints enables delta loads
- **Bulk export**: Async pattern async bulk export operation. Supports NDJSON (required) and Parquet (optional, recommended for lake ingestion)
- **Security**: OAuth 2.0 (recommended) or API key. Scopes map to HELIX data classification levels (`helix:read:confidential`, `helix:read:restricted`)
- **Validation endpoint**: Submit any resource payload and get back schema + terminology validation results

### Conformance Requirements

| Operation | Required? |
|-----------|----------|
| Read (single resource by ID) | **Required** |
| Search (list with filters) | **Required** |
| Bulk Export | Recommended |
| Validate | Recommended |
| Write (accept inbound data) | Optional |

## Using the Spec

The `openapi.json` file can be loaded into:
- **Swagger UI / Redoc** for interactive documentation
- **Postman** for API testing
- **Code generators** (OpenAPI Generator) to scaffold client libraries or server stubs in any language
- **API gateways** (AWS API Gateway, Kong, etc.) for deployment

## AsyncAPI (Future)

A companion AsyncAPI spec for event-driven patterns (student enrolled, grade posted, aid disbursed) is planned for a future release.
