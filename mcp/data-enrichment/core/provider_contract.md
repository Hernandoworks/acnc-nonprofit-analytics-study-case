# Data Enrichment MCP — Provider Contract

## Principle

The enrichment engine is capability-driven and provider-agnostic. Free/public providers are the default. Commercial providers are optional adapters only.

## Core capabilities

- `search(query)` — discover relevant public sources
- `fetch(url)` — retrieve an allowed public page
- `extract(content, schema)` — convert source content into structured attributes
- `verify(attribute, evidence)` — assess consistency and confidence
- `record_provenance(attribute, source)` — preserve evidence and retrieval metadata

## Required result fields

Every enrichment attribute should retain:

- `entity_id`
- `attribute`
- `value`
- `source_url`
- `source_type`
- `retrieved_dt`
- `confidence`
- `verification_status`

## Provider priority

1. Open government/open-data sources
2. Free web search
3. Public organisation websites
4. Local/self-hosted capabilities
5. Optional commercial adapters

The core pipeline must remain functional when commercial providers are unavailable.

## Guardrails

- Respect source terms, robots rules and reasonable rate limits.
- Cache fetched results where appropriate.
- Do not infer private personal contact details.
- Prefer official organisation sources for organisation facts.
- Preserve the original source URL for auditability.
