# Study Case 01 — Data Dictionary

The full ACNC 2024 data dictionary is maintained as a separate workbook artifact.

It documents:

- indexed source columns
- table groups
- source business fields
- target PostgreSQL data types
- target tables
- sample values
- transformation rules
- system metadata

## Table groups

| Group | Table | Source columns |
|---|---|---:|
| G00 | `staging.acnc_ais_raw` | Raw/source layer |
| G01 | `acnc.charities` | Entity |
| G02 | `acnc.operations` | Operations |
| G03 | `acnc.workforce` | Workforce |
| G04 | `acnc.financials` | Financial |
| G05 | `acnc.reporting` | Reporting |
| G06 | `acnc.registration` | Registration |
| G07 | `acnc.fundraising` | Fundraising |

## System metadata

Raw/staging: `source_load_id`, `source_file`, `source_loaded_at`, `etl_batch_id`

Curated/end tables: `source_file`, `etl_batch_id`, `created_at`, `updated_at`, `record_hash`
