#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

readonly ALLOWLIST_SOURCE="${ALLOWLIST_SOURCE:-/usr/local/share/proxy-allowlist.txt}"
readonly ALLOWLIST_PATH="${ALLOWLIST_PATH:-/etc/squid/proxy-allowlist.txt}"
readonly ALLOWLIST_REGEX_PATH="${ALLOWLIST_REGEX_PATH:-/etc/squid/proxy-allowlist.regex}"
readonly SQUID_CONFIG="${SQUID_CONFIG:-/etc/squid/squid.conf}"
readonly SQUID_FORWARD_PORT="${SQUID_FORWARD_PORT:-3127}"

UPSTREAM_PROXY_HOST="${UPSTREAM_PROXY_HOST:-}"
UPSTREAM_PROXY_PORT="${UPSTREAM_PROXY_PORT:-}"
UPSTREAM_PROXY_USERNAME="${UPSTREAM_PROXY_USERNAME:-}"
UPSTREAM_PROXY_PASSWORD="${UPSTREAM_PROXY_PASSWORD:-}"
UPSTREAM_PROXY_PASSWORD_FILE="${UPSTREAM_PROXY_PASSWORD_FILE:-}"
CACHE_PEER_DIRECTIVE=""
ROUTING_DIRECTIVES="always_direct allow all"

die() {
  echo "[ERROR] $*" >&2
  exit 1
}

escape_regex() {
  local value="$1"
  sed -e 's/[][(){}.^$*+?|\\-]/\\&/g' <<<"$value"
}

validate_upstream() {
  if [[ -n "$UPSTREAM_PROXY_HOST" || -n "$UPSTREAM_PROXY_PORT" ]]; then
    [[ -n "$UPSTREAM_PROXY_HOST" && -n "$UPSTREAM_PROXY_PORT" ]] || die "UPSTREAM_PROXY_HOST and UPSTREAM_PROXY_PORT must be set together."
    [[ "$UPSTREAM_PROXY_PORT" =~ ^[0-9]+$ ]] || die "UPSTREAM_PROXY_PORT must be numeric."
  fi

  if [[ -n "$UPSTREAM_PROXY_USERNAME" ]]; then
    [[ -n "$UPSTREAM_PROXY_PASSWORD" || -n "$UPSTREAM_PROXY_PASSWORD_FILE" ]] || die "UPSTREAM_PROXY_PASSWORD or UPSTREAM_PROXY_PASSWORD_FILE is required when UPSTREAM_PROXY_USERNAME is set."
  fi

  if [[ -n "$UPSTREAM_PROXY_PASSWORD_FILE" && ! -f "$UPSTREAM_PROXY_PASSWORD_FILE" ]]; then
    die "UPSTREAM_PROXY_PASSWORD_FILE does not exist: $UPSTREAM_PROXY_PASSWORD_FILE"
  fi
}

prepare_allowlist_files() {
  [[ -f "$ALLOWLIST_SOURCE" ]] || die "Allowlist file not found: $ALLOWLIST_SOURCE"
  mkdir -p "$(dirname "$ALLOWLIST_PATH")"
  mkdir -p "$(dirname "$ALLOWLIST_REGEX_PATH")"

  mapfile -t hosts < <(
    awk '
      /^[[:space:]]*#/ { next }
      /^[[:space:]]*$/ { next }
      {
        host=tolower($0)
        gsub(/\r/, "", host)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", host)
        print host
      }
    ' "$ALLOWLIST_SOURCE" | sort -u
  )

  ((${#hosts[@]} > 0)) || die "Allowlist is empty."

  : > "$ALLOWLIST_PATH"
  : > "$ALLOWLIST_REGEX_PATH"

  for host in "${hosts[@]}"; do
    [[ "$host" =~ ^[a-z0-9.-]+$ ]] || die "Invalid allowlist hostname: $host"
    printf "%s\n" "$host" >> "$ALLOWLIST_PATH"
    printf "^(https?://)?%s(:[0-9]+)?(/|$)\n" "$(escape_regex "$host")" >> "$ALLOWLIST_REGEX_PATH"
  done

  chmod 0644 "$ALLOWLIST_PATH" "$ALLOWLIST_REGEX_PATH"
}

build_upstream_directives() {
  local upstream_password=""
  CACHE_PEER_DIRECTIVE=""
  ROUTING_DIRECTIVES="always_direct allow all"

  if [[ -z "$UPSTREAM_PROXY_HOST" ]]; then
    return
  fi

  CACHE_PEER_DIRECTIVE="cache_peer ${UPSTREAM_PROXY_HOST} parent ${UPSTREAM_PROXY_PORT} 0 no-query default"
  ROUTING_DIRECTIVES=$'never_direct allow all\nprefer_direct off'

  if [[ -z "$UPSTREAM_PROXY_USERNAME" ]]; then
    return
  fi

  if [[ -n "$UPSTREAM_PROXY_PASSWORD" ]]; then
    upstream_password="$UPSTREAM_PROXY_PASSWORD"
  else
    upstream_password="$(tr -d '\r\n' < "$UPSTREAM_PROXY_PASSWORD_FILE")"
  fi
  [[ -n "$upstream_password" ]] || die "Upstream proxy password is empty."
  CACHE_PEER_DIRECTIVE="${CACHE_PEER_DIRECTIVE} login=${UPSTREAM_PROXY_USERNAME}:${upstream_password}"
}

render_squid_config() {
  cat > "$SQUID_CONFIG" <<EOF
visible_hostname devcontainer-squid
pid_filename /var/run/squid.pid
pinger_enable off

access_log stdio:/var/log/squid/access.log squid
cache_log stdio:/var/log/squid/cache.log
cache_store_log none

cache deny all

http_port 127.0.0.1:${SQUID_FORWARD_PORT}

acl CONNECT method CONNECT
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 443
acl allowed_targets url_regex -i "${ALLOWLIST_REGEX_PATH}"

http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow allowed_targets
http_access deny all

${CACHE_PEER_DIRECTIVE}
${ROUTING_DIRECTIVES}
EOF

  chmod 0644 "$SQUID_CONFIG"
}

validate_upstream
prepare_allowlist_files
build_upstream_directives
render_squid_config

echo "[INFO] Rendered Squid config: $SQUID_CONFIG"
echo "[INFO] Allowlist entries: $(wc -l < "$ALLOWLIST_PATH")"
