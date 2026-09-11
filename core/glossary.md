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


**HELIX Terminology:** `helix/enrollment-status` → codes: `registered`, `enrolled`, `waitlisted`, `dropped`, `withdrawn`, `completed`, `incomplete`, `audit`

**HELIX Resource:** `Enrollment.status`

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


**HELIX Terminology:** `helix/award-type` → codes: `federal_grant`, `state_grant`, `institutional_grant`, `scholarship_merit`, `scholarship_need`, `scholarship_athletic`, `federal_loan_subsidized`, `federal_loan_unsubsidized`, `private_loan`, `work_study`, `fellowship`

**HELIX Terminology:** `helix/sap-status` → codes: `satisfactory`, `warning`, `probation`, `suspended`, `reinstated`, `appeals_pending`
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


### Data Classification
HELIX assigns every resource attribute one of four classification tiers that determine handling rules, access controls, encryption requirements, and retention policies.

**HELIX Terminology:** `helix/data-classification` → codes: `public` (course catalog, institution name), `internal` (GL transactions, org charts), `confidential` (student records, employee data), `restricted` (SSN, financial aid, visa/SEVIS, compensation)

**HELIX Resource:** Every resource carries `meta.classification` in its schema.

**Context:** Classification drives the entire HELIX security model. See `govern/classification-handling-rules.json` for the full handling matrix covering encryption, access, audit, masking, retention, and disposal requirements per tier.

## The Registrar's Domain

### Registrar
The institutional officer responsible for the integrity of the academic record: enrollment, grades, transcripts, degree audit, degree conferral, academic calendar, classroom scheduling, and FERPA compliance.

### Transcript
The official record of a student's academic history: courses taken, grades earned, credits, GPA, degrees conferred, honors. The registrar is the custodian.

**Types:** Official (sealed, institution-verified), Unofficial (student-viewable, not for external use).

### Credit Hour
The standard unit of academic measurement. One credit hour typically represents one hour of classroom instruction plus two hours of outside work per week for a semester (the "Carnegie Unit").


### Course Level

The academic level at which a course is offered, which drives enrollment restrictions, tuition rates (at some institutions), financial aid eligibility, and IPEDS reporting.

| Level | Definition | Typical Course Numbers |
|-------|-----------|----------------------|
| **Developmental** | Pre-college remedial courses; may not carry degree credit | 001-099 |
| **Undergraduate Lower Division** | Freshman/sophomore courses | 100-299 |
| **Undergraduate Upper Division** | Junior/senior courses | 300-499 |
| **Graduate** | Master's-level courses | 500-699 or 5000-6999 |
| **Doctoral** | PhD-level courses, seminars, dissertation hours | 700-999 or 7000-9999 |
| **Professional** | Professional programs (JD, MD, PharmD) | Varies by school |
| **Continuing Education** | Non-degree, professional development | CE/ED prefix |
| **Non-Credit** | No academic credit awarded; workforce training, community enrichment | NC prefix |

**HELIX Terminology:** `helix/course-level` → codes: `developmental`, `undergraduate_lower`, `undergraduate_upper`, `graduate`, `doctoral`, `professional`, `continuing_education`, `non_credit`

**HELIX Resource:** `Course.course_level`, `CourseSection`

