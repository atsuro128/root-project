---
name: review
description: |
  コードレビューチェックリストに従いレビューを実施する。
  Use when: ユーザーが「レビューして」「コード見て」「差分チェックして」と依頼した時、コミット前の品質確認を求められた時
  DO NOT use when: 実装作業中、単にコードの説明を求められた時
allowed-tools: Read, Grep, Glob, Bash(git *)
---

ai-dev-framework/rules/review-checklist.md を読み込み、そのチェックリストに従ってコードレビューを実施してください。

## レビュー対象の差分

対象: $ARGUMENTS
（引数がない場合はステージ済みの変更を対象とする）

### ステージ済み差分
!`git diff --cached 2>&1 || echo "ステージ済み差分なし"`

### 未ステージ差分
!`git diff 2>&1 || echo "未ステージ差分なし"`

## 手順

1. 上記の差分を確認する（引数でファイル指定がある場合はそのファイルを読む）
2. review-checklist.md の各項目に照らして変更を評価
3. CLAUDE.md のコーディング規約・アーキテクチャ制約への準拠を確認
4. 問題点・改善提案をチェックリスト項目ごとに報告
