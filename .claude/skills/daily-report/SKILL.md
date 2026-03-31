---
name: daily-report
description: "日報作成。Use when: 「日報書いて」「作業報告して」"
disable-model-invocation: true
argument-hint: "[YYYY-MM-DD]"
---

今日の作業内容を日報としてまとめ、`dev-journal/archives/daily-reports/YYYY-MM-DD.md` に保存してください。

## 現在の日時

!`date "+%Y-%m-%d %H:%M"`

## 対象日

$ARGUMENTS
（引数がない場合は上記の日付を使用する）

## 各リポジトリの対象日コミット履歴

### root-project
!`git log --since=midnight --oneline`

### ai-dev-framework
!`git -C ai-dev-framework log --since=midnight --oneline`

### expense-saas
!`git -C expense-saas log --since=midnight --oneline`

### dev-journal
!`git -C dev-journal log --since=midnight --oneline`

## 手順

1. 上記の事前取得データを確認する（対象日が今日でない場合は Bash ツールで対象日のコミット履歴を個別に取得する）
2. `dev-journal/progress-management/session-log.md` を読み、当日のセッション記録を把握する
3. `dev-journal/archives/session-logs/YYYY-MM-DD.md`（対象日のファイル）を読み、アーカイブ済みセッション記録も把握する
4. `dev-journal/progress-management/progress.md` を読み、次タスクを確認する
5. 下記の出力形式に従い `dev-journal/archives/daily-reports/YYYY-MM-DD.md` にファイルを作成する
6. 作成した内容をユーザーにも表示する
7. `/commit` スキルに従いコミットする

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
（session-log.md の学び・気づきセクションから引用。なければ「記録なし」）

### 明日以降のタスク
（progress.md の直近タスクから引用）
```
