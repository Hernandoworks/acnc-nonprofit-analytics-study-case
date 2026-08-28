# Non-Profit Intelligence MCP

Purpose-built MCP for enriching the ACNC non-profit dataset using free/public sources.

## V1 scope

- ACNC organisation lookup
- ABN/entity validation
- Official website discovery
- Public website enrichment
- Public organisational contact extraction
- Public leadership/responsible-person extraction
- Public programs/services extraction
- Source provenance and retrieval dates

## Design principles

1. ACNC remains the authoritative organisation master.
2. ABN is the primary matching key where available.
3. Enrichment is stored separately from the core model.
4. Every enriched attribute carries source URL, source type, retrieval date and confidence.
5. Do not infer private contact information.
6. Cache public results and respect website terms, robots rules and rate limits.
7. Start with free/public sources; commercial providers remain optional adapters.

## Architecture

ACNC → Core Charity Model → MCP Enrichment → 400 Enrichment → 600 Analytics → Power BI

## Planned tools

- `acnc_lookup`
- `abn_lookup`
- `find_website`
- `enrich_website`
- `extract_contacts`
- `extract_leadership`
- `extract_programs`
- `enrich_charity`
- `save_enrichment`

V1 is specification-first. Implementation will be added after the data model and source contracts are confirmed.