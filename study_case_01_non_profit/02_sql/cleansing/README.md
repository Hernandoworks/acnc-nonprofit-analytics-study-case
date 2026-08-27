# SQL — Cleansing & Transformation

Transform the raw ACNC staging layer using SQL only.

Key treatments:
- trim text and convert blanks to NULL
- standardise ABN to digits only
- validate 11-digit ABNs
- convert dates to DATE
- convert financial fields to NUMERIC
- convert Yes/No fields to BOOLEAN
- preserve source lineage
- create deterministic canonical source rows
