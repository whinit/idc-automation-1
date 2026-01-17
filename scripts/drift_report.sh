#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

OUT="artifacts/reports/drift/drift_$(date +%Y%m%d_%H%M%S).md"

{
  echo "# Drift Report"
  echo ""
  echo "- Generated: $(date -Is)"
  echo "- Scope: artifacts/normalized"
  echo ""

  # normalized 파일들을 git에 올려둔 기준선 대비 diff 출력
  # (아직 커밋 안했으면 diff가 비어있거나 의미가 약함)
  echo "## Diff (normalized configs)"
  echo ""
  echo '```diff'
  git diff -- artifacts/normalized || true
  echo '```'
} > "$OUT"

echo "OK: wrote $OUT"
