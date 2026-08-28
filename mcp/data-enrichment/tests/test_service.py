from mcp.data_enrichment.server import EnrichmentService


def test_service_exposes_capabilities():
    service = EnrichmentService()
    assert callable(service.fetch_public_page)
    assert callable(service.extract_public_attributes)
    assert callable(service.enrich_batch)
    assert service.semantic_candidates(["Our Services"]) == ["Our Services"]
