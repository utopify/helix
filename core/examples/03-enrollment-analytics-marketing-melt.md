# HELIX Post-Migration Example: Enrollment Analytics, Marketing Optimization & Summer Melt

> How an enrollment management team uses HELIX-shaped data to optimize marketing spend, reduce summer melt, and anticipate student needs before fall semester begins.

---

## The Scenario

**Metro State University** has migrated its CRM (Slate), SIS (PeopleSoft CS), and financial aid system into a HELIX-conformant data lake. For the first time, admissions funnel data, enrollment data, financial aid awards, demographic data, and marketing touchpoints are all in one queryable shape.

The VP for Enrollment Management has three objectives for Fall 2027:
1. **Optimize marketing spend** — stop wasting money on channels that don't convert
2. **Reduce summer melt** — their melt rate is 18%, costing them ~500 students and $7.5M in net tuition revenue annually
3. **Anticipate student needs** — identify students who are likely to struggle before they arrive, so support is waiting

---

## The Enrollment Funnel in HELIX

HELIX tracks the full funnel through connected resources:

```
Suspect (purchased names)
    ↓  Marketing touchpoints (EngagementActivity)
Inquiry (RFI, campus visit, test score send)
    ↓  AdmissionApplication created
Applicant (application submitted)
    ↓  Application reviewed, decision made
Admitted (offer extended)
    ↓  Enrollment deposit paid
Confirmed (intent to enroll)
    ↓  Orientation, registration, financial aid finalized
    ↓  ⚠️ SUMMER MELT ZONE ⚠️
Enrolled (census day — officially counted)
```

Each stage maps to HELIX resources:

| Funnel Stage | HELIX Resources |
|-------------|----------------|
| Suspect → Inquiry | `EngagementActivity` (marketing touches), `Person` |
| Inquiry → Applicant | `AdmissionApplication` (submitted) |
| Applicant → Admitted | `AdmissionApplication` (status: admitted) |
| Admitted → Confirmed | `AdmissionApplication` (enrollment_intent: confirmed, deposit_paid: true) |
| Confirmed → Enrolled | `Student` (status: enrolled), `Enrollment` (courses registered) |
| Melt | `AdmissionApplication` (confirmed) + no matching `Enrollment` at census |

---

## Use Case 1: Marketing Spend Optimization

### The Question
"We spend $2.8M annually on student recruitment marketing across 14 channels. Which channels actually produce enrolled students, and what's the cost-per-enrolled-student for each?"

### The Query

```sql
-- Marketing channel ROI: cost per enrolled student by source
WITH funnel AS (
    SELECT
        aa.application_source AS channel,
        COUNT(DISTINCT aa.helix_id) AS applications,
        COUNT(DISTINCT CASE WHEN aa.application_status = 'admitted' THEN aa.helix_id END) AS admits,
        COUNT(DISTINCT CASE WHEN aa.enrollment_intent = 'confirmed' THEN aa.helix_id END) AS confirms,
        COUNT(DISTINCT CASE WHEN s.status = 'enrolled' THEN s.helix_id END) AS enrolled
    FROM admission_application aa
    LEFT JOIN student s ON aa.student_ref = s.helix_id AND s.status = 'enrolled'
    WHERE aa.admit_period_ref = 'fall-2026-period-id'
    GROUP BY aa.application_source
)
SELECT
    f.channel,
    f.applications,
    f.admits,
    f.confirms,
    f.enrolled,
    ROUND(f.admits::decimal / NULLIF(f.applications, 0) * 100, 1) AS admit_rate,
    ROUND(f.enrolled::decimal / NULLIF(f.confirms, 0) * 100, 1) AS yield_rate,
    ROUND(f.enrolled::decimal / NULLIF(f.applications, 0) * 100, 1) AS app_to_enroll_rate,
    b.budget_amount,
    ROUND(b.budget_amount / NULLIF(f.enrolled, 0), 0) AS cost_per_enrolled
FROM funnel f
LEFT JOIN marketing_budget b ON f.channel = b.channel AND b.fiscal_year = '2026'
ORDER BY cost_per_enrolled ASC
```

### Sample Output

| Channel | Apps | Admits | Confirms | Enrolled | Admit % | Yield % | Cost/Enrolled |
|---------|------|--------|----------|----------|---------|---------|---------------|
| Campus Visit | 1,200 | 1,080 | 920 | 875 | 90% | 95% | $85 |
| High School Counselor | 2,800 | 2,100 | 1,450 | 1,290 | 75% | 89% | $120 |
| Alumni Referral | 380 | 340 | 290 | 268 | 89% | 92% | $148 |
| Organic Search/Website | 4,200 | 2,940 | 1,680 | 1,428 | 70% | 85% | $175 |
| Social Media (Instagram) | 3,100 | 1,860 | 930 | 698 | 60% | 75% | $429 |
| College Board Search | 8,500 | 3,400 | 1,360 | 952 | 40% | 70% | $525 |
| Radio/TV | 600 | 240 | 96 | 67 | 40% | 70% | $2,985 |
| Print Mail | 2,200 | 660 | 264 | 172 | 30% | 65% | $1,744 |

