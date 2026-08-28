# Reusable Data Enrichment MCP

A free-first, provider-agnostic enrichment engine for data products.

## Pipeline

`search → discover → fetch → extract → verify → evidence → cache`

## Current implementation

- Free search adapter using DDGS
- Official website discovery/ranking
- Conservative public-web fetcher
- Deterministic extraction of contacts, links and headings
- Transparent confidence/verification scoring
- Canonical evidence record
- Local response cache
- Bounded orchestration
- Unit tests
- GitHub Actions CI

## Reuse model

The engine is generic. Data-product-specific requirements live under `profiles/`. The first profile is `nonprofit.yml`.

Commercial enrichment providers are optional adapters. The core pipeline must continue to work without them.

## Production principles

- Prefer authoritative/open sources.
- Preserve source URL and retrieval timestamp.
- Do not infer private contact information.
- Keep network operations bounded.
- Cache repeat requests.
- Validate deterministic extraction before semantic enrichment.
- Treat confidence as a review signal, not proof of truth.
