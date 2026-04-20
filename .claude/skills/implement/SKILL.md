---
name: implement
description: |
  実装エージェントを起動する（チケット・issue 対応など実装全般）。
  Use when: 実装チケットの着手時、issue 対応の実装着手時、PR 追加対応時
  DO NOT use when: 設計成果物の作成（設計成果物フローを使う）
argument-hint: "<チケットID または issue 参照>"
---

実装エージェントを起動してください。

対象: $ARGUMENTS

## 手順

### 1. 実装計画の参照元を読み込み

対象に応じて以下から実装計画を読み込む:
- **チケット対応**: `dev-journal/progress-management/tickets/` 配下のチケットファイル
- **issue 対応**: `dev-journal/issues/open/` 配下の issue ファイル（末尾の追加対応ログを含む場合あり）
- **PR 追加対応**: 元 issue / チケットに追記された追加対応ログ

以下を取得する:
- 担当エージェント
- ブランチ名
- 入力資料
- 責務
- 完了条件

### 2. 依存チェック

`dev-journal/progress-management/progress.md` を確認し、依存先（チケット・issue 等）が全て `完了`（または解決済み）であることを確認する。
未完了の依存があればユーザーに報告して中止する。

### 3. master 最新化と worktree ベース確認（重要）

`isolation: "worktree"` のエージェントは、main リポジトリの現在の HEAD を基点に worktree を作成する。main が master 以外のブランチに居ると **編集履歴に無関係なコミットが混入する**。

エージェント起動前に以下を必ず実行する:

```bash
git -C /root-project/expense-saas fetch origin
git -C /root-project/expense-saas rev-parse --abbrev-ref HEAD  # master であること
git -C /root-project/expense-saas rev-parse HEAD               # origin/master と一致すること
git -C /root-project/expense-saas rev-parse origin/master
```

main の HEAD が master でない、または `origin/master` と一致しない場合はユーザーに報告して中止する（勝手に checkout しない）。

エージェント起動後、worktree のベースが master と一致するか再度確認する:

```bash
git -C /root-project/expense-saas/.claude/worktrees/agent-XXXXXXXX merge-base HEAD origin/master
# 戻り値が origin/master と一致すれば OK
```

不一致ならエージェントを停止（`TaskStop`）→ worktree 削除 → main を master に戻してから再起動する。

### 4. エージェント起動

担当エージェントを Agent tool で起動する。

起動時の設定:
- `subagent_type`: 担当エージェント名
- `run_in_background: true`
- `isolation: "worktree"`

プロンプトに以下を**必ず**含める:
- 責務・完了条件
- 入力資料のパス（絶対パスで指定: `/root-project/dev-journal/...`）
- ブランチ名（新規: `{ブランチ名}`）
- **worktree 汚染防止ブロック**（以下をそのまま貼る）:

```
## 作業ディレクトリ（重要）

作業ディレクトリは worktree 内です。最初に `pwd` で確認してください。
パスは `/root-project/expense-saas/.claude/worktrees/agent-XXXXXXXX/` の形式です。

### 絶対に守ること
- Read / Edit / Write / Bash の全操作を worktree 内のパスで行うこと
- `/root-project/expense-saas/` 直下（worktree 外の本体）を絶対に読み書きしないこと
- 既存コードを参照する場合も worktree 内の相対パスまたは worktree の絶対パスを使うこと
- `/root-project/dev-journal/...` の参照資料は読み取り専用でアクセスしてよい
```

- **ローカル CI 禁止ブロック**（以下をそのまま貼る）:

```
## ローカル CI（禁止事項）

lint / test / build のフルスイート実行（`npm run lint` / `npm test` / `go test ./...` / `npm run build` 等）は行わないこと。ローカル CI は指揮役が別途 /test スキルで実施する。

個別テストのデバッグ実行（`go test -v -run <テスト名>` / `npx vitest run <ファイル名>` 等）は許容する。
```

### 4. 完了報告

エージェント完了後、結果をユーザーに報告する:
- PR URL
- 実装内容の要約
- 次のアクション（/test スキルでローカル CI → 内部レビュー → codex レビュー）

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

### 6. progress.md 更新（チケット対応時のみ）

チケット対応の場合、チケットの状態を `作業中` に更新する。
issue 対応の場合は progress.md の該当 issue ステータスを更新する（該当箇所がなければスキップ）。
