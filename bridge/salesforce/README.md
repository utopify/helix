# HELIX Bridge: Salesforce

Mappings from Salesforce to HELIX Core for the three higher ed data models institutions run: **Agentforce Education** (formerly Education Cloud) standard objects, the **Education Data Architecture (EDA)** managed package, and **NPSP or Nonprofit Cloud** for advancement.

The landing zone (how to extract, land, secure, and enrich) is in [`docs/landing-zones/salesforce-landing-zone.md`](../../docs/landing-zones/salesforce-landing-zone.md). No Salesforce add-on is needed: Bulk API 2.0 and Change Data Capture are the default extraction paths.

## Mappings (10)

| HELIX Resource | Mapping File | Key Salesforce Objects | Attrs |
|---|---|---|---:|
| AcademicPeriod | `academic_period_mapping.json` | AcademicTerm, AcademicYear, AcademicSession | 9 |
| AdmissionApplication | `admission_application_mapping.json` | IndividualApplication, ApplicationDecision, hed__Application__c | 14 |
| Campaign | `campaign_mapping.json` | Campaign, CampaignMember | 10 |
| Constituent | `constituent_mapping.json` | Contact, Account, npsp rollup fields on Contact | 15 |
| EngagementActivity | `engagement_activity_mapping.json` | Task, Event, CampaignMember | 10 |
| Enrollment | `enrollment_mapping.json` | CourseOfferingParticipant, CourseOffering, AcademicTerm | 8 |
| Gift | `gift_mapping.json` | Opportunity (donation record types), npe01__OppPayment__c, npe03__Recurring_Donation__c | 14 |
| Person | `person_mapping.json` | Contact, ContactProfile, Account | 11 |
| StudentGroup | `student_group_mapping.json` | InvolvementGroup / InvolvementGroupMember, EducCharacteristicAssignment, hed__Affiliation__c | 9 |
| StudentProgram | `student_program_mapping.json` | LearnerProgram, hed__Program_Enrollment__c, LearningProgram | 8 |

## Before you build

- **Every org is different.** Field names follow Salesforce's published models, but orgs add custom fields (ending in `__c`) and record types. Each file carries a `validate` note; check every field against your org's describe output.
- **Identity first.** Contact resolves to HELIX Person before anything else. See section 4 of the landing zone.
- **Systems of record.** Program of study, course enrollment, and terms usually belong to the SIS. Map them from Salesforce only where Salesforce is the source, and reconcile in silver.
- **Free text stays out of silver.** Task and Event descriptions, email bodies, and case comments don't land in silver.
