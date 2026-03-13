#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, and pipeline failures
IFS=$'\n\t'       # Stricter word splitting

###############################################################################
# Step 1: Generate squid.conf (SNI transparent proxy)
###############################################################################
echo "=== Step 1: Generating squid.conf ==="

# Domain allowlist (shared between HTTP dstdomain and HTTPS SNI matching)
ALLOWED_DOMAINS="\
  .github.com \
  .githubusercontent.com \
  .githubassets.com \
  registry.npmjs.org \
  pypi.org \
  files.pythonhosted.org \
  proxy.golang.org \
  sum.golang.org \
  storage.googleapis.com \
  api.anthropic.com \
  statsig.anthropic.com \
  sentry.io \
  statsig.com \
  .visualstudio.com \
  vscode.blob.core.windows.net \
  update.code.visualstudio.com \
  .openai.com \
  challenges.cloudflare.com \
  discord.com \
  gateway.discord.gg"

cat > /etc/squid/squid.conf <<SQUID_CONF
# --- SNI Transparent Proxy: FQDN allowlist ---

# Explicit proxy (for tools that natively support proxy)
http_port 3128

# Transparent intercept for HTTP (port 80)
http_port 3129 intercept

# Transparent intercept for HTTPS (port 443) — SNI peek/splice
https_port 3130 intercept ssl-bump \\
  cert=/etc/squid/ssl/squid-ca.pem \\
  generate-host-certificates=on \\
  dynamic_cert_mem_cache_size=4MB

# Certificate generator for ssl-bump
sslcrtd_program /usr/lib/squid/security_file_certgen -s /var/lib/squid/ssl_db -M 4MB

# Disable caching (pure proxy)
cache deny all

# DNS: Docker internal resolver + fallback
dns_nameservers 127.0.0.11 8.8.8.8

# Logging
access_log /var/log/squid/access.log

# --- ACL: allowed destination domains (HTTP / explicit proxy) ---
acl allowed_domains dstdomain ${ALLOWED_DOMAINS}

# --- ACL: allowed destination domains (HTTPS SNI) ---
acl allowed_domains_ssl ssl::server_name ${ALLOWED_DOMAINS}

# --- SSL bump: peek SNI, splice if allowed, terminate otherwise ---
acl step1 at_step SslBump1
ssl_bump peek step1
ssl_bump splice allowed_domains_ssl
ssl_bump terminate all

# --- HTTP access ---
acl SSL_ports port 443
acl CONNECT method CONNECT

# Explicit proxy: allow CONNECT only to SSL ports
http_access deny CONNECT !SSL_ports

# Allow traffic to permitted domains (HTTP intercept + explicit proxy CONNECT)
http_access allow allowed_domains

# Deny everything else
http_access deny all
SQUID_CONF

echo "squid.conf generated"

###############################################################################
# Step 2: Start Squid & health check
###############################################################################
echo "=== Step 2: Starting Squid ==="

# Initialize cache directories
squid -z -f /etc/squid/squid.conf 2>/dev/null || true

# Start Squid daemon
squid -f /etc/squid/squid.conf

# Health check: wait up to 15 seconds for Squid to be ready
echo "Waiting for Squid to start..."
SQUID_READY=false
for i in $(seq 1 15); do
    if squid -k check -f /etc/squid/squid.conf 2>/dev/null; then
        SQUID_READY=true
        break
    fi
    sleep 1
done

if [ "$SQUID_READY" != "true" ]; then
    echo "ERROR: Squid failed to start within 15 seconds"
    cat /var/log/squid/cache.log 2>/dev/null || true
    exit 1
fi
echo "Squid is running (ports: 3128 explicit, 3129 HTTP intercept, 3130 HTTPS intercept)"

###############################################################################
# Step 3: iptables (NAT REDIRECT + safety net)
###############################################################################
echo "=== Step 3: Configuring iptables ==="

# Extract Docker DNS NAT rules BEFORE flushing
DOCKER_DNS_RULES=$(iptables-save -t nat | grep "127\.0\.0\.11" || true)

# Flush existing rules
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

# Restore Docker DNS NAT rules
if [ -n "$DOCKER_DNS_RULES" ]; then
    echo "Restoring Docker DNS rules..."
    iptables -t nat -N DOCKER_OUTPUT 2>/dev/null || true
    iptables -t nat -N DOCKER_POSTROUTING 2>/dev/null || true
    echo "$DOCKER_DNS_RULES" | xargs -L 1 iptables -t nat
else
    echo "No Docker DNS rules to restore"
fi

# NAT: transparently redirect HTTP/HTTPS to Squid intercept ports
# (exclude proxy user to prevent redirect loops)
iptables -t nat -A OUTPUT -p tcp --dport 80 -m owner ! --uid-owner proxy -j REDIRECT --to-port 3129
iptables -t nat -A OUTPUT -p tcp --dport 443 -m owner ! --uid-owner proxy -j REDIRECT --to-port 3130

# Allow loopback (required for app → Squid communication after REDIRECT)
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow DNS (udp/53)
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -j ACCEPT

# Allow SSH (tcp/22)
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

# Allow host network communication
HOST_IP=$(ip route | grep default | cut -d" " -f3)
if [ -z "$HOST_IP" ]; then
    echo "ERROR: Failed to detect host IP"
    exit 1
fi
HOST_NETWORK=$(echo "$HOST_IP" | sed "s/\.[0-9]*$/.0\/24/")
echo "Host network detected as: $HOST_NETWORK"
iptables -A INPUT -s "$HOST_NETWORK" -j ACCEPT
iptables -A OUTPUT -d "$HOST_NETWORK" -j ACCEPT

# Allow established/related connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow Squid (proxy user) to access tcp/80,443 directly
iptables -A OUTPUT -p tcp --dport 80 -m owner --uid-owner proxy -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner proxy -j ACCEPT

# Set default policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# Final catch-all REJECT for immediate feedback
iptables -A OUTPUT -j REJECT --reject-with icmp-admin-prohibited

echo "iptables configured (NAT REDIRECT to Squid intercept ports)"

###############################################################################
# Step 4: Verification tests
###############################################################################
echo "=== Step 4: Running verification tests ==="

# Test 1: example.com should be BLOCKED (transparent proxy denies it)
echo "Test 1: Verifying example.com is blocked..."
if curl --connect-timeout 5 https://example.com >/dev/null 2>&1; then
    echo "ERROR: Firewall verification failed - was able to reach https://example.com"
    exit 1
else
    echo "PASS: unable to reach https://example.com (blocked as expected)"
fi

# Test 2: api.github.com should be ALLOWED (transparent proxy allows it)
echo "Test 2: Verifying api.github.com is allowed..."
if ! curl --connect-timeout 10 https://api.github.com/zen >/dev/null 2>&1; then
    echo "ERROR: Firewall verification failed - unable to reach https://api.github.com"
    exit 1
else
    echo "PASS: able to reach https://api.github.com"
fi

# Test 3: proxy.golang.org should be ALLOWED
echo "Test 3: Verifying proxy.golang.org is allowed..."
if ! curl --connect-timeout 10 https://proxy.golang.org/ >/dev/null 2>&1; then
    echo "ERROR: Firewall verification failed - unable to reach https://proxy.golang.org"
    exit 1
else
    echo "PASS: able to reach https://proxy.golang.org"
fi

echo "=== All verification tests passed ==="
echo "Egress proxy configuration complete (SNI transparent proxy)"
