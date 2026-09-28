# HELIX Bridge: Banner Financial Aid

Financial Aid module mappings from Ellucian Banner to HELIX Core Financial Aid resources.

## Mappings (7 resources)

| HELIX Resource | Mapping File | Key Banner Tables | Attrs |
|---------------|-------------|-------------------|-------|
| FinAidAward | `fin_aid_award_mapping.json` | RPRAWRD, RFRBASE, RTVFTYP, RFRMGMT | 24 |
| AidApplication | `aid_application_mapping.json` | RCRAPP1-4, RCRESAR, RORSTAT, RCRLDS4 | 26 |
| AidPackage | `aid_package_mapping.json` | RORSTAT, RBRCOMP, RPRATRM, RNRNA05 | 26 |
| Verification | `verification_mapping.json` | RRRAREQ, RTVTREQ, RORSTAT, RCRTPGP | 19 |
| SAPEvaluation | `sap_evaluation_mapping.json` | RORSTAT, RHRTPADV, RTVSAPR | 20 |
| Disbursement | `disbursement_mapping.json` | RPRADSB, RPRAWRD, ROBINST | 23 |
| LoanRecord | `loan_record_mapping.json` | RPRLORG, RPRAWRD, RORLOAN | 26 |

## Key Banner Financial Aid Table Prefixes

| Prefix | Meaning | Examples |
|--------|---------|----------|
| **RPR** | Financial aid aPplicant Records | RPRAWRD (award), RPRATRM (award by term), RPRADSB (disbursement), RPRLORG (loan origination) |
| **RCR** | Financial aid appliCant Records | RCRAPP1-4 (FAFSA/ISIR), RCRESAR (SAR/ISIR results), RCRLDS4 (NSLDS) |
| **RRR** | Financial aid Requirements | RRRAREQ (applicant requirements/tracking) |
| **ROR** | Financial aid ORganization/status | RORSTAT (applicant status), ROBINST (institution options), RORLOAN (loan status) |
| **RFR/RBR/RHR** | Fund base / budget / history | RFRBASE (fund base), RBRCOMP (budget components), RHRTPADV (academic progress) |
| **RTV** | Financial aid validation | RTVFTYP (fund type), RTVTREQ (tracking requirement), RTVSAPR (SAP status) |

Banner Financial Aid is **aid-year centric** (AIDY codes, e.g. `2526`). Awards, applications, and status all key on PIDM + aid year, with term-level detail in RPR*TRM tables. Post-2024 FAFSA Simplification: the ISIR `PRIMARY_EFC` field now carries the **Student Aid Index (SAI)**.
