# 経費精算SaaS — Claude Code プロジェクト方針

## 技術スタック
Backend: Go / Frontend: React (TypeScript, Vite) / DB: PostgreSQL / Infra: AWS (ECS Fargate, RDS, S3) / CI: GitHub Actions

## リポジトリ構成
| リポジトリ | 責務 |
|---|---|
| `root-project/` | メタリポジトリ（CLAUDE.md・.claude/ による統括） |
| `expense-saas/` | プロダクト本体（実装コードのみ） |
| `dev-journal/` | 開発プロセス記録（進捗・日報・ログ・設計成果物・参照資料） |
| `ai-dev-framework/` | AI駆動開発フレームワーク（ルール・コマンド・テンプレート・ADR） |

## 参照先
- 進め方・完了条件: dev-journal/guide/project_steps.md
- MVP スコープ: dev-journal/deliverables/docs/02_scope.md
- 用語集: dev-journal/references/glossary.md
