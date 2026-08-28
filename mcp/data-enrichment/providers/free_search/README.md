# Free Search Provider

Initial V1 adapter for the reusable enrichment MCP.

## Provider

`DDGSProvider` uses the `ddgs` Python package as a free web-search adapter.

## Contract

Input:

- `query`
- `max_results`

Output:

- `title`
- `url`
- `snippet`
- `provider`
- `retrieved_dt`

The rest of the enrichment system should consume the `SearchProvider` contract and must not depend directly on DDGS.

## Next

Add website ranking/discovery logic above this provider so `find_website()` can score candidate official domains using organisation name, ABN and source evidence.
