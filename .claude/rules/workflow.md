# ワークフロー制約

## セッション管理
- 作業開始時に `dev-journal/progress-management/progress.md` を確認すること
  - ops セクションに未対応項目がある場合、Step 作業より先に対応を提案すること
- 作業開始時に `dev-journal/progress-management/issues/open/` のブロッカー issue を確認すること
  - 次 Step の成果物作成に着手する前に、その Step に関連するブロッカー issue を先に解消すること
- 作業完了時に `dev-journal/progress-management/progress.md` を更新すること

## Step 一覧と作業分解

各 Step の成果物・完了条件・プロセスは work-breakdown を参照。

| Step | 名称 | 作業分解 |
|------|------|----------|
| 0 | 事前準備 | `dev-journal/guide/work-breakdown/step0-preparation.md` |
| 1 | 要件定義 | `dev-journal/guide/work-breakdown/step1-requirements.md` |
| 2 | ドメイン設計 | `dev-journal/guide/work-breakdown/step2-domain.md` |
| 3 | アーキテクチャ設計 | `dev-journal/guide/work-breakdown/step3-architecture.md` |
| 4 | 基本設計 | `dev-journal/guide/work-breakdown/step4-basic-design.md` |
| 5 | 詳細設計 | `dev-journal/guide/work-breakdown/step5-detail-design.md` |
| 6 | テスト設計 | `dev-journal/guide/work-breakdown/step6-testing.md` |
| 7 | 実装・運用 | `dev-journal/guide/work-breakdown/step7-implementation.md` |

### progress.md ステータス定義

| ステータス | 意味 |
|-----------|------|
| 未着手 | まだ開始していない |
| 進行中（成果物作成） | 成果物を作成中 |
| レビュー待ち | 成果物作成完了。レビュー依頼済み |
| 指摘対応中 | レビュー指摘への対応中 |
| 完了 | 完了条件を満たし、レビュー指摘も全て解消 |

## 成果物作成フロー

Step 成果物の作成時は以下のフローに従う。

```
0. 計画（Plan エージェント）
   - work-breakdown の手順 + 上流成果物を入力に、作業計画を立案
   - 上流の代替系・任意入力・判断が必要なポイントを洗い出す
   - ユーザーに計画を提示し、承認を得てから実行に移る
   ↓
1. 成果物作成（各 Step の担当エージェント）
   ↓
2. 内部レビュー（カスタムエージェント）
   - 各 Step の work-breakdown に指定された reviewer エージェントを起動
   - 品質ゲート判定（team-structure.md 基準）
   - blocker があれば修正 → 再レビュー（LGTM まで繰り返す）
   ↓
3. ユーザーにコミットを提案
   ↓
4. codex レビュー（/codex-review）
   - コミット後に実行
   - 指摘は review-findings/open/ に起票される
   ↓
5. 指摘対応
   - review-findings を確認し、issue 化が必要なものは /issue で起票
   - issue 化したら元の review-findings を削除（二重管理防止）
   - Step 成果物の修正で対応可能なものは修正 → 再コミット → 再レビュー
```

## スコープ制約
- ソースコードの新規作成・編集は `expense-saas/` 配下のみで行うこと
- MVP スコープ外の機能を実装しないこと（スコープ定義: `dev-journal/deliverables/docs/02_scope.md`）
- 不要なファイルを生成しないこと（ドキュメント・README の自動生成を含む）

## 作業規約
- 作業がひと段落したら、ユーザーにコミットを提案し、承認を得てから `/commit` でコミットすること
  - 細かい変更のたびではなく、意味のある作業単位でまとめる
  - 確認なしにコミットをスキップして次の作業に進むことは禁止
- コマンド実行時は目的を**日本語**で明示すること
- Claude Code の Auto Memory 機能は使用しないこと
- ドキュメント・コード・コミットメッセージの用語は統一すること（用語集: `dev-journal/references/glossary.md`）

## Issue 発掘規約

成果物作成中に設計上の問題を発見した場合、影響度によらず `/issue 起票` で issue 化すること（発見経緯: `proactive`）。

- **即時起票**（作業中断）: 上流成果物との矛盾、ブロッカー、前ステップ成果物の修正が必要な場合
- **作業継続して起票**: 未決定事項、仕様の曖昧さ、改善アイデアなど作業続行可能なもの
