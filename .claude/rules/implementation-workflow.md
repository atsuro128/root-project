---
paths:
  - "expense-saas/**/*"
---

# 実装共通ルール

## 必須参照

実装・レビュー時に以下の設計成果物を確認すること。

- セキュリティ: `dev-journal/deliverables/docs/50_detail_design/security.md`
- 認可: `dev-journal/deliverables/docs/50_detail_design/authz.md`
- DB: `dev-journal/deliverables/docs/50_detail_design/db_schema.md`
- API: `dev-journal/deliverables/docs/50_detail_design/openapi.yaml`
- 画面: `dev-journal/deliverables/docs/50_detail_design/screens/`
- テスト: `dev-journal/deliverables/docs/60_test/`

## コメント言語

- コード内コメントは全て日本語で書く（godoc / JSDoc 含む）
- 識別子（変数名・関数名・型名）は英語のまま

## worktree 作業ルール

expense-saas のコードを編集するエージェントは worktree 内で起動される。以下を厳守すること。

- カレントディレクトリ（worktree）内で全ての作業を行う
- **`/root-project/expense-saas/` に `cd` や絶対パスで直接アクセスしない**（Read も禁止）
- 既存コードの参照は worktree 内のパスを使う（`./` または worktree の絶対パス）
- dev-journal 等の参照資料は `/root-project/dev-journal/...` の絶対パスで読み取ってよい（読み取り専用）

### よくある汚染パターン（禁止）

```
# NG: 本体パスで Read → そのパスで Edit してしまう
Read /root-project/expense-saas/internal/testutil/fixture.go
Edit /root-project/expense-saas/internal/testutil/fixture.go  ← 本体を汚染

# OK: worktree 内のパスで操作する
Read /root-project/expense-saas/.claude/worktrees/agent-XXX/internal/testutil/fixture.go
Edit /root-project/expense-saas/.claude/worktrees/agent-XXX/internal/testutil/fixture.go
```

### ブランチ操作

指揮役からブランチ名が指定される。以下の手順でブランチを設定すること。

- 新規ブランチ: `git branch -m {ブランチ名}`（worktree の自動ブランチをリネーム）
- 既存ブランチ: `git checkout {ブランチ名}`（worktree 内で切り替え）

## デリバリー手順

ビルド・lint 通過後:

1. 変更をコミット
2. ブランチを push: `git push -u origin <ブランチ名>`
3. PR を作成: `gh pr create --title "<チケットID>: <概要>" --body "<変更内容>"`
4. 指揮役に **PR URL** を返す

