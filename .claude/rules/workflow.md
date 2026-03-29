# プロジェクト運用ルール

## 必須ルール

### やること

#### 計画・設計時
- 変更対象とその利用先を全て読んでから設計する
- 追加提案の前に「誰が読み、行動できるか」を確認する
- タスク着手前に依存先が全て `完了` であることを progress.md で確認する

#### 実行時
- サブエージェントは `run_in_background: true` で起動する
- issue 対応着手前に `/issue 対応` を実行する（issue ファイルを直接読んで着手しない）
- コミット前にユーザーに提案し、承認を得てから `/commit` で実行する
- 成果物作成中に設計上の問題を発見したら `/issue 起票` する
- コマンド実行時は目的を**日本語**で明示する
- ドキュメント・コード・コミットメッセージの用語は用語集に従う（`dev-journal/deliverables/docs/01_glossary.md`）

### やらないこと
- Auto Memory を使わない。記憶は `.claude/memory/` に保存する
- 成果物ファイルを直接編集しない（サブエージェントに委譲）
- レビューを自分で行わない（reviewer エージェントに委譲）
- 設計判断を独断しない（architect の分析を元にユーザーに確認）
- 確認なしにコミットをスキップして次の作業に進まない
- MVP スコープ外の機能を実装しない
- `expense-saas/` 以外にソースコードを作成・編集しない
- 不要なファイルを生成しない（ドキュメント・README の自動生成を含む）

## 指揮役の行動原則

- **ユーザーとの対話を常に維持する**（最優先）
  - 計画立案・ファイル操作・レビュー等、会話を長く止める作業は全てサブエージェントに委譲する
  - エージェント完了通知を受けたら結果を報告し、次のアクションを提案する
  - 維持が難しい作業が発生したら、サブエージェントの新規作成を提案する

## セッション管理

### 開始時
1. `dev-journal/progress-management/session-log.md` を確認し、前回セッションの引き継ぎを把握する
2. `dev-journal/progress-management/progress.md` を確認する
3. `dev-journal/issues/open/` のブロッカー issue を確認する
   - 次 Step の成果物作成に着手する前に、その Step に関連するブロッカー issue を先に解消すること
4. セッションのゴールを決める — 何をどこまでやるかをユーザーと合意してから作業に入ること

### 終了時
- 作業がひと段落したら `/session-log` の実行を提案すること（次セッションへの引き継ぎ）
- `dev-journal/progress-management/progress.md` を更新すること

## Step 一覧と作業分解

各 Step の成果物・完了条件・プロセスは work-breakdown を参照。

| Step | 名称 | 作業分解 |
|------|------|----------|
| 0 | 事前準備 | `ai-dev-framework/guide/work-breakdown/step0-preparation.md` |
| 1 | 要件定義 | `ai-dev-framework/guide/work-breakdown/step1-requirements.md` |
| 2 | ドメイン設計 | `ai-dev-framework/guide/work-breakdown/step2-domain.md` |
| 3 | アーキテクチャ設計 | `ai-dev-framework/guide/work-breakdown/step3-architecture.md` |
| 4 | 基本設計 | `ai-dev-framework/guide/work-breakdown/step4-basic-design.md` |
| 5 | 詳細設計 | `ai-dev-framework/guide/work-breakdown/step5-detail-design.md` |
| 6 | テスト設計 | `ai-dev-framework/guide/work-breakdown/step6-testing.md` |
| 7 | 基盤構築 | `ai-dev-framework/guide/work-breakdown/step7-foundation.md` |
| 8 | テストコード実装 | `ai-dev-framework/guide/work-breakdown/step8-test-implementation.md` |
| 9 | 機能実装 | `ai-dev-framework/guide/work-breakdown/step9-feature-implementation.md` |
| 10 | システムテスト・UAT | `ai-dev-framework/guide/work-breakdown/step10-system-test.md` |

## 成果物作成フロー

```
0. チケット起票（指揮役）
   - work-breakdown のタスク一覧 + 上流成果物を入力に、チケットを起票
   - チケットテンプレート（templates/ticket-template.md）に従い、各成果物のチケットファイルを作成
   - progress.md にチケット一覧と状態を記載
   ↓
1. 成果物作成（各 Step の担当エージェント）
   ↓
2. 内部レビュー（カスタムエージェント）
   - 各 Step の work-breakdown に指定された reviewer エージェントを起動
   - 品質ゲート判定（下記基準）
   - blocker があれば修正 → 再レビュー（LGTM まで繰り返す）
   ↓
3. ユーザーにコミットを提案
   ↓
4. codex レビュー（/codex-review）
   - コミット後に実行
   - 指摘は review-findings/open/ に起票される
   ↓
5. 指摘対応
   - 修正 → 再レビュー（LGTM まで繰り返す）
   - 対応不要と判断した指摘は理由を記載して pending-review に移動
   - issue 化が必要なものは /issue で起票し、元の review-findings を削除（二重管理防止）
```

## 品質ゲート判定基準

唯一の判定基準: **この成果物の下流工程が、曖昧さや矛盾なく作業できるか**

| 状況 | 判定 | アクション |
|------|------|-----------|
| 下流が曖昧さなく作業できる | PASS | 次のタスクに進む |
| 下流が困る問題あり（修正可能） | FIX | 該当エージェントに修正指示 → 再レビュー |
| 下流が困る問題あり（上流の問題） | ESCALATE | `/issue 起票` → ユーザーに判断を求める |
| 下流に影響しない改善提案 | PASS with NOTE | 記録して次のタスクに進む |
| 3回修正しても未解消 | ESCALATE | ユーザーにエスカレート |

reviewer が blocker/warning とラベルした結果ではなく、指揮役がこの基準で最終判定する。

## ブランチ運用

### 基本方針

- worktree は使わない（リポジトリが分離しているため expense-saas/ に対して正常に機能しない）
- 実装エージェントは expense-saas/ 内で直接ブランチを操作する
- ブランチ戦略（main 直接 or 機能ブランチ）は各 Step の work-breakdown で宣言する

## 意思決定権限

### 指揮役が単独で行えること
- サブエージェントの起動・再起動
- タスク実行順序の決定
- 品質ゲート PASS 時の次タスク進行
- 下流に影響しない改善提案の記録して続行
- issue の起票
- progress.md の更新

### ユーザー承認が必須なこと
- コミット・PR のマージ
- blocker の修正方針
- 上流成果物の修正
- チケット内容の確認（必要な場合）
