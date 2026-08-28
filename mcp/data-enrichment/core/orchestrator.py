"""Small orchestration layer for practical, bounded enrichment."""

from dataclasses import dataclass
from datetime import datetime, timezone

from .cache import FileCache
from .extractor import PageExtractor
from .web_fetcher import WebFetcher


@dataclass
class EnrichmentRun:
    url: str
    status: str
    retrieved_dt: str
    attributes: dict


class EnrichmentOrchestrator:
    def __init__(self, fetcher=None, extractor=None, cache=None):
        self.fetcher = fetcher or WebFetcher()
        self.extractor = extractor or PageExtractor()
        self.cache = cache or FileCache()

    def enrich_page(self, url: str) -> EnrichmentRun:
        cached = self.cache.get(url)
        if cached:
            return EnrichmentRun(url, "cached", cached["retrieved_dt"], cached["attributes"])

        result = self.fetcher.fetch(url)
        if result.error:
            return EnrichmentRun(url, result.error, result.retrieved_dt, {})

        extracted = self.extractor.extract(result.content, url)
        attributes = {
            "emails": extracted.emails,
            "phones": extracted.phones,
            "links": extracted.links,
            "headings": extracted.headings,
        }
        payload = {
            "retrieved_dt": result.retrieved_dt,
            "attributes": attributes,
        }
        self.cache.set(url, payload)
        return EnrichmentRun(url, "fetched", result.retrieved_dt, attributes)
