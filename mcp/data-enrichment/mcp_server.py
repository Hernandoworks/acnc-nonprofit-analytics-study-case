"""MCP transport entry point using the official Python SDK."""
from .server import EnrichmentService

from mcp.server.fastmcp import FastMCP


def create_mcp() -> FastMCP:
    app = FastMCP("data-enrichment")
    service = EnrichmentService()

    @app.tool()
    def fetch_public_page(url: str):
        """Fetch a bounded public page and extract deterministic attributes."""
        return service.fetch_public_page(url).__dict__

    @app.tool()
    def extract_public_attributes(url: str):
        """Extract public emails, phones, links and headings."""
        return service.extract_public_attributes(url).__dict__

    @app.tool()
    def enrich_batch(urls: list[str], max_items: int = 50):
        """Enrich a bounded list of public URLs."""
        return service.enrich_batch(urls, max_items=max_items)

    @app.tool()
    def semantic_candidates(headings: list[str]):
        """Identify headings that may contain program or service information."""
        return service.semantic_candidates(headings)

    return app


if __name__ == "__main__":
    create_mcp().run()
