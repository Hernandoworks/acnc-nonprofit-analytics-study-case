# SQL — Source-to-Target Reconciliation

Prove that the ingestion is aligned with the source.

Checks include:

- raw record count
- distinct ABN count
- target entity count
- column-level non-NULL counts
- NULL counts
- source vs target aggregates
- row-level mismatch checks where required
- accounting reconciliations

The report must never report PASS simply because tables are non-empty.
