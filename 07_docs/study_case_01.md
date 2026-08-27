# Study Case 01 — Australian Non-Profit Analytics

## Data Modelling, Complex SQL Analysis & Data Quality

### Business problem

Government charity data is large and useful, but source-level fields are not automatically fit for decision-making. The challenge is to build a trustworthy analytical model and then use advanced SQL to understand charity scale, financial sustainability, funding dependency and workforce capacity.

### Objective

Create an auditable analytical pipeline from the ACNC 2024 Annual Information Statement dataset and answer:

> What can we learn about the scale, financial sustainability, funding model and workforce capacity of Australian charities once the source is correctly modelled and quality-assured?

### Dataset

- 53,875 source records
- 53,874 distinct ABNs
- 1 duplicate ABN record identified
- 92 source columns
- Canonical grain: 1 charity per ABN

### Skills demonstrated

- PostgreSQL / Supabase
- SQL-first ETL
- Relational data modelling
- Entity resolution and deduplication
- Data-quality engineering
- Source-to-target reconciliation
- NULL / non-NULL profiling
- Financial business-rule validation
- Window functions and CTEs
- Segmentation and ratio analysis
- Power BI-ready analytical views

### Data model

```text
                 acnc.charities
                       │
       ┌───────────────┼────────────────┐
       ▼               ▼                ▼
 acnc.financials  acnc.workforce  acnc.operations
       │
       ├── acnc.reporting
       ├── acnc.registration
       └── acnc.fundraising
```

### Quality approach

The project does not treat row-count matching as sufficient. Acceptance requires:

1. Source row-count alignment
2. ABN uniqueness/reconciliation
3. Column-level NULL and non-NULL checks
4. Source-to-target aggregate reconciliation
5. Referential-integrity checks
6. Financial business-rule checks
7. Documented duplicate treatment

### Analysis themes

- Charity population by size and registration status
- Revenue concentration
- Government funding dependency
- Donation dependency
- Net margin and surplus/deficit profile
- Asset and liability structure
- Employee cost intensity
- Volunteer-to-FTE intensity
- KMP remuneration
- Multi-dimensional charity segmentation
- Outlier screening

### Key design decisions

**ABN** is the business key.

**charity_id** is the surrogate key used for relationships.

**Raw/staging** preserves the source.

**Curated tables** contain typed, canonical records.

**Analytics views** prepare decision-ready outputs for Power BI.

**System metadata** records source file, batch, created/updated timestamps and record hash for lineage and change detection.

### Repository position

This is **Study Case 01** within the broader Non-Profit Analytics repository. The repository plan is intentionally unchanged; this case populates the existing structure.
