#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

ansible-playbook ansible/backup_only.yml
./scripts/normalize_config.py

if git diff --quiet -- artifacts/normalized; then
  echo "OK: No drift."
  exit 0
fi

# --- drift 발생 후 ---
./scripts/drift_report.sh

REPORT_FILE=$(ls -t artifacts/reports/drift/drift_*.md | head -1)

# 변경된 장비(= normalized cfg 파일명에서 추출)
CHANGED_HOSTS=$(git diff --name-only -- artifacts/normalized \
  | sed 's#.*/##; s#\.cfg##' | sort -u | tr '\n' ',' | sed 's/,$//')

# 변경 파일 수
CHANGED_FILES=$(git diff --name-only -- artifacts/normalized | wc -l | tr -d ' ')

# +/- 라인 수 요약
# 예: " 1 file changed, 23 insertions(+), 1 deletion(-)"
DIFF_STAT=$(git diff --stat -- artifacts/normalized | tail -n 1 | sed 's/^[[:space:]]*//')

MSG="drift: update normalized configs (${CHANGED_FILES} file(s))"

git add artifacts/normalized artifacts/reports/drift
git commit -m "$MSG"

# 🔔 Slack 알림 (diff 요약 포함)
./scripts/notify_slack.sh \
  "🚨 Network Config Drift Detected" \
  "Changed device(s): \`${CHANGED_HOSTS}\`\nChanges: \`${DIFF_STAT}\`\nReport: \`${REPORT_FILE}\`"

