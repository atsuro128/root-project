---
name: daily-report
description: |
  今日の作業内容を日報としてまとめる。
  Use when: ユーザーが「日報書いて」「今日のまとめ」「作業報告して」と依頼した時
  DO NOT use when: 単に進捗確認をしたい時（statusを使う）
disable-model-invocation: true
argument-hint: "[YYYY-MM-DD]"
---

今日の作業内容を日報としてまとめ、`dev-journal/daily-reports/YYYY-MM-DD.md` に保存してください。

## 現在の日時

!`date "+%Y-%m-%d %H:%M"`

## 対象日

$ARGUMENTS
（引数がない場合は上記の日付を使用する）

## 各リポジトリの本日コミット履歴

### root-project
!`git log --since="$(date +%Y-%m-%d) 00:00" --until="$(date +%Y-%m-%d) 23:59" --oneline 2>&1 || echo "コミットなし"`

### ai-dev-framework
!`cd ai-dev-framework && git log --since="$(date +%Y-%m-%d) 00:00" --until="$(date +%Y-%m-%d) 23:59" --oneline 2>&1 || echo "コミットなし"`

### expense-saas
!`cd expense-saas && git log --since="$(date +%Y-%m-%d) 00:00" --until="$(date +%Y-%m-%d) 23:59" --oneline 2>&1 || echo "コミットなし"`

### dev-journal
!`cd dev-journal && git log --since="$(date +%Y-%m-%d) 00:00" --until="$(date +%Y-%m-%d) 23:59" --oneline 2>&1 || echo "コミットなし"`

## 手順

1. 上記の事前取得データを確認する
2. `dev-journal/logs/YYYY-MM-DD/session-log.md` が存在すれば読み込む（Readツールで絶対パスを使用すること）
3. `dev-journal/progress-management/progress.md` を読み、次タスクを確認する
4. 下記の出力形式に従い `dev-journal/daily-reports/YYYY-MM-DD.md` にファイルを作成する
5. 作成した内容をユーザーにも表示する
6. `ai-dev-framework/rules/commit-message.md` に従いコミットする

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
