# Data Preparation Rules

## Objective
Convert source data into consistent, analysis-ready structures without hiding data-quality issues.

## Preparation principles

- Preserve source meaning.
- Standardise field names and data types.
- Handle NULLs explicitly.
- Remove or isolate duplicate records only when the business rule is understood.
- Standardise dates and categorical values.
- Preserve source identifiers for lineage.
- Document every derived field.
- Do not calculate business KPIs until the underlying grain is confirmed.

## Quality handoff

Prepared data moves to modelling only after profiling exceptions are documented and validation checks pass or are explicitly accepted.
