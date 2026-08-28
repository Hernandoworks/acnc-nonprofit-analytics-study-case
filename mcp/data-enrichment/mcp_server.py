"""MCP-compatible transport entry point.

Uses the official MCP Python SDK when installed. Core enrichment logic remains
independent of the transport so the provider and business layers are reusable.
"""
from .server import EnrichmentService

try:
    from mcp.server.fastmcp import FastMCP
except ImportError:
    FastMCP = None


def create_mcp():
    if FastMCP is None:
        raise RuntimeError("Install the optional MCP SDK to run the MCP transport")

    app = FastMCP("data-enrichment")
    service = EnrichmentService()

    @app.tool()
    def fetch_public_page(url: str):
        """Fetch and deterministically extract public page attributes."""
        return service.fetch_public_page(url).__dict__

    @app.tool()
    def extract_public_attributes(url: str):
        """Extract public emails, phones, links and headings from a page."""
        return service.extract_public_attributes(url).__dict__

    @app.tool()
    def enrich_batch(urls: list[str], max_items: int = 50):
        """Enrich a bounded list of public URLs."""
        return service.enrich_batch(urls, max_items=max_items)

    @app.tool()
    def semantic_candidates(headings: list[str]):
        """Return headings that may contain program/service information."""
        return service.semantic_candidates(headings)

    return app


if __name__ == "__main__":
    create_mcp().run()
