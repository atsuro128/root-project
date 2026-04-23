#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

readonly ALLOWLIST_PATH="${ALLOWLIST_PATH:-${1:-/etc/squid/proxy-allowlist.txt}}"
readonly CONNECT_TIMEOUT="${CONNECT_TIMEOUT:-8}"
readonly MAX_TIME="${MAX_TIME:-20}"
readonly USER_AGENT="${USER_AGENT:-devcontainer-egress-verifier/1.0}"
readonly PROXY_URL="${PROXY_URL:-http://127.0.0.1:3127}"

die() {
  echo "[ERROR] $*" >&2
  exit 1
}

proxy_endpoint() {
  if [[ "$PROXY_URL" =~ ^https?://([^/:]+):([0-9]+)/?$ ]]; then
    printf "%s %s\n" "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
    return 0
  fi

  die "Unsupported PROXY_URL format: ${PROXY_URL}"
}

check_proxy_ready() {
  local host
  local port
  local attempt

  IFS=' ' read -r host port < <(proxy_endpoint)
  [[ -n "$host" && -n "$port" ]] || die "Failed to parse PROXY_URL: ${PROXY_URL}"

  for attempt in {1..20}; do
    if (exec 3<>"/dev/tcp/${host}/${port}") >/dev/null 2>&1; then
      echo "[PASS] proxy listening: ${PROXY_URL}"
      return 0
    fi

    sleep 0.25
  done

  die "proxy is not reachable: ${PROXY_URL}"
}

run_curl() {
  curl \
    --silent \
    --show-error \
    --output /dev/null \
    --connect-timeout "$CONNECT_TIMEOUT" \
    --max-time "$MAX_TIME" \
    --user-agent "$USER_AGENT" \
    "$@"
}

check_reachable() {
  local host="$1"
  local url="https://${host}"

  if run_curl --proxy "$PROXY_URL" "$url"; then
    echo "[PASS] reachable: ${host}"
  else
    die "reachable check failed: ${host}"
  fi
}

check_blocked() {
  local url="$1"
  local curl_stderr

  curl_stderr="$(mktemp)"

  if run_curl --proxy "$PROXY_URL" "$url" 2>"$curl_stderr"; then
    rm -f "$curl_stderr"
    die "blocked check failed (unexpectedly reachable): ${url}"
  fi

  if grep -qiE "Failed to connect|Could not resolve proxy|Connection refused" "$curl_stderr"; then
    cat "$curl_stderr" >&2
    rm -f "$curl_stderr"
    die "blocked check inconclusive because proxy was unavailable: ${url}"
  fi

  rm -f "$curl_stderr"
  echo "[PASS] blocked: ${url}"
}

check_direct_blocked() {
  local url="$1"

  if HTTP_PROXY= HTTPS_PROXY= ALL_PROXY= http_proxy= https_proxy= all_proxy= \
    run_curl --proxy "" --noproxy "*" "$url"; then
    die "direct egress check failed (unexpectedly reachable): ${url}"
  else
    echo "[PASS] direct blocked: ${url}"
  fi
}

[[ -f "$ALLOWLIST_PATH" ]] || die "Allowlist file not found: $ALLOWLIST_PATH"

echo "[INFO] Verifying egress via proxy: ${PROXY_URL}"
check_proxy_ready

mapfile -t allow_hosts < <(
  awk '
    /^[[:space:]]*#/ { next }
    /^[[:space:]]*$/ { next }
    {
      host=tolower($0)
      gsub(/\r/, "", host)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", host)
      print host
    }
  ' "$ALLOWLIST_PATH" | sort -u
)

((${#allow_hosts[@]} > 0)) || die "Allowlist is empty: $ALLOWLIST_PATH"

echo "[INFO] Checking explicit block target"
check_blocked "https://example.com"

echo "[INFO] Checking required OpenAI endpoints"
check_reachable "chatgpt.com"
check_reachable "auth.openai.com"
check_reachable "api.openai.com"

echo "[INFO] Checking required Anthropic endpoints"
check_reachable "api.anthropic.com"
check_reachable "platform.claude.com"
check_reachable "downloads.claude.ai"

echo "[INFO] Checking required GitHub endpoints"
check_reachable "github.com"
check_reachable "api.github.com"

echo "[INFO] Checking direct egress is fail-closed"
check_direct_blocked "https://api.openai.com"

echo "[INFO] Checking allowlist hosts (${#allow_hosts[@]})"
for host in "${allow_hosts[@]}"; do
  check_reachable "$host"
done

echo "[INFO] Egress verification completed successfully"
