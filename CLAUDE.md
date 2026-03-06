# 経費精算SaaS — Claude Code プロジェクト方針

## メモリ
- 記憶・知見の保存先は `.claude/memory/MEMORY.md` とする
- グローバルのメモリパスは使用しない

## 作業開始時ルール
- 作業開始時に必ず `progress-management/progress.md` を確認し、現在のフェーズ・直近タスク・課題を把握すること
- 作業完了時に `progress-management/progress.md` を更新し、次回セッションに引き継げる状態にすること
- **【必須】作業完了時に `logs/YYYY-MM-DD/session-log.md` へセッションの作業ログを記録すること（ルール: `rules/session-log.md`）**

## 作業フロー
- 全体の進め方・各ステップの成果物・完了条件: `guide/portfolio_project_steps.md`
- 現在のステップの完了条件を満たしてから次ステップに進むこと
- MVP のスコープ: `deliverables/docs/02_scope.md`（スコープ外の機能を実装しない）

## 用語統一
- ドキュメント・コード・コミットメッセージで用語を統一すること
- 用語定義: `references/glossary.md`

## Git 操作
- Git リポジトリは2つ存在する:
  - `root-project/` : プロジェクト管理・AI運用基盤（private）
  - `root-project/project/` : プロダクトコード（public）
- git コマンドは対象に応じて適切なディレクトリで実行すること
- ソースコード関連のコミットは `project/` で、設定・ドキュメント関連は `root-project/` で行う
- **【必須】ユーザーへの最終応答を返す前に、root-project/ 配下のファイルを編集していた場合は必ずコミットすること。コミットせずに作業完了の報告をしてはならない。**
- コミット規約: rules/commit-message.md
- **【必須】コミットフッターは `Co-Authored-By: Claude <noreply@anthropic.com>` のみ。モデル名は付けない。**

## コマンド実行
**【必須】コマンド実行を行う際に、何をする為のコマンドなのかを必ず日本語で明示すること。**

## ディレクトリ
- ソースコードの新規作成・編集は `project/` 配下のみで行うこと
- フォルダ追加・削除・移動時は `references/directory-structure.md` または `references/project-structure.md` を更新すること

## 技術スタック
Backend: Rust (Actix Web) / Frontend: React (TypeScript, Vite) / DB: PostgreSQL / DB Access: SQLx / Infra: AWS (ECS Fargate, RDS, S3) / CI: GitHub Actions

## アーキテクチャ・制約
詳細: `rules/architecture.md`

## 禁止事項
- tenant_id なしのクエリ作成
- 不要なファイル生成（ドキュメント・READMEの自動生成含む）

## Issue 対応
- issue に対応する際は必ず `rules/issue-management.md` の手順を順守すること

## レビュー指摘対応
- レビュー指摘に対応する際は必ず `rules/review-findings.md` の手順を順守すること

## ファイル参照ルール
- API一覧・DB定義・テスト戦略等の詳細仕様: PROJECT_SUMMARY.md
- コーディング規約: rules/coding-standards.md
- テスト方針: rules/testing.md
- ディレクトリ役割・構成詳細（root-project）: references/directory-structure.md
- ディレクトリ構成（project）: references/project-structure.md
