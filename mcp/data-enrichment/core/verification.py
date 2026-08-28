"""Transparent verification and confidence scoring for enrichment evidence."""

from dataclasses import dataclass
from urllib.parse import urlparse


@dataclass
class VerificationResult:
    confidence: float
    verification_status: str
    reasons: list[str]


class Verifier:
    """Score evidence using explicit, inspectable rules rather than opaque judgement."""

    def verify(
        self,
        *,
        attribute: str,
        value: str,
        source_url: str,
        official_domain: str | None = None,
        corroborated: bool = False,
    ) -> VerificationResult:
        score = 0.20
        reasons: list[str] = ["attribute has a non-empty extracted value"]

        host = (urlparse(source_url).hostname or "").lower()
        if official_domain and host == official_domain.lower().removeprefix("www."):
            score += 0.45
            reasons.append("source is the known official domain")
        elif official_domain and host.endswith("." + official_domain.lower().removeprefix("www.")):
            score += 0.30
            reasons.append("source is a subdomain of the known official domain")

        if corroborated:
            score += 0.25
            reasons.append("attribute is corroborated by another source")

        if attribute in {"email", "phone", "website"}:
            score += 0.10
            reasons.append("attribute was extracted by a deterministic rule")

        confidence = min(round(score, 2), 1.0)
        status = "verified" if confidence >= 0.80 else "review" if confidence >= 0.50 else "unverified"
        return VerificationResult(confidence, status, reasons)
