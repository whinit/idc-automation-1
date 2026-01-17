#!/usr/bin/env bash
set -euo pipefail

WEBHOOK_URL="${SLACK_WEBHOOK_URL:?SLACK_WEBHOOK_URL not set}"

TITLE="$1"
MESSAGE="$2"

payload=$(cat <<EOF
{
  "text": "*${TITLE}*\n${MESSAGE}"
}
EOF
)

curl -s -X POST -H 'Content-type: application/json' \
  --data "$payload" \
  "$WEBHOOK_URL" > /dev/null
