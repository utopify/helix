# HELIX Post-Migration Example: Advancement & Donor Engagement

> How a university advancement team uses HELIX-shaped data to accelerate thank-you notes, identify and curate donors, create targeted outreach, and turn campus events into donor engagement opportunities.

---

## The Scenario

**State University** has migrated its advancement data from Blackbaud Raiser's Edge into a HELIX-conformant data lake. Their Constituent, Gift, Campaign, and EngagementActivity resources are now in Iceberg tables, queryable by any tool in their ecosystem.

The VP for Advancement wants three things:
1. **Thank-you notes out in 48 hours**, not 2 weeks
2. **Better donor identification** — who's ready to be asked, who's at risk of lapsing, who's been under the radar
3. **Campus events as engagement levers** — every homecoming, lecture, and groundbreaking is a chance to deepen relationships

Here's how HELIX-shaped data makes each of those possible.

---

## Use Case 1: AI-Accelerated Thank-You Notes

### The Problem
Thank-you letters are the #1 stewardship best practice, but most advancement shops take 7-14 days to get them out. The data lives in one system, the letter templates in another, and personalization requires manual lookup.

### The HELIX Solution
With HELIX-shaped data, an AI agent can generate personalized thank-you drafts the moment a gift is recorded.

### Data Flow
```
Gift resource (new record)
    ↓ triggers event
Constituent resource (donor context)
    + Gift.designation (where the money goes)
    + Constituent.lifetime_giving (total relationship)
    + Constituent.consecutive_giving_years (loyalty)
    + Constituent.affinity_groups (connection points)
    + EngagementActivity (recent interactions)
    ↓
AI Agent drafts personalized thank-you
    ↓
Development officer reviews and sends within 48 hours
```

### Sample HELIX Data (Gift + Constituent)

**Gift Record:**
```json
{
  "helix_id": "a1b2c3d4-5678-90ab-cdef-111111111111",
  "constituent_ref": "f9e8d7c6-5432-10ab-cdef-222222222222",
  "gift_type": "outright_gift",
  "amount": 5000.00,
  "gift_date": "2026-08-28",
  "designation": {
    "fund_code": "ENG-SCHOLAR-01",
    "fund_name": "College of Engineering Scholarship Fund",
    "fund_type": "scholarship",
    "college_school": "College of Engineering"
  },
  "gift_source": "online",
  "payment_method": "credit_card",
  "appeal_code": "FY27-ENGR-ANNUAL",
  "acknowledgment_status": "pending",
  "meta": {
    "source_system": "raiser_edge",
    "classification": "confidential"
  }
}
```

**Constituent Record (the donor):**
```json
{
  "helix_id": "f9e8d7c6-5432-10ab-cdef-222222222222",
  "constituent_type": "alumnus",
  "status": "active",
  "class_year": "2008",
  "degrees": [
    {"degree_type": "BS", "major": "Mechanical Engineering", "year": "2008"}
  ],
  "affinity_groups": ["College of Engineering", "Tau Beta Pi", "Alumni Association"],
  "lifetime_giving": 22500.00,
  "last_gift_date": "2025-09-15",
  "last_gift_amount": 2500.00,
  "consecutive_giving_years": 6,
  "donor_segment": "upgrading",
  "engagement_score": 78,
  "giving_capacity": {
    "estimated_capacity": 250000,
    "capacity_rating": "major",
    "screening_date": "2026-03-01"
  },
  "employer": "SpaceX",
  "job_title": "Senior Propulsion Engineer",
  "assigned_officer": "Jennifer Walsh",
  "prospect_stage": "cultivation"
}
```

### What the AI Agent Can Generate

Using just these two HELIX resources, the agent drafts:

> Dear Sarah,
>
> Thank you for your generous $5,000 gift to the College of Engineering Scholarship Fund. Your support means a great deal, especially as someone who walked the same halls and labs as the students you're helping today.
>
> This marks your sixth consecutive year of giving to State University, and your total support has now reached $22,500. Your decision to increase your gift this year sends a powerful signal to our engineering students about the value of giving back.
>
> Tau Beta Pi would be proud.
>
> We'd love to share more about the students your scholarship is supporting. Jennifer Walsh from our development team will reach out to schedule a quick call at your convenience.
>
> With gratitude,
> Dean Robert Chen
> College of Engineering

**What made this possible:** The HELIX schema gave the agent everything in one query: giving history, affinity groups, loyalty streak, upgrade pattern, capacity rating, and the officer relationship. No system-hopping, no manual lookup.

---

## Use Case 2: Donor Identification & Curation

### The Queries HELIX Enables

**Find alumni with major gift capacity who haven't been assigned an officer:**
```sql
SELECT c.helix_id, c.class_year, c.employer, c.job_title,
       c.lifetime_giving, c.giving_capacity.estimated_capacity,
       c.giving_capacity.capacity_rating, c.engagement_score
FROM constituent c
WHERE c.constituent_type = 'alumnus'
  AND c.giving_capacity.capacity_rating IN ('principal', 'major')
  AND c.assigned_officer IS NULL
  AND c.status = 'active'
  AND c.prospect_stage = 'none'
ORDER BY c.giving_capacity.estimated_capacity DESC
LIMIT 50
```
*This single query against HELIX-shaped data would require joining 4-6 tables in Raiser's Edge or Advance.*

