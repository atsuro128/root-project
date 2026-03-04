# 経費精算SaaS — Claude Code プロジェクト方針

## 作業開始時ルール
- 作業開始時に必ず `progress-management/progress.md` を確認し、現在のフェーズ・直近タスク・課題を把握すること
- 作業完了時に `progress-management/progress.md` を更新し、次回セッションに引き継げる状態にすること

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
- `root-project/` 配下のファイルを編集した場合、作業完了時にコミットすること

## コマンド実行
コマンド実行の許可を求める際に、そのコマンドによって何が起きるかの説明を日本語で行うこと。

## 課題・気づきの管理
作業中に気づいた課題・改善提案は `progress-management/issues/` 配下の該当カテゴリフォルダにmdファイルを作成すること。
カテゴリ: requirements / domain / architecture / ui-design / detail-design / testing / implementation / security / infrastructure / project-management
解決済みは解決内容・解決日を記入してから `progress-management/resolved/` へ移動する。

## ディレクトリ役割
- root-project/ はAI運用・プロジェクト管理専用ディレクトリ
  - AIエージェント設定: CLAUDE.md、rules/、prompts/、skills/
  - 仕様・内部資料: PROJECT_SUMMARY.md、references/
  - 作業補助: templates/、scripts/、deliverables/
- 実プロダクト（ソースコード）は project/ 以下に配置
- ソースコードの新規作成・編集は project/ 配下のみで行う

## 技術スタック
Backend: Rust (Actix Web) / Frontend: React (TypeScript, Vite) / DB: PostgreSQL / DB Access: SQLx / Infra: AWS (ECS Fargate, RDS, S3) / CI: GitHub Actions

## アーキテクチャ制約
- 全テーブル・全クエリに tenant_id 必須。例外なし
- リポジトリ層で tenant_id を強制（ハンドラで直接SQL禁止）
- PostgreSQL RLS をテナント分離の二重保証として使用
- 状態遷移(draft→submitted→approved→paid, submitted→rejected)はドメイン層で一元管理
- JWT認証(RS256)、パスワードハッシュはArgon2id

## RBAC
Admin / Approver / Member / Accounting の4ロール。全APIでミドルウェア検証

## 禁止事項
- tenant_id なしのクエリ作成
- 不要なファイル生成（ドキュメント・READMEの自動生成含む）

## ファイル参照ルール
- API一覧・DB定義・テスト戦略等の詳細仕様: PROJECT_SUMMARY.md
- コーディング規約: rules/coding-standards.md
- テスト方針: rules/testing.md
- コミット規約: rules/commit-message.md
- ディレクトリ構成（root-project）: references/directory-structure.md
- ディレクトリ構成（project）: references/project-structure.md
