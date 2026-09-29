# Start Here: How to Press GO on HELIX

HELIX is big. You don't need most of it on day one. This page is the whole starting line: six steps, what to do in each one, which file to use, and how you know you're done.

If you only remember one thing: **start with one small slice of data, prove it matches numbers people already trust, then grow.** Everything else in this repo supports that loop.

---

## The six steps

```
  1. Describe      2. Pick your     3. Pick one      4. Land it       5. Map it and    6. Own it
     what you  -->    goal      -->    slice     -->    (bronze)  -->    prove it  -->    and grow
     have                                                               (silver)
```

| Step | What you do | Use this | You're done when |
|------|-------------|----------|------------------|
| **1. Describe what you have** | Fill in the institution profile: every source database, what module lives on it, versions, where copies and reporting replicas are, and who owns each one. | [`templates/intake/institution-profile.md`](templates/intake/institution-profile.md) | The profile is filled in and a second person has checked it. |
| **2. Pick your goal** | Choose one path. Most schools start with **A** because it pays off in weeks and makes a later ERP move easier. | See [Pick your goal](#step-2-pick-your-goal) below | You've written your goal in the profile. |
| **3. Pick one small slice** | Choose one subject area and one time window. Not all 64 resources. | See [Good first slices](#step-3-good-first-slices) below | The slice, its source tables, and its "trusted number" are written down. |
| **4. Land it** | Extract that slice from a reporting copy (never production) into a raw bronze area. Keep native keys and codes exactly as they are. | PeopleSoft: [`bridge/peoplesoft/PS_EXTRACTION.md`](bridge/peoplesoft/PS_EXTRACTION.md). Banner: [`bridge/banner/ONPREM_EXTRACTION.md`](bridge/banner/ONPREM_EXTRACTION.md) | Raw rows are in bronze and the row counts match the source. |
| **5. Map it and prove it** | Map bronze to HELIX Core with the bridge and the dbt starter, validate the shape, then reconcile against the trusted number. | [`bridge/`](bridge/), [`templates/dbt/`](templates/dbt/), [`tools/validate.py`](tools/validate.py), [`templates/reconciliation/`](templates/reconciliation/) | HELIX matches the number your registrar, controller, or HR director already signs off on. |
| **6. Own it and grow** | Name one data steward for the slice, apply the access rules for its resources, then pick the next slice. | [`docs/cdo-quick-start.md`](docs/cdo-quick-start.md), [`govern/access-control-matrix.json`](govern/access-control-matrix.json) (who can see what, for every resource) | A named person owns the slice and the next slice is chosen. |

That's it. Repeat steps 3 through 6 until you've covered what you need.

---

## Step 2: Pick your goal

| Goal | Pick this if... | Your next doc |
|------|-----------------|---------------|
| **A. Build a lakehouse on HELIX** | You're keeping your ERP for now but want trustworthy reporting, analytics, or AI on top of it. | [`docs/lakehouse-architecture-guide.md`](docs/lakehouse-architecture-guide.md) |
| **B. Migrate PeopleSoft to Workday** | A Workday contract is signed or close. | [`docs/ps-to-workday-migration.md`](docs/ps-to-workday-migration.md) |
| **C. Migrate Banner on-prem to Banner SaaS** | You're moving to Ellucian Platform. | [Adventure guide, Chapter 8](docs/migration-adventure-guide.md#chapter-8-banner-on-prem-to-banner-saas) |
| **D. Stand up data governance** | The first problem is ownership and definitions, not pipelines. | [`docs/cdo-quick-start.md`](docs/cdo-quick-start.md) |

A and B aren't competing choices. A lakehouse built on HELIX is the staging ground for a Workday migration: the extraction, mapping, and reconciliation work you do for A is the same work B needs.

---

## Step 3: Good first slices

Pick one. Each has a number somebody on campus already trusts, which is how you'll prove HELIX is right.

| Slice | HELIX resources | Trusted number to match |
|-------|-----------------|-------------------------|
| **Student census, one term** | Person, Student, AcademicPeriod, StudentProgram, Enrollment | Official census headcount and credit hours for that term |
| **GL, one fiscal year** | GLTransaction, Fund, FinancialOrg | Year-end trial balance, to the penny |
| **Active workforce, one date** | Person, Employee, Position, JobClassification | HR headcount as of a pay period end |
| **Financial aid, one aid year** | Person, Student, FinAidAward, Disbursement | Total disbursed by fund from the FISAP or COD reconciliation |

The student census slice lines up exactly with the dbt starter, which already has bronze sources for person, student, academic period, student program, and enrollment.

---

## A worked example: PeopleSoft on six Oracle databases plus a warehouse

Say you're a PeopleSoft school. Campus Solutions, HCM, and Financials each live on their own Oracle database, each has a reporting copy, and there's an older data warehouse that finance and IR both use. Here's what GO looks like.

**Week 1: Describe what you have.** You fill in the profile. It surfaces things people forget: which databases are production vs reporting copies, which PeopleTools release you're on, whether the warehouse is fed nightly or monthly, and that EMPLID is the same person across CS and HCM. That last one matters a lot later.

**Week 1: Pick your goal.** Leadership wants better enrollment reporting now and is scoping Workday for later. You pick **A, build a lakehouse**, knowing it sets up B.

**Week 2: Pick one slice.** Fall census. Five resources, one term, and a headcount number the registrar publishes every year.

**Weeks 2 to 4: Land it.** You read from the Campus Solutions *reporting copy*, never the production database, following `PS_EXTRACTION.md`. You pull the current and effective-dated rows for about a dozen PS records into bronze, keeping EMPLID, STRM, ACAD_CAREER, and the raw codes untouched. The old warehouse isn't your source of truth, but it's a useful second opinion for step 5.

**Weeks 4 to 6: Map it and prove it.** The CS bridge files tell you which PS fields become which HELIX fields. The dbt starter turns bronze into HELIX silver. `validate.py` confirms the shape. Then `enrollment_headcount_reconciliation.sql` compares HELIX to the registrar's census number. The first run won't match. That's normal. The differences teach you your institution's real rules (who counts as enrolled, how cross-listed sections are handled), and you write those rules down.

**Week 6 onward: Own it and grow.** The registrar becomes data steward for the student slice, FERPA flags are applied, and you pick slice two, probably the GL for one fiscal year out of the FSCM database.

These weeks are illustrative, not a promise. The point is the shape: small, proven, owned, then bigger.

---

## If you're working with an AI assistant

Load [`agents/helix-migration-companion.json`](agents/helix-migration-companion.json) into ChatGPT, Claude, Gemini, Amazon Q, or Bedrock, upload this repo as knowledge, and say "help me start." It walks you through these same six steps and hands you off to a specialist agent when you need one.

---

## Common first-week mistakes

- **Trying to map everything.** Sixty-four resources is the destination, not the first sprint.
- **Extracting from production.** Always use a reporting copy, standby, or replica.
- **Cleaning data in bronze.** Bronze keeps the source exactly as it is. Cleanup happens on the way to silver, where you can see and explain it.
- **Skipping the trusted number.** If you can't say which official number your slice should match, you can't prove it's right.
- **No owner.** A slice with no data steward drifts back into "whose number is correct?"

---

When you want the full inventory of what's in the repo, see [`docs/helix-reference.md`](docs/helix-reference.md).

*HELIX v0.8.1, September 2026*
