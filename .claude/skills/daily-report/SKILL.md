---
name: daily-report
description: |
  今日の作業内容を日報としてまとめる。
  Use when: ユーザーが「日報書いて」「今日のまとめ」「作業報告して」と依頼した時
  DO NOT use when: 単に進捗確認をしたい時（statusを使う）
---

今日の作業内容を日報としてまとめ、`dev-journal/daily-reports/YYYY-MM-DD.md` に保存してください。

対象日: $ARGUMENTS
（引数がない場合は、当日のコミット履歴とセッションログを確認する）

## 手順

1. 今日の日付を確認（YYYY-MM-DD形式）
2. 各サブリポジトリで対象日のコミット履歴を取得:
   `git log --since="YYYY-MM-DD 00:00" --until="YYYY-MM-DD 23:59" --oneline`
   - 対象: root-project/, ai-dev-framework/, expense-saas/, dev-journal/
3. `dev-journal/logs/YYYY-MM-DD/session-log.md` が存在すれば読み込む（Readツールで絶対パスを使用すること）
4. `dev-journal/progress-management/progress.md` を読み、次タスクを確認する
5. 下記の出力形式に従い `dev-journal/daily-reports/YYYY-MM-DD.md` にファイルを作成する
6. 作成した内容をユーザーにも表示する
7. `ai-dev-framework/rules/commit-message.md` に従いコミットする

## 出力形式

```
## YYYY-MM-DD 作業日報

### 実施内容

#### root-project
（コミット履歴をもとに箇条書き。コミットなしの場合は「コミットなし」）

#### ai-dev-framework
（同上）

#### expense-saas
（同上）

#### dev-journal
（同上）

### 判断・決定事項
（session-log.md の `判断:` 行を整形して記載。なければ「記録なし」）

### 明日以降のタスク
（progress.md の直近タスクから引用）
```
