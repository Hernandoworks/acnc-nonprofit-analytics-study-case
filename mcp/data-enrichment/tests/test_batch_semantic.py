from mcp.data_enrichment.core.batch import enrich_batch
from mcp.data_enrichment.core.semantic import candidate_sections


def test_semantic_candidates_are_conservative():
    assert candidate_sections(["About us", "Our Programs", "Contact"]) == ["Our Programs"]


def test_batch_has_a_hard_limit():
    try:
        enrich_batch(["https://example.org"] * 51, max_items=50)
    except ValueError as exc:
        assert "50" in str(exc)
    else:
        raise AssertionError("expected batch limit")
