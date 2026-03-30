---
name: review-findings
description: |
  codex レビュー指摘への対応を管理する（設計成果物フローのステップ5）。
  Use when: ユーザーが「指摘対応して」「レビュー指摘見て」と依頼した時、codex 指摘に対応する場合
  DO NOT use when: Issue 対応（/issue を使う）
argument-hint: "[対象の指摘ファイル名]"
---

codex レビュー指摘への対応を実行してください。

対象: $ARGUMENTS

## フォルダ構成

```
dev-journal/review-findings/
├── open/             # 未対応の指摘
├── pending-review/   # 対応済み・codex 再レビュー待ち
└── resolved/         # 再レビュー完了・クローズ済み
```

## 手順

1. `dev-journal/review-findings/open/` の該当ファイルを読む（引数なしの場合は open/ 全件を確認）
2. **正当性を検証する**
   - 当該ステップの関連資料を確認する
   - 上流の成果物（設計指摘なら要件定義成果物 等）も確認する
   - 指摘が妥当かを判断し、検証結果をユーザーに報告する
3. ユーザーの判断を受けて対応方針を決定する
   - **対応する場合**: 成果物を修正 → 指摘ファイルを `pending-review/` へ移動 → `/commit` でコミット → `/codex-review` で codex に再レビュー依頼
   - **対応不要の場合**: 指摘ファイルに判断理由を記載 → `pending-review/` へ移動 → `/codex-review` で codex に判断を委ねる
   - **issue に昇格する場合**: `/issue 起票` で issue 化 → 元の指摘ファイルを削除（二重管理防止）

## 注意事項

- 指揮役の差分確認で resolved にしない — 必ず codex に再レビューを依頼する
- codex が解消を確認したら `resolved/` に移動する
- codex が再度 FIX を出した場合は手順 2 に戻る（PASS まで繰り返す）
