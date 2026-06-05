#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)
WORKTREE_PATH=$(echo "$INPUT" | jq -r '.worktree_path')

[ ! -d "$WORKTREE_PATH" ] && exit 0

# スクリプト自身の位置（.claude/hooks/）から 2 つ上をプロジェクトルートとして解決する。
# Git Bash では cygpath -m で Windows 形式へ変換（Linux/devcontainer では POSIX パスのまま）。
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
command -v cygpath >/dev/null 2>&1 && ROOT_DIR="$(cygpath -m "$ROOT_DIR")"
EXPENSE_SAAS_DIR="${ROOT_DIR}/expense-saas"

git -C "$EXPENSE_SAAS_DIR" worktree remove "$WORKTREE_PATH" --force >/dev/null 2>&1 || true
