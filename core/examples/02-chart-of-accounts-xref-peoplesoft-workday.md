# HELIX Post-Migration Example: Chart of Accounts Cross-Reference (PeopleSoft → Workday)

> Mapping PeopleSoft Financials chartfields to Workday Financial worktags, creating a reusable XREF table, and illustrating how the same year-end financial report looks in both systems through the HELIX foundational layer.

---

## The Scenario

**Regional University** is migrating from PeopleSoft Financials (FSCM) to Workday Financial Management. The biggest structural challenge isn't data volume. It's the **chart of accounts**: PeopleSoft uses "chartfields" (Account, Fund, Department, Program, Class, Project) while Workday uses "worktags" (Ledger Account, Fund, Cost Center, Revenue Category, Spend Category, Grant). They aren't 1:1.

HELIX Bridge provides the structural mapping. This example shows the cross-reference table and how it's used in practice.

---

## The Structural Difference

### PeopleSoft Chartfields
PeopleSoft encodes financial context through 7 chartfield dimensions on every transaction:

| Chartfield | What It Answers | Example |
|-----------|----------------|---------|
| **Business Unit** | Which entity? | `UNIV1` (Main Campus) |
| **Account** | What type of money? | `52100` (Travel Expense) |
| **Fund** | Why/restriction? | `11000` (Unrestricted General) |
| **Department** | Who spent it? | `120400` (Computer Science Dept) |
| **Program** | What function? | `INSTR` (Instruction) |
| **Class** | Additional detail? | `100` (State Appropriation) |
| **Project** | Which grant/initiative? | `GR-NSF-2024-001` |

### Workday Worktags
Workday uses a flatter, more flexible "worktag" system:

| Worktag | What It Answers | Example |
|---------|----------------|---------|
| **Company** | Which entity? | `Regional University` |
| **Ledger Account** | What type of money? | `6200 - Travel` |
| **Fund** | Why/restriction? | `FD100 - General Operating` |
| **Cost Center** | Who spent it? | `CC-CS - Computer Science` |
| **Revenue Category** | Revenue source? | `State Appropriation` |
| **Spend Category** | What was bought? | `SC-TRAVEL - Domestic Travel` |
| **Grant** | Which grant? | `GR-NSF-2024-001` |

### HELIX as the Bridge

HELIX normalizes both into a foundational financial dimension model. The XREF table maps each PeopleSoft chartfield value to its Workday worktag equivalent through a HELIX intermediate.

---

## The XREF Table

### Account → Ledger Account

| PS Account | PS Description | HELIX Account Code | HELIX Category | Workday Ledger Account | WD Description |
|-----------|---------------|-------------------|----------------|----------------------|----------------|
| 40100 | Tuition Revenue | REV-TUITION | Revenue | 4010 | Tuition and Fees |
| 40200 | Fee Revenue | REV-FEES | Revenue | 4020 | Student Fees |
| 40500 | State Appropriation | REV-STATE-APPROP | Revenue | 4050 | Government Appropriations |
| 40600 | Federal Grants Revenue | REV-FED-GRANT | Revenue | 4060 | Federal Grant Revenue |
| 41000 | Auxiliary Revenue | REV-AUX | Revenue | 4100 | Auxiliary Enterprises |
| 42000 | Gift Revenue | REV-GIFT | Revenue | 4200 | Contributions and Gifts |
| 42500 | Endowment Income | REV-ENDOW | Revenue | 4250 | Investment Income - Endowment |
| 50100 | Faculty Salaries | EXP-SAL-FACULTY | Expense | 6010 | Faculty Compensation |
| 50200 | Staff Salaries | EXP-SAL-STAFF | Expense | 6020 | Staff Compensation |
| 50300 | Student Wages | EXP-SAL-STUDENT | Expense | 6030 | Student Employee Wages |
| 51000 | Employee Benefits | EXP-BENEFITS | Expense | 6100 | Employee Benefits |
| 52100 | Travel - Domestic | EXP-TRAVEL-DOM | Expense | 6200 | Travel - Domestic |
| 52200 | Travel - International | EXP-TRAVEL-INTL | Expense | 6210 | Travel - International |
| 53000 | Supplies & Materials | EXP-SUPPLIES | Expense | 6300 | Supplies and Materials |
| 54000 | Equipment (<$5K) | EXP-EQUIP-MINOR | Expense | 6400 | Non-Capital Equipment |
| 55000 | Contractual Services | EXP-CONTRACT | Expense | 6500 | Professional Services |
| 56000 | Utilities | EXP-UTILITIES | Expense | 6600 | Utilities |
| 57000 | Scholarships & Fellowships | EXP-SCHOLAR | Expense | 6700 | Scholarships and Fellowships |
| 58000 | Depreciation | EXP-DEPREC | Expense | 6800 | Depreciation Expense |
| 60000 | Capital Equipment (>$5K) | ASSET-EQUIP-CAP | Asset | 1600 | Capital Equipment |
| 70000 | Accounts Payable | LIAB-AP | Liability | 2100 | Accounts Payable |
| 80000 | Net Assets - Unrestricted | EQUITY-UNREST | Net Assets | 3100 | Net Assets Without Restriction |
| 80500 | Net Assets - Restricted | EQUITY-REST | Net Assets | 3200 | Net Assets With Restriction |