**Insight:** Campus visits produce the highest-quality enrollees at $85/student. Radio/TV and print mail cost 20-35x more per enrolled student. Reallocating $400K from print/radio to campus visit programming and digital could yield 1,500+ additional net enrollments.

### The Agent Action

An enrollment analytics agent can generate a monthly dashboard that:
- Tracks each channel's funnel conversion rates in real time
- Flags channels where cost-per-enrolled exceeds the institutional threshold
- Recommends budget reallocation based on mid-cycle performance
- Projects final enrollment by channel based on current conversion trends

---

## Use Case 2: Summer Melt Prediction & Intervention

### The Problem
Summer melt is the gap between students who confirm (pay deposit) and students who actually show up. At Metro State, 18% of confirmed students melt. That's ~500 students and ~$7.5M in lost net tuition revenue.

### The Melt Risk Model

Using HELIX-shaped data, the enrollment team builds a predictive model that scores each confirmed student's melt risk based on:

```sql
-- Summer melt risk factors, all from HELIX resources
SELECT
    s.helix_id,
    s.name,
    aa.application_type,
    aa.residency_at_application,
    aa.first_generation_flag,
    fa.total_aid_offered,
    fa.unmet_need,
    fa.efc,
    e.courses_registered,
    e.orientation_complete,
    h.has_active_hold,
    h.hold_types,
    ea.engagement_score_summer,
    ea.last_touchpoint_date,
    days_since_last_touch
FROM student s
JOIN admission_application aa ON s.helix_id = aa.student_ref
LEFT JOIN (
    SELECT student_ref,
           SUM(amount_offered) as total_aid_offered,
           MAX(unmet_need) as unmet_need,
           MAX(efc) as efc
    FROM fin_aid_award
    WHERE academic_period_ref = 'fall-2027-period-id'
    GROUP BY student_ref
) fa ON s.helix_id = fa.student_ref
LEFT JOIN (
    SELECT student_ref,
           COUNT(*) as courses_registered,
           MAX(CASE WHEN activity_type = 'orientation' THEN true ELSE false END) as orientation_complete
    FROM enrollment
    WHERE academic_period_ref = 'fall-2027-period-id'
    GROUP BY student_ref
) e ON s.helix_id = e.student_ref
LEFT JOIN (
    SELECT student_ref,
           COUNT(*) > 0 as has_active_hold,
           ARRAY_AGG(hold_type) as hold_types
    FROM hold
    WHERE hold_status = 'active'
    GROUP BY student_ref
) h ON s.helix_id = h.student_ref
LEFT JOIN (
    SELECT constituent_ref,
           SUM(engagement_points) as engagement_score_summer,
           MAX(activity_date) as last_touchpoint_date,
           DATEDIFF('day', MAX(activity_date), CURRENT_DATE) as days_since_last_touch
    FROM engagement_activity
    WHERE activity_date >= '2027-05-01'
    GROUP BY constituent_ref
) ea ON s.person_ref = ea.constituent_ref
WHERE aa.enrollment_intent = 'confirmed'
  AND aa.admit_period_ref = 'fall-2027-period-id'
  AND s.status != 'enrolled'
```

### Risk Scoring Model

| Factor | High Risk Signal | Points |
|--------|-----------------|--------|
| **Financial gap** | Unmet need > $5,000 | +25 |
| **No courses registered** | 0 courses by July 15 | +20 |
| **No orientation** | Hasn't completed orientation by Aug 1 | +15 |
| **Active holds** | Financial or admissions hold active | +15 |
| **No summer engagement** | Zero touchpoints since May 1 | +15 |
| **First-generation** | First-gen flag = true | +10 |
| **Distance** | Out-of-state or international | +10 |
| **Late confirmation** | Deposited after May 15 | +10 |
| **No financial aid** | No aid package assembled | +20 |
| **Low EFC, high sticker** | EFC < $5K, unmet need > $10K | +30 |

Students scoring 50+ are flagged for intervention.

### Intervention Playbook (driven by the data)

| Risk Score | Risk Level | Automated Action | Human Action |
|-----------|-----------|-----------------|-------------|
| 70+ | Critical | Daily nudge texts + email with specific next steps | Personal phone call from advisor within 48 hours |
| 50-69 | High | Bi-weekly text reminders, orientation booking link | Peer mentor outreach, virtual Q&A invitation |
| 30-49 | Medium | Weekly emails with "getting ready" content | Group webinar: "What to Expect Your First Week" |
| 0-29 | Low | Standard summer communications | No additional action needed |

### Specific Interventions by Risk Factor

