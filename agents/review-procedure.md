# 初回レビュー手順

## Step 1: 対象成果物の確認

`guide/portfolio_project_steps.md` の対象ステップの「成果物」「完了条件」を確認する。

| Step | 内容 | 主な対象ディレクトリ |
|------|------|------------------|
| 0 | 事前準備 | `deliverables/docs/`（00_goals, 01_glossary, 02_scope） |
| 1 | 要件定義 | `deliverables/docs/10_requirements/` |
| 2 | ドメイン設計 | `deliverables/docs/20_domain/` |
| 3 | アーキテクチャ設計 | `deliverables/docs/30_arch/` |
| 4 | 基本設計 | `deliverables/docs/40_basic_design/` |
| 5 | 詳細設計 | `deliverables/docs/50_detail_design/` |
| 6 | テスト設計 | `deliverables/docs/60_test/` |
| 7 | 実装・運用 | `project/` |

---

## Step 2: レビュー観点

### 共通観点（全ステップ必須）

- [ ] ステップの**完了条件**をすべて満たしているか
- [ ] 用語が `references/glossary.md` に準拠しているか
- [ ] MVP スコープ（`deliverables/docs/02_scope.md`）の範囲内か
- [ ] 文書間の**整合性**（矛盾・重複がないか）
- [ ] 意思決定事項に未決のものが残っていないか

### ステップ別追加観点

| Step | 観点 |
|------|------|
| 1（要件定義） | アクター・ユースケースの網羅性、RBAC 整合性、状態遷移の漏れ、非機能要件の明示、ルールIDのトレーサビリティ |
| 2（ドメイン設計） | テナント分離の不変条件明記、状態遷移の禁止操作、監査ログの INSERT ONLY 制約 |
| 3（アーキテクチャ設計） | ADR への選定理由記載、テナント分離の二重保証（アプリ層 + RLS）方針、構成図の存在 |
| 4（基本設計） | 権限別の操作可否の明示、主要画面の網羅性 |
| 5（詳細設計） | tenant_id 必須チェック、認可チェック責務の明確化、署名付き URL 発行前の認可チェック、セキュリティヘッダー |
| 6（テスト設計） | テナント分離テスト・RBAC テスト・状態遷移テストの存在、CI による自動実行 |
| 7（実装） | tenant_id なしのクエリ不在、unwrap 禁止、テスト網羅性 |

---

## Step 3: 指摘の起票

レビュー指摘は `review-findings/` で管理する（issue とは別管理）。

- **1 指摘 = 1 ファイル**: `review-findings/open/NNN-kebab-case.md` を作成
- 番号体系は `review-findings/` 内（`open/`・`pending-review/`・`resolved/` 横断）で一意の連番

> 指摘のうち、独立した設計判断が必要で対応が大きいものは issue に昇格させる。
昇格の判断はユーザーに確認すること。
