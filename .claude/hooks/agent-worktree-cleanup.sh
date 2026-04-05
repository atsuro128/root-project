#!/usr/bin/env bash
# PostToolUse(Agent) ワークアラウンド — WorktreeRemove フック未発火バグ対策
# https://github.com/anthropics/claude-code/issues/28363
set -euo pipefail

INPUT=$(cat)

# isolation: worktree のサブエージェント完了時のみ実行
ISOLATION=$(echo "$INPUT" | jq -r '.tool_input.isolation // empty' 2>/dev/null)
[ "$ISOLATION" = "worktree" ] || exit 0

EXPENSE_SAAS_DIR="/root-project/expense-saas"
WORKTREES_DIR="${EXPENSE_SAAS_DIR}/.claude/worktrees"

[ -d "$WORKTREES_DIR" ] || exit 0

for wt in "$WORKTREES_DIR"/*/; do
    [ -d "$wt" ] || continue

    # 未コミットの変更があるワークツリーは残す
    CHANGES=$(cd "$wt" && git diff --name-only 2>/dev/null | wc -l)
    if [ "$CHANGES" -eq 0 ]; then
        BRANCH=$(basename "$wt")
        git -C "$EXPENSE_SAAS_DIR" worktree remove "$wt" --force 2>/dev/null || true
        git -C "$EXPENSE_SAAS_DIR" branch -D "$BRANCH" 2>/dev/null || true
    fi
done

exit 0
