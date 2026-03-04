以下は本プロジェクトのツリー構造想定図である。
あくまで想定であり、サンプルという位置づけの為、記載してあるフォルダやファイルは不要になることもある。
また、本プロジェクトでは、claude code設定関連や、内部資料やメモなどはrootProjectで管理し、アプリケーション層はprojectフォルダ以下に実装し、
gitにあげるのはproject以下のみとすることで、公開範囲を明確に分離する想定となっている。
その為、git操作はprojectに移動して実行する点を注意する旨をskillsに記載する必要があるが現段階では不要。
一旦はこの構造のままファイルのみ作成して、後から必要性を検討していく。
ファイル作成時に、1行目にそのファイルの大まかな役割を記載すること。
それ以外の記載は合理的な理由がない限りは現段階では行わないこと。(ex.1行では説明が足りない場合は記載を許可)
後から肉付けする想定。
ファイルがないフォルダに関しては、explanation.mdファイルを仮置きし、そのフォルダの用途と、explanation.mdは仮置きである旨を記載すること。

root-project/                        # Claude Code 運用ルート
├─ PROJECT_SUMMARY.md                # プロジェクト概要(叩きレベルの為ブラッシュアップが必要だが、別に要件定義書を作成してそこで確定させることも検討)
├─ project-structure.md              # 本ファイル： アプリケーション層との分離、claude codeの利用など初めての試みの為、想定するツリー構造を可視化しておく
├─ CLAUDE.md                         # Claude Code 用のプロジェクト方針/前提/禁止事項など
├─ .claude/                          # Claude Code 設定ディレクトリ
│  ├─ commands/                      # カスタムコマンド定義
│  │  ├─ review.md
│  │  └─ status.md
│  └─ settings.json
├─ guide/                            # プロジェクト進行ガイド（全体ステップ・実装手順等）
│  ├─ implementation-guide.md
│  └─ portfolio_project_steps.md
├─ progress-management/              # 進捗管理（運用方法未定）
├─ discussion/                       # claude codeのエージェント機能を利用してプロジェクトの品質向上を目指すが運用方法は未定
├─ skills/                           # カスタムスキル（手順・テンプレ・定型化した作業）
│  ├─ README.md
│  ├─ architecture/                  # 例：設計レビュー観点、ADRテンプレ等
│  ├─ backend/
│  ├─ frontend/
│  ├─ db/
│  ├─ security/
│  └─ release/
├─ rules/                            # ルール（守るべき規約・品質基準・運用）
│  ├─ coding-standards.md
│  ├─ branching.md
│  ├─ commit-message.md
│  ├─ review-checklist.md
│  ├─ security-policy.md
│  └─ data-handling.md
├─ prompts/                          # よく使う指示文（要件定義/実装/レビュー等の型）→skillsにまとめることも検討
│  ├─ requirement.md
│  ├─ implementation.md
│  └─ refactor.md
├─ templates/                        # 各種テンプレ（README/ADR/設計書/議事録など）→skillsにまとめることも検討
│  ├─ ADR-template.md
│  ├─ README-template.md
│  └─ RFC-template.md
├─ references/                       # 参照資料（仕様メモ、調査結果、リンク集）
│  ├─ glossary.md
│  ├─ links.md
│  ├─ decisions/                     # 採用/不採用理由など（軽量ログ）
│  └─ tech-stack-notes/              # 比較検討メモ、候補、リンク集、判断ログ（AI運用向け）
├─ scripts/                          # 自動化（セットアップ、lint、生成、DB初期化など）
│  ├─ setup.sh
│  ├─ lint.sh
│  └─ db-reset.sh
├─ deliverables/                     # 成果物置き場(アーキテクチャ、設計・テスト仕様書など適宜、項目ごとや機能ごとに子階層を作成)
└─ project/                          # （下階層）実プロダクト（経費精算SaaS）コード置き場
   ├─ README.md
   ├─ .gitignore
   ├─ .github/
   │  ├─ workflows/
   │  └─ PULL_REQUEST_TEMPLATE.md
   ├─ docs/                          # 公開用も兼ねる設計/運用ドキュメント
   │  ├─ architecture.md
   │  ├─ api.md
   │  ├─ tech-stack.md               # 採用技術の一覧 + 理由 + トレードオフ
   │  └─ runbook.md
   ├─ apps/                          # モノレポ想定
   │  ├─ web/                        # フロントエンド
   │  │  ├─ src/
   │  │  └─ package.json
   │  └─ api/                        # バックエンドAPI
   │     ├─ src/
   │     └─ package.json
   ├─ packages/                      # 共有パッケージ（UI, 設定, 型, DBなど）
   │  ├─ ui/
   │  ├─ config/
   │  ├─ types/
   │  └─ db/
   ├─ infra/                         # IaC / 環境（Terraform, CDK, k8s, etc）
   ├─ database/                      # マイグレーション/シード/ERD等
   ├─ docker/                        # ローカル開発用コンテナ
   ├─ scripts/                       # プロダクト側スクリプト
   └─ tests/                         # E2E/統合テスト等
