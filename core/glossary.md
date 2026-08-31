# HELIX Glossary

### A Comprehensive Taxonomy of Higher Education Terms

> From the first website visit to the last alumni event. From the student financial services counter to the tenure committee vote. Every term, every role, every pipeline stage — defined once, understood everywhere.

---

## How to Use This Glossary

This glossary follows the **lifecycle of a student** from first digital touchpoint through alumni engagement, then covers the **administrative and academic infrastructure** that supports that lifecycle. Terms are organized into pipeline stages so you can read it front-to-back as a narrative or jump to a specific section.

Each term includes:
- **Definition** — what it means in higher education
- **HELIX Resource** — which HELIX Core resource captures this concept (if applicable)
- **HELIX Terminology** — which code set standardizes the values
- **Aliases** — what different ERPs or institutions call the same thing
- **Context** — why it matters for data governance, reporting, or integration

---

# Part I: The Student Lifecycle Pipeline

## Stage 1: Awareness & Recruitment

The student doesn't exist in any institutional system yet. They're a digital signal.

### Web Visitor
A person who has visited the institution's website but has not identified themselves. Known only through analytics cookies, IP geolocation, and page-view behavior. Not a record in the SIS — lives in the web analytics platform (Google Analytics, Adobe Analytics, Sitecore).

**Why it matters:** Marketing attribution. If a web visitor later becomes an inquiry, the recruitment team wants to know which pages they visited, which programs they explored, and which CTA they clicked. This requires a cross-system join between the analytics platform and the CRM.

### Suspect / Prospect (Recruitment)
A named individual in the institution's recruitment pipeline who has **not yet initiated contact**. Typically a purchased name from a list source.

**Sources:** College Board Search, ACT, NRCCUA/Encoura, Clearinghouse StudentTracker, Cappex, Niche, list purchases from testing agencies.

**HELIX Terminology:** `helix/enrollment-funnel-stage` → code: `suspect`

**Aliases:** Prospect (Slate), Suspect (Ellucian CRM Recruit), Lead (Salesforce), Name Buy (colloquial)

**Context:** These are the raw materials of the recruitment funnel. An institution may purchase 100,000-500,000 names per cycle for a class of 2,000-5,000. The conversion rate from suspect to inquiry is typically 2-8%.

### Inquiry
A person who has **self-identified** by initiating contact with the institution. The first moment of intent.

**Actions that create an inquiry:** Submitting a Request for Information (RFI) form, requesting a campus visit, sending test scores (SAT/ACT score send), attending a college fair and scanning a badge, responding to a direct mail piece, texting a keyword, chatting with an admissions bot.

**HELIX Terminology:** `helix/enrollment-funnel-stage` → code: `inquiry`
**HELIX Resource:** `EngagementActivity` (the inquiry touchpoint) + `Person` (created or matched)

**Aliases:** Inquiry (universal), Prospect (some CRMs overload this term), Lead (Salesforce)

**Key metric:** Inquiry-to-applicant conversion rate. Typically 15-35% depending on selectivity.

---

## Stage 2: Application & Admission

### Applicant
A person who has **submitted a formal application** for admission. This is the first record in the SIS/admissions module.

**Application channels:** Common Application, Coalition Application, institutional application (via Slate, Banner self-service, PeopleSoft self-service), SOPHAS (public health), AMCAS (medical), LSAC (law), graduate school direct application.

**HELIX Resource:** `AdmissionApplication` (status: `submitted`)
**HELIX Terminology:** `helix/enrollment-funnel-stage` → `applicant`; `helix/admission-status` → `submitted`

**Types of applicants by entry pathway:**

