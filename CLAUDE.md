# 経費精算SaaS — Claude Code プロジェクト方針

## 1. 絶対ルール
- 作業開始時に必ず `dev-journal/progress-management/progress.md` を確認し、現在のフェーズ・直近タスク・課題を把握すること
- 作業完了時に必ず `dev-journal/progress-management/progress.md` を更新し、次回セッションに引き継げる状態にすること
- ソースコードの新規作成・編集は `expense-saas/` 配下のみで行うこと
- コマンド実行時は、何をするためのコマンドなのかを必ず日本語で明示すること
- tenant_id なしのクエリを作成しないこと
- 不要なファイルを生成しないこと（ドキュメント・READMEの自動生成を含む）
- MVP スコープ外の機能を実装しないこと: `dev-journal/deliverables/docs/02_scope.md`
- ルール未確認のまま Issue 対応・レビュー指摘対応を進めないこと
- 必要に応じて関連ルール・仕様を参照すること
- 記憶・知見の保存先は `.claude/memory/MEMORY.md` とし、グローバルのメモリパスは使用しない
- 以上すべてを満たした状態でユーザーへ最終応答を返すこと

## 2. 標準作業手順
1. `dev-journal/progress-management/progress.md` と関連資料を確認し、作業目的を理解する
2. 現在ステップの完了条件、MVPスコープ、影響範囲を確認する
3. 必要なルール・仕様書を参照する
4. 実装または修正方針を整理してから変更を行う
5. 必要なテスト・動作確認を行う
6. 関連ドキュメントと `dev-journal/progress-management/progress.md` を更新する
7. Step 成果物の作成・コミットが完了したら、`/codex-review` スキルを実行する

## 3. 主要参照先
- 全体の進め方・各ステップの成果物・完了条件: `dev-journal/guide/portfolio_project_steps.md`
- アーキテクチャ・制約・コーディング規約・テスト方針・セキュリティポリシー: `.claude/rules/` で自動ロード
- フォルダ追加・削除・移動を行う場合: 本ファイルのセクション5「リポジトリ構成」を参照し、対象リポジトリ内で作業すること

## 4. メモリ運用
- 記憶・知見の保存先は `.claude/memory/MEMORY.md` とする
- グローバルのメモリパスは使用しない

## 5. リポジトリ構成
| リポジトリ | 責務 | Git |
|---|---|---|
| `root-project/` | メタリポジトリ（CLAUDE.md・.claude/による統括） | 本体 |
| `ai-dev-framework/` | AI駆動開発フレームワーク（ルール・コマンド・テンプレート・ADR） | 独立 |
| `expense-saas/` | プロダクト本体（実装コードのみ） | 独立 |
| `dev-journal/` | 開発プロセス記録（進捗・日報・ログ・設計成果物・参照資料） | 独立 |

## 6. 用語統一
- ドキュメント・コード・コミットメッセージで用語を統一すること
- 用語定義: `dev-journal/references/glossary.md`

## 7. 技術スタック
Backend: Rust (Actix Web) / Frontend: React (TypeScript, Vite) / DB: PostgreSQL / DB Access: SQLx / Infra: AWS (ECS Fargate, RDS, S3) / CI: GitHub Actions
