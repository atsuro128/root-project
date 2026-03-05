# 015: 認可エラーの 403/404 仕様が文書間で不整合

## 指摘概要
認可失敗時のHTTPステータス定義が `requirements.md` と `rbac.md` / `security-policy.md` で一致していない。

## 根拠
- `requirements.md`:
  - `RBC-004` 権限不足時は 403
  - `deliverables/docs/10_requirements/requirements.md:96`
- `rbac.md`:
  - 他テナントリソースは 404 Not Found
  - `deliverables/docs/10_requirements/rbac.md:194`
- `rules/security-policy.md`:
  - 権限不足: 403
  - 他テナントリソース: 404
  - `rules/security-policy.md:39`
  - `rules/security-policy.md:40`

## 判定
セキュリティ要件の不整合（中）。

## 修正方針案
`requirements.md` にケース別の返却コード（403/404）を明記し、RBACルールIDを分離して統一する。

