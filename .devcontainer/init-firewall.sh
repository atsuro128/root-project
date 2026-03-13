#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, and pipeline failures
IFS=$'\n\t'       # Stricter word splitting

###############################################################################
# Step 1: Generate squid.conf
###############################################################################
echo "=== Step 1: Generating squid.conf ==="

cat > /etc/squid/squid.conf <<'SQUID_CONF'
# --- Egress Proxy: FQDN allowlist (CONNECT tunnel mode) ---

# Listen port
http_port 3128

# Disable caching (pure proxy)
cache deny all

# DNS: Docker internal resolver + fallback
dns_nameservers 127.0.0.11 8.8.8.8

# Logging
access_log /var/log/squid/access.log

# --- ACL: allowed destination domains ---
acl allowed_domains dstdomain \
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
  .auth.openai.com \
  challenges.cloudflare.com \
  discord.com \
  gateway.discord.gg

# SSL ports for CONNECT
acl SSL_ports port 443
acl CONNECT method CONNECT

# Allow CONNECT only to SSL ports
http_access deny CONNECT !SSL_ports

# Allow traffic to permitted domains
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

# Health check: wait up to 10 seconds for Squid to be ready
echo "Waiting for Squid to start..."
SQUID_READY=false
for i in $(seq 1 10); do
    if squid -k check -f /etc/squid/squid.conf 2>/dev/null; then
        SQUID_READY=true
        break
    fi
    sleep 1
done

if [ "$SQUID_READY" != "true" ]; then
    echo "ERROR: Squid failed to start within 10 seconds"
    exit 1
fi
echo "Squid is running on port 3128"

###############################################################################
# Step 3: iptables (safety net — block direct 80/443 except from Squid)
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

# Allow loopback (required for proxy communication)
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

# REJECT direct tcp/80,443 from all other users (forces proxy usage)
iptables -A OUTPUT -p tcp --dport 80 -j REJECT --reject-with icmp-admin-prohibited
iptables -A OUTPUT -p tcp --dport 443 -j REJECT --reject-with icmp-admin-prohibited

# Set default policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# Final catch-all REJECT for immediate feedback
iptables -A OUTPUT -j REJECT --reject-with icmp-admin-prohibited

echo "iptables configured"

###############################################################################
# Step 4: Write proxy environment variables
###############################################################################
echo "=== Step 4: Writing proxy environment variables ==="

cat > /etc/profile.d/proxy.sh <<'PROXY_ENV'
export http_proxy="http://127.0.0.1:3128"
export https_proxy="http://127.0.0.1:3128"
export HTTP_PROXY="http://127.0.0.1:3128"
export HTTPS_PROXY="http://127.0.0.1:3128"
export no_proxy="localhost,127.0.0.1,127.0.0.11"
export NO_PROXY="localhost,127.0.0.1,127.0.0.11"
PROXY_ENV

chmod +r /etc/profile.d/proxy.sh

# Source for current shell session
export http_proxy="http://127.0.0.1:3128"
export https_proxy="http://127.0.0.1:3128"
export HTTP_PROXY="http://127.0.0.1:3128"
export HTTPS_PROXY="http://127.0.0.1:3128"
export no_proxy="localhost,127.0.0.1,127.0.0.11"
export NO_PROXY="localhost,127.0.0.1,127.0.0.11"

echo "Proxy environment variables written to /etc/profile.d/proxy.sh"

###############################################################################
# Step 5: Verification tests
###############################################################################
echo "=== Step 5: Running verification tests ==="

# Test 1: example.com should be BLOCKED via proxy
echo "Test 1: Verifying example.com is blocked (via proxy)..."
if curl --proxy http://127.0.0.1:3128 --connect-timeout 5 https://example.com >/dev/null 2>&1; then
    echo "ERROR: Firewall verification failed - was able to reach https://example.com via proxy"
    exit 1
else
    echo "PASS: unable to reach https://example.com via proxy (blocked as expected)"
fi

# Test 2: api.github.com should be ALLOWED via proxy
echo "Test 2: Verifying api.github.com is allowed (via proxy)..."
if ! curl --proxy http://127.0.0.1:3128 --connect-timeout 5 https://api.github.com/zen >/dev/null 2>&1; then
    echo "ERROR: Firewall verification failed - unable to reach https://api.github.com via proxy"
    exit 1
else
    echo "PASS: able to reach https://api.github.com via proxy"
fi

# Test 3: proxy.golang.org should be ALLOWED via proxy
echo "Test 3: Verifying proxy.golang.org is allowed (via proxy)..."
if ! curl --proxy http://127.0.0.1:3128 --connect-timeout 5 https://proxy.golang.org/ >/dev/null 2>&1; then
    echo "ERROR: Firewall verification failed - unable to reach https://proxy.golang.org via proxy"
    exit 1
else
    echo "PASS: able to reach https://proxy.golang.org via proxy"
fi

# Test 4: Direct access (bypassing proxy) should be BLOCKED by iptables
echo "Test 4: Verifying direct access is blocked (proxy bypass)..."
if curl --noproxy '*' --connect-timeout 5 https://api.github.com/zen >/dev/null 2>&1; then
    echo "ERROR: Firewall verification failed - direct access bypassed proxy"
    exit 1
else
    echo "PASS: direct access blocked by iptables (proxy bypass prevented)"
fi

echo "=== All verification tests passed ==="
echo "Egress proxy configuration complete"
