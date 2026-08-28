# Enrichment Core

The core pipeline is deliberately deterministic-first:

`search → discover → fetch → extract → verify → evidence`

AI/LLM extraction may be added later for semantic fields such as programs and services, but deterministic extraction remains the baseline and validation layer.

## Current components

- Provider contract
- Website discovery/ranking
- Conservative web fetcher
- Deterministic page extractor
- Canonical enrichment evidence schema
