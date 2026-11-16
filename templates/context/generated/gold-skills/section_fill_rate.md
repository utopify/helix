# Gold metric: Section fill rate

**Id:** `section_fill_rate` · **Domain:** Academic Structure · **Owner:** University Registrar · **Output classification:** internal

**Approved:** not yet approved

## Grain

Per section, rolled up by department and period

## Population

- Sections with section_status active and max_enrollment over 0

## Formula

actual_enrollment / max_enrollment at census

## Source columns

- `helix_silver.course_section.actual_enrollment`
- `helix_silver.course_section.max_enrollment`
- `helix_silver.course_section.section_status`
- `helix_silver.course_section.academic_org_ref`
- `helix_silver.course_section.academic_period_ref`

## Standard

Institutional

## Suppression

None

## Notes

Combine cross-listed sections before computing.

Defined in `templates/context/gold-metrics.yaml`. Don't answer this metric any other way.
