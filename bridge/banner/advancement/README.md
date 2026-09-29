# HELIX Bridge: Banner Advancement

Advancement module mappings from Ellucian Banner to HELIX Core Advancement resources.

## Mappings (5 resources)

| HELIX Resource | Mapping File | Key Banner Tables | Attrs |
|---------------|-------------|-------------------|-------|
| AlumniProfile | `alumni_profile_mapping.json` | APBCONS, APRCATG, APRADEG +5 more | 24 |
| Campaign | `campaign_mapping.json` | AFBCAMP, AFRCDES | 12 |
| Constituent | `constituent_mapping.json` | APBCONS, SPRIDEN, APRCATG, APRDONR | 24 |
| EngagementActivity | `engagement_activity_mapping.json` | APRCONT, APRMEMO, STVCTYP | 12 |
| Gift | `gift_mapping.json` | AGBGIFT, AGBPLDG, AFRDESG, APRCFAE | 24 |

## Key Banner Advancement Table Prefixes

| Prefix | Meaning | Examples |
|--------|---------|----------|
| **APB** | Advancement Person/constituent Base | APBCONS (constituent base) |
| **AGB** | Advancement Gift Base | AGBGIFT (gift), AGBPLDG (pledge) |
| **AFB/AFR** | Advancement campaign (Fund) | AFBCAMP (campaign), AFRCDES (designation), AFRDESG (designation validation) |
| **APR** | Advancement Person-Related | APRCATG (category), APRDONR (donor category), APRCONT (contact), APRMEMO (contact memo), APRCFAE (campaign/fund/appeal/effort) |

Advancement constituents share the **PIDM** identity model with the student and HR modules -- a constituent record in APBCONS links to the same SPRIDEN identity as that person's student/employee records.

AlumniProfile holds career and engagement data (employer, activities, events, memberships). It links to Constituent through `constituent_ref` and never copies giving fields. Per ACM-SPECIAL-009 in `govern/access-control-matrix.json`, don't bulk-join it to solicitation lists without steward review.
