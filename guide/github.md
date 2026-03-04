# GitHub 運用ガイド（ユーザー向け）

## リポジトリ・ボード

| 項目 | URL |
|---|---|
| リポジトリ | https://github.com/atsuro128/expense-saas |
| Projectsボード | https://github.com/users/atsuro128/projects/1 |

## ラベル一覧

### Type（種別）
| ラベル | 意味 |
|---|---|
| `feat` | 新機能 |
| `bug` | 不具合 |
| `chore` | 設定・環境整備 |
| `refactor` | リファクタリング |
| `test` | テスト |

### Priority（優先度）
| ラベル | 意味 |
|---|---|
| `priority: high` | 優先度高（ブロッカー） |
| `priority: medium` | 通常 |
| `priority: low` | 後回し可 |

### Area（領域）
| ラベル | 意味 |
|---|---|
| `area: backend` | Rustバックエンド |
| `area: frontend` | Reactフロントエンド |
| `area: db` | DB・マイグレーション |
| `area: infra` | インフラ・CI/CD |
| `area: auth` | 認証・認可 |

## IssueとPRの流れ

```
Issue作成 → ブランチ作成 → 実装 → PR作成（Closes #番号） → マージ → Issue自動クローズ
```

Projectsボードのステータスはマージ後に手動で「Done」に移動する。

## 進捗確認

Projectsボード（https://github.com/users/atsuro128/projects/1）でカンバン形式で全体を確認できる。

面接時にアピールしたい場合はリポジトリをpublicに変更:
```bash
gh repo edit atsuro128/expense-saas --visibility public
```
