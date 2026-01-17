#!/usr/bin/env bash
set -euo pipefail

# === 환경 고정 ===
export HOME="/home/kch"
export PATH="/usr/bin:/bin:/usr/sbin:/sbin"

# Slack Webhook (환경변수로만 주입)
: "${SLACK_WEBHOOK_URL:?SLACK_WEBHOOK_URL not set}"

# 프로젝트 경로
cd /home/kch/idc-automation

# venv 활성화
source .venv/bin/activate

# 실행
./scripts/run_backup_drift_commit.sh
