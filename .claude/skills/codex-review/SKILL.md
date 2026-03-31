---
name: codex-review
description: |
  codex CLI を使って Step 成果物のレビューを依頼する。
  Use when: Step 成果物の作成・コミットが完了した時、再レビューを依頼する時、Issue 解決のレビューを依頼する時
  DO NOT use when: 通常のコードレビュー（/review を使う）
argument-hint: "[Step番号 ステップ名] [初回|再レビュー|issue解決レビュー]"
---

codex レビューを実行してください。

対象: $ARGUMENTS

## トリガー条件

### Step 成果物レビュー（初回・再レビュー）

以下の **すべて** を満たしていることを確認:

1. Step の成果物が作成済み（設計文書: `dev-journal/deliverables/docs/`、実装コード: `expense-saas/`）
2. 内部レビュー（reviewer エージェント）が PASS 済み
3. コミット前でも実行可能（codex はファイルを直接読める）

### Issue 解決レビュー

以下の **いずれか** を満たしていることを確認:

- `dev-journal/issues/pending-review/` に解決済み issue が存在する
- issue の解決に関連する未コミットの変更がある（`git diff` で確認可能）

## 実行手順

### 初回レビュー

```bash
codex exec "Step N（ステップ名）の初回レビューを実施してください" --sandbox danger-full-access
```

### 再レビュー

```bash
codex exec "Step N の再レビューを実施してください" --sandbox danger-full-access
```

### Issue 解決レビュー（コミット済み）

```bash
codex exec "issues/pending-review/ にある Issue の解決レビューを実施してください" --sandbox danger-full-access
```

### Issue 解決レビュー（未コミット・差分ベース）

```bash
# 差分をファイルに出力してからレビューを依頼
git -C dev-journal diff > /tmp/issue-diff.txt
codex exec "Issue NNN の解決レビューを実施してください。変更差分は /tmp/issue-diff.txt を参照してください。issue ファイルは dev-journal/issues/open/NNN-*.md です" --sandbox danger-full-access
```

### PR レビュー（expense-saas の実装コード）

```bash
codex exec "PR #N のレビューを実施してください" --sandbox danger-full-access
```

### PR 再レビュー（指摘対応後）

```bash
codex exec "PR #N の再レビューを実施してください" --sandbox danger-full-access
```

- 作業ディレクトリは `root-project/` であること
- Bash ツールの `run_in_background: true` で実行する（長時間かかるため）
- 完了通知を受け取ったら、結果を確認する
  - Step 成果物レビュー: `dev-journal/review-findings/open/` に指摘が起票されているか確認
  - Issue 解決レビュー: `dev-journal/issues/pending-review/` の issue が `resolved/` に移動されているか確認
  - PR レビュー: PR のコメント欄（`gh pr view <PR番号> --comments`）に指摘が投稿されているか確認

## 実行後の対応

### Step 成果物レビューの場合

1. codex がレビュー完了したら、`dev-journal/review-findings/open/` の指摘を確認
2. 指摘がある場合: `/review-findings`スキルに従って成果物を修正し、指摘ファイルを `pending-review/` に移動してコミット
3. 再レビューを依頼（上記コマンド）
4. 指摘が全て `resolved/` になったら、`dev-journal/progress-management/progress.md` のステータスを「完了」に更新

### Issue 解決レビューの場合

1. codex がレビュー完了したら、`dev-journal/issues/pending-review/` を確認
2. 解決が妥当と判断された issue: `resolved/` に移動済み
3. 解決が不十分と判断された issue: `open/` に差し戻し済み（追加コメント付き）

## progress.md ステータスとの対応

| タイミング | progress.md ステータス |
|-----------|---------------------|
| codex exec 実行前 | 進行中（成果物作成） |
| codex exec 実行後 | レビュー待ち |
| 指摘対応中 | 指摘対応中 |
| 全指摘 resolved | 完了 |
