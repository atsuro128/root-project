---
name: review-findings
description: |
  レビュー指摘への対応を管理する。
  Use when: ユーザーが「指摘対応して」「レビュー指摘見て」と依頼した時、レビュー指摘に対応する場合
  DO NOT use when: Issue 対応（/issue を使う）、コードレビューの実施（/review を使う）
argument-hint: "[対象の指摘ファイル名]"
---

レビュー指摘対応ルールに従って操作を実行してください。

対象: $ARGUMENTS

## フォルダ構成

```
dev-journal/review-findings/
├── open/             # 未対応の指摘
├── pending-review/   # 対応済み・レビュー待ち
└── resolved/         # 再レビュー完了・クローズ済み
```

## 手順

1. `dev-journal/review-findings/open/` の該当ファイルを読む
2. **正当性を検証する**
   - 当該ステップの関連資料を確認する
   - 上流の成果物（設計指摘なら要件定義成果物 等）も確認する
   - 指摘が妥当かを判断し、検証結果をユーザーに報告する
3. ユーザーの判断を受けて対応方針を決定する
   - **対応する場合**: 成果物を修正 → 指摘ファイルを `pending-review/` へ移動
   - **対応不要の場合**: 指摘ファイルに判断理由を記載 → `pending-review/` へ移動

## issue への昇格

指摘のうち、独立した設計判断が必要で対応が大きいものは issue に昇格させる（`/issue` スキル参照）。
昇格の判断はユーザーに確認すること。
Issue に昇格した指摘ファイルは、status を `escalated` に変更し `resolved/` へ移動する。
