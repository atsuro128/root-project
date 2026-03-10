---
paths:
  - "expense-saas/**/*"
---

# アーキテクチャ制約

## マルチテナント
- 全テーブル・全クエリに tenant_id 必須。例外なし
- リポジトリ層で tenant_id を強制（ハンドラで直接SQL禁止）
- PostgreSQL RLS をテナント分離の二重保証として使用

## ドメイン
- 状態遷移(draft→submitted→approved→paid, submitted→rejected)はドメイン層で一元管理

## 認証・セキュリティ
- JWT認証(RS256)、パスワードハッシュはArgon2id

## RBAC
Admin / Approver / Member / Accounting の4ロール。全APIでミドルウェア検証