**Unmet need > $5K:**
```
Trigger: FinAidAward.unmet_need > 5000 AND AdmissionApplication.enrollment_intent = 'confirmed'
Action: Financial aid office outreach within 72 hours
        "We noticed your aid package may not cover everything. Let's talk about
         additional options — work-study, emergency grants, or payment plans."
Content: Link to net price calculator, work-study job board, emergency aid application
```

**No courses registered by July 15:**
```
Trigger: No Enrollment records for fall term AND date > July 15
Action: Text message from assigned advisor
        "Hey [First Name]! We're getting excited for fall. I noticed you haven't
         registered for classes yet. Need help picking courses? I'm here."
Content: Link to advising appointment scheduler, first-year course guide PDF
```

**No orientation completed by August 1:**
```
Trigger: No EngagementActivity with type='orientation' AND date > August 1
Action: Phone call from orientation office
        "We want to make sure you're all set for fall. Orientation is your chance
         to meet your advisor, register, and find your people."
Content: Remaining orientation dates, virtual orientation option
```

---

## Use Case 3: Anticipating Student Needs Before Fall

### Pre-Arrival Dashboard

Using HELIX data, an agent generates a per-student "readiness profile" for incoming freshmen:

```
STUDENT READINESS PROFILE — Jaylen Williams (Fall 2027)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Academic Preparation
  ✅ Admitted: First-time freshman, in-state
  ✅ HS GPA: 3.2 (meets admission threshold)
  ⚠️  Math placement: Pre-Calculus (below Calculus readiness)
  ✅ 6 AP credits awarded (English Comp, US History)
  📋 Recommended: MATH 1050 (College Algebra) before MATH 1210

Financial Readiness
  ✅ Aid package: $18,200 (Pell $7,395 + State $3,000 + Institutional $4,805 + Sub Loan $3,000)
  ⚠️  Unmet need: $4,300 (after aid, before work-study)
  📋 Recommended: Work-study application (eligible), emergency fund awareness

Registration Status
  ✅ Orientation: Completed June 22
  ✅ Courses registered: 15 credit hours (5 courses)
  ✅ No active holds

Support Flags
  🔴 First-generation student
  🔴 Pell-eligible (EFC: $2,100)
  📋 Recommended: First-gen mentoring program, TRIO/SSS outreach,
     financial literacy workshop

Housing
  ✅ Housing assignment: Lincoln Hall, Room 214
  ✅ Meal plan: Standard 15

Engagement
  ✅ Attended 2 summer events (admitted student day, dept mixer)
  ✅ Opened 8 of 12 summer emails
  📋 Last touchpoint: August 3 (email click)
```

### Aggregate Readiness Report

```
INCOMING CLASS READINESS — Fall 2027
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Total Confirmed:              2,840
  Fully Ready (score 0-29):   1,704 (60%)
  Medium Risk (score 30-49):    568 (20%)
  High Risk (score 50-69):      398 (14%)
  Critical Risk (score 70+):    170 (6%)

Top Risk Factors (% of high+critical):
  Unmet need > $5K:             312 students (55%)
  No courses registered:        187 students (33%)
  No orientation:               142 students (25%)
  Active financial hold:        128 students (23%)
  Zero summer engagement:       201 students (35%)

Projected Melt (based on model):
  Without intervention:         512 students (18.0%)
  With targeted intervention:   ~285 students (10.0%)
  Projected students saved:     ~227
  Projected revenue preserved:  ~$3.4M
```

---

## What Makes This Different

| Before HELIX | After HELIX |
|-------------|------------|
| Funnel data in Slate, enrollment in PeopleSoft, aid in a third system | Single HELIX-shaped lake: funnel stage, enrollment, aid, engagement all connected |
| Marketing ROI calculated manually once a year in a spreadsheet | Real-time channel-level ROI with cost-per-enrolled-student |
| Summer melt discovered at census (too late) | Predictive risk model flags at-risk students in June, interventions start immediately |
| Student needs identified week 3 of classes (reactive) | Pre-arrival readiness profiles generated in July (proactive) |
| First-gen/Pell students fall through cracks | Risk model weights first-gen, EFC, and financial gap — automatically routed to support programs |

---

## HELIX Resources Used

| Resource | Role in This Example |
|----------|---------------------|
| `AdmissionApplication` | Funnel tracking, channel attribution, deposit/intent |
| `Student` | Enrollment status, demographics, first-gen flag |
| `Enrollment` | Course registration, credit hours (registration status) |
| `FinAidAward` | Aid package, unmet need, EFC/SAI, SAP |
| `Hold` | Active holds preventing registration |
| `EngagementActivity` | Marketing touchpoints, orientation, summer engagement |
| `TransferCredit` | AP/IB/transfer credits for placement |
| `AcademicPeriod` | Term context for all time-bound queries |
| `Person` | Contact information for outreach |

---

*This example demonstrates how HELIX-shaped data enables enrollment management analytics that span the full student lifecycle, from first marketing touch through census day. The queries and models shown use standard SQL against Iceberg tables.*
