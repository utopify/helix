# HELIX Agents

7 downloadable AI assistant templates (v0.8.1). Compatible with ChatGPT, Gemini, Claude, Grok, Amazon Q, and Bedrock.

**Start here**

Say **"help me start"** to the Migration Companion and it walks you through [START_HERE](../START_HERE.md) step by step.

- **helix-migration-companion.json** — The unified entry point. Interactive menu guiding users through migrations, governance, analytics, and compliance, and routing to the right specialist.

**PeopleSoft to Workday (the cornerstone path)**
- **ps-to-workday-hcm-agent.json** — PeopleSoft HCM to Workday HCM: JOB rows to business processes, EMPLID to Universal ID, job profiles, comp, payroll parallel, benefits, absence. *New in v0.6.0*
- **ps-to-workday-fin-agent.json** — PeopleSoft FSCM to Workday Financial Management: chartfields to worktags, fund accounting, GLBA
- **ps-to-workday-sis-agent.json** — PeopleSoft Campus Solutions to Workday Student: identity, program of study, academic history, FERPA carryover. *New in v0.6.0*

**Other specialists**
- **banner-to-lakehouse-agent.json** — Banner to data lake migration
- **enrollment-analytics-agent.json** — Enrollment funnel, melt prediction, marketing ROI
- **advancement-donor-agent.json** — Donor engagement, prospect pipeline, stewardship

The three PeopleSoft to Workday agents share one knowledge set: `docs/ps-to-workday-migration.md`, `bridge/xref/ps-to-workday-{hr,fin,sis}/`, `templates/ps-to-workday/`, and the PeopleSoft and Workday bridges.

Setup: Copy the `system_prompt` field into your platform's instructions. Upload HELIX files as knowledge.
