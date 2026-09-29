# HELIX

### Higher Education Linked Information eXchange

> What if every university spoke the same data language?

HELIX is a free, open framework that gives colleges and universities one shared data model for students, courses, financial aid, HR, finance, and advancement, plus ready-made mappings from the ERPs they already run (PeopleSoft, Banner, Workday, Colleague). Map your ERP to HELIX once, and your lakehouse, your reporting, and your next ERP migration all start from the same foundation.

**Version:** 0.8.1 (September 2026) · **License:** Apache 2.0 · **Founded by:** Dallas Maddox

---

## Press GO

**New here? Open [START_HERE.md](START_HERE.md).** It's six steps, and each one tells you what to do, which file to use, and how you know you're done.

| Step | Do this | Done when |
|------|---------|-----------|
| 1 | Describe what you have in the [institution profile](templates/intake/institution-profile.md) | Every source database is listed with an owner |
| 2 | Pick your goal (below) | It's written in the profile |
| 3 | Pick one small slice, like fall census or one fiscal year of GL | You know which official number it has to match |
| 4 | Land that slice raw, from a reporting copy | Bronze row counts match the source |
| 5 | Map it to HELIX and reconcile | HELIX matches the number your registrar or controller trusts |
| 6 | Name an owner and pick the next slice | Someone owns it |

---

## Pick your goal

| I want to... | Start with |
|--------------|-----------|
| **Build a lakehouse** and keep my ERP for now | [Lakehouse Architecture Guide](docs/lakehouse-architecture-guide.md) |
| **Move PeopleSoft to Workday** (HCM, Financials, or Student) | [PeopleSoft to Workday Guide](docs/ps-to-workday-migration.md) |
| **Move Banner on-prem to Banner SaaS** | [Adventure Guide, Chapter 8](docs/migration-adventure-guide.md#chapter-8-banner-on-prem-to-banner-saas) |
| **Stand up data governance** | [CDO Quick Start](docs/cdo-quick-start.md) |
| **Explore other paths** (Colleague, Banner to Workday, and more) | [Migration Adventure Guide](docs/migration-adventure-guide.md) |

Building a lakehouse and moving to Workday go together. The extraction, mapping, and reconciliation you do for one is the same work the other needs.

---

## What's in the box

| Folder | What it gives you |
|--------|-------------------|
| [`core/`](core/) | The data model: 64 resources, 67 code sets, a data dictionary, and a plain-English [glossary](core/glossary.md) of higher ed terms |
| [`bridge/`](bridge/) | Field-by-field mappings from PeopleSoft, Banner, Workday, and Colleague into HELIX, mappings for graduate outcomes sources outside the ERP (career services, the Clearinghouse, state wage records, licensure, the LMS), plus direct PeopleSoft to Workday crosswalks and extraction playbooks |
| [`templates/`](templates/) | Things you run: a [starter intake](templates/intake/), a dbt starter project, reconciliation queries, and the PeopleSoft to Workday toolkit |
| [`govern/`](govern/) | Data governance you can adopt: roles, quality rules, FERPA and GLBA frameworks, access controls, AI agent guardrails |
| [`agents/`](agents/) | AI assistant templates for ChatGPT, Claude, Gemini, Amazon Q, or Bedrock |
| [`connect/`](connect/) | An OpenAPI spec for exchanging HELIX data between systems |
| [`tools/`](tools/) | A validator that checks your data against the HELIX schemas, and a check that every resource has access rules |

Want every count, layer, and file? See the [full reference](docs/helix-reference.md).

---

## Get help from an AI assistant

Load [`agents/helix-migration-companion.json`](agents/helix-migration-companion.json) into your assistant of choice, upload this repo as knowledge, and say **"help me start."** It walks you through the same six steps and hands you off to a specialist (PeopleSoft to Workday HCM, Financials, or Student; Banner; enrollment; advancement) when you need one.

---

## Learn more

- [Executive summary](docs/helix-executive-summary.md): a one-page explainer for CIOs, provosts, and presidents
- [Full reference](docs/helix-reference.md): the complete inventory, design principles, and how HELIX relates to CEDS, Ed-Fi, and PESC
- [Glossary](core/glossary.md): the student lifecycle and campus operations, explained
- [Changelog](CHANGELOG.md): what changed in each release

---

## Contribute

HELIX gets better every time an institution confirms a mapping. The fastest way to help is to check the values marked VALIDATE in [`bridge/xref/VALIDATE_REGISTER.md`](bridge/xref/VALIDATE_REGISTER.md) against your own configuration and open a pull request. See [CONTRIBUTING.md](CONTRIBUTING.md).

HELIX is an open, philanthropic effort. It isn't a product, a consultancy, or owned by any vendor. It belongs to the higher education community.

*HELIX v0.8.1, September 2026 · Licensed under Apache 2.0*
