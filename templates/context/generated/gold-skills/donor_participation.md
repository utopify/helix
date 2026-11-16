# Gold metric: Alumni giving participation

**Id:** `donor_participation` · **Domain:** Advancement · **Owner:** Director of Advancement Services · **Output classification:** internal

**Approved:** not yet approved

## Grain

Per fiscal year

## Population

- Solicitable alumni of record (constituent_type alumni, status active, not do_not_solicit)

## Formula

Alumni with at least one gift in the fiscal year / solicitable alumni of record

## Source columns

- `helix_silver.constituent.constituent_type`
- `helix_silver.constituent.status`
- `helix_silver.gift.constituent_ref`
- `helix_silver.gift.gift_date`
- `helix_silver.gift.gift_type`

## Standard

CASE Global Reporting Standards

## Suppression

None at institution level

## Notes

Count pledge payments in the year they're paid; count pledges per CASE rules.

Defined in `templates/context/gold-metrics.yaml`. Don't answer this metric any other way.