| Type | Definition | HELIX Terminology |
|------|-----------|-------------------|
| **First-Time Freshman (FTFT)** | Entering college for the first time. No prior postsecondary enrollment after high school. The IPEDS primary cohort. | `helix/student-type` → `first_time_freshman` |
| **Transfer Student** | Has earned college credits at another institution and is transferring them. | `transfer` |
| **Readmit** | Previously attended this institution, left, and is returning. | `readmit` |
| **Transient / Visiting** | Enrolled at another institution, taking courses here temporarily (usually summer). | `transient` |
| **Dual Enrollment / Concurrent** | High school student simultaneously enrolled in college courses. | `dual_enrollment` |
| **Non-Degree Seeking** | Taking courses without pursuing a formal credential. | `non_degree` |
| **Post-Baccalaureate** | Has a bachelor's degree, pursuing additional undergrad courses or a second bachelor's. | `post_baccalaureate` |
| **Graduate Applicant** | Applying to a master's or doctoral program. | `graduate` (in `application_type`) |
| **Professional Applicant** | Applying to a professional program (MD, JD, DDS, PharmD, etc.). | `professional` |
| **International Applicant** | Applying from outside the country, typically requiring a student visa (F-1, J-1). | `international` (in `application_type`) |

### Admitted Student
An applicant whose application has been **approved for enrollment**. The offer has been extended.

**HELIX Resource:** `AdmissionApplication` (status: `admitted`)
**HELIX Terminology:** `helix/admission-status` → `admitted`

**Admission decision types:**

| Decision | Definition |
|----------|-----------|
| **Full Admit** | Unconditional acceptance |
| **Conditional Admit** | Accepted with conditions (e.g., complete final transcript, maintain GPA, pass background check) |
| **Waitlisted** | Neither admitted nor denied. Offered a spot if space opens. |
| **Deferred** | Decision postponed to a later review cycle (common in Early Decision/Early Action) |
| **Denied** | Application not approved |

### Yield
The percentage of admitted students who **confirm their intent to enroll** (typically by paying an enrollment deposit). The most strategically important metric in enrollment management.

**Formula:** `Yield Rate = Confirmed Students / Admitted Students × 100`

**Typical ranges:** 10-20% at open-access institutions that admit most applicants; 40-60% at moderately selective institutions; 70-90% at highly selective institutions.

### Confirmed / Deposited Student
An admitted student who has **paid the enrollment deposit**, signaling intent to enroll. This is the institution's best forecast of incoming class size — but it's not final.

**HELIX Resource:** `AdmissionApplication` (enrollment_intent: `confirmed`, enrollment_deposit_paid: `true`)
**HELIX Terminology:** `helix/enrollment-funnel-stage` → `confirmed`

**Aliases:** Deposited (most institutions), Committed (some), Intent to Enroll (ITE), Seat Deposit Paid

---

## Stage 3: Summer Melt & Onboarding

### Summer Melt
The phenomenon where confirmed/deposited students **fail to show up** for the start of the term. They confirmed, but they "melted" away during the summer.

**HELIX Terminology:** `helix/enrollment-funnel-stage` → `melted`

**Typical melt rates:** 10-20% at open-access/broad-access institutions; 2-5% at selective institutions. Melt is strongly correlated with: unmet financial need, first-generation status, distance from campus, late deposit date, and lack of summer engagement.

**Why it matters:** If an institution confirms 3,000 students but 500 melt, that's $7.5M+ in lost net tuition revenue (at $15K average). Melt prediction and intervention (see Example 03) is one of the highest-ROI applications of HELIX-shaped data.

### Orientation
A structured onboarding program (1-3 days) where incoming students complete academic advising, course registration, placement testing, campus tours, and peer bonding. May be in-person, virtual, or hybrid.

**HELIX Resource:** `EngagementActivity` (activity_type: `event_attendance`, event_type: `orientation`)

**Data significance:** Orientation completion is a strong predictor of enrollment. Students who complete orientation are 3-5x more likely to actually enroll than those who don't.

### Placement Testing
Assessments that determine a student's readiness for college-level coursework in math, English, and sometimes foreign languages. Results determine whether a student enrolls in credit-bearing courses or developmental/remedial courses.

**Common platforms:** ALEKS (math), Accuplacer, institutional placement exams, AP/IB/CLEP credit (bypasses placement)

---

## Stage 4: Enrolled Student

### Enrolled Student (Census)
A student who has **registered for and is attending courses** as of the institution's official census date. This is the definitive enrollment count for IPEDS, state reporting, and internal KPIs.

