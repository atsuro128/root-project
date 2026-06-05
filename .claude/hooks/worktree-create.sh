#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)
NAME=$(echo "$INPUT" | jq -r '.name')

# スクリプト自身の位置（.claude/hooks/）から 2 つ上をプロジェクトルートとして解決する。
# devcontainer（/root-project）でもネイティブ環境（C:\...）でもホストパス非依存で動く。
# Git Bash では pwd が /c/... 形式を返すが、Claude Code は Windows 形式（C:/...）を期待するため
# cygpath -m で変換する（cygpath が無い Linux/devcontainer では POSIX パスのまま）。
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
command -v cygpath >/dev/null 2>&1 && ROOT_DIR="$(cygpath -m "$ROOT_DIR")"
EXPENSE_SAAS_DIR="${ROOT_DIR}/expense-saas"
WORKTREE_PATH="${EXPENSE_SAAS_DIR}/.claude/worktrees/${NAME}"
BRANCH="${NAME}"

log() { echo "$*" > /dev/tty 2>/dev/null || true; }

log "Creating worktree (branch: $BRANCH)..."

mkdir -p "${EXPENSE_SAAS_DIR}/.claude/worktrees"

git -C "$EXPENSE_SAAS_DIR" worktree add -b "$BRANCH" "$WORKTREE_PATH" HEAD >/dev/null 2>&1

[ -f "${EXPENSE_SAAS_DIR}/.env" ] && cp "${EXPENSE_SAAS_DIR}/.env" "${WORKTREE_PATH}/.env"

log "Worktree ready: $WORKTREE_PATH"

echo "$WORKTREE_PATH"
