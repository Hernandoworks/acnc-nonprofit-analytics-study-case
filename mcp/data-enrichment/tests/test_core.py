import sys
from pathlib import Path

CORE = Path(__file__).resolve().parents[1] / "core"
sys.path.insert(0, str(CORE))

from extractor import PageExtractor
from verification import Verifier


def test_extractor_finds_public_contact_and_headings():
    html = "<h1>Example Charity</h1><a href='/contact'>Contact</a><p>info@example.org.au</p><p>02 9000 0000</p>"
    result = PageExtractor().extract(html, "https://example.org.au")
    assert "info@example.org.au" in result.emails
    assert any("contact" in link for link in result.links)
    assert result.headings == ["Example Charity"]


def test_official_domain_can_be_verified():
    result = Verifier().verify(
        attribute="website",
        value="https://example.org.au",
        source_url="https://example.org.au/about",
        official_domain="example.org.au",
        corroborated=True,
    )
    assert result.verification_status == "verified"
    assert result.confidence >= 0.8