**HELIX Resource:** `Student` (status: `enrolled`) + `Enrollment` (enrollment_status: `enrolled`)
**HELIX Terminology:** `helix/enrollment-funnel-stage` → `enrolled`; `helix/student-status` → `enrolled`

**Census date:** The date (typically 2-3 weeks into the term) when the institution takes its official enrollment snapshot. After census, drops become withdrawals (W on transcript) rather than clean drops. Financial aid is locked. IPEDS cohorts are set.

### Student Classification by Enrollment Intensity

| Classification | Definition | HELIX Code | Financial Aid Threshold |
|---------------|-----------|------------|------------------------|
| **Full-Time** | 12+ credit hours (undergrad) or 9+ (graduate) | `full_time` | Full Pell eligibility |
| **Three-Quarter Time** | 9-11 credit hours (undergrad) | `three_quarter_time` | 75% Pell |
| **Half-Time** | 6-8 credit hours (undergrad) | `half_time` | 50% Pell; minimum for loan deferment |
| **Less Than Half-Time** | 1-5 credit hours (undergrad) | `less_than_half_time` | Limited aid eligibility |

### Student Classification by Class Standing

Based on cumulative earned credit hours (thresholds vary by institution):

| Standing | Typical Hours | HELIX Code |
|----------|-------------|------------|
| **Freshman** | 0-29 | `freshman` |
| **Sophomore** | 30-59 | `sophomore` |
| **Junior** | 60-89 | `junior` |
| **Senior** | 90+ | `senior` |
| **Post-Baccalaureate** | Has bachelor's, taking more undergrad | `post_baccalaureate` |
| **Graduate 1st Year** | 1st year of master's | `graduate_1` |
| **Graduate 2nd Year** | 2nd year of master's | `graduate_2` |
| **Doctoral Candidate** | Passed qualifying exams, ABD | `doctoral_candidate` |

---

## Stage 4a: Special Student Populations

### Student Worker
A student employed by the institution in a part-time capacity. The student holds records in **both** the SIS (as a student) and the HR system (as an employee).

**Types:**

| Type | Definition | Funding | Typical Hours |
|------|-----------|---------|---------------|
| **Federal Work-Study (FWS)** | Employment funded by federal financial aid. Need-based. | Federal (75%) + Institution (25%) | 10-15 hrs/week |
| **Institutional Student Employee** | Employment funded by the institution (not financial aid). | Institutional | 10-20 hrs/week |
| **Graduate Assistant (GA)** | Graduate student with a teaching or research appointment. | Institutional / Grant | 20 hrs/week (typically half-time) |
| **Teaching Assistant (TA)** | GA specifically assigned to teach or assist in courses. | Institutional | 20 hrs/week |
| **Research Assistant (RA)** | GA specifically assigned to a research project. | Grant / Institutional | 20 hrs/week |
| **Graduate Fellow** | Graduate student on a fellowship (stipend, no work requirement). | Institutional / External | N/A (no work required) |
| **Resident Advisor (RA)** | Student employed in residential life, typically with room/board comp. | Institutional (housing) | 15-20 hrs/week |

**HELIX Resources:** `Student` + `Employee` (planned). The PIDM/EMPLID is shared.
**Data challenge:** The student-as-employee creates dual records. HELIX's shared `Person` resource with `Student` and `Employee` both referencing the same `person_ref` solves this.

### Student Athlete
A student who participates in intercollegiate athletics governed by the NCAA, NAIA, or NJCAA.

**Compliance requirements:** Eligibility verification (GPA, credit hour progress, full-time enrollment), NCAA Graduation Success Rate (GSR), Academic Progress Rate (APR), transfer eligibility.

**HELIX Resource:** `AcademicTermRecord` includes `is_athlete` flag and `sport_codes[]` array.

**Banner tables:** SGRSPRT (sport participation), linked by PIDM + term.

### International Student
A student who is not a citizen or permanent resident of the host country and typically holds a student visa.

**US visa types:** F-1 (academic), J-1 (exchange visitor), M-1 (vocational). Each has specific enrollment, employment (CPT/OPT), and reporting requirements.

