#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Ensure mounted config/history volumes are writable by the non-root dev user.
install -d -o node -g node /home/node/.claude /home/node/.codex /home/node/.config/gh /commandhistory
chown -R node:node /home/node/.claude /home/node/.codex /home/node/.config/gh /commandhistory

exec /usr/local/bin/init-firewall.sh
