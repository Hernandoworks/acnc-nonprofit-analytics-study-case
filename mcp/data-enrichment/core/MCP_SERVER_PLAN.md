# MCP Server Plan

Expose the reusable enrichment engine through capability-oriented tools:

- `search_entities(query, limit)`
- `find_website(entity_name, abn=None)`
- `fetch_public_page(url)`
- `extract_public_attributes(url)`
- `verify_attribute(...)`
- `enrich_entity(entity_type, entity_id, attributes)`
- `enrich_batch(entities, attributes)`

The server must remain profile-driven. `nonprofit.yml` supplies the first profile.

Commercial APIs are optional adapters and are never required by the server contract.
