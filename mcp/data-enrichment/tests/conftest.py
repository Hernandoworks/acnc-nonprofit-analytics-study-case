import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PACKAGE = ROOT / "data-enrichment"
if str(PACKAGE) not in sys.path:
    sys.path.insert(0, str(PACKAGE))
