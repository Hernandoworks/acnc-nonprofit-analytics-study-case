"""Deterministic first-pass extraction from public organisation pages."""

from dataclasses import dataclass
import re
from urllib.parse import urljoin


@dataclass
class ExtractionResult:
    emails: list[str]
    phones: list[str]
    links: list[str]
    headings: list[str]


EMAIL_RE = re.compile(r"[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}", re.I)
PHONE_RE = re.compile(r"(?:\+?61\s?|0)(?:\(?\d{1,2}\)?[\s.-]?){3,5}\d")
HREF_RE = re.compile(r'''href=[\"']([^\"']+)[\"']''', re.I)
HEADING_RE = re.compile(r"<h[1-3][^>]*>(.*?)</h[1-3]>", re.I | re.S)
TAG_RE = re.compile(r"<[^>]+>")


def _clean(value: str) -> str:
    return re.sub(r"\s+", " ", TAG_RE.sub(" ", value)).strip()


class PageExtractor:
    """Extract high-confidence, pattern-based attributes before any AI enrichment."""

    def extract(self, html: str, base_url: str) -> ExtractionResult:
        emails = sorted(set(EMAIL_RE.findall(html)))
        phones = sorted(set(m.group(0).strip() for m in PHONE_RE.finditer(html)))
        links = sorted(set(urljoin(base_url, href) for href in HREF_RE.findall(html)))
        headings = [_clean(h) for h in HEADING_RE.findall(html)]
        headings = [h for h in headings if h]
        return ExtractionResult(emails, phones, links, headings)
