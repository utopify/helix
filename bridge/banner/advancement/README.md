# HELIX Bridge: Banner Advancement

Advancement module mappings from Ellucian Banner to HELIX Core Advancement resources.

## Mappings (4 resources)

| HELIX Resource | Mapping File | Key Banner Tables | Attrs |
|---------------|-------------|-------------------|-------|
| Constituent | `constituent_mapping.json` | APBCONS, SPRIDEN, APRCATG, APRDONR | 24 |
| Gift | `gift_mapping.json` | AGBGIFT, AGBPLDG, AFRDESG, APRCFAE | 24 |
| Campaign | `campaign_mapping.json` | AFBCAMP, AFRCDES | 12 |
| EngagementActivity | `engagement_activity_mapping.json` | APRCONT, APRMEMO, STVCTYP | 12 |

## Key Banner Advancement Table Prefixes

| Prefix | Meaning | Examples |
|--------|---------|----------|
| **APB** | Advancement Person/constituent Base | APBCONS (constituent base) |
| **AGB** | Advancement Gift Base | AGBGIFT (gift), AGBPLDG (pledge) |
| **AFB/AFR** | Advancement campaign (Fund) | AFBCAMP (campaign), AFRCDES (designation), AFRDESG (designation validation) |
| **APR** | Advancement Person-Related | APRCATG (category), APRDONR (donor category), APRCONT (contact), APRMEMO (contact memo), APRCFAE (campaign/fund/appeal/effort) |

Advancement constituents share the **PIDM** identity model with the student and HR modules -- a constituent record in APBCONS links to the same SPRIDEN identity as that person's student/employee records.
