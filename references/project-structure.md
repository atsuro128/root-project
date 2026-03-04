# プロダクト（project/）ディレクトリ構成

```
project/
├─ README.md
├─ .github/
│  ├─ workflows/
│  └─ PULL_REQUEST_TEMPLATE.md
├─ apps/                          # モノレポ: アプリケーション
│  ├─ api/                        # バックエンド API (Rust / Actix Web)
│  │  ├─ src/
│  │  └─ package.json
│  └─ web/                        # フロントエンド (React / TypeScript / Vite)
│     ├─ src/
│     └─ package.json
├─ packages/                      # 共有パッケージ
│  ├─ config/
│  ├─ db/
│  ├─ types/
│  └─ ui/
├─ database/                      # マイグレーション / シード / ERD 等
├─ docker/                        # ローカル開発用コンテナ
├─ docs/                          # 公開用設計・運用ドキュメント
│  ├─ architecture.md
│  ├─ api.md
│  ├─ tech-stack.md
│  └─ runbook.md
├─ infra/                         # IaC（Terraform 等）
├─ scripts/                       # プロダクト側スクリプト
└─ tests/                         # E2E / 統合テスト
```
