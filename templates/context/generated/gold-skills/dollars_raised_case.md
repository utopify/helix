# Gold metric: Dollars raised (CASE)

**Id:** `dollars_raised_case` · **Domain:** Advancement · **Owner:** Director of Advancement Services · **Output classification:** internal

**Approved:** not yet approved

## Grain

Per fiscal year and campaign

## Population

- Gifts and new pledges dated in the fiscal year

## Formula

SUM(gift.amount) for outright gifts and new pledges; pledge payments excluded to avoid double counting

## Source columns

- `helix_silver.gift.amount`
- `helix_silver.gift.gift_type`
- `helix_silver.gift.gift_date`
- `helix_silver.gift.campaign_ref`

## Standard

CASE Global Reporting Standards

## Suppression

None

## Notes

Planned gifts at present value per CASE.

Defined in `templates/context/gold-metrics.yaml`. Don't answer this metric any other way.
