# 経費精算SaaS プロジェクト

マルチテナント型の経費精算 SaaS。要件定義から AWS デプロイ・UAT 完走までを 4 つのリポジトリに分けて開発したポートフォリオ。

**公開デモ**: https://djhmwtrr79jdq.cloudfront.net/

---

## このリポジトリについて

メタリポジトリ。プロダクト本体は [`expense-saas/`](./expense-saas/) にある。本リポジトリ自体は実装コードを持たず、4 リポジトリ全体の運用ルール（CLAUDE.md / .claude/）を集約している。

## リポジトリ構成

| ディレクトリ | 役割 | README |
|---|---|---|
| [`expense-saas/`](./expense-saas/) | プロダクト本体（実装コード） | [README](./expense-saas/README.md) |
| [`dev-journal/`](./dev-journal/) | 開発プロセス記録（設計成果物・進捗・issue・ログ） | [README](./dev-journal/README.md) |
| [`ai-dev-framework/`](./ai-dev-framework/) | AI 駆動開発フレームワーク（エージェント定義・ワークフロー・テンプレート） | [README](./ai-dev-framework/README.md) |
| `root-project/`（本リポジトリ） | メタリポジトリ（CLAUDE.md・.claude/ による全体統括） | — |

## どこから読むか

| 関心 | 入口 |
|---|---|
| プロダクトを動かしたい / 公開デモを試したい | [`expense-saas/README.md`](./expense-saas/README.md) |
| 設計判断・ADR・テスト戦略・運用設計を見たい | [`dev-journal/README.md`](./dev-journal/README.md) |
| AI 駆動開発の仕組み（エージェント定義・ワークフロー）を見たい | [`ai-dev-framework/README.md`](./ai-dev-framework/README.md) |
| 全体の運用ルール・セッション開始の流れ | [`CLAUDE.md`](./CLAUDE.md) |
