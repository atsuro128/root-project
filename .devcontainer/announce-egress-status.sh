#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

readonly VERIFY_LOG="/tmp/devcontainer-egress-check.log"
readonly VERIFY_STATUS="/tmp/devcontainer-egress-check.status"

if [[ ! -f "$VERIFY_STATUS" ]]; then
  echo "[INFO] Egress verification status is not available yet."
  exit 0
fi

status=""
finished_at=""
log_path="$VERIFY_LOG"

while IFS='=' read -r key value; do
  case "$key" in
    STATUS) status="$value" ;;
    FINISHED_AT) finished_at="$value" ;;
    LOG_PATH) log_path="$value" ;;
  esac
done < "$VERIFY_STATUS"

case "$status" in
  PASS)
    echo "[INFO] Egress verification: PASS (${finished_at})"
    ;;
  FAIL)
    echo "[ERROR] Egress verification: FAIL (${finished_at})"
    ;;
  *)
    echo "[INFO] Egress verification status is unavailable."
    ;;
esac

if [[ -f "$log_path" ]]; then
  echo "[INFO] Details: ${log_path}"
fi