**Find loyal donors at risk of lapsing:**
```sql
SELECT c.helix_id, c.class_year, c.lifetime_giving,
       c.consecutive_giving_years, c.last_gift_date, c.last_gift_amount,
       c.engagement_score
FROM constituent c
WHERE c.donor_segment = 'loyal'
  AND c.consecutive_giving_years >= 5
  AND c.last_gift_date < '2026-01-01'
  AND c.status = 'active'
ORDER BY c.consecutive_giving_years DESC
```
*These are your highest-risk stewardship targets: donors who've given 5+ years straight but haven't given yet this fiscal year.*

**Find non-donor alumni who are highly engaged:**
```sql
SELECT c.helix_id, c.class_year, c.employer, c.engagement_score,
       COUNT(ea.helix_id) as activities_12mo
FROM constituent c
JOIN engagement_activity ea ON ea.constituent_ref = c.helix_id
WHERE c.donor_segment = 'non_donor'
  AND c.constituent_type = 'alumnus'
  AND ea.activity_date >= '2025-09-01'
  AND c.engagement_score >= 60
GROUP BY c.helix_id, c.class_year, c.employer, c.engagement_score
HAVING COUNT(ea.helix_id) >= 3
ORDER BY c.engagement_score DESC
```
*These are your best first-time donor prospects: they're showing up, opening emails, and attending events, but haven't been asked yet.*

---

## Use Case 3: Campus Events as Donor Engagement Opportunities

### The Data Model

Every campus event feeds the EngagementActivity resource. An AI agent monitors upcoming events and matches them against constituent profiles.

**Sample EngagementActivity (Event Registration):**
```json
{
  "helix_id": "event-reg-001",
  "constituent_ref": "f9e8d7c6-5432-10ab-cdef-222222222222",
  "activity_type": "event_registration",
  "activity_date": "2026-09-15T09:00:00",
  "event_name": "Engineering Innovation Showcase 2026",
  "event_type": "lecture",
  "channel": "in_person",
  "location": "Scott Engineering Center, Room 200",
  "engagement_points": 15,
  "notes": "Registered via alumni portal. Selected 'Propulsion Systems' session."
}
```

### What an Advancement Agent Can Do

**Pre-Event Briefing (automated, day before):**
For each upcoming campus event, the agent queries:
1. Which registered attendees are constituents?
2. For each constituent: what's their giving history, capacity, segment, and prospect stage?
3. Who among them is in active cultivation or overdue for a stewardship touch?

The agent generates a briefing for the development officer:

> **Engineering Innovation Showcase — Donor Briefing (Sep 15)**
>
> **High-Priority Attendees:**
>
> 🔴 **Sarah Chen '08** — Upgrading donor, $22.5K lifetime, major capacity ($250K), in cultivation with Jennifer Walsh. Registered for Propulsion Systems session (aligns with her SpaceX role). *Recommend: Jennifer attends this session and sits with Sarah. Perfect cultivation touch.*
>
> 🟡 **Michael Torres '15** — Loyal donor (4 years), $8.2K lifetime, last gift $1,500. No officer assigned. Engagement score 65. *Recommend: Introduce to Jennifer. Potential upgrade to leadership giving.*
>
> 🟢 **Amanda Park '20** — Non-donor, high engagement (score 72, 5 activities in 12 months). Mechanical engineering alumna, now at Boeing. *Recommend: Young alumni outreach. First-time donor prospect for engineering annual fund.*
>
> **Total registered constituents:** 23
> **With giving history:** 14
> **Major gift prospects:** 3
> **Unassigned with capacity:** 5

### Post-Event Follow-Up (automated, day after)

The agent generates personalized follow-up emails for each attendee based on what happened:

- **For donors:** Thank-you for attending + "the students whose scholarships you support were presenting in the poster session"
- **For prospects in cultivation:** "Great to see you at the showcase. Would love to continue our conversation about your vision for engineering at State"
- **For non-donor engaged alumni:** "Glad you joined us! Here's what the College of Engineering has planned for next year. Many of these programs are donor-supported..."

---

## What Makes This Different From Pre-HELIX

| Before HELIX | After HELIX |
|-------------|------------|
| Donor data in Raiser's Edge, event data in Slate, engagement in Mailchimp, alumni in a separate database | All in one HELIX-shaped lake: Constituent + Gift + EngagementActivity + Campaign |
| Thank-you notes require exporting CSV, mail merging, manual personalization | AI agent generates personalized drafts instantly from live HELIX data |
| Event attendee lists never reach the development team before the event | Pre-event briefings are auto-generated with giving history and prospect intelligence |
| Donor identification is a quarterly project by the research team | Real-time queries against HELIX-shaped data: anyone with SQL or a dashboard can find prospects |
| "Summer melt" in donor relationships goes undetected | Lapsing loyal donors are flagged automatically with engagement-score trends |

---

## HELIX Resources Used

| Resource | Role in This Example |
|----------|---------------------|
| `Constituent` | Donor profiles, capacity, segment, officer assignment |
| `Gift` | Transaction history, designation, acknowledgment tracking |
| `Campaign` | Campaign counting, progress, priority alignment |
| `EngagementActivity` | Event attendance, email engagement, meeting tracking |
| `Person` | Base identity, contact info, communication preferences |
| `Degree` | Alumni affiliation, class year, major (for affinity targeting) |

---

*This example demonstrates HELIX Core resources from the Advancement domain (v0.1). The queries shown use standard SQL against Iceberg tables shaped to HELIX schemas.*