**Context:** Course level determines whether a course counts toward degree requirements, whether financial aid covers it (federal aid doesn't cover developmental at some institutions), and how it maps to IPEDS Completions data.

### Delivery Mode

How a course is delivered — increasingly important post-pandemic for enrollment reporting, space utilization, faculty workload, and IPEDS distance education reporting.

| Mode | Definition | IPEDS Distance Ed? |
|------|-----------|-------------------|
| **In Person** | Traditional face-to-face classroom instruction | No |
| **Online Synchronous** | Real-time virtual instruction (Zoom, Teams) at scheduled times | Yes |
| **Online Asynchronous** | Self-paced online; no scheduled meeting times | Yes |
| **Hybrid** | Combination of in-person and online (typically fixed schedule for each) | Partially |
| **HyFlex** | Students choose to attend in-person OR online each session | Partially |
| **Correspondence** | Self-paced with mailed/emailed materials and assignments | Yes (separate IPEDS category) |
| **Independent Study** | Student works individually with faculty guidance, no regular class meetings | No |
| **Clinical** | Supervised practice in a clinical setting (hospitals, clinics, schools) | No |
| **Practicum** | Structured field experience with academic supervision | No |
| **Internship** | Work experience in a professional setting, with or without academic credit | No |
| **Study Abroad** | Courses taken at a foreign institution or through an overseas program | No |

**HELIX Terminology:** `helix/delivery-mode` → codes: `in_person`, `online_synchronous`, `online_asynchronous`, `hybrid`, `hyflex`, `correspondence`, `independent_study`, `clinical`, `practicum`, `internship`, `study_abroad`

**HELIX Resource:** `CourseSection.delivery_mode`

**Context:** IPEDS requires institutions to report how many students are enrolled "exclusively in distance education." The delivery mode of each section is the source data for this calculation. Misclassification affects the institution's IPEDS distance education profile, which in turn affects state authorization requirements (SARA) and accreditation.
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

### Grade Mode
The grading basis for a course enrollment. Determines how (or whether) the grade is calculated into GPA.

| Mode | Definition | GPA Impact |
|------|-----------|-----------|
| **Standard** | Letter grades (A, B, C, D, F) | Included in GPA |
| **Pass/Fail** | Binary outcome; no letter grade | Excluded from GPA |
| **Satisfactory/Unsatisfactory** | Similar to P/F, common for thesis/dissertation | Excluded from GPA |
| **Audit** | Student attends but receives no credit or grade | Not recorded in GPA |
| **In Progress** | Course spans multiple terms; grade deferred until completion | Excluded until resolved |

**HELIX Terminology:** `helix/grade-mode` → codes: `standard`, `pass_fail`, `satisfactory_unsatisfactory`, `audit`, `in_progress`

**HELIX Resource:** `Enrollment.grade_mode`

**Context:** Grade mode affects financial aid SAP calculations (audit courses don't count toward completion rate), GPA-based honors determination, and transcript reporting. Some institutions allow students to retroactively change grade mode (e.g., to P/F during COVID) — this creates data versioning challenges.

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

**HELIX Terminology:** `helix/faculty-rank` → codes: `instructor`, `lecturer`, `senior_lecturer`, `assistant_professor`, `associate_professor`, `full_professor`, `distinguished_professor`, `university_professor`, `emeritus_professor`, `clinical_professor`, `research_professor`, `professor_of_practice`, `endowed_chair`

**HELIX Resource:** `JobClassification.faculty_rank`

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

**HELIX Terminology:** `helix/tenure-status` → codes: `pre_tenure`, `tenured`, `non_tenure_track`, `tenure_denied`, `tenure_revoked`

**HELIX Resource:** `JobClassification.tenure_status`

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

**HELIX Terminology:** `helix/eeo-category` → codes: `executive_admin`, `faculty`, `professional_nonfaculty`, `clerical_secretarial`, `technical_paraprofessional`, `skilled_crafts`, `service_maintenance`

**HELIX Resource:** `JobClassification.eeo_category`

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

### Ethnicity & Race
Federal reporting (IPEDS) requires institutions to collect race/ethnicity using a two-question format: (1) Are you Hispanic or Latino? (2) Select one or more races. The resulting categories drive enrollment demographics, completion rates, equity gap analysis, and compliance with Title VI.

**HELIX Terminology:** `helix/ethnicity` → codes: `hispanic_latino`, `american_indian_alaska_native`, `asian`, `black_african_american`, `native_hawaiian_pacific_islander`, `white`, `two_or_more`, `nonresident_alien`, `unknown`, `prefer_not_to_say`

**HELIX Terminology:** `helix/gender` → codes: `male`, `female`, `nonbinary`, `other`, `unknown`

**HELIX Resource:** `Person.ethnicity`, `Person.gender`

**Context:** Race/ethnicity data is self-reported and voluntary, but IPEDS requires institutions to impute race for non-respondents using observer identification (a problematic but current requirement). HELIX stores the self-reported value and a separate imputed flag so institutions can distinguish the two.

### Gender Identity
A person's internal sense of their own gender, which may or may not correspond to their sex assigned at birth. Increasingly collected by institutions for compliance with state/federal reporting updates and to support inclusive campus environments.

**HELIX Terminology:** `helix/gender-identity` → codes: `man`, `woman`, `nonbinary`, `transgender_man`, `transgender_woman`, `genderqueer`, `agender`, `two_spirit`, `other`, `prefer_not_to_say`

**HELIX Resource:** `Person.gender_identity`

**Context:** IPEDS currently reports binary sex (male/female). However, many institutions now collect gender identity separately from legal sex. The distinction matters for student services, housing, Title IX reporting, and — increasingly — state reporting mandates. Store both: legal sex for federal reporting, gender identity for institutional use.

### Identifier Types
The various identifiers used to uniquely identify a person across institutional systems. Higher education deals with an unusually complex identifier landscape because a single person may be a student, employee, alumnus, and donor simultaneously — each system assigning its own ID.

| Identifier | Source | Sensitivity |
|-----------|--------|------------|
| **Institutional ID** | SIS-assigned (EMPLID, PIDM, Universal ID) | Internal |
| **National ID / SSN** | Government-issued; used for financial aid (FAFSA), tax reporting (1098-T), employment (I-9) | Restricted |
| **SSN Last 4** | Truncated for verification without full SSN exposure | Confidential |
| **Passport Number** | International students, travel authorization | Restricted |
| **Driver's License** | Identity verification, campus parking | Confidential |
| **SEVIS ID** | DHS-assigned for F-1/J-1 visa holders | Restricted |
| **ORCID** | Researcher identifier (Open Researcher and Contributor ID) | Public |
| **Medicaid/Insurance ID** | Student health center billing | Restricted |
| **Alumni ID** | Advancement/alumni systems (may differ from student ID) | Internal |
| **Donor ID** | Advancement CRM identifier | Internal |
| **Employee ID** | HR system identifier (may be same as institutional ID) | Internal |
| **LMS Username** | Learning Management System login | Internal |

**HELIX Terminology:** `helix/identifier-type` → codes: `institutional_id`, `national_id`, `ssn_last4`, `passport`, `drivers_license`, `sevis_id`, `orcid`, `medicaid_id`, `alumni_id`, `donor_id`, `employee_id`, `lms_username`

**HELIX Resource:** `Person.identifiers[]` (array of typed identifier objects)

**Context:** Identity resolution — matching the same person across systems — is the foundational data integration challenge in higher education. HELIX's `Person` resource serves as the identity hub, with typed identifiers enabling deterministic matching (SSN token, institutional ID, email) before falling back to probabilistic methods.

---

# Part V: Institutional Operations — Deep Dive

## Business Affairs, Bursar & Student Financial Services

### Bursar vs. Student Financial Services (SFS)
Many institutions have consolidated the Bursar's Office into a broader **Student Financial Services** (SFS) unit that combines billing, collections, financial aid, and student employment under one roof. Where they remain separate, the Bursar handles billing and collections while SFS handles the aid side. The data challenge is the same: student financial data lives across both the SIS (billing module) and the financial aid module, with GL postings in the finance system.

**HELIX Resource:** `ARTransaction` (charges, payments, refunds), `FinAidAward` (aid side)

### Tuition and Fee Structures

| Structure | Definition | Data Implications |
|-----------|-----------|-------------------|
| **Flat-Rate Tuition** | One price for 12-18 credit hours (overloads charged per credit) | Billing system must cap charges at the flat rate; excess credits use a different rate |
| **Per-Credit Tuition** | Each credit hour charged individually | Most common at graduate and community college level |
| **Differential Tuition** | Higher rate for specific programs (engineering, nursing, business) | Requires program-level billing logic; multiple tuition rates per term |
| **Course Fees** | Fees attached to specific courses (lab fees, studio fees, technology fees) | Billed at the section level, not the student level |
| **Comprehensive Fee** | Single all-inclusive fee covering tuition, fees, room, board, activities | Simplifies billing but complicates financial reporting (must allocate for IPEDS) |
| **Resident vs. Non-Resident** | In-state vs. out-of-state rate at public institutions | Residency classification is a separate determination process; incorrect classification is a compliance risk |

**HELIX Resource:** `ARTransaction.charge_code` maps to the charge type

### Tuition Reciprocity & Exchange
**Reciprocity agreements** between states allow residents of neighboring states to attend at reduced rates (e.g., NEBHE Tuition Break, MSEP, WUE, SREB Academic Common Market). **Tuition exchange programs** (Council of Independent Colleges, Great Lakes Colleges Association) allow dependents of employees at member institutions to attend other member institutions at reduced or zero tuition.

### Billing Cycles
**Term billing** posts all charges at the start of each academic term. **Monthly billing** spreads charges across installments (payment plan). Most institutions use a third-party payment plan vendor (Nelnet, Transact/Cashnet, TouchNet). Payment plans are NOT financial aid and do NOT appear on the FAFSA.

### The 1098-T Tax Form
IRS Form 1098-T reports qualified tuition and related expenses paid (Box 1) and scholarships/grants received (Box 5) for each calendar year. Institutions are required to file for every enrolled student who has a valid SSN/TIN. Box 1 minus Box 5 drives the student/family's eligibility for the American Opportunity Tax Credit (AOTC) or Lifetime Learning Credit. Data source: the student account system (PS_ITEM / Banner TBRACCD).

**HELIX Resource:** `ARTransaction` (charges) + `FinAidAward` (scholarships/grants for Box 5)

### Refund Policy & Return of Title IV (R2T4)
When a student withdraws, the institution calculates a refund based on its institutional refund policy (prorated by weeks attended or a fixed schedule). Separately, **R2T4** (34 CFR 668.22) is a federal calculation that determines how much Title IV aid must be returned to the federal government based on the percentage of the payment period completed. R2T4 is NOT the same as the institutional refund. Both calculations must be run: the institutional refund determines what the student gets back; R2T4 determines what the institution sends back to the government.

**Data implications:** R2T4 requires: withdrawal date, payment period start/end dates, scheduled breaks, Title IV aid disbursed, and institutional charges. Incorrect R2T4 is a top audit finding.

### Third-Party Billing
Billing a third party instead of (or in addition to) the student:

| Third Party | Mechanism | Data Challenge |
|-------------|-----------|---------------|
| **VA (Department of Veterans Affairs)** | Tuition certified and billed directly to VA. GI Bill (Ch 33) covers tuition + housing + books. | VA certification (enrollment, tuition amount) is a separate data feed. |
| **Employer Tuition Reimbursement** | Student pays up front; employer reimburses. Or employer is billed directly via contract. | Third-party contract in the SIS (PS_THIRD_PARTY_CONTRACT). |
| **Tribal Nation** | Tribal scholarship or direct billing for Native American students | Similar to employer billing. |
| **Sponsoring Government** | Foreign government sponsors (e.g., Saudi SACM, Kuwait) pay tuition directly | Requires sponsor billing interface and payment reconciliation. |
| **529 Plan** | State-sponsored college savings plan. Tax-advantaged withdrawals for qualified expenses. | Payment arrives as a check/ACH from the plan administrator. Must be applied to the student account correctly. |

**HELIX Resource:** `ARTransaction.third_party_ref`

### Collections
When a student account balance remains unpaid past a threshold (typically 90-120 days after the term ends), the institution may: (a) place a financial hold, (b) send to an internal collections team, (c) assign to a third-party collection agency, (d) report to credit bureaus (if allowed by state law), (e) use state tax offset programs (at public institutions). Write-offs of uncollectable balances are a GL transaction.

### Payment Status
Every charge and payment on a student account (or vendor invoice) moves through a lifecycle tracked by status codes. Reconciliation between the student billing system and the general ledger depends on accurate status tracking.

**HELIX Terminology:** `helix/payment-status` → codes: `pending`, `approved`, `scheduled`, `paid`, `voided`, `cancelled`, `returned`, `partially_paid`, `in_dispute`

**HELIX Resource:** `ARTransaction.status`, `APVoucher.payment_status`

### Fund Accounting

Higher education uses **fund accounting** rather than the single-entity model common in corporate finance. Each fund is a self-balancing set of accounts with its own assets, liabilities, and fund balance. This exists because universities receive money with strings attached — federal grants, donor restrictions, bond covenants, auxiliary operations — and must demonstrate that restricted funds were used only for their intended purpose.

| Fund Type | Definition | Example |
|-----------|-----------|---------|
| **Unrestricted** | No external restrictions on use; institution's operating budget | General fund, tuition revenue |
| **Temporarily Restricted** | Donor or sponsor has imposed a time or purpose restriction that will eventually be satisfied | Scholarship fund restricted for 2025-26 academic year |
| **Permanently Restricted** | Principal must be maintained in perpetuity (corpus); only investment income is spendable | Endowed chair, endowed scholarship |
| **Endowment** | Funds where the corpus is invested and only the spending distribution (typically 4-5% of trailing average) is available | Named endowments |
| **Quasi-Endowment** | Board-designated funds functioning like endowments but without donor restriction; board can un-designate | Board reserves |
| **Agency** | Funds held in custody for others (student organizations, third parties) | Student government funds |
| **Loan** | Revolving loan funds (Perkins, institutional emergency loans) | Federal Perkins Loan Fund |
| **Plant** | Funds for capital assets: acquisition, renewal, debt service | Building construction fund |
| **Auxiliary** | Self-supporting operations that charge fees for services | Housing, dining, parking, athletics |
| **Grant/Sponsored** | Externally funded research and programs (federal, state, private) | NSF grant, NIH award |
| **Designated** | Unrestricted funds the institution has internally earmarked for specific purposes | Technology refresh fund |
| **Internal Service** | Funds that provide services to other institutional units on a charge-back basis | Print shop, motor pool |

**HELIX Terminology:** `helix/fund-type` → codes: `unrestricted`, `temporarily_restricted`, `permanently_restricted`, `endowment`, `quasi_endowment`, `agency`, `loan`, `plant`, `auxiliary`, `grant_sponsored`, `designated`, `internal_service`

**HELIX Resource:** `Fund`

**Aliases:** Fund Group (Banner), Fund Code (PeopleSoft), Fund Worktag (Workday)

**Context:** Fund accounting is what makes higher ed financial data fundamentally different from corporate financial data. Any analytics, migration, or integration project that touches finance must understand fund structure. The NACUBO (National Association of College and University Business Officers) financial reporting standards define the authoritative fund categories. GASB standards govern public institutions; FASB governs private. The fund type drives how revenue and expenses are reported on the institution's audited financial statements.

### Chart of Accounts (COA)

The institutional Chart of Accounts is the classification structure for all financial transactions. Higher education COAs are more complex than corporate COAs because of fund accounting, sponsored research, and regulatory reporting requirements.

| COA Dimension | What It Classifies | PeopleSoft Term | Workday Term | Banner Term |
|---------------|-------------------|-----------------|-------------|-------------|
| **Account** | What type of revenue/expense (salaries, supplies, travel, tuition) | Account | Ledger Account | Account Code |
| **Fund** | Source of money and restrictions (see Fund Accounting above) | Fund Code | Fund Worktag | Fund Code |
| **Department** | Organizational unit responsible | DeptID | Cost Center | Organization Code |
| **Program** | Functional purpose (instruction, research, public service, academic support, institutional support, student services, O&M, scholarships, auxiliary, hospital) | Program Code | Revenue Category / Spend Category | Program Code |
| **Project** | Specific initiative or grant | Project ID | Grant Worktag + Project | Grant/Project |
| **Class** | Additional sub-classification (varies by institution) | Class Field | Custom Worktag | Activity Code |

**HELIX Terminology:** `helix/account-type` → codes: `asset`, `liability`, `fund_balance`, `revenue`, `expenditure`, `transfer`

**HELIX Resource:** `GLTransaction` (carries the full COA string for each journal entry line)

**Aliases:** Chartfield (PeopleSoft), Worktag combination (Workday), FOAPAL (Banner: Fund-Org-Account-Program-Activity-Location)

**Context:** The COA is the Rosetta Stone of institutional finance. Every ERP migration must map the old COA to the new one — and this is consistently the most contentious and time-consuming part of a financial system conversion. HELIX Bridge provides cross-reference mappings (see `bridge/xref/ps-to-workday-fin/`) for the four primary dimensions.

### General Ledger Transaction Types

The types of entries posted to the general ledger. Understanding transaction types is essential for GL reconciliation and audit.

| Type | Definition | Typical Frequency |
|------|-----------|-------------------|
| **Journal Entry** | Manual or imported entry to record a financial event | Daily |
| **Standard** | System-generated entries from sub-ledgers (AP, AR, Payroll) | Daily/batch |
| **Adjustment** | Correction to a previously posted entry | As needed |
| **Accrual** | Record revenue earned or expense incurred but not yet cash-settled | Monthly |
| **Reversal** | Automatic reversal of an accrual in the next period | Monthly |
| **Closing** | Year-end entries to close revenue/expense to fund balance | Annual |
| **Reclassification** | Move an amount from one COA segment to another without changing the total | As needed |
| **Elimination** | Remove inter-fund or inter-entity transactions for consolidated reporting | Annual (consolidation) |
| **Statistical** | Non-monetary entries for tracking (FTE, square footage, headcount) | Periodic |
| **Budget Entry** | Record approved budget amounts | Annual + revisions |
| **Encumbrance** | Reserve budget for a committed but not yet paid expense (PO, contract) | When PO approved |

**HELIX Terminology:** `helix/transaction-type` → codes: `journal_entry`, `standard`, `adjustment`, `accrual`, `reversal`, `closing`, `reclassification`, `elimination`, `statistical`, `budget_entry`, `encumbrance`

**HELIX Resource:** `GLTransaction.transaction_type`

### Budget Lifecycle

Institutional budgets move through a defined lifecycle. In higher education, the annual budget process typically begins 6-9 months before the fiscal year starts and involves input from every academic and administrative unit.

**HELIX Terminology:** `helix/budget-status` → codes: `proposed`, `submitted`, `approved`, `active`, `frozen`, `closed`, `revised`, `lapsed`, `carried_forward`

**HELIX Resource:** `Budget.status`

**Context:** Budget status determines whether funds can be spent. A "frozen" budget typically means a hiring or spending freeze has been imposed (common during enrollment shortfalls or mid-year revenue misses). Encumbrance accounting — reserving budget when a PO is approved — is standard practice but varies in implementation across ERPs.

### Procurement / Purchase Orders

The lifecycle of a purchase order from requisition through receipt and payment. Higher ed procurement adds complexity through mandated state procurement rules (at public institutions), grant-funded purchasing restrictions (2 CFR 200.320), and sole-source justification requirements.

**HELIX Terminology:** `helix/purchase-order-status` → codes: `draft`, `pending_approval`, `approved`, `dispatched`, `partially_received`, `received`, `closed`, `cancelled`, `on_hold`

**HELIX Resource:** `PurchaseOrder.status`

### Expense Report Status

Travel and expense reports follow a multi-step approval workflow with additional compliance checks for grant-funded travel (sponsor prior approval requirements, fly-America act for federal grants, per diem limits from GSA or sponsor).

**HELIX Terminology:** `helix/expense-status` → codes: `draft`, `submitted`, `pending_approval`, `approved`, `paid`, `returned`, `denied`, `audit_hold`

**HELIX Resource:** `ExpenseReport.status`

### Contract Management

Institutional contracts span a wide range: vendor services, consulting, facilities construction, revenue agreements (food service, bookstore), affiliation agreements (clinical sites), and sponsored research sub-awards. Contract status tracking is essential for compliance and financial planning.

**HELIX Terminology:** `helix/contract-status` → codes: `draft`, `negotiation`, `pending_approval`, `pending_execution`, `active`, `suspended`, `expired`, `terminated`, `renewed`

**HELIX Resource:** `Contract.status`

### Fixed Asset Management

Capital assets — buildings, equipment, land, artwork, library collections — must be tracked for financial reporting (depreciation), insurance, federal property regulations (for grant-purchased equipment), and campus master planning.

| Category | Definition | Typical Capitalization Threshold |
|----------|-----------|--------------------------------|
| **Land** | Real property owned by the institution | All amounts (not depreciated) |
| **Buildings** | Academic, administrative, residential, athletic facilities | $100K+ |
| **Building Improvements** | Renovations that extend useful life or add functionality | $50K-100K+ |
| **Equipment** | Laboratory, IT, vehicles, furniture meeting the threshold | $5K-25K (varies) |
| **Vehicles** | Fleet vehicles, campus shuttles | $5K+ |
| **Software** | Enterprise systems (ERP, LMS), licensed software | $100K+ |
| **Leasehold Improvements** | Improvements to leased space | Varies |
| **Construction in Progress (CIP)** | Capital projects not yet completed | All amounts |
| **Library Collections** | Books, journals, digital resources | May be group-capitalized |
| **Artwork / Historical Treasures** | Museum collections, public art | May be exempt from depreciation |

**HELIX Terminology:** `helix/asset-category` → codes: `land`, `buildings`, `building_improvements`, `equipment`, `vehicles`, `software`, `leasehold_improvements`, `construction_in_progress`, `library_collections`, `artwork`, `furniture`, `infrastructure`

**HELIX Terminology:** `helix/asset-status` → codes: `active`, `idle`, `under_repair`, `disposed`, `retired`, `lost`, `transferred`, `in_service`

**HELIX Resource:** `Asset`

**Context:** Grant-funded equipment (federally titled property) has special disposition requirements under 2 CFR 200.313. Equipment purchased with federal funds over $5,000 must be tracked, used for the original purpose, and disposed of according to federal rules — even after the grant ends.

---

## Grants Management & Sponsored Programs

### The Sponsored Programs Lifecycle

```
Proposal Development → Submission → Award → Account Setup → Spending → Effort Reporting → Billing → Closeout
```

### Pre-Award

#### Sponsored Programs Office (SPO / OSP)
The office that manages the administrative side of external funding. May be called Office of Sponsored Programs (OSP), Office of Research (OR), or Division of Research. Responsible for proposal review, budget justification, submission, and award negotiation. Distinct from **Grants Accounting**, which handles post-award financial management (spending, billing, closeout).

**HELIX Resource:** `Grant` (the full lifecycle record)

#### Budget Justification
The detailed budget attached to a grant proposal that itemizes: personnel (salaries + fringe benefits), equipment (>$5K per unit), travel, participant support, supplies, contractual/subawards, other direct costs, and indirect costs (F&A). Must comply with the sponsor's budget categories and cost principles.

#### Facilities & Administrative (F&A) / Indirect Cost Rate
The percentage added to direct costs to recover the institution's overhead: facilities (building depreciation, utilities, maintenance) and administration (sponsored programs office, accounting, compliance). Negotiated with the institution's **cognizant federal agency** (typically DHHS or ONR for most universities).

**Typical rates:** 45-60% of Modified Total Direct Costs (MTDC) for on-campus organized research. Lower rates for off-campus (25-30%), instruction (40-50%), and other sponsored activity.

**MTDC base:** Total direct costs minus: equipment (>$5K), participant support costs, tuition remission, subaward amounts above $25K, capital expenditures, and patient care costs. The MTDC base is one of the most misunderstood concepts in research administration.

**HELIX Resource:** `Grant.idc_rate`, `Grant.indirect_costs_budget`

#### Cost Sharing
The institution's financial contribution to a sponsored project. **Mandatory cost sharing** is required by the sponsor. **Voluntary committed cost sharing** is offered in the proposal. **Voluntary uncommitted cost sharing** is effort over and above what's proposed (doesn't need to be tracked). Once committed, cost sharing must be documented and reported.

#### Subawards
When the institution subcontracts part of a grant to another institution or organization. The first $25K of each subaward counts in the MTDC base for F&A; amounts above $25K are excluded. Subaward monitoring is an audit focus area.

### Post-Award

#### No-Cost Extension (NCE)
An extension of the grant period without additional funding. Most federal awards allow one NCE of up to 12 months with notification (no prior approval needed). A second NCE requires sponsor approval. Critical for projects that need more time to spend remaining funds.

#### Carry Forward
Transferring unspent funds from one budget period to the next. Some federal awards allow automatic carry forward; others require prior approval. Distinct from NCE (which extends time, not dollars).

#### Re-budgeting
Moving funds between budget categories within a grant. Federal rules (2 CFR 200.308) allow re-budgeting up to a percentage threshold without sponsor approval (typically 10-25% of the budget). Larger moves require prior approval.

### Effort Certification
A process where faculty/staff certify that the percentage of effort charged to each sponsored project reasonably reflects how they actually spent their time. Required by 2 CFR 200.430 for all federal grants.

**Methods:** After-the-fact activity reports (semi-annual or per-pay-period), plan-confirmation systems. The certification must be signed by the individual or someone with firsthand knowledge.

**Non-compliance consequences:** Disallowed costs, repayment to the federal government, institutional-level audit findings, False Claims Act liability.

**HELIX Resource:** Effort certification data lives in PS_GM_EFFORT_CERT (PeopleSoft) or Workday effort certification functionality. Maps to `Grant` and `Employee` resources.

### Grant / Sponsored Program Status

Every grant moves through a lifecycle from pre-award through closeout. The status determines what financial transactions are allowed (spending is blocked in `pre_award` and `closed` statuses) and what compliance activities are required.

**HELIX Terminology:** `helix/grant-status` → codes: `pre_award`, `pending`, `negotiation`, `active`, `no_cost_extension`, `suspended`, `closed`, `final_reporting`, `audit`, `terminated`

**HELIX Resource:** `Grant.status`

**Context:** Grant status is a critical control point. The finance system should prevent charges to grants that aren't in `active` or `no_cost_extension` status. Post-closeout charges are audit findings. The transition from `active` → `closed` → `final_reporting` involves a 90-day final reporting window (for federal awards) during which remaining invoices must be paid and financial reports submitted.

### 2 CFR 200 (Uniform Guidance)

| Subpart | Topic | Key Rules |
|---------|-------|-----------|
| **Subpart D** | Post-Award Requirements | Financial management, cost sharing, program income, revision of budget, closeout |
| **Subpart E** | Cost Principles | Allowable (benefits the project), allocable (proportional to benefit), reasonable (prudent person test), consistent (treat similar costs the same way) |
| **Subpart F** | Single Audit | Institutions spending ≥$750K in federal awards must undergo an annual single audit (A-133). Findings reported in Schedule of Expenditures of Federal Awards (SEFA). |

### Research Compliance

#### IRB (Institutional Review Board)
Reviews and approves research involving human subjects. Federal mandate (45 CFR 46, the "Common Rule"). Three review levels: exempt, expedited, full board. Every active human subjects study has an IRB protocol number tracked in the research compliance system.

#### IACUC (Institutional Animal Care and Use Committee)
Reviews and approves research involving vertebrate animals. Federal mandate (PHS Policy, USDA AWA). Every animal protocol has an IACUC approval number.

#### Export Controls
Federal regulations (EAR, ITAR) that restrict sharing certain technologies, data, and knowledge with foreign nationals. Research universities with international collaborators and graduate students must have an export control compliance program.

#### Conflict of Interest (COI)
Federal and institutional requirements for researchers to disclose significant financial interests that could affect the design, conduct, or reporting of research. PHS-funded investigators must disclose interests >$5K. Managed by a COI committee.

#### Technology Transfer / IP
When research produces inventions or intellectual property, the institution (typically through a Technology Transfer Office / TTO) manages patent filing, licensing, and startup formation under the Bayh-Dole Act (35 U.S.C. 200-212). Revenue is shared between the inventor, department, and institution per institutional policy.

---

## Human Resources (Institutional)

### Position Management
A **position** is the organizational "seat" defined independently of who fills it (or whether it's filled at all). A **job** is the assignment of a person to a position. PeopleSoft and Workday both use position management; Banner uses a lighter model where positions are optional.

| Concept | Definition | HELIX Resource |
|---------|-----------|----------------|
| **Position** | The funded seat: title, classification, grade, department, FTE | `Position` |
| **Funded Position** | Position with approved budget | `Position` + `PositionBudget` |
| **Unfunded Position** | Position exists in the system but has no budget allocation (frozen or pending) | `Position` (status: `frozen`) |
| **Vacant Position** | Funded position with no incumbent | `Position` (status: `open`) |
| **FTE (Full-Time Equivalent)** | Proportion of full-time effort: 1.0 = full-time, 0.5 = half-time | `Position.fte`, `Employee.fte` |

**HELIX Resource:** `Position`, `PositionBudget`, `Employee`

### Position Control

**Position control** is the practice of tying every hire to a funded position in the budget system — not just tracking employees, but ensuring that no one can be hired into a position that doesn't exist and isn't funded. This is what makes higher education HR fundamentally different from many corporate HR systems.

Why it matters: at public institutions, the legislature or governing board may appropriate a specific number of funded positions. Overspending on personnel (the largest single expense category, typically 60-75% of E&G budget) is a compliance risk. Position control provides the governance layer between "we want to hire someone" and "we can afford to hire someone."

**HELIX Terminology:** `helix/position-status` → codes: `open`, `filled`, `frozen`, `abolished`, `proposed`, `reclassified`

**HELIX Resource:** `Position`, `PositionBudget`

**Context:** Position status directly drives the `Requisition` workflow: only positions in `open` status can have requisitions opened against them. A `frozen` position means a hiring freeze is in effect. An `abolished` position has been permanently eliminated (often during budget cuts or reorganizations).

### Worker Types

The classification of an individual's employment relationship with the institution. Higher education has an unusually diverse workforce — faculty, staff, student workers, contingent workers, and volunteers all co-exist, often with different pay systems, benefit eligibility, and governance structures.

**HELIX Terminology:** `helix/worker-type` → codes: `regular`, `temporary`, `contingent`, `contractor`, `student_worker`, `intern`, `fellow`, `volunteer`, `emeritus`, `visiting`, `adjunct`, `per_diem`

**HELIX Resource:** `Employee.worker_type`

**Aliases:** Person of Interest / POI (PeopleSoft for non-employees), PEAEMPL employee class (Banner), Worker Type (Workday)

### Employment Status Lifecycle

An employee's status changes as they move through their institutional career — from initial hire through active employment, leaves, and eventually separation.

**HELIX Terminology:** `helix/employment-status` → codes: `active`, `inactive`, `leave_of_absence`, `terminated`, `retired`, `suspended`, `deceased`, `pre_hire`

**HELIX Resource:** `Employee.employment_status`

**Context:** Employment status drives benefits eligibility (only `active` employees accrue leave), payroll processing (only `active` and some `leave_of_absence` statuses generate pay), system access (deprovisioning should trigger on `terminated`), and IPEDS HR reporting (headcount = `active` employees as of November 1 snapshot).

### Compensation Structures

| Element | Definition | HELIX Attribute |
|---------|-----------|-----------------|
| **Salary Plan** | The compensation framework (e.g., Staff, Faculty, Executive, Student) | `Compensation.compensation_grade` |
| **Pay Grade** | A band within a plan defining the min/mid/max salary range | `Compensation.grade_minimum/midpoint/maximum` |
| **Step** | Fixed increment within a grade (common in unionized/classified staff) | `Compensation.compensation_step` |
| **Compa-Ratio** | Employee's pay divided by the grade midpoint. <1.0 = below market, >1.0 = above | `Compensation.compa_ratio` |
| **Market Adjustment** | Off-cycle pay increase to address market competitiveness | `Compensation.change_reason` = `market` |


**HELIX Terminology:** `helix/compensation-type` → codes: `base_salary`, `hourly`, `stipend`, `overload`, `summer_pay`, `administrative_supplement`, `acting_pay`, `shift_differential`, `on_call`, `hazard`, `longevity`, `merit`

**HELIX Terminology:** `helix/pay-frequency` → codes: `biweekly`, `semimonthly`, `monthly`, `weekly`, `annual`, `one_time`

**HELIX Resource:** `Compensation`, `PayrollResult`

**Context:** Higher education compensation is more complex than it appears. Faculty on 9-month contracts may receive pay spread over 12 months or 9 months — the "pay basis" vs. "contract basis" distinction trips up many HR system implementations. Overload pay (for teaching extra sections), summer pay (separate from base), and administrative supplements (for department chairs) are separate compensation components, not adjustments to base salary.
### Employee Classifications

| Classification | Definition |
|---------------|-----------|
| **Exempt (FLSA)** | Not eligible for overtime. Paid a salary. Faculty and most professional staff. |
| **Non-Exempt (FLSA)** | Eligible for overtime (1.5x for hours >40/week). Must track hours. Clerical, technical, service. |
| **Regular** | Ongoing employment with no predetermined end date |
| **Temporary** | Employment for a fixed period or specific project |
| **Classified** | Positions within a state civil service system (public institutions). Subject to state HR rules, pay tables, and grievance procedures. |
| **Unclassified** | Positions outside the civil service (typically faculty, senior admin, executives). Institution sets own pay and terms. |

**HELIX Resource:** `Employee.employee_type`, `Employee.flsa_status`, `Employee.worker_type`

**HELIX Terminology:** `helix/flsa-status` → codes: `exempt`, `non_exempt`, `exempt_teaching`

**HELIX Terminology:** `helix/worker-type` (see Worker Types above for full code list)

**Context:** The `exempt_teaching` code is specific to higher education — faculty qualify for the "learned professional" FLSA exemption and have a distinct overtime exemption under 29 CFR 541.303. This matters for data: exempt employees don't track hours, non-exempt must. The HELIX `TimeEntry` resource applies only to non-exempt workers.

### Bargaining Units / Collective Bargaining
At unionized institutions (common in public higher ed), groups of employees may be represented by a union for collective bargaining. Bargaining units negotiate: pay scales, benefits, working conditions, grievance procedures, layoff rules. Separate contracts may exist for faculty, staff, police, facilities workers, graduate employees. The contract (CBA) overrides institutional policy where they conflict.

**HELIX Resource:** `Employee` (union code), `Position` (bargaining unit)

### Employee Benefits in Higher Ed

| Benefit | What Makes Higher Ed Unique |
|---------|---------------------------|
| **403(b) Retirement** | The higher ed equivalent of a 401(k). Defined contribution. Often with TIAA-CREF. |
| **State Pension** | Public institutions often participate in a state retirement system (defined benefit). Vesting periods, contribution rates, and retirement eligibility vary by state. |
| **Tuition Waiver / Remission** | Employees (and often dependents) receive free or reduced tuition at the institution. One of the most valued benefits. Taxable above $5,250/year for graduate courses (IRC §127). |
| **Tuition Exchange** | Dependents attend a different member institution at reduced cost (CIC-TEP, FACHEX, etc.). |
| **Sabbatical Leave** | Paid research leave for tenured faculty, typically every 7 years. Half pay for a full year or full pay for one semester. |
| **COBRA** | Federal requirement to offer continued health coverage for 18-36 months after employment ends. |

**HELIX Resource:** `BenefitEnrollment`

**HELIX Terminology:** `helix/benefit-plan-type` → codes: `medical`, `dental`, `vision`, `life_insurance`, `disability_short_term`, `disability_long_term`, `retirement_403b`, `retirement_pension`, `tuition_waiver`, `hsa`, `fsa`, `cobra`, `eap`, `supplemental_retirement`, `legal_plan`

### IPEDS HR Survey Categories
Institutions report employees to IPEDS by:

- **Occupational category:** Faculty (instructional/research/public service), Graduate Assistants, Professional Staff, Clerical, Skilled Crafts, Technical/Paraprofessional, Service/Maintenance, Executive/Administrative/Managerial
- **Tenure status** (for faculty)
- **Full-time vs. Part-time**
- **Gender** and **Race/Ethnicity**
- **New hires** and **Salary** (by rank for faculty)

**HELIX Resource:** `JobClassification.eeo_category`, `JobClassification.ipeds_faculty_category`

### Leave & Absence Management

Faculty and staff absence tracking spans multiple leave categories with different accrual rules, approval workflows, and compliance requirements.

**HELIX Terminology:** `helix/absence-type` → codes: `vacation`, `sick`, `personal`, `fmla`, `military`, `bereavement`, `jury_duty`, `sabbatical`, `parental`, `administrative`, `workers_compensation`, `unpaid`, `covid`

**HELIX Resource:** `AbsenceRecord`

**Context:** FMLA (Family and Medical Leave Act) entitles eligible employees to 12 weeks of unpaid, job-protected leave per year for qualifying reasons. Tracking FMLA usage and remaining balance is a compliance requirement. Sabbatical leave — unique to higher education — is a paid research leave for tenured faculty, typically every 7 years, and requires a separate approval and workload-coverage plan.

### Hiring & Requisition Lifecycle

The process from identifying a need to filling a position. Higher education hiring is often slower than corporate due to faculty search committee requirements, affirmative action compliance, and position control approvals.

**HELIX Terminology:** `helix/requisition-status` → codes: `draft`, `pending_approval`, `approved`, `posted`, `interviewing`, `offer_extended`, `filled`, `cancelled`, `on_hold`, `waiver`

**HELIX Resource:** `Requisition`

**Context:** The `waiver` status is specific to academia — a search waiver allows hiring without a full competitive search (used for spousal/partner hires, emergency replacements, or when a uniquely qualified candidate is identified). Search waivers require EEO/Affirmative Action office approval and are tracked for federal contractor compliance (Executive Order 11246).

### Performance Management

Annual or periodic evaluation of employee job performance. In higher education, faculty evaluation follows a different process (peer review, student evaluations, tenure review) than staff evaluation (supervisor review, goal-based).

**HELIX Terminology:** `helix/performance-rating` → codes: `exceptional`, `exceeds_expectations`, `meets_expectations`, `partially_meets`, `does_not_meet`, `new_employee`, `not_rated`

**HELIX Resource:** `PerformanceReview`

**Context:** Performance data is classified as **restricted** in HELIX because it's highly sensitive, often subject to union grievance procedures, and may have legal implications. Access should be limited to the employee, their supervisor chain, and HR. Faculty performance data is especially sensitive when connected to tenure and promotion decisions.

### Professional Development & Learning

Tracking of employee participation in training, certifications, conferences, and other professional development activities. Compliance training (Title IX, FERPA, cybersecurity, safety) is mandatory and auditable.

**HELIX Terminology:** `helix/learning-type` → codes: `course`, `workshop`, `certification`, `conference`, `webinar`, `self_paced`, `on_the_job`, `mentoring`, `compliance_training`

**HELIX Resource:** `LearningRecord`

**Context:** Compliance training completion is auditable — institutions must demonstrate that all employees completed required training (Title IX for all employees, FERPA for those handling student records, research compliance for investigators). Learning records feed into performance reviews and professional development plans.

---

## Academic Structure & Governance

### Academic Hierarchy

```
University / System
  +-- Campus (for multi-campus systems)
      +-- College / School (e.g., College of Engineering, School of Nursing)
          +-- Division (sometimes used between college and department)
              +-- Department (e.g., Computer Science, English, Biology)
                  +-- Program (e.g., BS in Computer Science, MS in Data Analytics)
                      +-- Concentration / Track / Emphasis (e.g., AI focus, Cybersecurity focus)
```

**HELIX Resource:** `AcademicOrg` (the hierarchy), `Program` (the credential pathway)

### Key Administrative Roles

| Role | Responsibility | HELIX Relevance |
|------|---------------|-----------------|
| **President / Chancellor** | CEO of the institution. Reports to the Board of Trustees/Regents. | `Institution` governance |
| **Provost / Chief Academic Officer** | Academic leader. Oversees all academic programs, faculty, and research. | Data Trustee for Academic domains |
| **Dean** | Leads a college or school. Reports to the Provost. | `AcademicOrg` (college level) |
| **Associate / Assistant Dean** | Deputy to the Dean. Often manages specific functions (academics, research, students, DEI). | |
| **Department Chair** | Leads an academic department. Manages faculty, curriculum, scheduling, budget. Usually a faculty member on a rotating appointment (3-5 years). | `AcademicOrg` (department level) |
| **Program Director** | Oversees a specific degree program. Manages curriculum, assessment, accreditation. | `Program` |
| **Faculty Senate** | Elected body of faculty members. Primary vehicle for **shared governance** on academic matters. | Governance framework |
| **Curriculum Committee** | Reviews and approves new courses, course changes, and program proposals. | `Course`, `Program` |
| **Graduate Council** | Oversees graduate education policies, program reviews, thesis/dissertation standards. | |

### Shared Governance
The principle that major academic decisions (curriculum, degree requirements, faculty hiring, academic standards) are made collaboratively between faculty and administration. Faculty have primary authority on academic matters; administration has primary authority on finances and operations. Codified in institutional bylaws and governance documents.

### Accreditation Bodies

**Regional accreditors** (required for Title IV eligibility):

| Accreditor | Region |
|-----------|--------|
| **HLC** (Higher Learning Commission) | Midwest and West (19 states) |
| **MSCHE** (Middle States Commission on Higher Education) | Mid-Atlantic (DE, DC, MD, NJ, NY, PA, PR, USVI) |
| **SACSCOC** (Southern Association of Colleges and Schools Commission on Colleges) | South (11 states) |
| **NECHE** (New England Commission of Higher Education) | New England (CT, ME, MA, NH, RI, VT) |
| **NWCCU** (Northwest Commission on Colleges and Universities) | Northwest (AK, ID, MT, NV, OR, UT, WA) |
| **WSCUC** (WASC Senior College and University Commission) | West (CA, HI, Pacific Islands) |

**Programmatic accreditors** (field-specific):

| Accreditor | Programs |
|-----------|----------|
| **AACSB** | Business (most prestigious) |
| **ABET** | Engineering, Computing, Applied Science |
| **CAEP** (formerly NCATE) | Education |
| **CCNE** | Nursing |
| **ABA** | Law |
| **LCME** | Medicine |
| **NAAB** | Architecture |
| **CSWE** | Social Work |

**Data implications:** Accreditation reviews require extensive institutional data: enrollment trends, graduation rates, retention, assessment results, faculty credentials, financial health, student satisfaction. Much of this is drawn from the same HELIX-shaped data.

---

## Auxiliary Services

Auxiliary enterprises are **self-supporting** units that provide services to the campus community, funded primarily through user charges rather than state appropriations or tuition. They operate under their own fund codes (HELIX fund category: `auxiliary`).

### Housing & Residential Life

| Data Element | Description | HELIX Relevance |
|-------------|-------------|-----------------|
| **Room Assignment** | Student → building → room → bed space | Links to `Student` via student_ref |
| **Meal Plan** | Board plan (unlimited, block, declining balance) assigned to residential students | `ARTransaction.charge_code` for billing |
| **Occupancy Rate** | Filled beds / available beds. Target: 95-100%. Below 90% is a revenue problem. | Operational metric from housing system |
| **Damage Billing** | Charges for room damage at checkout | `ARTransaction` (charge_code: room_damage) |
| **RA Staffing** | Resident Advisors are student employees living in the halls | `Student` + `Employee` (dual role) |

### Dining Services
Board plans, declining balance accounts, retail dining, and catering. Increasingly managed by contracted vendors (Aramark, Sodexo, Chartwells). Student meal plan data links to the student account and the housing assignment.

### Bookstore
Textbook adoption (faculty select titles per course section), inclusive access programs (digital materials bundled into course fees), and course materials platforms. Bookstore data connects to `CourseSection` (adoptions by section) and `ARTransaction` (if course materials are billed to the student account).

### Student Health Center
Provides medical services to students. **Important distinction:** Most student health centers are NOT HIPAA-covered entities because they are not health care providers that transmit health information electronically in standard transactions. They are covered by **FERPA** instead (student health records at an institution are education records under FERPA). This is a common misunderstanding with significant data governance implications.

**Exception:** If the student health center submits electronic claims to insurance, it IS a HIPAA-covered entity for those transactions.

### Other Auxiliaries
Parking and transportation, recreation/fitness centers, conference and event services, printing/copy services, telecommunications, campus postal services. Each is typically a separate cost center with its own revenue and expense tracking in the GL.

**HELIX Resource:** `Fund` (fund_category: `auxiliary`), `GLTransaction` (for financial reporting)

---

## Athletics — Deep Dive

### NCAA Structure

| Division | Scholarships | Number of Sports Required | Key Characteristics |
|----------|-------------|--------------------------|-------------------|
| **Division I - FBS** | Full athletics scholarships allowed | 16 (min) | Football Bowl Subdivision. Largest athletics budgets ($50M-$250M+). Media rights revenue. Bowl games. |
| **Division I - FCS** | Full athletics scholarships (with limits) | 16 (min) | Football Championship Subdivision. Smaller than FBS but still scholarship-granting. FCS Playoffs. |
| **Division II** | Partial scholarships (equivalency model) | 10 (min) | Balance of academics and athletics. Smaller budgets. Regional competition. |
| **Division III** | No athletics scholarships | 10 (min) | Athletics as a complement to academics. No athletics financial aid. 40% of all NCAA student-athletes. |
| **NAIA** | Scholarships allowed (by sport) | 5 (min) | Smaller institutions. Own eligibility and scholarship rules. NAIA Champions of Character program. |
| **NJCAA** | Varies by division (I, II, III) | Varies | Community and junior colleges. Two-year eligibility. Transfer pathway to NCAA/NAIA. |

**Conference realignment** (2024-25 onward): Power 4 conferences (SEC, Big Ten, Big 12, ACC) plus independents in football. Autonomy conferences have additional legislative authority on cost-of-attendance stipends, insurance, and athlete welfare.

### Compliance & Eligibility

#### Initial Eligibility
Prospective student-athletes must be certified by the **NCAA Eligibility Center** (formerly Clearinghouse) before competing in Division I or II. Requirements: complete 16 core courses in high school, meet the sliding scale (GPA + SAT/ACT combination), and graduate high school.

#### Continuing Eligibility
To remain eligible each semester/quarter, student-athletes must:
- Be enrolled **full-time** (12+ credits)
- Maintain progress toward degree (**Bylaw 14.4**: percentage of degree requirements by year: 40% by end of year 2, 60% by end of year 3, 80% by end of year 4)
- Meet minimum **GPA requirements** (1.8 → 1.9 → 2.0 progression by year, with 2.0 cumulative for seniors)
- Complete a minimum number of credits per term

**HELIX Resource:** `StudentGroup` (group_code: sport-specific), `AcademicTermRecord` (GPA, units, standing), `Enrollment` (full-time verification)

#### Transfer Eligibility
The NCAA transfer rules changed significantly in 2021-22 with the **one-time transfer exception**: undergraduate student-athletes may transfer once without sitting out a year of competition, provided they meet academic requirements and notify their current institution through the **Transfer Portal**. The Transfer Portal is a database managed by the NCAA where student-athletes formally enter their name to signal intent to transfer. Entry windows are defined by sport.

### Scholarships & Financial Aid

#### Head Count vs. Equivalency Sports

| Model | How It Works | Examples |
|-------|-------------|---------|
| **Head Count** | Each scholarship athlete receives a full scholarship. If you have a scholarship, it's full. The limit is on the NUMBER of athletes on scholarship. | Football (85 DI FBS), M Basketball (13), W Basketball (15), W Volleyball (12), W Tennis (8), W Gymnastics (12) |
| **Equivalency** | A fixed NUMBER of full scholarships can be divided among any number of athletes. An athlete might get 25%, 50%, 75%, or 100%. | Baseball (11.7 equivalencies), Soccer (9.9 M), Softball (12), Track (12.6), Swimming (9.9 M / 14 W) |

**Grant-in-Aid components** (post-Alston, 2021): tuition and fees, room and board, required course-related books, and other expenses related to attendance up to the full Cost of Attendance (COA). The COA stipend was a landmark change that added $2K-$6K per year beyond the traditional scholarship.

#### National Letter of Intent (NLI)
A binding agreement between a prospective student-athlete and an institution. Once signed, the student-athlete agrees to attend the institution for one academic year; the institution agrees to provide athletics financial aid for one academic year. Administered by the Collegiate Commissioners Association (CCA).

**Data object:** NLI status links to `AdmissionApplication`, `FinAidAward`, and `StudentGroup` (sport).

### NIL (Name, Image, Likeness)
Since July 1, 2021 (following the NCAA v. Alston Supreme Court decision and subsequent NCAA policy changes), student-athletes may profit from their name, image, and likeness. This includes: social media endorsements, personal appearances, autograph signings, camps/clinics, branded merchandise, and NIL agency representation.

**NIL collectives** are booster-organized entities that pool donor funds to create NIL opportunities for athletes. The line between NIL deals and recruiting inducements is the most contentious compliance issue in college athletics today.

**Data implications:** Institutions must track NIL disclosures (athletes are required to report NIL activity), ensure NIL deals don't violate pay-for-play rules (compensation must be for actual services), and monitor collective activity. This is an emerging data domain with no standardized data model yet.

### Academic Metrics

#### Academic Progress Rate (APR)
The NCAA's real-time academic metric for Division I teams, measured on a 1000-point scale.

**How it works:** Each scholarship student-athlete earns two points per term: one for **retention** (enrolled at the institution the next term) and one for **eligibility** (academically eligible). A team's APR is the total points earned divided by total points possible, multiplied by 1000.

**Example:** A team with 15 scholarship athletes, all retained and eligible for both fall and spring = 60/60 points = 1000 APR.

**Penalties for low APR:**
- Below 930 (4-year average): warnings, practice restrictions
- Below 900: competition restrictions, postseason ban, scholarship reductions
- The "930 multi-year rate" roughly corresponds to a 50% graduation rate

**HELIX Resource:** `StudentGroup` (athletes by sport) + `AcademicTermRecord` (per-term GPA, enrollment status) + `Enrollment` (full-time status). APR can be calculated from HELIX-shaped data.

#### Graduation Success Rate (GSR) vs. Federal Graduation Rate
| Metric | How It's Calculated | Key Difference |
|--------|-------------------|---------------|
| **Federal Graduation Rate** (IPEDS) | % of first-time, full-time freshmen who graduate within 6 years at the same institution | Counts transfers OUT as non-completers (penalizes institutions whose athletes transfer successfully) |
| **GSR** (NCAA) | Adds transfer students INTO the cohort and removes transfer-outs who left in good academic standing | More accurate picture of athletics academic success; GSR is typically 5-15 points higher than the federal rate |

### Title IX in Athletics
Title IX of the Education Amendments of 1972 prohibits sex discrimination in any educational program or activity receiving federal funding. In athletics, compliance is measured through a three-part test:

1. **Substantial Proportionality:** Athletics participation rates for each sex are substantially proportionate to enrollment rates
2. **History and Continuing Practice:** The institution has a history and continuing practice of program expansion for the underrepresented sex
3. **Effective Accommodation:** The interests and abilities of the underrepresented sex are fully and effectively accommodated

**Data requirements for Title IX compliance reviews:** roster sizes by sport by gender, scholarship dollars by gender, recruiting expenditures by gender, coaching compensation by gender, travel budgets by gender, facilities quality comparison, equipment/supplies spending, participation rates vs. enrollment proportions.

**HELIX Resource:** `StudentGroup` (athletics, with gender), `FinAidAward` (athletics scholarships by gender), `Enrollment` (enrollment by gender for proportionality)

### Athletics Financial Structure
Athletics departments are typically structured as a separate auxiliary fund or designated operating fund. Revenue sources and cost structure differ dramatically by division.

| Revenue Source | FBS | FCS | DII / DIII |
|---------------|-----|-----|-----------|
| **Media Rights / Conference Distribution** | $30M-$100M+ (Power 4) | $1M-$5M | Minimal |
| **Ticket Sales** | $10M-$50M+ (football, basketball) | $1M-$5M | Minimal |
| **Donor Contributions / Booster** | $10M-$50M+ | $2M-$10M | $500K-$2M |
| **Corporate Sponsorships / Multimedia Rights** | $5M-$30M | $1M-$5M | Minimal |
| **NCAA/Conference Distributions (tournament)** | Varies | $500K-$2M | $500K-$1M |
| **Institutional Subsidy** | $0-$20M | $5M-$20M | Most of budget |
| **Student Fees (athletics fee)** | $0-$10M | $5M-$15M | Common |

**Revenue sports vs. Olympic/non-revenue sports:** In most FBS programs, football and men's basketball generate revenue; all other sports operate at a loss. The athletics department subsidizes Olympic sports from football/basketball revenue and donor support.

**HELIX Resource:** `GLTransaction` (athletics fund), `Gift` (donor contributions to athletics), `Fund` (athletics fund code)

### Athletics Governance

| Role | Responsibility |
|------|---------------|
| **Athletics Director (AD)** | CEO of the athletics department. Reports to the President. |
| **Senior Woman Administrator (SWA)** | Highest-ranking female administrator in athletics. NCAA-designated role. |
| **Faculty Athletics Representative (FAR)** | Faculty member appointed by the President to represent academic interests. Liaison between athletics and the faculty/academic community. |
| **Compliance Officer** | Manages NCAA rules compliance: eligibility, recruiting, financial aid, amateurism, NIL. |
| **Student-Athlete Advisory Committee (SAAC)** | Student-athletes elected by peers to provide input on policies affecting student-athlete welfare. Required by NCAA. |

---

## Advancement & Alumni Relations — Deep Dive

### Gift Types

| Gift Type | Definition | HELIX Code | Data Considerations |
|-----------|-----------|------------|-------------------|
| **Outright Cash Gift** | Cash, check, credit card, wire, ACH | `cash` | Simplest. Counted at face value. |
| **Pledge** | A commitment to give a specific amount over time (typically 3-5 years) | `pledge` | Must track pledge payment schedule, payments received, balance, reminders, and write-offs. Distinguish pledge from bequest expectancy. |
| **Matching Gift** | Employer matches the employee's gift (typically 1:1 or 2:1) | `matching` | Must verify match eligibility and submit claim to employer. Track match amount separately from the employee's gift. |
| **Planned Gift (Bequest)** | A gift through a will or estate plan | `bequest` | Counted at face value in campaigns (varies by institution). Irrevocable vs. revocable. Estate expectancy tracking. |
| **Charitable Remainder Trust (CRT)** | Donor transfers assets to a trust; receives income for life; remainder goes to institution | `crt` | Complex valuation (present value of remainder interest). Requires trust administration data. |
| **Charitable Gift Annuity (CGA)** | Donor gives assets; institution pays fixed annuity for life; remainder is a gift | `cga` | Requires annuity payment tracking. ACGA rates. State registration requirements. |
| **Gift-in-Kind** | Non-cash gifts: artwork, equipment, real estate, books, software | `gift_in_kind` | Requires independent appraisal for gifts valued >$5,000. IRS Form 8283. |
| **Securities (Stock)** | Publicly traded stocks, bonds, mutual funds | `securities` | Value = mean of high and low on date of gift. Transfer via DTC or physical delivery. |
| **IRA Charitable Rollover (QCD)** | Direct transfer from IRA to institution by donors 70.5+ | `ira_rollover` | Up to $105K/year (2024). Counts toward RMD. Not a tax deduction but excluded from income. |
| **Cryptocurrency** | Bitcoin, Ethereum, etc. | `cryptocurrency` | Valued at fair market value on date of gift. Most institutions immediately liquidate. |

**HELIX Resource:** `Gift`, **HELIX Terminology:** `helix/gift-type`

### Campaign Management

**Comprehensive Campaign:** A multi-year fundraising initiative (typically 5-10 years) with a public dollar goal. Phases:

1. **Feasibility Study** — Consultant interviews top donors/stakeholders to assess capacity and willingness. Recommends a goal.
2. **Silent Phase** — Solicit lead gifts (40-60% of goal) before going public. Typically 2-3 years.
3. **Public Phase** — Launch publicly, broaden solicitation to the full constituency. Typically 3-5 years.
4. **Victory Celebration** — Goal reached (or exceeded). Public announcement and recognition events.

**Campaign counting rules** vary by institution but typically follow CASE (Council for Advancement and Support of Education) standards:
- Outright gifts: full face value
- Pledges: full face value (even if payments span beyond the campaign)
- Planned gifts: present value of the charitable portion (or face value, depending on policy)
- Government grants: some campaigns count them, others don't
- Testamentary commitments: may count at face value or discounted

**HELIX Resource:** `Campaign` (campaign phases, goals, progress), `Gift` (individual gifts linked to campaign designations)

### Stewardship
The practice of acknowledging gifts, reporting impact, and maintaining the donor relationship post-gift.

**Best practices:** Thank within 24-48 hours. Provide an official gift receipt (IRS requirement for cash gifts >$250). Send an annual endowment report showing: original gift, market value, spending, and the impact the spending funded. For named spaces: plaque installation, dedication ceremony. For endowed chairs: introduce the donor to the faculty holder.

**Stewardship matrix:** Higher-level donors receive more touches. A $100 annual fund donor gets an email thank-you and a tax receipt. A $1M+ donor gets a personal call from the President, a handwritten note, event invitations, an annual impact visit, and a named recognition opportunity.

**HELIX Resource:** `EngagementActivity` (stewardship touches), `Constituent` (stewardship plan)

### Endowment Management

| Concept | Definition |
|---------|-----------|
| **Corpus** | The original gift amount (principal). Never spent. Invested to generate income. |
| **Market Value** | Current value of the endowment investment. Fluctuates with market performance. |
| **Spending Policy** | The annual payout rate applied to the endowment. Typically 4-5% of a trailing 12-quarter average market value. |
| **Underwater Endowment** | An endowment whose current market value has fallen below the original gift (corpus). UPMIFA (Uniform Prudent Management of Institutional Funds Act) governs whether spending is permitted from underwater endowments (most states allow continued spending with prudence). |
| **Quasi-Endowment** | Funds the institution's board has chosen to treat as endowment (invested, with a spending policy) but that could legally be spent in full. The board can reverse the endowment designation. |

**HELIX Resource:** `Fund` (fund_category: `endowment_true` or `endowment_quasi`), `Gift` (gifts to endowments)

### Prospect Research & Management

**Wealth screening tools:** DonorSearch, WealthEngine, iWave, Windfall. These match constituent records against external data (real estate, SEC filings, business ownership, political donations, foundation grants) to estimate capacity.

| Metric | Definition |
|--------|-----------|
| **Capacity Rating** | Estimated total gift capacity (what they could give). Typically a dollar range ($100K-$500K, $1M-$5M, etc.). |
| **Propensity Score** | Likelihood of making a gift, based on behavioral indicators (engagement, past giving, connection to institution). |
| **Affinity Indicators** | Signals of connection: degree holder, parent, former athlete, volunteer, event attendee, email engager. |
| **RFM Analysis** | Recency (when was last gift), Frequency (how often they give), Monetary (how much they give). Classic segmentation for annual fund. |

**Moves Management (Detailed Pipeline):**

| Stage | Activity | Typical Duration |
|-------|---------|-----------------|
| **Identification** | Wealth screen flags the prospect; research reviews and qualifies | Days to weeks |
| **Qualification** | Initial outreach to assess interest and connection. Is this person assignable? | 1-3 months |
| **Cultivation** | Relationship building: meetings, campus visits, event invitations, faculty introductions, project tours | 6-24 months |
| **Solicitation** | The ask. May be a single conversation or a written proposal. Ideally face-to-face. | 1-3 months |
| **Stewardship** | Thank, receipt, report impact, maintain relationship for next gift | Ongoing |

**Major Gift Officer (MGO) portfolio:** Typically 100-150 prospects per MGO. Metrics: visits per month (10-15), proposals submitted, dollars raised, pipeline movement.

**HELIX Resource:** `Constituent` (prospect_stage, giving_capacity, donor_segment), `EngagementActivity` (cultivation and stewardship activities), **HELIX Terminology:** `helix/prospect-stage`

### Alumni Relations

**Alumni Engagement Score:** A composite metric (typically 0-100) based on:
- Event attendance (homecoming, reunions, chapter events, campus visits)
- Email engagement (opens, clicks)
- Volunteer activity (mentoring, admissions ambassadors, career panels)
- Social media interaction
- Giving (amount, frequency, recency)
- Board/committee service

**Why it matters:** Engagement is the leading indicator of giving. Non-donor alumni with high engagement scores are the best prospects for first-time gifts.

**Key alumni metrics:**
- **Reunion Giving Rate:** % of a class that gives during their reunion year (5th, 10th, 25th, 50th)
- **Class Participation Rate:** % of living alumni in a class who have given this fiscal year. Historically important for rankings (U.S. News used to weight it heavily).
- **Alumni Association Membership:** At institutions with dues-based associations, membership data is a key engagement indicator.

**HELIX Resource:** `Constituent.engagement_score`, `EngagementActivity`

### Annual Fund / Phonathon

| Term | Definition |
|------|-----------|
| **Annual Giving** | Gifts to the institution's annual operating support (unrestricted or broadly designated). Typically gifts under $10K-$25K. |
| **Leadership Annual Giving** | Annual gifts at a higher level ($1K-$25K). Named giving societies (e.g., "President's Circle" for $1K+). |
| **Young Alumni** | Recent graduates (typically first 10 years). Special outreach and lower giving levels expected. |
| **LYBUNT** | Last Year But Unfortunately Not This (year). Donors who gave last fiscal year but have not yet given this year. High priority for renewal. |
| **SYBUNT** | Some Years But Unfortunately Not This (year). Donors who have given in the past but not recently and not last year. Re-engagement target. |
| **Consecutive Giving Streak** | Number of consecutive years a donor has given. A 20-year streak donor who stops is a high-priority recovery target. |
| **Giving Day** | A 24-36 hour fundraising blitz (often online, with challenges and matching gifts). |
| **Phonathon** | Student callers reaching alumni by phone to solicit annual fund gifts. Declining in effectiveness but still a pipeline builder. Being replaced by texting, digital, and peer-to-peer campaigns. |

**HELIX Terminology:** `helix/donor-segment` (renewing, upgrading, lapsed, LYBUNT, SYBUNT, recaptured)

### Advancement Services

| Function | What It Does | Data Governance Concern |
|----------|-------------|----------------------|
| **Biographical Data Management** | Maintaining accurate name, address, phone, email, employer, relationship data for all constituents | Data hygiene is advancement's top data challenge. Duplicate records, deceased processing, and NCOA (National Change of Address) updates are ongoing. |
| **Constituent Codes** | Classifying each record: alumnus, parent, friend, faculty/staff, corporation, foundation | One person can hold multiple codes (alumnus + parent + employee). |
| **Entity Management** | Tracking both individuals and organizations (foundations, companies, family trusts) as donors | Organizations need different data structures than individuals. |
| **Relationship Tracking** | Recording who is connected to whom: spouse, child, grandparent, employer, board colleague | Critical for planned giving (who is the executor?), family giving strategies, and event seating. |
| **Deceased Processing** | Verifying and recording deaths, updating records, stopping solicitations, triggering bequest review | Failure to process deceased records quickly results in embarrassing solicitation mailings to the deceased. |
| **NCOA (National Change of Address)** | USPS service that provides updated mailing addresses for constituents who have moved | Run quarterly or semi-annually. Reduces undeliverable mail costs. |

**HELIX Resource:** `Constituent` (constituent_type, relationships), **HELIX Terminology:** `helix/constituent-type`

---

## Information Technology & Institutional Research

### Enterprise Architecture in Higher Education
Most institutions run a complex ecosystem of systems that must integrate:

| System | Purpose | Common Products |
|--------|---------|----------------|
| **Student Information System (SIS)** | Enrollment, registration, grades, degrees | PeopleSoft CS, Banner, Workday Student, Colleague |
| **Human Resources / Payroll** | Employee records, compensation, benefits, payroll | PeopleSoft HCM, Banner HR, Workday HCM |
| **Finance / ERP** | General ledger, AP, AR, budgets, purchasing | PeopleSoft Financials, Banner Finance, Workday Financials |
| **Learning Management System (LMS)** | Online course delivery, assignments, grades | Canvas (Instructure), Blackboard, D2L Brightspace, Moodle |
| **CRM (Admissions)** | Recruitment funnel management | Slate (Technolutions), Salesforce, TargetX, Radius |
| **Advancement / Fundraising** | Donor management, gift processing, campaigns | Raiser's Edge (Blackbaud), Advance (Ellucian), Salesforce, ThankView |
| **Identity Management** | SSO, directory services, account provisioning | Shibboleth, Azure AD, Okta, CAS |
| **Data Warehouse / Data Lake** | Analytics, reporting, institutional research | Snowflake, Databricks, AWS (Redshift, S3, Glue, Athena), Azure Synapse |
| **BI / Reporting** | Dashboards and visualizations | Amazon QuickSight, Tableau, Power BI, Cognos |

**HELIX's role:** The data standard that sits at the silver layer of the data lake, normalizing data from all of these source systems into one governed vocabulary.

### Institutional Research (IR)

The office responsible for institutional data analysis, reporting, and strategic decision support. Functions include:

- **IPEDS Reporting:** Submitting required federal data (enrollment, completions, graduation rates, financial aid, finance, HR). Three collection periods per year.
- **Common Data Set (CDS):** A standardized data template completed annually, used by guidebook publishers (U.S. News, Princeton Review, Peterson's) and internally.
- **Fact Book:** An annual publication of institutional statistics (enrollment, degrees, faculty, finances, retention).
- **Peer Analysis:** Benchmarking against peer institutions using IPEDS data, CUPA-HR salary surveys, and other sources.
- **Accreditation Support:** Providing data for self-study documents and accreditation reviews.
- **Ad Hoc Analysis:** Enrollment projections, tuition modeling, space utilization, course demand analysis, and every other data question leadership asks.

**HELIX Resource:** `Institution`, `AcademicTermRecord`, `Enrollment`, and the full Core resource set feed IR's work. The HELIX data dictionary is designed to be the IR office's shared vocabulary.

### Key Performance Indicators for Higher Education

| KPI | What It Measures | Typical Source |
|-----|-----------------|---------------|
| **Retention Rate** | Fall-to-fall return rate for FTFT cohort | `Student`, `Enrollment`, `AcademicTermRecord` |
| **Graduation Rate** | 4-year, 6-year completion rates | `Degree`, `Student` (cohort) |
| **Student-to-Faculty Ratio** | FTE students / FTE instructional faculty | `Enrollment`, `Employee` |
| **Net Tuition Revenue per Student** | (Gross tuition - institutional aid) / enrollment | `ARTransaction`, `FinAidAward` |
| **Discount Rate** | Institutional aid / gross tuition revenue | `FinAidAward`, `ARTransaction` |
| **Composite Financial Index (CFI)** | Weighted composite of four financial ratios (primary reserve, viability, return on net assets, net operating revenues) | `GLTransaction`, `Fund`, `Budget` |
| **Endowment per Student** | Endowment market value / FTE enrollment | `Fund` (endowment), `Enrollment` |
| **Alumni Giving Rate** | % of living alumni who gave this FY | `Constituent`, `Gift` |
| **Research Expenditures** | Total sponsored program spending | `Grant`, `GLTransaction` |
| **Cost per Degree** | Total E&G expenditures / degrees awarded | `GLTransaction`, `Degree` |

---

*HELIX Glossary v0.3.0 — September 2026*
*Part of the [HELIX Open Framework](https://github.com/utopify/helix)*