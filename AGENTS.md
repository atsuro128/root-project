# AGENTS.md — Codex 指示書

作業を開始する前に、下表から該当するファイルを読み込んでから作業を開始すること。

| 作業 | 読み込むファイル |
|---|---|
| 初回レビュー | `agents/review-procedure.md` |
| 再レビュー（指摘対応後） | `agents/re-review-procedure.md` |

---

## プロジェクト概要

マルチテナント型 経費精算SaaS のポートフォリオプロジェクト。

- **技術スタック**: Rust (Actix Web) / React (TypeScript, Vite) / PostgreSQL / SQLx / AWS (ECS Fargate, RDS, S3)
- **リポジトリ構成**:
  - `root-project/`: プロジェクト管理・AI 運用基盤（private）
  - `root-project/project/`: プロダクトコード（public）

---

## 参照ドキュメント

| ドキュメント | パス |
|---|---|
| 全体ステップ（成果物・完了条件） | `guide/portfolio_project_steps.md` |
| MVP スコープ | `deliverables/docs/02_scope.md` |
| 用語定義 | `references/glossary.md` |
| Issue 管理ルール | `rules/issue-management.md` |
| Issue テンプレート | `templates/issue-template.md` |
| アーキテクチャ制約 | `rules/architecture.md` |
| コーディング規約 | `rules/coding-standards.md` |
| テスト方針 | `rules/testing.md` |
| セキュリティポリシー | `rules/security-policy.md` |
