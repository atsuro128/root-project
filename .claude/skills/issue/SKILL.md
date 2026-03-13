---
name: issue
description: |
  Issue の起票・対応・移動を管理する。
  Use when: ユーザーが「Issue起票して」「Issue対応して」「Issue確認して」と依頼した時、作業中に設計上の問題を発見した時
  DO NOT use when: レビュー指摘への対応（/review-findings を使う）、単なるバグ修正
argument-hint: "[操作: 起票|対応|一覧] [対象]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(git *), Bash(mv *)
---

Issue 管理ルールに従って操作を実行してください。

対象: $ARGUMENTS

## フォルダ構成

```
dev-journal/progress-management/
├── issues/           # 対応中・未対応の issue
├── pending-review/   # 解決内容を記入済み・レビュー待ち
└── resolved/         # レビュー完了・クローズ済み
```

## ファイル命名規則

`NNN-kebab-case.md`（3桁ゼロ埋めのグローバル連番、3フォルダ横断で一意）

## ライフサイクル

1. **起票**: `issues/NNN-kebab-case.md` を作成（テンプレート: `ai-dev-framework/templates/issue-template.md`）
2. **正当性検証**（外部起票・レビュー指摘から昇格した issue の場合）
   - 当該ステップの関連資料を確認する
   - 上流の成果物も確認する
   - issue の妥当性を判断し、検証結果をユーザーに報告する
   - **対応不要の場合**: issue ファイルに判断理由を記載 → ユーザー確認後 `pending-review/` へ移動
3. **対応完了**: 解決内容・解決日を記入した後、**【必須】ユーザーに確認を行う**
   - 確認なしに `pending-review/` / `resolved/` へ移動してはならない
   - レビューが必要 → `pending-review/` へ移動
   - 重要度が低くレビュー不要 → 直接 `resolved/` へ移動
4. **レビュー後**（pending-review 経由の場合）: `resolved/` へ移動

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
| `ai-ops` | AI（Claude Code）の運用・操作ミス・改善 |

## 影響度の基準

| 影響度 | 基準 |
|-------|------|
| `高` | 放置すると設計判断・実装に直接支障をきたす |
| `中` | 次フェーズまでに対処が必要 |
| `低` | 改善提案・優先度低 |

## 発見経緯の分類

| 値 | 意味 | 典型的な状況 |
|----|------|-------------|
| `proactive` | 成果物作成中に Claude が能動的に発見 | 設計中に矛盾・曖昧さに気づいた |
| `review` | codex-review / ユーザーレビューで発見 | レビュー工程での指摘 |
| `escalation` | review-findings から issue に昇格 | 指摘対応中にスコープが大きいと判明 |
| `user-report` | ユーザーが直接報告 | ユーザーが問題を発見・報告 |

## 成果物作成中の即時起票フロー

Issue 発掘規約（`.claude/rules/workflow.md`）の即時起票条件を満たす場合:

1. **中断**: 現在の作業を中断し、発見した問題をユーザーに報告する
2. **判断**: ユーザーの判断を仰ぐ（起票する / 懸念として記録 / 対応不要）
3. **起票**: ユーザーが起票を承認した場合、テンプレートの「発見経緯」に `proactive` を設定して起票
4. **再開**: 元の作業を再開する
