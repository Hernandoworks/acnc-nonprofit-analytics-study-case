"""Deterministic website candidate scoring for the enrichment MCP."""

from dataclasses import dataclass
from urllib.parse import urlparse
import re


@dataclass
class WebsiteCandidate:
    title: str
    url: str
    snippet: str = ""


def _normalise(text: str) -> str:
    return re.sub(r"[^a-z0-9]+", " ", text.lower()).strip()


def _tokens(text: str) -> set[str]:
    return {t for t in _normalise(text).split() if len(t) > 2}


def score_candidate(
    organisation_name: str,
    candidate: WebsiteCandidate,
    abn: str | None = None,
) -> int:
    """Return a transparent heuristic score; not an identity assertion."""
    score = 0
    name = _normalise(organisation_name)
    title = _normalise(candidate.title)
    snippet = _normalise(candidate.snippet)
    url = candidate.url.lower()
    host = urlparse(candidate.url).netloc.lower()

    if name and name in title:
        score += 40
    else:
        name_tokens = _tokens(organisation_name)
        title_tokens = _tokens(candidate.title)
        if name_tokens:
            overlap = len(name_tokens & title_tokens) / len(name_tokens)
            score += round(40 * overlap)

    if host.endswith((".org.au", ".com.au", ".gov.au")):
        score += 20

    if _normalise(organisation_name) in snippet:
        score += 15

    if abn and re.sub(r"\D", "", abn) in re.sub(r"\D", "", candidate.snippet):
        score += 10

    if any(term in (title + " " + snippet) for term in ("contact", "about", "our services")):
        score += 10

    blocked = ("facebook.com", "linkedin.com", "instagram.com", "directory", "yellowpages", "news")
    if any(domain in host for domain in blocked):
        score -= 40

    return score


def rank_candidates(
    organisation_name: str,
    candidates: list[WebsiteCandidate],
    abn: str | None = None,
    threshold: int = 60,
) -> list[tuple[WebsiteCandidate, int]]:
    ranked = [(candidate, score_candidate(organisation_name, candidate, abn)) for candidate in candidates]
    return sorted(ranked, key=lambda item: item[1], reverse=True)