**Compliance:** SEVIS (Student and Exchange Visitor Information System) reporting to DHS/ICE. Mandatory reporting of enrollment status, address changes, program changes, employment authorization, and travel.

**HELIX Resource:** `InternationalStudent` (planned) mapping covers visa, SEVIS ID, CPT/OPT, English proficiency.

### First-Generation Student
A student whose parents/guardians did **not** complete a bachelor's degree. Definition varies by institution (some define it as "neither parent attended any college").

**HELIX Resource:** `Student.first_generation_flag` and `AdmissionApplication.first_generation_flag`

**Why it matters:** First-gen students have lower retention and graduation rates nationally. Identifying them enables targeted support (mentoring, bridge programs, TRIO/SSS).

### Veteran / Military-Connected Student
A student who is a military veteran, active-duty service member, reservist/guard member, or dependent/spouse of a service member.

**HELIX Terminology:** `helix/veteran-status` → codes: `veteran`, `active_duty`, `reserve_national_guard`, `dependent_spouse`

**Benefits:** GI Bill (Chapters 30, 31, 33, 35), Tuition Assistance (TA), Yellow Ribbon Program, state veteran tuition waivers. Institutions are required to report to the VA and certify enrollment.

---

## Stage 5: Academic Progress & Retention

### Retention
Whether a student returns to the same institution for the next fall term. The foundational persistence metric.

**Formula:** `Fall-to-Fall Retention Rate = Students enrolled Fall Y+1 / First-time cohort enrolled Fall Y × 100`

**IPEDS context:** IPEDS reports retention for first-time, full-time (FTFT) degree-seeking students. This is the most-watched metric in higher ed. National average: ~65% for 4-year publics, ~80% for 4-year privates.

### Persistence
Broader than retention: whether a student is still enrolled **anywhere** (not just the same institution). Measured via National Student Clearinghouse data.

### Academic Standing
A student's academic performance classification based on GPA and/or pace of completion.

| Standing | Definition | HELIX Code (AcademicTermRecord) |
|----------|-----------|-------------------------------|
| **Good Standing** | Meeting all academic requirements | `good_standing` |
| **Dean's List** | GPA above a high threshold (typically 3.5+) for the term | `deans_list` |
| **President's List** | GPA above an even higher threshold (typically 3.8+) | `presidents_list` |
| **Academic Warning** | GPA below minimum for one term. First alert. | `warning` |
| **Academic Probation** | GPA below minimum for two+ terms. Formal action. May restrict enrollment. | `probation` |
| **Academic Suspension** | Dismissed for academic underperformance. May appeal for reinstatement. | `suspension` |
| **Academic Dismissal** | Permanently separated for academic reasons. | `dismissal` |

### Satisfactory Academic Progress (SAP)
A **federal financial aid** requirement. Students must meet three criteria to remain eligible for Title IV aid:

1. **Qualitative:** Minimum cumulative GPA (typically 2.0)
2. **Quantitative (Pace):** Complete at least 67% of attempted credit hours
3. **Maximum Timeframe:** Complete degree within 150% of the published program length

**HELIX Terminology:** `helix/sap-status` → `meeting`, `warning`, `probation`, `suspension`, `appeal_approved`
**HELIX Resource:** `FinAidAward.satisfactory_academic_progress`

### Holds / Service Indicators
Restrictions on a student's record that prevent specific actions until resolved.

**HELIX Resource:** `Hold`
**HELIX Terminology:** `helix/hold-type`

| Hold Type | What It Prevents | Common Cause |
|-----------|-----------------|-------------|
| **Registration Hold** | Course registration | Advising not completed, missing prerequisites |
| **Financial Hold** | Registration, transcripts, graduation | Unpaid balance |
| **Academic Hold** | Registration | Below-minimum GPA, SAP failure |
| **Transcript Hold** | Official transcript release | Unpaid balance, incomplete exit process |
| **Health Compliance Hold** | Registration | Missing immunization records, health insurance |
| **Disciplinary Hold** | Varies | Conduct violation under investigation or sanction |
| **Admissions Hold** | Registration | Missing final transcript, test scores |
| **FERPA Hold** | Directory info disclosure | Student-initiated privacy restriction |
| **Graduation Hold** | Degree conferral | Outstanding requirements, exit interview |

