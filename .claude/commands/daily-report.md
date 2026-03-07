今日の作業内容を日報としてまとめ、`daily-reports/YYYY-MM-DD.md` に保存してください。

対象日: $ARGUMENTS
（引数がない場合は、当日のコミット履歴、セッションログを確認する）

## 手順

1. 今日の日付を確認（YYYY-MM-DD形式）
2. root-project/ で対象日のコミット履歴を取得:
   `git log --since="YYYY-MM-DD 00:00" --until="YYYY-MM-DD 23:59" --oneline`
3. project/ で同じコマンドを実行
4. `logs/YYYY-MM-DD/session-log.md` が存在すれば読み込む（Readツールで絶対パスを使用すること）
5. `progress-management/progress.md` を読み、次タスクを確認する
6. 下記の出力形式に従い `daily-reports/YYYY-MM-DD.md` にファイルを作成する
7. 作成した内容をユーザーにも表示する
8. `rules/commit-message.md` に従いコミットする

## 出力形式

```
## YYYY-MM-DD 作業日報

### 実施内容
（コミット履歴をもとに、何をしたかを箇条書きでまとめる）

### 判断・決定事項
（session-log.md の `判断:` 行を整形して記載。なければ「記録なし」）

### 明日以降のタスク
（progress.md の直近タスクから引用）
```
