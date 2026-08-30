# Contributing to HELIX

Thank you for your interest in contributing to HELIX. This project exists because the higher education community needs it, and it will only succeed with community input.

## How to Contribute

### Share Feedback

The simplest way to contribute is to open a [GitHub Issue](../../issues) with your thoughts:

- **Questions** about the data model, terminology choices, or design decisions
- **Suggestions** for new resources, attributes, or terminology codes
- **Experience reports** from your own ERP migration or data integration work
- **Corrections** to resource definitions based on your domain expertise

### Propose Changes

1. Fork this repository
2. Create a feature branch (`git checkout -b proposal/add-course-section-resource`)
3. Make your changes
4. Submit a Pull Request with a clear description of what you're proposing and why

### Contribute ERP Mappings (HELIX Bridge)

If you have experience mapping data from a specific ERP (Banner, PeopleSoft, Workday, Colleague, or others) to a canonical model, we especially welcome mapping contributions in the `bridge/` directory. Even partial mappings for a single resource are valuable.

### Contribute Governance Patterns (HELIX Govern)

If your institution has data governance frameworks, role definitions, or quality rules that could benefit others, consider contributing them (appropriately generalized) to the `govern/` directory.

## What We're Looking For Right Now

HELIX is in its earliest stage (v0.1). The most valuable contributions right now are:

- **Validation** — Do these resource definitions match your institutional reality?
- **Gaps** — What critical attributes are missing from the Student, AcademicPeriod, or Enrollment resources?
- **Terminology** — Are the enumerated values (enrollment statuses, period types, etc.) complete and correct?
- **ERP expertise** — Can you map these resources to your ERP's actual table/column structure?

## Guidelines

- Be respectful and constructive
- When proposing changes to resource definitions, explain the real-world scenario that drives the need
- Favor simplicity over completeness (80/20 rule)
- Remember that HELIX is globally scoped; country-specific needs should be handled through Implementation Profiles rather than changes to the core spec

## Code of Conduct

We are committed to providing a welcoming and inclusive experience for everyone. Be kind, be constructive, and assume good intent.

## Questions?

Open an issue or start a discussion in the [Discussions](../../discussions) tab.

---

*HELIX is an open, philanthropic effort. It belongs to the higher education community.*
