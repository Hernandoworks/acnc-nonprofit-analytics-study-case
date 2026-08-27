# Data Quality & Reconciliation

Authoritative QA is calculated in PostgreSQL.

## Controls

- Source row count
- Distinct ABN count
- ABN validity
- Column-level NULL and non-NULL counts
- Source-to-target row reconciliation
- Source-to-target measure reconciliation
- Foreign-key orphan checks
- Revenue component checks
- Expense component checks
- Balance-sheet checks
- Final PASS / FAIL summary

## Acceptance standard

An ingestion is accepted only when critical reconciliation checks pass. NULLs are not automatically errors; they are assessed according to the field's analytical purpose.

## Persistent QA output

`analytics.acnc_data_quality_report`

Executive view:

`analytics.v_acnc_validation_summary`
