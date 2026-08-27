# Data Model

## Domains

| Group | Table | Grain | Role |
|---|---|---|---|
| G00 | `staging.acnc_ais_raw` | 1 source record | Raw lineage |
| G01 | `acnc.charities` | 1 unique ABN | Charity entity |
| G02 | `acnc.operations` | 1 charity | Activities / purposes |
| G03 | `acnc.workforce` | 1 charity | Employees / FTE / volunteers |
| G04 | `acnc.financials` | 1 charity / report | Financial facts |
| G05 | `acnc.reporting` | 1 charity | Reporting / compliance |
| G06 | `acnc.registration` | 1 charity | Registration |
| G07 | `acnc.fundraising` | 1 charity | Fundraising footprint |

## Key relationship

`acnc.charities.charity_id` is the surrogate key used by the dependent ACNC tables. `abn` is the business key used to identify the charity in the source data.

## System metadata

Raw and curated layers retain ETL lineage through `source_file`, `etl_batch_id`, timestamps and optional `record_hash`.
