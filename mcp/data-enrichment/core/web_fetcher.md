# Web Fetcher

A bounded fetch layer for public enrichment sources.

## Practical controls

- HTTP/HTTPS only
- 10-second default timeout
- 2 MB response limit
- HTML/text/JSON only
- Redirects allowed
- Identifiable user agent
- Structured error results
- Retrieval timestamp on every response

## Production rule

This component is a fetch primitive, not a crawler. The orchestration layer must control URL count, caching, rate limits and source-specific robots/terms requirements before fetching pages in volume.
