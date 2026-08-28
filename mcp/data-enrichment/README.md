# Reusable Data Enrichment MCP

A provider-agnostic MCP for searching public sources, fetching pages, extracting structured entity information, verifying attributes, and returning evidence-backed enrichment.

## Design standard

- Free/public/self-hosted providers first.
- Commercial providers are optional adapters, never hard dependencies.
- Expose capabilities rather than vendor-specific APIs.
- Preserve source URL, source type, retrieval timestamp, confidence and verification status.
- Respect robots.txt, site terms, rate limits and applicable privacy requirements.
- Do not infer private contact information.

## Core capability contract

- `search_entities`
- `find_website`
- `fetch_page`
- `extract_entity`
- `find_contacts`
- `find_people`
- `find_programs`
- `verify_attribute`
- `enrich_entity`
- `enrich_batch`

## Architecture

```text
Data Product
    ↓
Enrichment MCP
    ├── Search
    ├── Fetch
    ├── Extract
    ├── Verify
    ├── Provenance
    └── Cache
    ↓
Structured Enrichment
```

## Profiles

Profiles define what to enrich for a data product without changing the core engine.

- `profiles/nonprofit.yml` — first profile
- Future profiles can support education providers, companies, occupations, industries and other entities.

## Provider strategy

```text
Capability
   ↓
Free/public implementation
   ↓
Local/self-hosted fallback
   ↓
Optional commercial adapter
```

The data product calls a capability such as `find_people()`, not Apollo or Hunter directly.

## Evidence contract

Each enriched attribute should carry:

- `entity_id`
- `attribute`
- `value`
- `source_url`
- `source_type`
- `retrieved_dt`
- `confidence`
- `verification_status`

V1 is intentionally free-first and reusable across data products.
