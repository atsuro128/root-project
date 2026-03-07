# コミット規約

## Git 運用
リポジトリは2つ存在する。
- `root-project/` : プロジェクト管理・AI運用基盤（private）
- `root-project/project/` : プロダクトコード（public）

- ソースコード関連のコミットは `project/`、設定・ドキュメント関連は `root-project/` で行う

## コミット前必須事項
- コミット前に必ずセッションログを記録すること（`rules/session-log.md` に従い `logs/YYYY-MM-DD/session-log.md` に追記してからコミット）

## メッセージ形式
- 言語: 日本語
- 形式: Conventional Commits（`feat:`, `fix:`, `chore:` 等）

## 必須フッター
全コミットの末尾に必ず付与する:
`Co-Authored-By: Claude <noreply@anthropic.com>`

## 禁止事項
- `.env` ファイルのコミット
- ユーザー指示なしの `git commit` / `git push`
