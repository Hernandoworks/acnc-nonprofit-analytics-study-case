"""Free-first web search adapter.

The adapter keeps the MCP provider-neutral: callers depend on SearchProvider,
not on a specific search vendor/library.
"""

from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Protocol


@dataclass(frozen=True)
class SearchResult:
    title: str
    url: str
    snippet: str
    provider: str
    retrieved_dt: str


class SearchProvider(Protocol):
    def search(self, query: str, max_results: int = 10) -> list[SearchResult]: ...


class DDGSProvider:
    """DuckDuckGo metasearch adapter.

    The dependency is imported lazily so the core package can still be tested
    without network/search dependencies installed.
    """

    name = "ddgs"

    def search(self, query: str, max_results: int = 10) -> list[SearchResult]:
        try:
            from ddgs import DDGS
        except ImportError as exc:
            raise RuntimeError("Install the optional 'ddgs' dependency to use this provider") from exc

        retrieved_dt = datetime.now(timezone.utc).isoformat()
        rows = DDGS().text(query, max_results=max_results)
        return [
            SearchResult(
                title=row.get("title", ""),
                url=row.get("href", ""),
                snippet=row.get("body", ""),
                provider=self.name,
                retrieved_dt=retrieved_dt,
            )
            for row in rows
            if row.get("href")
        ]
