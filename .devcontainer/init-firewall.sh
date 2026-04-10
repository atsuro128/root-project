#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

readonly SQUID_USER="proxy"
readonly SQUID_UID="$(id -u "${SQUID_USER}")"
readonly SQUID_CONFIG="/etc/squid/squid.conf"
readonly SQUID_PID_FILE="/var/run/squid.pid"
readonly SQUID_ALLOWLIST="/etc/squid/proxy-allowlist.txt"
readonly RENDER_SCRIPT="/usr/local/bin/render-squid-config.sh"
readonly VERIFY_SCRIPT="/usr/local/bin/verify-egress.sh"
readonly VERIFY_LOG="/tmp/devcontainer-egress-check.log"
readonly VERIFY_STATUS="/tmp/devcontainer-egress-check.status"
readonly NAT_CHAIN="CODEX_PROXY_REDIRECT"
readonly HOST_GATEWAY_TCP_PORTS_RAW="${HOST_GATEWAY_TCP_PORTS:-3000,5432,8080}"

UPSTREAM_PROXY_HOST="${UPSTREAM_PROXY_HOST:-}"
UPSTREAM_PROXY_PORT="${UPSTREAM_PROXY_PORT:-}"

declare -a DNS_SERVERS=()
declare -a HOST_GATEWAY_TCP_PORTS=()

log_info() {
  echo "[INFO] $*"
}

die() {
  echo "[ERROR] $*" >&2
  exit 1
}

