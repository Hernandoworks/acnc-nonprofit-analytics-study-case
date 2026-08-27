# Data Model Design

## Objective
Define the analytical model from confirmed source grain and relationships.

## Design sequence

```text
Source grain
  ↓
Business entities
  ↓
Keys and relationships
  ↓
Facts and dimensions
  ↓
Measures
  ↓
Analytical grain
```

## Modelling decisions to document

- Entity definitions
- Table grain
- Primary and business keys
- Foreign keys / relationships
- Fact tables
- Dimension tables
- Measures and derived metrics
- Historical behaviour
- Slowly changing attributes where relevant
- Power BI consumption grain

## Principle

The model is designed from business meaning and observed data, not from the desired dashboard layout.
