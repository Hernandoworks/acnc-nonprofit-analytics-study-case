"""Conservative semantic field extraction contract.

The first implementation deliberately does not invent facts. It identifies
candidate sections from headings and nearby text so a later local/optional
LLM adapter can classify them with evidence retained.
"""
import re

PROGRAM_TERMS = re.compile(r"\b(program|service|services|initiative|project|support|community)\b", re.I)


def candidate_sections(headings: list[str]) -> list[str]:
    return [h for h in headings if PROGRAM_TERMS.search(h)]
