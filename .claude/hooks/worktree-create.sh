#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)
NAME=$(echo "$INPUT" | jq -r '.name')

EXPENSE_SAAS_DIR="/root-project/expense-saas"
WORKTREE_PATH="${EXPENSE_SAAS_DIR}/.claude/worktrees/${NAME}"
BRANCH="${NAME}"

log() { echo "$*" > /dev/tty 2>/dev/null || true; }

log "Creating worktree (branch: $BRANCH)..."

mkdir -p "${EXPENSE_SAAS_DIR}/.claude/worktrees"

git -C "$EXPENSE_SAAS_DIR" worktree add -b "$BRANCH" "$WORKTREE_PATH" HEAD >/dev/null 2>&1

[ -f "${EXPENSE_SAAS_DIR}/.env" ] && cp "${EXPENSE_SAAS_DIR}/.env" "${WORKTREE_PATH}/.env"

log "Worktree ready: $WORKTREE_PATH"

echo "$WORKTREE_PATH"
