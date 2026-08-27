# Study Case 01 — Data Model

## Grain

The canonical entity grain is **one charity per ABN**.

## Entity / fact domains

- `acnc.charities` — canonical charity entity
- `acnc.operations` — activities and purposes
- `acnc.workforce` — staff, FTE, volunteers and KMP
- `acnc.financials` — revenue, expenses, assets and liabilities
- `acnc.reporting` — reporting/compliance attributes
- `acnc.registration` — incorporation and state registration
- `acnc.fundraising` — fundraising registrations

## Keys

- Source business key: `abn`
- Curated surrogate key: `charity_id`
- Source lineage key: `source_id` / `source_load_id`

## System metadata

Raw/staging:
- `source_load_id`
- `source_file`
- `source_loaded_at`
- `etl_batch_id`

Curated:
- `source_file`
- `etl_batch_id`
- `created_at`
- `updated_at`
- `record_hash`

## Mermaid ERD

```mermaid
erDiagram
    CHARITIES ||--|| FINANCIALS : has
    CHARITIES ||--|| WORKFORCE : has
    CHARITIES ||--|| OPERATIONS : has
    CHARITIES ||--|| REPORTING : has
    CHARITIES ||--|| REGISTRATION : has
    CHARITIES ||--|| FUNDRAISING : has

    CHARITIES {
        bigint charity_id PK
        text abn UK
        text charity_name
        text registration_status
        text charity_size
    }

    FINANCIALS {
        bigint charity_id PK,FK
        date fin_report_from
        date fin_report_to
        numeric total_revenue
        numeric total_expenses
        numeric net_surplus_deficit
        numeric total_assets
        numeric total_liabilities
    }

    WORKFORCE {
        bigint charity_id PK,FK
        numeric total_full_time_equivalent_staff
        numeric staff_volunteers
        numeric number_of_key_management_personnel
    }

    OPERATIONS {
        bigint charity_id PK,FK
        text conducted_activities
        text how_purposes_were_pursued
    }

    REPORTING {
        bigint charity_id PK,FK
        boolean charity_report_has_a_modification
        boolean charity_has_reportable_related_party_transactions
    }

    REGISTRATION {
        bigint charity_id PK,FK
        boolean incorporated_association
    }

    FUNDRAISING {
        bigint charity_id PK,FK
        boolean fundraising_online
    }
```
