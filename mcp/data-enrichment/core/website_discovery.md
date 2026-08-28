# Website Discovery — Practical V1

## Goal

Given an organisation name and optional ABN, identify the most likely official website without pretending search results are authoritative.

## Inputs

- `organisation_name` (required)
- `abn` (optional)
- `location` (optional)
- `known_domain` (optional)

## Search strategy

Run a small number of targeted queries rather than broad crawling:

1. Exact organisation name in quotes.
2. Exact organisation name + Australia.
3. Exact organisation name + ABN when available.
4. If needed, exact organisation name + contact/about.

Maximum default search results per query: 5–10.

## Candidate scoring

Score candidates using transparent deterministic signals:

- +40 exact/near-exact organisation name in page title/domain.
- +20 Australian domain (`.org.au`, `.com.au`, `.gov.au`) when appropriate.
- +15 organisation name appears in result snippet.
- +10 ABN appears in page/snippet when supplied.
- +10 contact/about page on the same domain.
- -40 obvious directory/social/news/aggregator domain.
- -25 unrelated organisation with similar name.

These are heuristics, not proof of identity.

## Acceptance rules

- Return the top candidate only when its score reaches the configured threshold (default 60).
- Otherwise return candidates with `status: needs_review`.
- Never claim a website is official solely because it ranked first.
- Prefer an organisation's own website over directories and social profiles.
- If an ACNC website is already present and valid, treat it as the starting candidate and optionally verify it through search.

## Output

```json
{
  "organisation_name": "Example Charity",
  "abn": "12345678901",
  "website": "https://example.org.au",
  "status": "accepted",
  "confidence": 0.91,
  "candidates": [],
  "evidence": []
}
```

## Practicality constraints

- No paid search API required for V1.
- Do not crawl the entire web.
- Do not enrich all ACNC records automatically.
- Cache search results to avoid repeated queries.
- Use rate limits and retries with backoff.
- Preserve every candidate URL so a human can review uncertain matches.
- Search is discovery; the organisation website remains the preferred evidence source.
