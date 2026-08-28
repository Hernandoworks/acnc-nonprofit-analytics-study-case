"""Simple filesystem cache for fetched enrichment responses."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
from time import time


class FileCache:
    def __init__(self, directory: str = ".cache/enrichment", ttl_seconds: int = 86400):
        self.directory = Path(directory)
        self.ttl_seconds = ttl_seconds

    def _path(self, key: str) -> Path:
        digest = hashlib.sha256(key.encode("utf-8")).hexdigest()
        return self.directory / f"{digest}.json"

    def get(self, key: str):
        path = self._path(key)
        if not path.exists() or time() - path.stat().st_mtime > self.ttl_seconds:
            return None
        return json.loads(path.read_text(encoding="utf-8"))

    def set(self, key: str, value) -> None:
        self.directory.mkdir(parents=True, exist_ok=True)
        self._path(key).write_text(json.dumps(value, ensure_ascii=False), encoding="utf-8")
