#!/usr/bin/env bash
# Refresh OSS-wedge catalog + results from monorepo sources.
# Run from monorepo root or from this script's directory.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
DEST="$(cd "$(dirname "$0")/.." && pwd)"

cp "$ROOT/packages/schema/field-types/catalog.json" "$DEST/catalog/catalog.json"
cp "$ROOT/www/src/data/benchmarks/results.json" "$DEST/results/results.json"
cp "$ROOT/www/src/data/benchmarks/results-history.json" "$DEST/results/results-history.json"
if [[ -f "$ROOT/docs/benchmarks/methodology.md" ]]; then
  cp "$ROOT/docs/benchmarks/methodology.md" "$DEST/docs/methodology.md"
fi

python3 - <<PY
import json
from pathlib import Path
cat = json.loads(Path("$DEST/catalog/catalog.json").read_text())
types = cat.get("types") or []
cats = cat.get("categories") or []
print(f"catalog: {len(types)} types, {len(cats)} categories")
res = json.loads(Path("$DEST/results/results.json").read_text())
print(f"results: generated_at={res.get('generated_at')} datasets={len(res.get('datasets') or [])}")
print("OK synced to", "$DEST")
PY
