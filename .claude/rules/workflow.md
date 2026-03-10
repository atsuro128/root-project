# ワークフロー制約

## セッション管理
- 作業開始時に `dev-journal/progress-management/progress.md` を確認すること
- 作業完了時に `dev-journal/progress-management/progress.md` を更新すること
- Step 成果物の作成・コミットが完了したら `/codex-review` を実行すること

## スコープ制約
- ソースコードの新規作成・編集は `expense-saas/` 配下のみで行うこと
- MVP スコープ外の機能を実装しないこと（スコープ定義: `dev-journal/deliverables/docs/02_scope.md`）
- 不要なファイルを生成しないこと（ドキュメント・README の自動生成を含む）

## 作業規約
- コマンド実行時は目的を日本語で明示すること
- 記憶・知見の保存先は `.claude/memory/MEMORY.md` とすること（グローバルのメモリパス不可）
- ドキュメント・コード・コミットメッセージの用語は統一すること（用語集: `dev-journal/references/glossary.md`）