require_root() {
  if [[ "$(id -u)" -ne 0 ]]; then
    die "init-firewall.sh must run as root."
  fi
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

validate_upstream_env() {
  if [[ -n "$UPSTREAM_PROXY_HOST" || -n "$UPSTREAM_PROXY_PORT" ]]; then
    [[ -n "$UPSTREAM_PROXY_HOST" && -n "$UPSTREAM_PROXY_PORT" ]] || die "UPSTREAM_PROXY_HOST and UPSTREAM_PROXY_PORT must be set together."
    [[ "$UPSTREAM_PROXY_PORT" =~ ^[0-9]+$ ]] || die "UPSTREAM_PROXY_PORT must be numeric."
  fi
}

load_dns_servers() {
  mapfile -t DNS_SERVERS < <(awk '/^nameserver/ { print $2 }' /etc/resolv.conf | sort -u)
  ((${#DNS_SERVERS[@]} > 0)) || die "No DNS servers found in /etc/resolv.conf."
}

load_host_gateway_ports() {
  local raw="${HOST_GATEWAY_TCP_PORTS_RAW//[[:space:]]/}"
  local port

  HOST_GATEWAY_TCP_PORTS=()
  [[ -n "$raw" ]] || return 0

  IFS=',' read -r -a HOST_GATEWAY_TCP_PORTS <<< "$raw"
  for port in "${HOST_GATEWAY_TCP_PORTS[@]}"; do
    [[ "$port" =~ ^[0-9]+$ ]] || die "HOST_GATEWAY_TCP_PORTS must contain only numeric ports."
    ((port >= 1 && port <= 65535)) || die "HOST_GATEWAY_TCP_PORTS contains an out-of-range port: $port"
  done
}

detect_host_gateway() {
  local gateway
  gateway="$(ip route show default | awk '{print $3; exit}')"
  [[ -n "$gateway" ]] || die "Failed to detect host gateway from default route."
  echo "$gateway"
}

resolve_ipv4() {
  local host="$1"
  getent ahostsv4 "$host" | awk '{print $1}' | sort -u
}

wait_for_squid_startup() {
  local pid=""
  local attempt

  for attempt in {1..20}; do
    if [[ -f "$SQUID_PID_FILE" ]]; then
      pid="$(tr -d '[:space:]' < "$SQUID_PID_FILE")"
      if [[ "$pid" =~ ^[0-9]+$ ]] && kill -0 "$pid" 2>/dev/null; then
        return 0
      fi
    fi

    sleep 0.5
  done

  return 1
}

render_and_start_squid() {
  "$RENDER_SCRIPT"

  squid -k parse -f "$SQUID_CONFIG" >/dev/null || die "Squid config validation failed: $SQUID_CONFIG"

  if pgrep -x squid >/dev/null; then
    log_info "Stopping existing Squid process."
    squid -k shutdown || true
    sleep 1
    pkill -x squid 2>/dev/null || true
  fi

  log_info "Starting Squid."
  rm -f "$SQUID_PID_FILE"
  squid -f "$SQUID_CONFIG"

  if ! wait_for_squid_startup; then
    tail -n 50 /var/log/squid/cache.log >&2 || true
    die "Squid failed to start."
  fi
}

configure_proxy_egress_rules() {
  if [[ -n "$UPSTREAM_PROXY_HOST" ]]; then
    local ip
    local -a upstream_ips=()

    mapfile -t upstream_ips < <(resolve_ipv4 "$UPSTREAM_PROXY_HOST")
    ((${#upstream_ips[@]} > 0)) || die "Failed to resolve upstream proxy host: $UPSTREAM_PROXY_HOST"

    for ip in "${upstream_ips[@]}"; do
      iptables -A OUTPUT -m owner --uid-owner "$SQUID_UID" -p tcp -d "$ip" --dport "$UPSTREAM_PROXY_PORT" -j ACCEPT
    done

    log_info "Allowed Squid egress only to upstream proxy ${UPSTREAM_PROXY_HOST}:${UPSTREAM_PROXY_PORT} (${#upstream_ips[@]} IPv4 addresses)."
    return
  fi

  iptables -A OUTPUT -m owner --uid-owner "$SQUID_UID" -p tcp --dport 80 -j ACCEPT
  iptables -A OUTPUT -m owner --uid-owner "$SQUID_UID" -p tcp --dport 443 -j ACCEPT

  log_info "Allowed Squid direct egress on tcp/80 and tcp/443; destination filtering is enforced by Squid allowlist."
}

configure_filter_rules() {
  local host_gateway="$1"
  local dns
  local port

  iptables -F
  iptables -X

  iptables -P INPUT DROP
  iptables -P FORWARD DROP
  iptables -P OUTPUT DROP

  iptables -A INPUT -i lo -j ACCEPT
  iptables -A OUTPUT -o lo -j ACCEPT

  iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
  iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

  if [[ -n "$host_gateway" && ${#HOST_GATEWAY_TCP_PORTS[@]} -gt 0 ]]; then
    for port in "${HOST_GATEWAY_TCP_PORTS[@]}"; do
      iptables -A INPUT -s "$host_gateway" -p tcp --dport "$port" -j ACCEPT
    done
    log_info "Allowed host gateway inbound access on tcp/${HOST_GATEWAY_TCP_PORTS_RAW}."
  else
    log_info "Host gateway inbound access is disabled."
  fi

  for dns in "${DNS_SERVERS[@]}"; do
    iptables -A OUTPUT -p udp -d "$dns" --dport 53 -j ACCEPT
    iptables -A OUTPUT -p tcp -d "$dns" --dport 53 -j ACCEPT
    iptables -A INPUT -p udp -s "$dns" --sport 53 -j ACCEPT
    iptables -A INPUT -p tcp -s "$dns" --sport 53 -j ACCEPT
  done

  configure_proxy_egress_rules

  iptables -A OUTPUT -j REJECT --reject-with icmp-admin-prohibited
}

reset_nat_rules() {
  while iptables -t nat -C OUTPUT -j "$NAT_CHAIN" >/dev/null 2>&1; do
    iptables -t nat -D OUTPUT -j "$NAT_CHAIN"
  done

  if iptables -t nat -L "$NAT_CHAIN" >/dev/null 2>&1; then
    iptables -t nat -F "$NAT_CHAIN"
    iptables -t nat -X "$NAT_CHAIN"
  fi
}

run_verification() {
  local started_at
  local finished_at
  local status="FAIL"
  local exit_code=0

  started_at="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  rm -f "$VERIFY_LOG" "$VERIFY_STATUS"

  if "$VERIFY_SCRIPT" "$SQUID_ALLOWLIST" \
    > >(tee "$VERIFY_LOG") \
    2> >(tee -a "$VERIFY_LOG" >&2); then
    status="PASS"
  else
    exit_code=$?
  fi

  finished_at="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  cat > "$VERIFY_STATUS" <<EOF
STATUS=${status}
STARTED_AT=${started_at}
FINISHED_AT=${finished_at}
LOG_PATH=${VERIFY_LOG}
EOF
  chmod 0644 "$VERIFY_LOG" "$VERIFY_STATUS"

  if [[ "$status" == "PASS" ]]; then
    log_info "Egress verification passed. See ${VERIFY_LOG}"
    return 0
  fi

  log_info "Egress verification failed. See ${VERIFY_LOG}"
  return "$exit_code"
}

main() {
  require_root
  require_command iptables
  require_command squid
  require_command curl
  require_command getent
  require_command "$RENDER_SCRIPT"
  require_command "$VERIFY_SCRIPT"

  validate_upstream_env
  load_dns_servers
  load_host_gateway_ports

  local host_gateway=""
  if ((${#HOST_GATEWAY_TCP_PORTS[@]} > 0)); then
    host_gateway="$(detect_host_gateway)"
    log_info "Detected host gateway: $host_gateway"
  fi

  render_and_start_squid
  reset_nat_rules
  configure_filter_rules "$host_gateway"
  run_verification

  log_info "Firewall and proxy configuration complete."
}

main "$@"
