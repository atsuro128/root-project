# references/directory-structure.md の内容が古い

## 発見日
2026-03-04

## 関連ステップ
Step 0（事前準備）

## カテゴリ
project-management

## 問題
`references/directory-structure.md` は `project/backend/`, `project/frontend/`, `project/migrations/` という構成を記載しているが、実際は `project/apps/api/`, `project/apps/web/`, `project/database/`。
また `project-structure.md` と内容が重複している。

## 影響
AIが古い構成を参照して誤ったファイル操作を行うリスクがある。

## 提案
- `project-structure.md` の内容に合わせて更新
- 2ファイルの重複を解消（一方に統合して片方は参照に）

## 解決内容


## 解決日

