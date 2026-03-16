# ワークフロー制約

## セッション管理
- 作業開始時に `dev-journal/progress-management/progress.md` を確認すること
- 作業開始時に `dev-journal/progress-management/issues/open/` のブロッカー issue を確認すること
  - 次 Step の成果物作成に着手する前に、その Step に関連するブロッカー issue を先に解消すること
- 作業完了時に `dev-journal/progress-management/progress.md` を更新すること
- Step 成果物の作成・コミットが完了したら `/codex-review` を実行すること

## スコープ制約
- ソースコードの新規作成・編集は `expense-saas/` 配下のみで行うこと
- MVP スコープ外の機能を実装しないこと（スコープ定義: `dev-journal/deliverables/docs/02_scope.md`）
- 不要なファイルを生成しないこと（ドキュメント・README の自動生成を含む）

## 作業規約
- ファイルを変更したら、ユーザーにコミットの要否を確認し、承認を得てから `/commit` でコミットすること
  - 確認なしにコミットをスキップして次の作業に進むことは禁止
- コマンド実行時は目的を**日本語**で明示すること
- Claude Code の Auto Memory 機能は使用しないこと
- ドキュメント・コード・コミットメッセージの用語は統一すること（用語集: `dev-journal/references/glossary.md`）

## Issue 発掘規約

成果物作成中に設計上の問題を発見した場合、影響度によらず `/issue 起票` で issue 化すること（発見経緯: `proactive`）。

- **即時起票**（作業中断）: 上流成果物との矛盾、ブロッカー、前ステップ成果物の修正が必要な場合
- **作業継続して起票**: 未決定事項、仕様の曖昧さ、改善アイデアなど作業続行可能なもの
