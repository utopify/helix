# HELIX Core Examples

Post-migration use cases that demonstrate what's possible when institutional data is in HELIX shape. These aren't abstract schema exercises. They're real scenarios with real queries, real data samples, and real outcomes.

## Examples

| # | Example | Domain | What It Shows |
|---|---------|--------|---------------|
| 01 | [Advancement & Donor Engagement](01-advancement-donor-engagement.md) | Advancement | AI-accelerated thank-you notes, donor identification queries, campus events as engagement levers, pre-event briefings |
| 02 | [Chart of Accounts XREF: PeopleSoft → Workday](02-chart-of-accounts-xref-peoplesoft-workday.md) | Finance | Full cross-reference table mapping PeopleSoft chartfields to Workday worktags through HELIX, year-end financial report in both systems |
| 03 | [Enrollment Analytics, Marketing & Summer Melt](03-enrollment-analytics-marketing-melt.md) | Enrollment | Marketing channel ROI, summer melt prediction model, student readiness profiles, intervention playbooks |

## Why These Examples Matter

HELIX Bridge mappings tell you *how to get data in*. These examples tell you *what you can do once it's there*.

The common thread: each example involves data that traditionally lives in 3-5 separate systems. When that data lands in a single HELIX-shaped lake, queries that used to be multi-week projects become afternoon work.

## HELIX Resources Used Across Examples

| Resource | Example 1 | Example 2 | Example 3 |
|----------|:---------:|:---------:|:---------:|
| Person | ✅ | | ✅ |
| Student | | | ✅ |
| Constituent | ✅ | | |
| Gift | ✅ | | |
| Campaign | ✅ | | |
| EngagementActivity | ✅ | | ✅ |
| Enrollment | | | ✅ |
| AdmissionApplication | | | ✅ |
| FinAidAward | | | ✅ |
| Hold | | | ✅ |
| TransferCredit | | | ✅ |
| AcademicPeriod | | | ✅ |
| Degree | ✅ | | |
| GLTransaction (planned) | | ✅ | |
| Institution | | ✅ | |
| AcademicOrg | | ✅ | |
