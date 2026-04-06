#!/usr/bin/env bash
# PostToolUse(Agent) — 完了したエージェントのワークツリーのみクリーンアップ
# 並列実行中の他エージェントのワークツリーには触れない
set -euo pipefail

INPUT=$(cat)

# 完了したエージェントのワークツリーパスを取得
WT_PATH=$(echo "$INPUT" | jq -r '.tool_response.worktreePath // empty' 2>/dev/null)
[ -n "$WT_PATH" ] || exit 0
[ -d "$WT_PATH" ] || exit 0

# ワークツリーの親リポジトリを特定
REPO_DIR=$(cd "$WT_PATH" && git rev-parse --show-toplevel 2>/dev/null) || exit 0
# worktree の場合、commondir を辿って本体リポジトリを取得
if [ -f "$WT_PATH/.git" ]; then
    REPO_DIR=$(cd "$WT_PATH" && git rev-parse --path-format=absolute --git-common-dir 2>/dev/null | sed 's|/\.git$||') || exit 0
fi

BRANCH=$(basename "$WT_PATH")

# 未コミットの変更があるワークツリーは残す
CHANGES=$(cd "$WT_PATH" && git diff --name-only 2>/dev/null | wc -l)
if [ "$CHANGES" -eq 0 ]; then
    git -C "$REPO_DIR" worktree remove "$WT_PATH" --force 2>/dev/null || true
    git -C "$REPO_DIR" branch -D "$BRANCH" 2>/dev/null || true
fi

exit 0
