# Study Case 01 — Detailed Approach, Challenges & Data Integrity

## 1. What the study case is demonstrating

This case is designed to demonstrate a complete analytical workflow rather than a dashboard-only exercise.

The evidence chain is:

**Source understanding → ingestion → profiling → cleansing → entity resolution → multi-table modelling → integrity controls → reconciliation → complex SQL → analytical figures → business insight.**

## 2. Challenge: a very wide government source

The ACNC AIS source contains **92 source columns** spanning several business domains.

A direct 1:1 analytical table would be difficult to maintain because entity, operations, workforce, financial, reporting, registration and fundraising concepts have different meanings.

### Approach

Decompose the source into domain tables:

- `acnc.charities`
- `acnc.operations`
- `acnc.workforce`
- `acnc.financials`
- `acnc.reporting`
- `acnc.registration`
- `acnc.fundraising`

Keep the complete source in `staging.acnc_ais_raw`.

## 3. Challenge: entity duplication

The source baseline is:

- 53,875 source records
- 53,874 distinct ABNs
- 1 known duplicate ABN record

### Approach

Use `ABN` as the business key and `charity_id` as the curated surrogate key.

The raw layer preserves every source row.

The canonical entity model applies a deterministic rule to keep one record per valid ABN.

This avoids both data loss and double-counting.

## 4. Challenge: mixed data types

The source combines:

- identifiers
- dates
- Yes/No values
- categorical attributes
- currency values
- numeric workforce values
- narrative text

### Approach

Use SQL transformations to standardise types:

```text
ABN            → validated text identifier
Dates          → DATE
Yes / No       → BOOLEAN
Currency       → NUMERIC
Counts / FTE   → NUMERIC
Narratives     → trimmed TEXT
Blank strings  → NULL
```

Do not convert business identifiers to numeric types simply because they contain digits.

## 5. Challenge: data integrity across multiple tables

Once one source is distributed across multiple tables, a row count alone is not enough.

### Integrity controls

The case checks:

```text
raw rows
unique ABNs
canonical entities
foreign-key orphans
non-null counts
source vs target measures
business-rule relationships
```

### Example

Every financial record must resolve to a valid charity:

```sql
SELECT COUNT(*) AS orphan_financial_rows
FROM acnc.financials f
LEFT JOIN acnc.charities c
    ON c.charity_id = f.charity_id
WHERE c.charity_id IS NULL;
```

Expected result:

```text
0
```

## 6. Challenge: proving figures remain correct after transformation

A transformation can preserve the row count while changing the numbers.

For example, currency cleansing can accidentally:

- drop commas incorrectly
- convert blanks to zero
- change signs
- truncate decimals
- cast invalid values to zero

### Approach

Reconcile critical measures at database level.

For each critical measure:

```text
Source row count
Source non-null count
Source NULL count
Source aggregate
Target row count
Target non-null count
Target NULL count
Target aggregate
Difference
Difference %
PASS / FAIL
```

The comparison is performed in PostgreSQL, not by Python arithmetic.

## 7. Challenge: valid NULLs vs bad data

A NULL does not automatically mean a data error.

Some ACNC fields are legitimately not applicable for an organisation.

### Approach

Classify NULLs into:

- expected / structurally valid
- missing but usable
- missing and critical
- transformed-to-NULL due to invalid source format

The case reports NULL counts rather than replacing missing values blindly.

## 8. Challenge: financial figures are highly skewed

Charity financial values can be dominated by very large organisations.

A simple mean can therefore be misleading.

### Approach

Use:

- median
- quartiles
- 90th / 95th / 99th percentiles
- size segmentation
- ratio measures
- concentration analysis

Outliers are investigated rather than automatically deleted.

## 9. Figure quality / analytical quality

The analytical output must distinguish between:

### Data quality
Is the value loaded correctly?

### Figure quality
Does the chart communicate the correct statistic without distortion?

### Business interpretation
What decision or opportunity does the figure support?

The case therefore uses a three-step control:

```text
Database validation
        ↓
Analytical query validation
        ↓
Figure / visual validation
```

## 10. Protecting financial figures

For financial measures, the preferred analytical pattern is:

```sql
SUM(total_revenue)
COUNT(total_revenue)
MIN(total_revenue)
MAX(total_revenue)
PERCENTILE_CONT(0.5)
```

This lets the analyst see both scale and distribution rather than relying on one headline number.

## 11. Business-rule validation

The model tests internal relationships such as:

### Revenue

```text
Government revenue
+ Donations
+ Goods/services
+ Investments
+ Other revenue
≈ Total revenue
```

### Expenses

```text
Employee expenses
+ Interest
+ Grants/donations
+ Other expenses
≈ Total expenses
```

### Balance sheet

```text
Assets - Liabilities
≈ Net assets/liabilities
```

The tolerance is explicitly documented and stored in the QA output.

## 12. Managing complex analysis

The complex analysis does not simply aggregate one table.

It deliberately joins across domains.

Example analytical grain:

```text
Charity
  + financial profile
  + workforce capacity
  + operational profile
  + registration footprint
  + fundraising footprint
```

This supports multi-dimensional segments such as:

- high revenue + high government dependency
- high volunteer intensity + low revenue
- high assets + high liabilities
- high margin + low workforce
- large workforce + high operating scale

## 13. Why this is a useful analyst case

The project demonstrates that the analyst can:

1. Understand a complex government dataset.
2. Define the correct grain of each table.
3. Build a relational model instead of a single wide table.
4. Maintain source lineage.
5. Detect and manage duplicate entities.
6. Validate NULL and non-NULL behaviour.
7. Reconcile measures after transformation.
8. Test business rules.
9. Analyse across multiple data domains.
10. Produce figures that are statistically and operationally defensible.

## 14. Final quality gate

The dataset should not move to Power BI until the SQL QA layer demonstrates that the critical ingestion and integrity controls pass.

The final evidence is the database-side validation report:

`analytics.acnc_data_quality_report`

This is the central quality artefact for Study Case 01.
