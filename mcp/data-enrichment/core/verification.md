# Verification policy

Verification is explicit and inspectable.

## Statuses

- `verified`: confidence >= 0.80
- `review`: confidence 0.50–0.79
- `unverified`: confidence < 0.50

## Evidence signals

- Non-empty extracted value
- Match to known official domain
- Corroboration by another source
- Deterministic extraction for simple fields such as website/email/phone

Confidence is a workflow signal, not a statement of absolute truth. Semantic fields such as programs or strategy should normally require stronger source evidence or human review before being treated as authoritative.
