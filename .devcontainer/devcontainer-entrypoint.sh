#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

if [[ "$(id -u)" -eq 0 ]]; then
  /usr/local/bin/init-devcontainer.sh

  if [[ $# -eq 0 ]]; then
    exec sudo -E -H -u node -- sleep infinity
  fi

  exec sudo -E -H -u node -- "$@"
fi

exec "$@"
