#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

append_if_missing() {
  local file="$1"
  local line="$2"

  touch "$file"

  if ! grep -Fqx "$line" "$file"; then
    printf '%s\n' "$line" >> "$file"
  fi
}

append_if_missing /home/node/.zshrc "alias cc='claude --dangerously-skip-permissions'"
append_if_missing /home/node/.zshrc "alias ccr='claude --resume --dangerously-skip-permissions'"
append_if_missing /home/node/.zshrc "alias cx='codex --dangerously-bypass-approvals-and-sandbox'"
append_if_missing /home/node/.zshrc 'export PATH="$HOME/.local/bin:$PATH"'

append_if_missing /home/node/.bashrc "alias cc='claude --dangerously-skip-permissions'"
append_if_missing /home/node/.bashrc "alias ccr='claude --resume --dangerously-skip-permissions'"
append_if_missing /home/node/.bashrc "alias cx='codex --dangerously-bypass-approvals-and-sandbox'"
append_if_missing /home/node/.bashrc 'export PATH="$HOME/.local/bin:$PATH"'
