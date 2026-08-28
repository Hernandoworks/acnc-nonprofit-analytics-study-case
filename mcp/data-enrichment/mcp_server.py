"""MCP transport entry point.

Keeps the transport dependency optional from the enrichment core. Install the
MCP SDK in an environment that needs to expose these tools to an MCP client.
"""
from .server import EnrichmentService


def build_service() -> EnrichmentService:
    return EnrichmentService()


# Tool definitions are intentionally capability-oriented. A transport adapter
# can register these callables with the MCP SDK without coupling core logic to
# the protocol implementation.
TOOL_NAMES = [
    "fetch_public_page",
    "extract_public_attributes",
    "enrich_batch",
    "semantic_candidates",
]
