# Gold metric: Average unmet need

**Id:** `unmet_need_avg` · **Domain:** Financial Aid · **Owner:** Director of Financial Aid · **Output classification:** confidential

**Approved:** not yet approved

## Grain

Per aid year and student segment

## Population

- Students with an AidPackage in packaged or finalized status for the aid year

## Formula

AVG(aid_package.unmet_need), where unmet_need = max(need minus need-based aid, 0)

## Source columns

- `helix_silver.aid_package.unmet_need`
- `helix_silver.aid_package.need`
- `helix_silver.aid_package.packaging_status`
- `helix_silver.aid_package.academic_year`

## Standard

Common Data Set H2 for aided first-year students

## Suppression

Aggregate only; suppress cells under 5; never per student outside financial aid roles (GLBA)

## Notes

Built from restricted data; publish only aggregates.

Defined in `templates/context/gold-metrics.yaml`. Don't answer this metric any other way.
