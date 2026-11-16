# Salesforce Landing Zone

How to land Salesforce (Agentforce Education, formerly Education Cloud; the older Education Data Architecture package; and Nonprofit Success Pack or Nonprofit Cloud for advancement) in a HELIX lakehouse using what the Salesforce platform already includes, then enrich it and point AI agents at the result.

Read [`../own-your-intelligence.md`](../own-your-intelligence.md) first for the why.

---

## 1. Ways to get data out of Salesforce

| Method | What it is | Included with the org? | Best for |
|--------|------------|------------------------|----------|
| **Bulk API 2.0 (query)** | Asynchronous SOQL extracts returned as CSV | Yes (API-enabled editions) | Full and incremental loads of large objects |
| **REST API and SOQL** | Synchronous queries | Yes | Small objects, metadata, and the object describe calls |
| **Change Data Capture (CDC)** | Change events published for selected objects | Included for a limited number of objects; more is an add-on. Check your contract | Near real-time changes |
| **Amazon AppFlow (Salesforce connector)** | AWS-managed flows from Salesforce to S3, scheduled or event-triggered | Salesforce side: yes. AWS side: priced per flow run and data processed | Teams that want a managed connector instead of writing code |
| **Salesforce Data 360 (formerly Data Cloud) zero copy** | Federation and sharing between Data 360 and outside lakes such as Redshift and S3 | No, a separately licensed product | Schools already using Data 360 for marketing activation or Agentforce |

**The HELIX default is Bulk API 2.0 for loads plus CDC or AppFlow for objects that need freshness.** No Salesforce add-on is required.

## 2. Architecture

```
  Salesforce org
    |  Bulk API 2.0 (CSV)     CDC events          Amazon AppFlow
    v                           v                    v
  Glue Python shell or Lambda   EventBridge / Lambda  AppFlow flow
    |  (connected app OAuth, JWT bearer flow; secrets in AWS Secrets Manager)
    v
  s3://<lake>/bronze/salesforce/<object>/extract_date=YYYY-MM-DD/   (Parquet)
    |  AWS Glue: polymorphic lookups, record types, picklist decode, Contact to HELIX ID
    v
  S3 Tables: silver.person, silver.admission_application, silver.engagement_activity,
             silver.constituent, silver.gift, ...
    |  gold metrics (templates/context/gold-metrics.yaml)
    v
  gold.enrollment_funnel, gold.donor_360, gold.melt_risk, ...
    |  context layer (docs/context/)
    v
  Agents through Lake Formation permissions
```

## 3. Bronze: objects to land

Mappings are in [`bridge/salesforce/`](../../bridge/salesforce/). Which objects you land depends on the data model your org uses:

| Area | Agentforce Education (standard objects) | EDA managed package | Advancement (NPSP or Nonprofit Cloud) |
|------|-----------------------------------------|---------------------|----------------------------------------|
| People | Contact, ContactProfile, Account | Contact, Account (Administrative) | Contact, Account (Household) |
| Recruiting and admissions | Lead, EducationalInfoRequest, IndividualApplication, ApplicationDecision | `hed__Application__c` | |
| Programs | LearningProgram, LearnerProgram | Account (Academic Program), `hed__Program_Enrollment__c` | |
| Terms and courses | AcademicTerm, CourseOffering, CourseOfferingParticipant | `hed__Term__c`, `hed__Course_Offering__c`, `hed__Course_Enrollment__c` | |
| Groups and attributes | InvolvementGroup, InvolvementGroupMember, EducCharacteristicAssignment | `hed__Affiliation__c` | |
| Engagement | Task, Event, Campaign, CampaignMember, Case | Same | Same |
| Giving | | | Opportunity (donations), `npe01__OppPayment__c`, `npe03__Recurring_Donation__c`, `npsp__General_Accounting_Unit__c`; or GiftTransaction, GiftCommitment on Nonprofit Cloud |

Rules for Salesforce bronze:
- **Describe before you extract.** Pull each object's describe (fields, picklist values, record types) daily into `bronze/salesforce/_metadata/`. It's your audit of schema drift and it feeds the context layer.
- **Incremental by `SystemModstamp`.** Track a high-water mark per object. Pull deletes with `queryAll` so `IsDeleted` rows reach bronze.
- **Land Ids as 18-character.** Case-safe 18-character Ids avoid join errors in case-insensitive engines.
- **Record types and picklists are data.** Land `RecordTypeId` and decode picklists in silver through crosswalks, not in the extract.
- **A dedicated integration user** with a permission set limited to the objects it extracts.

## 4. Silver: identity is the hard part

The CRM holds people the SIS doesn't (inquiries, parents, donors, alumni) and sometimes duplicates people the SIS does. In silver:
- Match Contact to HELIX Person deterministically first: the SIS student ID or employee ID field on Contact (most institutions add one), then email plus birth date. Send anything ambiguous to the stewardship queue. Never auto-merge.
- Keep the Salesforce Id in `identifiers[]` with `system = salesforce`.
- Prospects who never apply still become Person rows. They're not education records until they enroll, and HELIX marks them that way.

## 5. Gold: questions the CRM alone can't answer

| Gold table | Silver resources | Question it answers |
|------------|------------------|---------------------|
| `gold.enrollment_funnel` | Person, AdmissionApplication, EngagementActivity, Enrollment | Conversion and yield by source, territory, and program, all the way to census |
| `gold.melt_risk` | AdmissionApplication, FinAidAward, Hold, EngagementActivity | Which deposited students are likely to melt, and why |
| `gold.donor_360` | Constituent, Gift, EngagementActivity, Degree, EmploymentOutcome | Giving, engagement, degree, and career in one view |
| `gold.advising_load` | EngagementActivity (cases), Student, Enrollment | Advising contacts against outcomes |

## 6. Security

- Map Salesforce profiles, permission sets, and sharing rules to the HELIX roles in `govern/access-control-matrix.json`. Salesforce's sharing model (ownership and territories) usually becomes a Lake Formation row filter on owner or territory.
- Prospect and donor data aren't FERPA education records, but state privacy laws and donor intent still apply. Gift and Constituent stay confidential; wealth screening and capacity fields stay restricted to prospect research.

## 7. If you do own Data 360

Treat Data 360 as an activation tool and, if you like, one more source. Data 360 can read lake tables through zero copy, so gold tables can feed Salesforce journeys without a separate pipeline. Keep definitions and agent rules in your context layer so they cover non-Salesforce data and survive a change of CRM.

## Things that trip people up

- **API limits.** Bulk API jobs count against daily limits. Schedule large backfills off-peak and check limits before adding objects.
- **Formula and rollup fields.** They're computed at query time and may change without `SystemModstamp` moving. Recompute in silver or snapshot them.
- **Polymorphic fields** (`WhoId`, `WhatId` on Task and Event). Land the Id and the object type; resolve in silver.
- **EDA and Agentforce Education in the same org.** Some schools have both during a transition. Map each and reconcile in silver.

*HELIX v0.10.0, November 2026*
