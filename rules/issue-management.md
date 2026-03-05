# Issue 管理ルール

## ファイル命名規則

```
NNN-kebab-case.md
```

- `NNN`: 3桁ゼロ埋めのグローバル連番（`issues/`・`pending-review/`・`resolved/` 横断で一意）
- 次の番号は3フォルダを横断して最大番号 + 1 を使用する
- 説明部分はハイフン区切りの英小文字（kebab-case）

**例**: `011-rbac-middleware-missing.md`

## フォルダ構成

```
progress-management/
├── issues/           # 対応中・未対応の issue
├── pending-review/   # 解決内容を記入済み・レビュー待ち
└── resolved/         # レビュー完了・クローズ済み
```

カテゴリはフォルダで分けず、テンプレートのカテゴリ欄で管理する。

## ライフサイクル

1. **起票**: `issues/NNN-kebab-case.md` を作成（テンプレート: `templates/issue-template.md`）
2. **対応完了**: 解決内容・解決日を記入した後、**ユーザーに確認を行う**
   - レビューが必要 → `pending-review/` へ移動
   - 重要度が低くレビュー不要 → 直接 `resolved/` へ移動
3. **レビュー後**（pending-review 経由の場合）: `resolved/` へ移動

## カテゴリ一覧

| カテゴリ | 対象 |
|---------|------|
| `requirements` | 要件定義・仕様の問題 |
| `domain` | ドメインロジック・ビジネスルールの問題 |
| `architecture` | アーキテクチャ・設計構造の問題 |
| `ui-design` | UI/UX 設計の問題 |
| `detail-design` | 詳細設計（API・DB・インターフェース）の問題 |
| `testing` | テスト戦略・テストコードの問題 |
| `implementation` | 実装・コードの問題 |
| `security` | セキュリティ上の問題 |
| `infrastructure` | インフラ・CI/CD・環境の問題 |
| `project-management` | プロジェクト管理・運用ルールの問題 |

## 影響度の基準

| 影響度 | 基準 |
|-------|------|
| `高` | 放置すると設計判断・実装に直接支障をきたす |
| `中` | 次フェーズまでに対処が必要 |
| `低` | 改善提案・優先度低 |
