"""Minimal capability-oriented MCP-style service facade.

The business logic stays in core modules so a transport adapter can be
replaced without changing enrichment behaviour. This file currently exposes
plain Python callables; MCP transport wiring is intentionally isolated for the
next integration step.
"""
from .core.batch import enrich_batch
from .core.orchestrator import EnrichmentOrchestrator
from .core.semantic import candidate_sections
from .core.verification import Verifier


class EnrichmentService:
    def __init__(self):
        self.orchestrator = EnrichmentOrchestrator()
        self.verifier = Verifier()

    def fetch_public_page(self, url: str):
        return self.orchestrator.enrich_page(url)

    def extract_public_attributes(self, url: str):
        return self.orchestrator.enrich_page(url)

    def enrich_batch(self, urls: list[str], max_items: int = 50):
        return enrich_batch(urls, self.orchestrator, max_items=max_items)

    def semantic_candidates(self, headings: list[str]):
        return candidate_sections(headings)
