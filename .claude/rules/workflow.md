# プロジェクト運用ルール

## 必須ルール

### やること
- サブエージェントは `run_in_background: true` で起動する
- issue 対応着手前に `/issue 対応` を実行する（issue ファイルを直接読んで着手しない）
- コミット前にユーザーに提案し、承認を得てから `/commit` で実行する
- 成果物作成中に設計上の問題を発見したら `/issue 起票` する
- コマンド実行時は目的を**日本語**で明示する
- ドキュメント・コード・コミットメッセージの用語は用語集に従う（`dev-journal/references/glossary.md`）

### やらないこと
- Auto Memory（`/home/node/.claude/projects/` 配下）を使わない
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
1. `dev-journal/progress-management/handoff.md` を確認し、前回セッションの引き継ぎを把握する
2. `dev-journal/progress-management/progress.md` を確認する
3. `dev-journal/progress-management/issues/open/` のブロッカー issue を確認する
   - 次 Step の成果物作成に着手する前に、その Step に関連するブロッカー issue を先に解消すること
4. セッションのゴールを決める — 何をどこまでやるかをユーザーと合意してから作業に入ること

### 終了時
- 作業がひと段落したら `/handoff` の実行を提案すること（次セッションへの引き継ぎ）
- `dev-journal/progress-management/progress.md` を更新すること

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

## 成果物作成フロー

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
   - review-findings を確認し、issue 化が必要なものは /issue で起票
   - issue 化したら元の review-findings を削除（二重管理防止）
   - Step 成果物の修正で対応可能なものは修正 → 再コミット → 再レビュー
```

## 品質ゲート判定基準

| reviewer 結果 | 判定 | アクション |
|--------------|------|-----------|
| blocker なし | PASS | 次のタスクに進む |
| blocker あり（設計者で修正可能） | FIX | 該当エージェントに修正指示 → 再レビュー |
| blocker あり（上流の問題） | ESCALATE | `/issue 起票` → ユーザーに判断を求める |
| warning のみ | PASS with NOTE | warning を記録して次のタスクに進む |
| 3回修正しても未解消 | ESCALATE | ユーザーにエスカレート |

## 意思決定権限

### 指揮役が単独で行えること
- サブエージェントの起動・再起動
- タスク実行順序の決定
- reviewer PASS 時の次タスク進行
- warning の記録して続行
- issue の起票
- progress.md の更新

### ユーザー承認が必須なこと
- コミット・PR のマージ
- blocker の修正方針
- 上流成果物の修正
- 作業計画への合意
