"""Bounded batch enrichment with explicit concurrency limits."""
from dataclasses import asdict
from .orchestrator import EnrichmentOrchestrator


def enrich_batch(urls: list[str], orchestrator: EnrichmentOrchestrator | None = None, max_items: int = 50):
    if len(urls) > max_items:
        raise ValueError(f"batch exceeds safety limit of {max_items} URLs")
    runner = orchestrator or EnrichmentOrchestrator()
    return [asdict(runner.enrich_page(url)) for url in urls]
