"""Conservative public-web fetcher for the reusable enrichment MCP."""

from dataclasses import dataclass
from datetime import datetime, timezone
from urllib.parse import urlparse

import requests


@dataclass
class FetchResult:
    url: str
    status_code: int | None
    content_type: str | None
    content: str
    retrieved_dt: str
    error: str | None = None


class WebFetcher:
    """Fetch small public HTML/text resources with bounded network behaviour."""

    def __init__(self, timeout_seconds: int = 10, max_bytes: int = 2_000_000):
        self.timeout_seconds = timeout_seconds
        self.max_bytes = max_bytes

    def fetch(self, url: str) -> FetchResult:
        retrieved_dt = datetime.now(timezone.utc).isoformat()
        parsed = urlparse(url)
        if parsed.scheme not in {"http", "https"} or not parsed.netloc:
            return FetchResult(url, None, None, "", retrieved_dt, "invalid_url")

        try:
            response = requests.get(
                url,
                timeout=self.timeout_seconds,
                headers={"User-Agent": "DataEnrichmentMCP/0.1 (research; contact via repository)"},
                allow_redirects=True,
            )
            content_type = response.headers.get("Content-Type", "")
            if "text/" not in content_type and "html" not in content_type and "json" not in content_type:
                return FetchResult(url, response.status_code, content_type, "", retrieved_dt, "unsupported_content_type")

            body = response.content
            if len(body) > self.max_bytes:
                return FetchResult(url, response.status_code, content_type, "", retrieved_dt, "response_too_large")

            response.encoding = response.encoding or "utf-8"
            return FetchResult(url, response.status_code, content_type, response.text, retrieved_dt)
        except requests.RequestException as exc:
            return FetchResult(url, None, None, "", retrieved_dt, type(exc).__name__)
