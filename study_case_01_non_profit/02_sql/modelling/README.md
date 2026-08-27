# SQL — Data Modelling

Define the relational ACNC analytical model.

## Canonical entity

`acnc.charities`

**Grain:** one canonical charity per ABN.

## Related domains

- `acnc.operations`
- `acnc.workforce`
- `acnc.financials`
- `acnc.reporting`
- `acnc.registration`
- `acnc.fundraising`

Use `charity_id` as the curated surrogate key and ABN as the source business key.
