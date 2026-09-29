# PeopleSoft to Workday Reconciliation Pack

22 SQL templates that prove a PeopleSoft to Workday conversion is correct. Every query compares both systems through HELIX Silver, so the same query works no matter how each side was extracted.

## Run order

| Track | Order | Query | Gate |
|-------|------:|-------|------|
| FIN | 1 | `worktag_completeness_check.sql` | Before posting any converted journal |
| FIN | 2 | `trial_balance_tieout.sql` | Must tie to the penny |
| FIN | 3 | `fund_balance_tieout.sql` | Restriction class must match |
| FIN | 4 | `open_ap_tieout.sql` | Before the first Workday payment run |
| FIN | 5 | `open_po_encumbrance_tieout.sql` | Before budget checking goes live |
| FIN | 6 | `grant_budget_to_actual_tieout.sql` | Each parallel month-end |
| HCM | 1 | `headcount_tieout.sql` | Each worker mock load |
| HCM | 2 | `position_count_tieout.sql` | Before hiring opens in Workday |
| HCM | 3 | `compensation_total_tieout.sql` | After comp conversion |
| HCM | 4 | `benefit_enrollment_tieout.sql` | Before first Workday deduction |
| HCM | 5 | `leave_balance_tieout.sql` | After first Workday accrual run |
| HCM | 6 | `payroll_parallel_compare.sql` | Every parallel cycle (2 minimum) |
| Student | 1 | `ferpa_restriction_carryover_check.sql` | HARD GATE: before any student data is visible |
| Student | 2 | `active_student_tieout.sql` | Each student mock |
| Student | 3 | `program_of_study_tieout.sql` | After program conversion |
| Student | 4 | `enrollment_credit_tieout.sql` | After registration conversion |
| Student | 5 | `gpa_recompute_check.sql` | After academic history conversion |
| Student | 6 | `student_account_balance_tieout.sql` | Before first Workday billing run |
| Aid | 1 | `sap_status_carryover_check.sql` | HARD GATE: before the first Workday disbursement |
| Aid | 2 | `aid_award_total_tieout.sql` | Each aid mock, and at cutover for every open award year |
| Aid | 3 | `loan_record_tieout.sql` | Before any Workday loan origination or disbursement |
| Aid | 4 | `disbursement_cod_tieout.sql` | Before the first Workday disbursement, then monthly |

## Tolerances

| Area | Tolerance |
|------|-----------|
| GL, fund balance, AP, encumbrance, grants, student accounts | 0.00 |
| Payroll components | 0.01 per component per worker |
| Annualized compensation | 1.00 per worker (rounding on 9-over-12 annualization) |
| Leave balances | 0.01 hours |
| GPA | 0.005 |
| FERPA restriction carryover | Zero misses. No tolerance. |
| Aid awards, disbursements, loans, COD totals | 0.00 |
| SAP status carryover | Zero misses. No tolerance. |

## Parallel-run cadence

- FIN: at least one full month-end close in parallel, ideally a quarter-end.
- Payroll: at least two full cycles, including one with benefits deductions and one supplemental or off-cycle run.
- Student: one registration window and one grade posting cycle if timing allows.
- Aid: one disbursement run in parallel before Workday disburses on its own, and a COD reconciliation after it. Time cutover away from the start of a payment period.

## Sign-off

| Track | Signs off (govern/roles.json) |
|-------|-------------------------------|
| FIN | Data Steward, Financial Operations; Controller as Data Trustee |
| HCM | Data Steward, Human Resources; Payroll Director for payroll |
| Student | University Registrar (Data Steward); FERPA check also signed by the institution's FERPA compliance officer |
| Aid | Director of Financial Aid (Data Steward); COD tie-out also signed by the Bursar |

Compensation, payroll, benefits, student account, and all Aid queries touch restricted data. Run them under `helix_analyst_restricted` per `govern/lakehouse-rbac-model.json`.
