---
name: implement
description: |
  チケットに基づき実装エージェントを起動する。
  Use when: 実装チケットの着手時（ユーザー指示 or 計画に基づく自主判断）
  DO NOT use when: 設計成果物の作成（設計成果物フローを使う）
argument-hint: "<チケットID（例: 9-1）>"
---

チケットに基づき実装エージェントを起動してください。

チケットID: $ARGUMENTS

## 手順

### 1. チケット読み込み

`dev-journal/progress-management/tickets/` 配下からチケットファイルを探して Read する。
以下を取得する:
- 担当エージェント
- ブランチ名
- 入力資料
- 責務
- 完了条件

### 2. 依存チェック

`dev-journal/progress-management/progress.md` を確認し、依存先チケットが全て `完了` であることを確認する。
未完了の依存があればユーザーに報告して中止する。

### 3. エージェント起動

担当エージェントを Agent tool で起動する。

起動時の設定:
- `subagent_type`: チケットの担当エージェント名
- `run_in_background: true`
- `isolation: "worktree"`

プロンプトに以下を含める:
- チケットの責務・完了条件
- 入力資料のパス（絶対パスで指定: `/root-project/dev-journal/...`）
- expense-saas 内のファイル操作は worktree 内の相対パスで行うこと（`/root-project/expense-saas/` に直接移動しない）
- ブランチ操作の指示:
  1. 現在のブランチを `git branch -m {チケットのブランチ名}` でリネーム
  2. 実装
  3. 完了条件を確認
  4. `git add` + `git commit`
  5. `git push -u origin {ブランチ名}`
  6. `gh pr create --title "{チケットID}: {タイトル}" --base master`
  7. PR URL を返す

### 4. 完了報告

エージェント完了後、結果をユーザーに報告する:
- PR URL
- 実装内容の要約
- 次のアクション（CI 監視 → 内部レビュー → codex レビュー）

### 5. worktree クリーンアップ

エージェント完了後、worktree とブランチが残っていないか確認する。

```bash
git -C /root-project/expense-saas worktree list
```

不要な worktree が残っていれば削除する:
```bash
git -C /root-project/expense-saas worktree remove <パス> --force
```

PR 作成前のブランチは削除しない。

### 6. progress.md 更新

チケットの状態を `作業中` に更新する。
