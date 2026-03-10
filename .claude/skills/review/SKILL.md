---
name: review
description: |
  コードレビューチェックリストに従いレビューを実施する。
  Use when: ユーザーが「レビューして」「コード見て」「差分チェックして」と依頼した時、コミット前の品質確認を求められた時
  DO NOT use when: 実装作業中、単にコードの説明を求められた時
---

ai-dev-framework/rules/review-checklist.md を読み込み、そのチェックリストに従ってコードレビューを実施してください。

手順:
1. git diff で変更差分を取得
2. review-checklist.md の各項目に照らして変更を評価
3. CLAUDE.md のコーディング規約・アーキテクチャ制約への準拠を確認
4. 問題点・改善提案をチェックリスト項目ごとに報告

対象: $ARGUMENTS
（引数がない場合はステージ済みの変更を対象とする）
