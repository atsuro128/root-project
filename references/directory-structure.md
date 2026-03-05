# root-project ディレクトリ構成

project/ 以下のプロダクト構成は `references/project-structure.md` を参照。

```
root-project/
├─ CLAUDE.md                         # Claude Code プロジェクト方針
├─ PROJECT_SUMMARY.md                # プロジェクト概要・仕様サマリ
├─ .claude/                          # Claude Code 設定
│  ├─ commands/                      # カスタムコマンド（review, status）
│  └─ settings.json
├─ guide/                            # プロジェクト進行ガイド
│  ├─ github.md
│  ├─ implementation-guide.md
│  └─ portfolio_project_steps.md
├─ progress-management/              # 進捗・課題管理
│  ├─ progress.md
│  ├─ issues/                        # 未解決の課題（フラット構造・カテゴリはファイル内で管理）
│  ├─ pending-review/                # 対応完了・レビュー待ちの課題
│  ├─ resolved/                      # レビュー完了・クローズ済み課題
│  └─ step-deliverables/             # ステップ別成果物チェック
├─ rules/                            # 規約・ポリシー
│  ├─ branching.md
│  ├─ coding-standards.md
│  ├─ commit-message.md
│  ├─ data-handling.md
│  ├─ github.md
│  ├─ architecture.md
│  ├─ issue-management.md
│  ├─ review-checklist.md
│  ├─ security-policy.md
│  └─ testing.md
├─ prompts/                          # 指示文テンプレート（手動コピペ用 / .claude/commands/ 昇格前の下書き）
│  ├─ README.md
│  ├─ implementation.md
│  ├─ refactor.md
│  └─ requirement.md
├─ templates/                        # ドキュメントテンプレート
│  ├─ ADR-template.md
│  ├─ issue-template.md
│  ├─ README-template.md
│  └─ RFC-template.md
├─ references/                       # 参照資料
│  ├─ decisions/
│  ├─ dev-commands.md
│  ├─ directory-structure.md         # 本ファイル
│  ├─ glossary.md
│  ├─ links.md
│  ├─ project-structure.md           # project/ の構成
│  └─ tech-stack-notes/
├─ scripts/                          # 自動化スクリプト
│  ├─ db-reset.sh
│  ├─ lint.sh
│  └─ setup.sh
├─ deliverables/                     # 成果物
│  └─ docs/
│     ├─ 00_goals.md
│     ├─ 01_glossary.md
│     └─ 02_scope.md
└─ project/                          # プロダクトコード → references/project-structure.md 参照
```

## ディレクトリ役割

| ディレクトリ | 役割 |
|---|---|
| `CLAUDE.md` / `rules/` / `prompts/` / `.claude/commands/` | AIエージェント設定・規約 |
| `PROJECT_SUMMARY.md` / `references/` | 仕様・内部資料 |
| `templates/` / `scripts/` / `deliverables/` | 作業補助・成果物 |
| `progress-management/` | 進捗・課題管理 |
| `project/` | 実プロダクト（ソースコード）|

