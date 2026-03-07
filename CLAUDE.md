# 経費精算SaaS — Claude Code プロジェクト方針

## 1. 絶対ルール
- 作業開始時に必ず `progress-management/progress.md` を確認し、現在のフェーズ・直近タスク・課題を把握すること
- 作業完了時に必ず `progress-management/progress.md` を更新し、次回セッションに引き継げる状態にすること
- ソースコードの新規作成・編集は `project/` 配下のみで行うこと
- `root-project/` 配下のファイルを編集した場合、ユーザーへの最終応答前に必ずコミットすること
- コミット前に必ずセッションログを記録すること（`rules/session-log.md` に従い `logs/YYYY-MM-DD/session-log.md` に追記してからコミット）
- コマンド実行時は、何をするためのコマンドなのかを必ず日本語で明示すること
- tenant_id なしのクエリを作成しないこと
- 不要なファイルを生成しないこと（ドキュメント・READMEの自動生成を含む）
- 現在のステップの完了条件を満たしてから次ステップへ進むこと
- MVP スコープ外の機能を実装しないこと:`deliverables/docs/02_scope.md`
- ルール未確認のまま Issue 対応・レビュー指摘対応を進めないこと
- 必要に応じて関連ルール・仕様を参照すること
- 以上すべてを満たした状態でユーザーへ最終応答を返すこと

## 2. 標準作業手順
1. `progress-management/progress.md` と関連資料を確認し、作業目的を理解する
2. 現在ステップの完了条件、MVPスコープ、影響範囲を確認する
3. 必要なルール・仕様書を参照する
4. 実装または修正方針を整理してから変更を行う
5. 必要なテスト・動作確認を行う
6. 関連ドキュメントと `progress-management/progress.md` を更新する

## 3. 主要参照先
- 全体の進め方・各ステップの成果物・完了条件: `guide/portfolio_project_steps.md`
- MVP のスコープ: `deliverables/docs/02_scope.md`
- 用語定義: `references/glossary.md`
- アーキテクチャ・制約: `rules/architecture.md`
- API一覧・DB定義・テスト戦略等の詳細仕様: `PROJECT_SUMMARY.md`
- コーディング規約: `rules/coding-standards.md`
- テスト方針: `rules/testing.md`

## 4. 条件付き参照ルール
- Issue に対応する場合: `rules/issue-management.md`
- レビュー指摘に対応する場合: `rules/review-findings.md`
- フォルダ追加・削除・移動を行う場合: `references/directory-structure.md`, `references/project-structure.md`

## 5. メモリ運用
- 記憶・知見の保存先は `.claude/memory/MEMORY.md` とする
- グローバルのメモリパスは使用しない

## 6. Git 運用
リポジトリは2つ存在する。
- `root-project/` : プロジェクト管理・AI運用基盤（private）
- `root-project/project/` : プロダクトコード（public）

- ソースコード関連のコミットは `project/`、設定・ドキュメント関連は `root-project/` で行う
- コミット規約: `rules/commit-message.md`
- コミットフッター: `Co-Authored-By: Claude <noreply@anthropic.com>`

## 7. ディレクトリ運用
- 構成変更時は対応する構成資料を更新すること
  - root-project 側: `references/directory-structure.md`
  - project 側: `references/project-structure.md`

## 8. 用語統一
- ドキュメント・コード・コミットメッセージで用語を統一すること
- 用語定義: `references/glossary.md`

## 9. 技術スタック
Backend: Rust (Actix Web) / Frontend: React (TypeScript, Vite) / DB: PostgreSQL / DB Access: SQLx / Infra: AWS (ECS Fargate, RDS, S3) / CI: GitHub Actions
