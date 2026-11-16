# Gold metric: Pell recipient share

**Id:** `pell_share` · **Domain:** Financial Aid · **Owner:** Director of Financial Aid · **Output classification:** internal

**Approved:** not yet approved

## Grain

Per academic year and level

## Population

- Undergraduates enrolled at fall census

## Formula

Students with a disbursed Pell award in the aid year / undergraduates at census

## Source columns

- `helix_silver.fin_aid_award.fund_code`
- `helix_silver.fin_aid_award.award_status`
- `helix_silver.fin_aid_award.academic_year`
- `helix_silver.enrollment.student_ref`
- `helix_silver.student.academic_level`

## Standard

IPEDS Student Financial Aid (SFA)

## Suppression

Suppress subgroups under 5

## Notes

Identify Pell by the fund code crosswalk, not by fund name.

Defined in `templates/context/gold-metrics.yaml`. Don't answer this metric any other way.
