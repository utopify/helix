# Contributing to HELIX

Thank you for your interest in contributing to HELIX. This framework exists because the higher education community needs it, and it will only succeed with community input.

## Current State

HELIX v0.1 includes:
- **15 foundational resources** across 6 domains (Identity, Academic Structure, Enrollment, Financial Aid, Outcomes, Student Services)
- **18 terminology code sets** standardizing values across resources
- **4 ERP Bridge mappings** (Banner, PeopleSoft, Workday, Colleague) covering Student, Enrollment, and AcademicPeriod
- **Governance framework** with 6 roles, 22 quality rules, a 5-dimension maturity model, and a 9-domain taxonomy
- **OpenAPI 3.1 spec** with 16 REST endpoints for data exchange

## How to Contribute

### Share Feedback (Easiest Entry Point)

Open a [GitHub Issue](../../issues) with your thoughts:

- **Validation:** Do these resource definitions match your institutional reality? Are the attributes right?
- **Gaps:** What critical attributes are missing? What resources should be added?
- **Terminology:** Are the enumerated values (enrollment statuses, period types, etc.) complete and correct for your institution?
- **ERP expertise:** Can you verify or correct the Bridge mappings against your actual ERP table structures?
- **Governance:** Do the roles, quality rules, and maturity levels make sense for your institution's context?
- **International perspective:** How would HELIX need to adapt for institutions outside the US? (UK HESA, Australian TCSI, European EHEA, etc.)

### Propose Changes

1. Fork this repository
2. Create a feature branch (`git checkout -b proposal/add-course-section-resource`)
3. Make your changes
4. Submit a Pull Request with a clear description of what you're proposing and why

### Contribute ERP Mappings (HELIX Bridge)

If you have experience mapping data from a specific ERP to a foundational model, we especially welcome:

- **New resource mappings** for existing ERPs (e.g., Banner-to-HELIX for CourseSection, Program, FinAidAward)
- **New ERP systems** (Jenzabar, Unit4, Tribal, Campus Management, etc.)
- **Corrections** to existing mappings based on your production experience
- **Version-specific notes** (e.g., "Banner 9.x changed the gender field from SPBPERS_SEX to SPBPERS_GNDR_CODE")

Mapping contributions go in the `bridge/` directory. Even partial mappings for a single resource are valuable.

### Contribute Governance Patterns (HELIX Govern)

If your institution has governance frameworks, quality rules, or maturity assessments that could benefit others, consider contributing them (appropriately generalized) to the `govern/` directory:

- Additional quality rules for specific domains
- Country-specific regulatory context notes
- Real-world governance council structures that worked

### Contribute Terminologies

Suggest new codes, report missing values, or propose entirely new terminology code sets for domains we haven't covered yet.

### Contribute Implementation Profiles

If you're implementing HELIX at an institution in a specific country or regulatory context, document the constraints and adaptations as an Implementation Profile:

- **US Profile:** FERPA constraints, IPEDS reporting alignment, Title IV financial aid rules
- **UK Profile:** HESA data requirements, UK data protection
- **AU Profile:** TCSI reporting, Australian Privacy Act considerations
- **EU Profile:** GDPR implications for student data

## What We're Looking For Right Now

HELIX is in its earliest stage (v0.1). The most valuable contributions right now are:

1. **Institutional validation** - Does this model match how your institution actually works?
2. **ERP mapping verification** - Are the source tables and columns correct for your version?
3. **Terminology completeness** - Are we missing codes that your institution uses?
4. **International input** - How should HELIX adapt for non-US contexts?
5. **Governance reality check** - Do these roles and rules map to real institutional governance?

## Guidelines

- Be respectful and constructive
- When proposing changes to resource definitions, explain the real-world scenario that drives the need
- Favor simplicity over completeness (80/20 rule)
- Remember that HELIX is globally scoped; country-specific needs should be handled through Implementation Profiles rather than changes to the core spec
- Include your institutional context when possible ("At our 40,000-student R1, we found that...")

## Repository Structure

```
helix/
├── core/
│   ├── resources/         ← 15 JSON Schema resource definitions
│   ├── terminologies/     ← 18 standardized code sets
│   └── examples/          ← Sample payloads
├── connect/               ← OpenAPI 3.1 API spec
├── govern/                ← Governance roles, rules, maturity model, domains
├── bridge/
│   ├── banner/            ← Ellucian Banner mappings
│   ├── peoplesoft/        ← Oracle PeopleSoft mappings
│   ├── workday/           ← Workday Student mappings
│   └── colleague/         ← Ellucian Colleague mappings
└── docs/                  ← Comprehensive documentation
```

## Code of Conduct

We are committed to providing a welcoming and inclusive experience for everyone. Be kind, be constructive, and assume good intent. Higher education is a global endeavor, and this framework should reflect that.

## Questions?

Open an issue or start a discussion in the [Discussions](../../discussions) tab.

---

*HELIX is an open, philanthropic effort. It belongs to the higher education community.*
