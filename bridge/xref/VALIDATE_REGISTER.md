# PeopleSoft to Workday VALIDATE Register

83 crosswalk rows are marked VALIDATE. The value is realistic and commonly documented, but it differs by institution, PeopleSoft configuration, or Workday tenant. Confirm each one against your configuration workbook before mock load 1, then open a pull request if your institution can confirm or correct it.

| Module | Crosswalk | PS value | What to confirm |
|---|---|---|---|
| HR | `absence-type-xref` | VAC | Convert balances as of cutover, not full accrual history. VALIDATE: take code names. |
| HR | `compensation-xref` | OVL | Often calculated per credit hour. VALIDATE: ERNCD value (OVL, OLD, OVLD vary). |
| HR | `compensation-xref` | ACT | VALIDATE: rate code value. |
| HR | `compensation-xref` | ONC | VALIDATE: ERNCD value. |
| HR | `compensation-xref` | LNG | Common under state pay plans. VALIDATE: rate code value. |
| HR | `compensation-xref` | HSG | Confirm taxability configuration in Workday Payroll. VALIDATE: ERNCD value. |
| HR | `deduction-benefit-xref` | 4x (457) | VALIDATE: plan type number used locally (commonly 41-49). |
| HR | `deduction-benefit-xref` | 4x (DB) | Public institutions often model state pension as a deduction only. VALIDATE: local plan type. |
| HR | `deduction-benefit-xref` | HSA | VALIDATE: PS has no single delivered HSA plan type; often a savings plan or DEDCD. |
| HR | `deduction-benefit-xref` | TUI | Taxable portion above IRS 127 limit needs an imputed income earning. VALIDATE: custom code. |
| HR | `deduction-benefit-xref` | EAP | Usually no deduction. VALIDATE: may not exist in PS. |
| HR | `employment-status-xref` | S | Workday has no native Suspended status; model as a Leave Type. VALIDATE: tenant leave type name. |
| HR | `employment-status-xref` | Z | Some institutions use L with a furlough ACTION_REASON instead. VALIDATE: local status code. |
| HR | `flsa-eeo-xref` | X (teaching) | PS has no separate teaching code; derive from faculty job family. VALIDATE: some tenants use V or custom values for other exempt categories. |
| HR | `flsa-eeo-xref` | 1 | Workday stores EEO-1, EEO-4 and IPEDS as separate Job Classification Groups. VALIDATE: numeric code values differ between EEO-4 and IPEDS. |
| HR | `flsa-eeo-xref` | 5 | Legacy category; newer IPEDS SOC-based categories may apply. VALIDATE. |
| HR | `job-action-xref` | DTA | Many DTA rows are corrections. Rows that change nothing Workday tracks should collapse or be skipped. VALIDATE: review DTA volume before con |
| HR | `job-action-xref` | SUS | VALIDATE: suspension leave type exists in tenant. |
| HR | `job-code-to-profile-xref` | STF700 | Union step schedules usually become Grade Profiles with Steps. VALIDATE: union codes. |
| HR | `pay-frequency-xref` | M (9/12) | PS contract pay or deferred pay becomes Workday academic pay (salary earned over 9, paid over 12, with accrual). This is the most error-pron |
| HR | `pay-frequency-xref` | C | VALIDATE: PS has no delivered per-course frequency; most institutions use ADDL_PAY or a custom code. |
| HR | `position-xref` | F | VALIDATE: POSN_STATUS values (A approved, F frozen, P proposed are common). |
| HR | `worker-type-xref` | EMP + T | Workday often uses Fixed Term for defined end dates; set End_Employment_Date on hire. VALIDATE: tenant Employee Type values. |
| HR | `worker-type-xref` | EMP + S | Keep FICA student exemption logic in payroll. VALIDATE: EMPL_CLASS value for students varies by institution (S, STU, H). |
| HR | `worker-type-xref` | EMP + G | Tuition remission is not a comp element in Workday HCM; coordinate with Workday Student waiver setup. VALIDATE: EMPL_CLASS code. |
| HR | `worker-type-xref` | EMP + A | Adjuncts in Workday usually also get an Academic Appointment track. Per-course pay maps to pay-frequency per_course. VALIDATE: EMPL_CLASS co |
| HR | `worker-type-xref` | EMP + P | NIH NRSA trainee postdocs may not be employees; route those to fellow. VALIDATE: EMPL_CLASS code. |
| HR | `worker-type-xref` | EMP + I | Unpaid interns belong as Contingent Worker or not loaded. VALIDATE: EMPL_CLASS code. |
| HR | `worker-type-xref` | POI + FEL | POIs have no JOB row in PS. Decide per POI type whether to load as Contingent Worker, Academic Affiliate, or not at all. VALIDATE: POI_TYPE  |
| HR | `worker-type-xref` | POI + VOL | Often excluded from conversion. VALIDATE: POI_TYPE codes. |
| HR | `worker-type-xref` | POI + EMR | Emeritus retirees are terminated employees who need an affiliate record for privileges. VALIDATE: POI_TYPE codes. |
| FIN | `business-unit-company-xref` | MED01 | VALIDATE: if Medicine is a separate legal entity or practice plan, it becomes its own Company. |
| FIN | `business-unit-company-xref` | HOSP1 | Often out of scope for the university Workday tenant. VALIDATE. |
| FIN | `project-grant-xref` | A | VALIDATE: PS award status values. |
| FIN | `project-grant-xref` | CONTRACT | PS Contracts drives sponsor billing; Workday links billing to the Award. VALIDATE billing model. |
| FIN | `vendor-supplier-xref` | R (Regular) | VALIDATE: VENDOR_CLASS delivered values. |
| FIN | `vendor-supplier-xref` | Vendor category | VALIDATE: many PS vendors have no category; derive from spend history. |
| SIS | `academic-career-level-xref` | GRAD | Some institutions define a separate DOCT career. VALIDATE. |
| SIS | `academic-career-level-xref` | MED | Medical programs often run non-standard periods; VALIDATE period design. |
| SIS | `academic-career-level-xref` | DENT | VALIDATE: career code is institution defined. |
| SIS | `academic-career-level-xref` | PHRM | VALIDATE: career code is institution defined. |
| SIS | `admit-type-xref` | FYR | VALIDATE: ADMIT_TYPE codes are institution defined. |
| SIS | `admit-type-xref` | COND | VALIDATE: often ADMT with a PROG_REASON rather than a separate action. |
| SIS | `admit-type-xref` | WAIT | VALIDATE: institution-defined action. |
| SIS | `enrollment-status-xref` | E / ENRL | VALIDATE: exact Workday status label. |
| SIS | `fin-aid-item-type-xref` | PELL | VALIDATE: ITEM_TYPE value is local. Pell LEU history comes from NSLDS, not PS. |
| SIS | `fin-aid-item-type-xref` | TUITWV | VALIDATE: employee and dependent remission may be modeled as a sponsor or a benefit instead of aid. |
| SIS | `grading-basis-xref` | OPT | VALIDATE: some tenants model student option as allowed grading bases on the course section. |
| SIS | `identifier-xref` | EMPLID | Many institutions keep the PS EMPLID value as the Workday Student ID for continuity on transcripts and ID cards. VALIDATE: confirm Student I |
| SIS | `identifier-xref` | PASSPORT | Carry issuing country and expiration. VALIDATE: PS record name varies by release (CITIZEN_PSSPRT). |
| SIS | `identifier-xref` | EXT: SLATE | VALIDATE: EXTERNAL_SYSTEM type codes are institution defined. |
| SIS | `identifier-xref` | EXT: SEVIS | Restricted. VALIDATE: some tenants model SEVIS on the International Student data instead of Other ID. |
| SIS | `identifier-xref` | EXT: NSC | VALIDATE: many institutions do not store an NSC ID and match on name plus DOB. |
| SIS | `instruction-mode-xref` | P | INSTRUCTION_MODE values are configurable. VALIDATE codes. |
| SIS | `instruction-mode-xref` | OS | VALIDATE: institution-defined code. |
| SIS | `instruction-mode-xref` | HF | VALIDATE: institution-defined code. |
| SIS | `instruction-mode-xref` | INT | VALIDATE: FLD or PRA may be used instead of INT. |
| SIS | `program-plan-xref` | HIST-MIN | VALIDATE: tenants differ on modeling minors as Programs of Study versus a separate minor construct. |
| SIS | `program-plan-xref` | CS-MS | Thesis and non-thesis tracks usually become Concentrations or Program of Study variants. VALIDATE. |
| SIS | `program-plan-xref` | CS-MS-BSMS | Shared-credit rules must be rebuilt as academic requirements. VALIDATE. |
| SIS | `program-status-xref` | PM / DEIN | VALIDATE: DEIN is an institution-defined action in many implementations. |
| SIS | `program-status-xref` | AC / MATR | Matriculation creates the Program of Study Record. VALIDATE event name. |
| SIS | `program-status-xref` | SP / SPND | VALIDATE: some institutions keep suspended students active with a registration hold. |
| SIS | `service-indicator-hold-xref` | PRK | VALIDATE: some institutions retire parking holds at migration. |
| SIS | `term-period-xref` | 2252 | VALIDATE: STRM numbering convention. |
| SIS | `term-period-xref` | 2252 / 1 | If the regular session covers the full term, some tenants skip the child period. VALIDATE. |
| Student | `sap-status-xref` | MEET | VALIDATE: local code (MEET, GOOD, SAT are common). |
| Student | `sap-status-xref` | WARN | Only valid for schools that evaluate every payment period (34 CFR 668.34). VALIDATE: local code. |
| Student | `sap-status-xref` | PROB | Probation only follows an approved appeal. VALIDATE: local code. |
| Student | `sap-status-xref` | PLAN | Load the plan as a Workday Academic Plan so later evaluations check plan progress, not the standard. VALIDATE: local code. |
| Student | `sap-status-xref` | SUSP | Hard stop for disbursement. Part of the SAP carryover gate. VALIDATE: local code. |
| Student | `sap-status-xref` | MAXT | Keep the reason. Maximum timeframe suspensions can't be cured by grades alone. VALIDATE: local code. |
| Student | `verification-status-xref` | Checklist Initiated | VALIDATE: checklist item status codes are local. |
| Student | `verification-status-xref` | All items Received | VALIDATE: local code. |
| Student | `verification-status-xref` | Under Review | VALIDATE: local code. |
| Student | `verification-status-xref` | Not Completed | No Pell or campus-based aid. VALIDATE: local code. |
| Student | `loan-type-xref` | DLSUB | Undergraduates only. Subsidized usage limit history comes from NSLDS. VALIDATE: local code. |
| Student | `loan-type-xref` | DLUNS | VALIDATE: local code. |
| Student | `loan-type-xref` | DLPLS | Borrower is the parent. Map the parent as a separate HELIX Person; don't overwrite student identity. VALIDATE: local code. |
| Student | `loan-type-xref` | DLGPL | VALIDATE: local code, and check current federal eligibility rules for new Grad PLUS borrowers. |
| Student | `loan-type-xref` | ALT | Needs self-certification tracking. VALIDATE: local item types (often one per lender). |
| Student | `loan-type-xref` | INST | Servicing usually lives in Student Financials or a third party. VALIDATE: local code. |
| Student | `disbursement-status-xref` | Authorized | VALIDATE: authorization logic differs by release. |

*Updated for HELIX v0.8.0, September 2026*
