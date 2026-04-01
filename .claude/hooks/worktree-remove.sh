#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)
WORKTREE_PATH=$(echo "$INPUT" | jq -r '.worktree_path')

[ ! -d "$WORKTREE_PATH" ] && exit 0

EXPENSE_SAAS_DIR="/root-project/expense-saas"

git -C "$EXPENSE_SAAS_DIR" worktree remove "$WORKTREE_PATH" --force >/dev/null 2>&1 || true