### Fund → Fund Worktag

| PS Fund | PS Description | HELIX Fund Category | Workday Fund | WD Description |
|---------|---------------|-------------------|-------------|----------------|
| 11000 | Unrestricted General | unrestricted_general | FD100 | General Operating |
| 12000 | Designated Operating | unrestricted_designated | FD110 | Board Designated |
| 13000 | Auxiliary Enterprises | auxiliary | FD200 | Auxiliary Operations |
| 14000 | Service Centers | service_center | FD210 | Internal Services |
| 21000 | Restricted - Federal | restricted_federal | FD300 | Federal Grants |
| 22000 | Restricted - State | restricted_state | FD310 | State Grants |
| 23000 | Restricted - Private | restricted_private | FD320 | Private Restricted |
| 30000 | Endowment - Permanent | endowment_true | FD400 | True Endowment |
| 31000 | Endowment - Quasi | endowment_quasi | FD410 | Quasi-Endowment |
| 40000 | Plant - Unexpended | plant_unexpended | FD500 | Capital Projects |
| 41000 | Plant - Renewal | plant_renewal | FD510 | Renewal and Replacement |
| 42000 | Plant - Retirement of Debt | plant_debt | FD520 | Debt Service |
| 50000 | Student Financial Aid | student_aid | FD600 | Student Aid |
| 60000 | Agency/Custodial | agency | FD700 | Agency Funds |

### Department → Cost Center

| PS DeptID | PS Description | HELIX Org Code | Workday Cost Center | WD Description |
|----------|---------------|---------------|-------------------|----------------|
| 100100 | Office of the President | PRES | CC-PRES | President's Office |
| 100200 | Office of the Provost | PROV | CC-PROV | Provost's Office |
| 110100 | College of Arts & Sciences - Dean | A&S-DEAN | CC-AS-DEAN | A&S Dean's Office |
| 110200 | English Department | ENGL | CC-ENGL | English |
| 110300 | Mathematics Department | MATH | CC-MATH | Mathematics |
| 120100 | College of Engineering - Dean | ENGR-DEAN | CC-EN-DEAN | Engineering Dean's Office |
| 120400 | Computer Science | CS | CC-CS | Computer Science |
| 200100 | Registrar's Office | REG | CC-REG | Registrar |
| 200200 | Financial Aid Office | FINAID | CC-FINAID | Financial Aid |
| 300100 | Athletics | ATH | CC-ATH | Athletics |
| 400100 | Facilities Management | FAC | CC-FAC | Facilities |
| 500100 | University Advancement | ADV | CC-ADV | Advancement |

### Program → Revenue/Spend Category (Functional Classification)

| PS Program | PS Description | HELIX Functional Class | IPEDS Category | Workday Revenue Category |
|-----------|---------------|----------------------|---------------|------------------------|
| INSTR | Instruction | instruction | Instruction | Instruction |
| RESRCH | Research | research | Research | Research |
| PUBSVC | Public Service | public_service | Public Service | Public Service |
| ACASUP | Academic Support | academic_support | Academic Support | Academic Support |
| STUSVC | Student Services | student_services | Student Services | Student Services |
| INSTSUP | Institutional Support | institutional_support | Institutional Support | Institutional Support |
| O&M | Operation & Maintenance of Plant | plant_operations | Operation of Plant | Plant Operations |
| SCHLRSHP | Scholarships & Fellowships | scholarships | Scholarships | Scholarships and Fellowships |
| AUXENT | Auxiliary Enterprises | auxiliary | Auxiliary Enterprises | Auxiliary Enterprises |
| HOSP | Hospital/Medical | hospital | Hospital Services | Hospital/Clinical |

---

## Sample Year-End Financial Report: Both Views

### Revenue Summary — Fiscal Year 2026

**In PeopleSoft Chartfield Terms:**
```
REGIONAL UNIVERSITY
Statement of Revenues — FY2026
PeopleSoft General Ledger (PS_LEDGER)

Account    Description                    Fund 11000     Fund 21000     Fund 30000     Total
--------   ---------------------------    ----------     ----------     ----------     ----------
40100      Tuition Revenue                 85,200,000                                   85,200,000
40200      Fee Revenue                     12,400,000                                   12,400,000
40500      State Appropriation             42,000,000                                   42,000,000
40600      Federal Grants Revenue                         28,500,000                    28,500,000
41000      Auxiliary Revenue               18,200,000                                   18,200,000
42000      Gift Revenue                     3,800,000      2,100,000     1,200,000       7,100,000
42500      Endowment Income                                               4,500,000      4,500,000
           -------------------------------------------------------------------
           TOTAL REVENUE                  161,600,000     30,600,000     5,700,000     197,900,000
```