---

## Stage 6: Completion & Graduation

### Degree Conferral
The official awarding of a degree, certificate, or credential. Occurs at the end of a term after all requirements are verified by the registrar.

**HELIX Resource:** `Degree`
**HELIX Terminology:** `helix/degree-level`

**Types of credentials:**

| Credential | Duration | HELIX Code |
|-----------|----------|------------|
| **Undergraduate Certificate** | < 1 year or 1-2 years | `certificate_undergraduate` |
| **Associate Degree** (AA, AS, AAS) | 2 years | `associate` |
| **Bachelor's Degree** (BA, BS, BFA, etc.) | 4 years | `bachelors` |
| **Post-Baccalaureate Certificate** | 1 year post-bachelor's | `certificate_post_baccalaureate` |
| **Master's Degree** (MA, MS, MBA, MFA, etc.) | 1-3 years | `masters` |
| **Post-Master's Certificate** (EdS, etc.) | 1 year post-master's | `certificate_post_masters` |
| **Doctoral - Research** (PhD, EdD-research) | 4-7 years | `doctoral_research` |
| **Doctoral - Professional** (MD, JD, DDS, PharmD, DPT) | 3-4 years | `doctoral_professional` |
| **Micro-Credential / Digital Badge** | Variable | `micro_credential` |

### Graduation Rate
The percentage of a cohort that completes a degree within a specified timeframe.

**IPEDS definition:** First-time, full-time degree-seeking students who complete within 150% of normal time (6 years for a 4-year institution, 3 years for a 2-year institution).

**Formula:** `6-Year Graduation Rate = Completers within 6 years / Original FTFT cohort × 100`

### Commencement
The ceremonial event celebrating graduates. **Not the same as degree conferral.** A student may participate in commencement before their degree is officially conferred (e.g., walking in May with a pending summer course), or may be conferred without attending commencement.

### Latin Honors

| Honor | Typical GPA Threshold | HELIX Code |
|-------|----------------------|------------|
| **Summa Cum Laude** | 3.90+ | `summa_cum_laude` |
| **Magna Cum Laude** | 3.70-3.89 | `magna_cum_laude` |
| **Cum Laude** | 3.50-3.69 | `cum_laude` |
| **With Distinction** | Varies | `with_distinction` |
| **With Honors** | Honors program completion | `with_honors` |

---

## Stage 7: Alumni & Advancement

### Alumnus / Alumna / Alumni
A person who has **attended** the institution (not necessarily graduated). Definition varies: some institutions count degree holders only; others count anyone who earned credits.

**HELIX Resource:** `Constituent` (constituent_type: `alumnus`)

### Donor
Any person or entity that has made a philanthropic gift to the institution.

**HELIX Resource:** `Constituent` + `Gift`
**HELIX Terminology:** `helix/donor-segment`

