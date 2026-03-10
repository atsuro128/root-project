---
name: codex-review
description: |
  codex CLI を使って Step 成果物のレビューを依頼する。
  Use when: Step 成果物の作成・コミットが完了した時、再レビューを依頼する時
  DO NOT use when: 成果物がまだコミットされていない時、通常のコードレビュー（/review を使う）
argument-hint: "[Step番号 ステップ名] [初回|再レビュー]"
allowed-tools: Read, Glob, Grep, Bash(codex *), Bash(git *)
---

codex レビューを実行してください。

対象: $ARGUMENTS

## トリガー条件

以下の **すべて** を満たしていることを確認:

1. Step の成果物（`dev-journal/deliverables/docs/` 配下）を新規作成または更新した
2. 上記を該当リポジトリにコミット済み

## 実行手順

### 初回レビュー

```bash
codex exec "Step N（ステップ名）の初回レビューを実施してください" --full-auto
```

### 再レビュー

```bash
codex exec "Step N の再レビューを実施してください" --full-auto
```

- 作業ディレクトリは `root-project/` であること
- Bash ツールの `run_in_background: true` で実行する（長時間かかるため）
- 完了通知を受け取ったら、`dev-journal/review-findings/open/` に指摘が起票されているか確認する

## 実行後の対応

1. codex がレビュー完了したら、`dev-journal/review-findings/open/` の指摘を確認
2. 指摘がある場合: 成果物を修正し、指摘ファイルを `pending-review/` に移動してコミット
3. 再レビューを依頼（上記コマンド）
4. 指摘が全て `resolved/` になったら、`dev-journal/progress-management/progress.md` のステータスを「完了」に更新

## progress.md ステータスとの対応

| タイミング | progress.md ステータス |
|-----------|---------------------|
| codex exec 実行前 | 進行中（成果物作成） |
| codex exec 実行後 | レビュー待ち |
| 指摘対応中 | 指摘対応中 |
| 全指摘 resolved | 完了 |
