# AGENTS.md — Codex 指示書

作業を開始する前に、下表から該当するファイルを読み込んでから作業を開始すること。

| 作業 | 読み込むファイル |
|---|---|
| 初回レビュー | `ai-dev-framework/agents/review-procedure.md` |
| 再レビュー（指摘対応後） | `ai-dev-framework/agents/re-review-procedure.md` |

---

## プロジェクト概要

マルチテナント型 経費精算SaaS。

- **技術スタック**: Go / React (TypeScript, Vite) / PostgreSQL / AWS (ECS Fargate, RDS, S3)
- **リポジトリ構成**:
  - `root-project/`: メタリポジトリ（CLAUDE.md・AGENTS.md・.claude/による統括）
  - `expense-saas/`: プロダクトコード（public）
  - `ai-dev-framework/`: AI駆動開発フレームワーク（ルール・テンプレート・ADR）
  - `dev-journal/`: 開発プロセス記録（進捗・日報・ログ・設計成果物・参照資料）

---

## 参照ドキュメント

| ドキュメント | パス |
|---|---|
| 全体ステップ（成果物・完了条件） | `dev-journal/guide/project_steps.md` |
| MVP スコープ | `dev-journal/deliverables/docs/02_scope.md` |
| 用語定義 | `dev-journal/references/glossary.md` |
| Issue 管理ルール | `.claude/skills/issue/SKILL.md` |
| Issue テンプレート | `ai-dev-framework/templates/issue-template.md` |
| アーキテクチャ制約 | `.claude/rules/architecture.md` |
| コーディング規約 | `.claude/rules/coding-standards.md` |
| テスト方針 | `.claude/rules/testing.md` |
| セキュリティポリシー | `.claude/rules/security-policy.md` |