See the [Donor Segment taxonomy](#donor-segments) under Part III.

### Alumni Engagement Score
A composite metric measuring an alumnus's non-financial engagement with the institution: event attendance, email opens, volunteer activities, mentoring, social media interaction, campus visits.

**HELIX Resource:** `Constituent.engagement_score`, derived from `EngagementActivity` records.

**Why it matters:** Engagement predicts giving. A non-donor alumnus with a high engagement score is a prime first-time donor prospect.

---

# Part II: Administrative & Academic Infrastructure

## Student Financial Services

### Cost of Attendance (COA)
The estimated total cost for a student to attend the institution for one year. Includes tuition, fees, room, board, books, supplies, transportation, and personal expenses. Used as the ceiling for financial aid packaging.

### Expected Family Contribution (EFC) / Student Aid Index (SAI)
A number calculated from the FAFSA that indicates how much a family can contribute toward college costs. Renamed from EFC to **Student Aid Index (SAI)** starting with the 2024-25 aid year. Under SAI, the value can be negative (indicating highest need).

**HELIX Resource:** `FinAidAward.efc`

### Unmet Need
The gap between COA and all financial resources (family contribution + all aid). The single most important number for predicting summer melt and stop-out risk.

**Formula:** `Unmet Need = COA - EFC - Total Aid`

### FERPA (Family Educational Rights and Privacy Act)
Federal law (20 U.S.C. § 1232g) that protects the privacy of student education records. Gives students the right to inspect their records, request corrections, and control disclosure of personally identifiable information.

**Key concepts:**
- **Education Record:** Any record directly related to a student and maintained by the institution.
- **Directory Information:** Information that would not generally be considered harmful if disclosed (name, email, major, enrollment status, dates of attendance, degrees, honors). Students can opt out.
- **Legitimate Educational Interest:** The standard that authorizes institutional employees to access student records — they need it to perform their job.
- **HELIX Resource:** `Hold` (hold_type: `ferpa`) tracks directory information restrictions.

### GLBA (Gramm-Leach-Bliley Act)
Federal law protecting **customer financial information**. Applies to higher ed because institutions engage in financial activities (student loans, payment plans). Covers: student account balances, financial aid details, EFC/SAI, bank account information, tax return data from FAFSA.

---

## The Registrar's Domain

### Registrar
The institutional officer responsible for the integrity of the academic record: enrollment, grades, transcripts, degree audit, degree conferral, academic calendar, classroom scheduling, and FERPA compliance.

### Transcript
The official record of a student's academic history: courses taken, grades earned, credits, GPA, degrees conferred, honors. The registrar is the custodian.

**Types:** Official (sealed, institution-verified), Unofficial (student-viewable, not for external use).

### Credit Hour
The standard unit of academic measurement. One credit hour typically represents one hour of classroom instruction plus two hours of outside work per week for a semester (the "Carnegie Unit").

### Grade Point Average (GPA)
A weighted average of grades where each course's grade value is multiplied by its credit hours.

**Types tracked in HELIX:**

| GPA Type | What It Measures | Banner Table |
|----------|-----------------|-------------|
| **Term GPA** | Performance in a single term | SHRLGPA (term-level) |
| **Cumulative GPA** | Lifetime performance at this institution | SHRLGPA (overall) |
| **Major GPA** | Performance in courses within the major | Calculated from enrollment records |
| **Transfer GPA** | GPA from prior institution(s) | SHRLGPA (transfer type) |
| **Combined GPA** | Institutional + transfer | SHRLGPA (overall including transfer) |

### Academic Calendar Types

| Type | Terms Per Year | Term Length | Common In |
|------|---------------|------------|-----------|
| **Semester** | 2 (+ summer) | ~15 weeks | Most US 4-year institutions |
| **Quarter** | 3 (+ summer) | ~10 weeks | Some research universities (Stanford, UChicago) |
| **Trimester** | 3 | ~13 weeks | Some institutions |
| **4-1-4** | 2 semesters + January term | 15 + 3 + 15 weeks | Some liberal arts colleges |
| **Modular / Block** | 8-12 per year | 3-8 weeks | Some accelerated programs |

**HELIX Terminology:** `helix/period-type`

### Transfer Credit Evaluation
The process of reviewing courses taken at other institutions and determining: (a) whether they transfer, (b) how many credits are awarded, (c) which institutional course they equate to, and (d) how they apply to degree requirements.

**HELIX Resource:** `TransferCredit`

---

## Faculty Types & Ranks

### Faculty
Employees whose primary responsibility is instruction, research, and/or service. The IPEDS HR survey categorizes faculty for federal reporting.

### Faculty Classification by Employment Type

| Type | Definition | Contract | Benefits | Governance |
|------|-----------|----------|----------|-----------|
| **Tenured Faculty** | Faculty who have been awarded tenure — a permanent appointment that can only be terminated for cause, financial exigency, or program discontinuation. | Indefinite | Full | Full voting rights in faculty senate |
| **Tenure-Track Faculty** | Faculty on a probationary period (typically 5-7 years) working toward a tenure decision. "Up or out" — if tenure is denied, the appointment ends. | Term (reappointed annually during probationary period) | Full | Typically full voting rights |
| **Non-Tenure-Track Faculty (NTT)** | Full-time faculty on renewable contracts **without** the possibility of tenure. May be teaching-focused, research-focused, or clinical. Growing category nationally. | 1-3 year renewable | Full or partial | Varies by institution |
| **Contract Faculty** | Faculty hired on a fixed-term contract for a specific period. May be full-time or part-time. Contract specifies duties, compensation, and end date. | Fixed term (1 semester to 3 years) | Varies | Limited |
| **Adjunct Faculty** | Part-time, per-course instructors. Hired to teach specific sections, typically without benefits or governance rights. The largest and most precarious faculty category. | Per course/semester | Rarely | None or advisory |
| **Visiting Faculty** | Faculty from another institution or industry on a temporary appointment (typically 1-2 years). May hold any rank. | Fixed term | Varies | Limited |
| **Emeritus Faculty** | Retired faculty who retain the honorary title and certain privileges (library access, email, office space). No active appointment. | None (honorary) | Retirement benefits only | May retain some voting rights |
| **Clinical Faculty** | Faculty whose primary role is clinical practice and clinical teaching (common in health sciences, law, business). May be NTT. | Term | Full or partial | Varies |
| **Research Faculty** | Faculty whose primary role is funded research, typically supported by external grants. May not teach. | Grant-funded term | Full or partial | Limited |
| **Instructor of Record** | The faculty member officially responsible for a course section. Assigns grades and appears on the transcript. May be any employment type. | N/A (role, not type) | N/A | N/A |

### Faculty Rank (Academic Rank)

The hierarchical position within the faculty. Used for IPEDS reporting, salary surveys, and governance.

| Rank | Typical Qualifications | HELIX Code |
|------|----------------------|------------|
| **Distinguished/Endowed Professor** | Most senior; named chair or endowed position | `distinguished_professor` |
| **Professor** (Full Professor) | Terminal degree + significant teaching, research, and service record | `professor` |
| **Associate Professor** | Terminal degree + substantial record. Typically coincides with tenure. | `associate_professor` |
| **Assistant Professor** | Terminal degree (or ABD). Entry-level tenure-track rank. | `assistant_professor` |
| **Senior Lecturer / Senior Instructor** | Master's or terminal degree. Experienced NTT teaching faculty. | `senior_lecturer` |
| **Lecturer** | Master's or terminal degree. NTT teaching-focused faculty. | `lecturer` |
| **Instructor** | Master's degree. May be tenure-track at some institutions. | `instructor` |
| **Adjunct Professor / Adjunct Instructor** | Varies. Per-course, part-time. | `adjunct` |
| **Graduate Teaching Assistant** | Enrolled graduate student. Teaching under faculty supervision. | `teaching_assistant` |

### Tenure
A system of academic employment that grants a faculty member **permanent appointment** after a probationary period (typically 5-7 years as assistant professor). Designed to protect academic freedom.

**Tenure decision process:** Application → departmental review → college/school review → provost/president review → board of trustees approval.

**Tenure status:**

| Status | Definition | HELIX Code |
|--------|-----------|------------|
| **Tenured** | Tenure has been granted | `tenured` |
| **Tenure-Track** | On the probationary path toward tenure | `tenure_track` |
| **Non-Tenure-Track** | Position does not lead to tenure | `non_tenure_track` |
| **Not Applicable** | Position type doesn't have a tenure concept (adjunct, staff, etc.) | `not_applicable` |

### Faculty Workload
Faculty effort is typically measured in one or more ways:

- **Teaching Load:** Number of courses or credit hours per semester (e.g., "3/3" = 3 courses fall + 3 courses spring; "2/2" with research expectations)
- **FTE:** Full-time equivalency (1.0 = full-time)
- **IBS (Institutional Base Salary):** For sponsored research costing, the annual salary from which effort percentages are calculated

### IPEDS Faculty Categories (for federal reporting)

| Category | Includes |
|----------|---------|
| **Full-time instructional staff** | All full-time faculty whose primary activity is instruction |
| **Full-time research staff** | Faculty primarily doing research |
| **Full-time public service staff** | Faculty primarily doing public service |
| **Part-time instructional staff** | Adjunct, part-time lecturers |
| **Graduate assistants** | TAs and RAs |

Reported by: rank, tenure status, gender, race/ethnicity, salary. HELIX's `Job Classification` mapping (banner: PTRECLS, PS: PS_JOBCODE_TBL) feeds these categories.

---

# Part III: Key Taxonomies & Segments

## Donor Segments

| Segment | Definition | HELIX Code |
|---------|-----------|------------|
| **Non-Donor** | Never made a gift | `non_donor` |
| **First-Time Donor** | First gift in current fiscal year | `first_time` |
| **Renewing Donor** | Gave last year, gave again at same level | `renewing` |
| **Upgrading Donor** | Gave last year, increased this year | `upgrading` |
| **Downgrading Donor** | Gave last year, decreased this year | `downgrading` |
| **Loyal / Consecutive Donor** | Given 3+ years in a row | `loyal` |
| **Lapsed Donor** | Previously gave, no gift in 1-2 years | `lapsed` |
| **Deep Lapsed Donor** | No gift in 3+ years | `deep_lapsed` |
| **Major Donor** | Cumulative or single gift at major threshold ($25K-$100K+) | `major` |
| **Planned Giving Donor** | Has documented a deferred gift (bequest, trust, etc.) | `planned_giving` |
| **Recaptured Donor** | Was lapsed, gave again this year | `recaptured` |

## Prospect Pipeline (Moves Management)

| Stage | Definition | HELIX Code |
|-------|-----------|------------|
| **Identification** | Prospect identified through screening or referral | `identification` |
| **Qualification** | Research and outreach to assess interest, capacity, inclination | `qualification` |
| **Cultivation** | Active relationship-building: meetings, events, campus visits | `cultivation` |
| **Solicitation** | Formal ask has been made or is imminent | `solicitation` |
| **Stewardship** | Post-gift acknowledgment, impact reporting, relationship continuity | `stewardship` |

---

# Part IV: Cross-Cutting Concepts

### Cohort
A group of students defined by a shared characteristic and entry point, tracked over time. The foundational unit of longitudinal analysis.

**Common cohort definitions:** Fall 2024 FTFT (first-time full-time), Fall 2024 Transfer, Spring 2025 Graduate. IPEDS uses Fall FTFT as the primary cohort for graduation and retention rates.

**HELIX Resource:** `Student.cohort`

### Census Date
The official date (typically 2-3 weeks into the term) when the institution takes its enrollment snapshot. Before census: drops are clean (no record). After census: drops become withdrawals (W on transcript), and financial aid calculations are locked.

**HELIX Resource:** `AcademicPeriod.census_date`

### IPEDS (Integrated Postsecondary Education Data System)
The federal data collection system administered by NCES (National Center for Education Statistics). All Title IV institutions must report annually. Key surveys: Enrollment (EF), Completions (C), Graduation Rates (GR), Financial Aid (SFA), Finance (F), Human Resources (HR).

### Accreditation
External review verifying that an institution or program meets established quality standards. Regional accreditation (HLC, SACSCOC, NEASC, MSCHE, WSCUC, NWCCU) is required for Title IV eligibility. Program-level accreditation (ABET for engineering, AACSB for business, etc.) is field-specific.

### CIP Code (Classification of Instructional Programs)
A 6-digit code assigned by NCES that classifies every academic program. Used for IPEDS Completions reporting, program-level benchmarking, and federal gainful employment regulations.

**HELIX Resource:** `Program.cip_code`

**Example:** 11.0701 = Computer Science; 52.0201 = Business Administration; 13.1001 = Special Education

### SOC Code (Standard Occupational Classification)
A federal code classifying occupations. Used for IPEDS HR reporting and labor market outcome tracking.

**HELIX Resource:** `JobClassification.soc_code` (Banner/PS Bridge mappings)

---

*HELIX Glossary v0.1 — August 2026*
*Part of the [HELIX Open Framework](https://github.com/utopify/helix)*
