---
paths:
  - "expense-saas/**/*"
---

# 実装共通ルール

## 必須参照

実装・レビュー時に以下の設計成果物を確認すること。

- セキュリティ: `dev-journal/deliverables/docs/50_detail_design/security.md`
- 認可: `dev-journal/deliverables/docs/50_detail_design/authz.md`
- DB: `dev-journal/deliverables/docs/50_detail_design/db_schema.md`
- API: `dev-journal/deliverables/docs/50_detail_design/openapi.yaml`
- 画面: `dev-journal/deliverables/docs/50_detail_design/screens/`
- テスト: `dev-journal/deliverables/docs/60_test/`

## デリバリー手順

チケットのブランチ欄を確認し、以下に従う。

## 機能ブランチの場合

品質チェック完了後:

1. 変更をコミット
2. ブランチを push: `git push -u origin <ブランチ名>`
3. PR を作成: `gh pr create --title "<チケットID>: <概要>" --body "<変更内容>"`
4. 指揮役に **PR URL** を返す

## main 直接の場合

品質チェック完了後:

1. 変更をコミット
2. 指揮役に完了を報告する