**The Same Data in Workday Worktag Terms:**
```
REGIONAL UNIVERSITY
Statement of Revenues — FY2026
Workday Financial Management (Ledger)

Ledger Acct  Description                  FD100          FD300          FD400          Total
-----------  ---------------------------  ----------     ----------     ----------     ----------
4010         Tuition and Fees              85,200,000                                   85,200,000
4020         Student Fees                  12,400,000                                   12,400,000
4050         Government Appropriations     42,000,000                                   42,000,000
4060         Federal Grant Revenue                        28,500,000                    28,500,000
4100         Auxiliary Enterprises         18,200,000                                   18,200,000
4200         Contributions and Gifts        3,800,000      2,100,000     1,200,000       7,100,000
4250         Investment Income - Endowment                                4,500,000      4,500,000
             -------------------------------------------------------------------
             TOTAL REVENUE               161,600,000     30,600,000     5,700,000     197,900,000
```

**Through HELIX (the foundational layer):**
```
REGIONAL UNIVERSITY
Statement of Revenues — FY2026
HELIX Foundational Financial Model

HELIX Code         Category          Unrestricted    Restricted     Endowment      Total
-----------------  ---------------   ----------      ----------     ----------     ----------
REV-TUITION        Tuition            85,200,000                                   85,200,000
REV-FEES           Fees               12,400,000                                   12,400,000
REV-STATE-APPROP   State Approp.      42,000,000                                   42,000,000
REV-FED-GRANT      Federal Grants                     28,500,000                   28,500,000
REV-AUX            Auxiliary          18,200,000                                   18,200,000
REV-GIFT           Gifts               3,800,000      2,100,000     1,200,000       7,100,000
REV-ENDOW          Endowment Income                                  4,500,000      4,500,000
                   -------------------------------------------------------------------
                   TOTAL             161,600,000     30,600,000     5,700,000     197,900,000
```

**The numbers are identical.** The structure is equivalent. The HELIX layer is the Rosetta Stone: once data is in HELIX shape, generating either the PeopleSoft-style or Workday-style report is a formatting exercise, not a mapping exercise.

---

## The XREF in Practice

### Migration Day: Loading History

During migration, the XREF table drives the ETL:
```sql
-- Transform PeopleSoft journal lines to Workday-ready format via HELIX
SELECT
    jl.JOURNAL_ID,
    jl.JOURNAL_DATE,
    xref_acct.workday_ledger_account,
    xref_fund.workday_fund,
    xref_dept.workday_cost_center,
    xref_prog.workday_revenue_category,
    jl.MONETARY_AMOUNT
FROM ps_jrnl_ln jl
JOIN helix_xref_account xref_acct ON jl.ACCOUNT = xref_acct.ps_account
JOIN helix_xref_fund xref_fund ON jl.FUND_CODE = xref_fund.ps_fund
JOIN helix_xref_department xref_dept ON jl.DEPTID = xref_dept.ps_deptid
JOIN helix_xref_program xref_prog ON jl.PROGRAM_CODE = xref_prog.ps_program
WHERE jl.JRNL_HDR_STATUS = 'P'  -- posted only
```

### Post-Migration: Historical Comparability

After migration, analysts can query the HELIX lake and produce reports in either system's terminology:
- **For the CFO** who still thinks in PeopleSoft terms: render with PS account codes
- **For the new Workday team**: render with worktag codes
- **For IPEDS/GASB reporting**: render with HELIX functional classifications (which map directly to IPEDS categories)

---

## Key Mapping Challenges This XREF Solves

| Challenge | How HELIX Handles It |
|-----------|---------------------|
| PeopleSoft "Program" is a single field; Workday splits functional classification across Revenue/Spend Categories | HELIX maps Program to a normalized functional classification that maps to both |
| PeopleSoft "Class" field is institution-specific (no standard use); Workday has no direct equivalent | HELIX maps Class to the most appropriate worktag (Revenue Category, Custom Worktag, or drops it if truly local) |
| PeopleSoft fund accounting (11000-60000 ranges) doesn't map 1:1 to Workday fund codes | HELIX introduces a fund category taxonomy that both systems map to |
| PeopleSoft uses numeric account codes; Workday uses alpha-numeric ledger accounts | HELIX uses descriptive codes (REV-TUITION, EXP-SAL-FACULTY) that are self-documenting |
| Historical PeopleSoft data needs to be queryable alongside new Workday data | Both land in HELIX shape in the lake. Same query, same schema, regardless of source era. |

---

## HELIX Resources Used

| Resource | Role in This Example |
|----------|---------------------|
| `GLTransaction` (planned) | Journal entries with chartfield/worktag coding |
| `Institution` | Business unit / company mapping |
| `AcademicOrg` | Department / cost center hierarchy |

**Bridge mappings used:** `bridge/peoplesoft/fin/general_ledger_mapping.json`

---

*This example demonstrates the HELIX Bridge financial cross-reference pattern. The XREF tables shown are illustrative defaults; each institution adapts them to their specific chart of accounts.*
