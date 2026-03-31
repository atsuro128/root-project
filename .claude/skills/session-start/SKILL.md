---
name: session-start
description: |
  セッション開始時に状態確認とゴール提案を行う。
  Use when: セッションの最初のアクションとして必ず実行する。ユーザーが「次の作業は？」「どこまで進んだ？」「続きをやろう」と言った時も同様。
  DO NOT use when: セッション途中での呼び出し（セッション開始時の1回のみ実行）
---

セッション開始時の状態確認とゴール提案を実行してください。

## 実行手順

### 1. ワークフロー読み込み

`/root-project/ai-dev-framework/guide/workflow.md` を Read し、フロー手順を把握する。

### 2. 進捗確認

`/root-project/dev-journal/progress-management/progress.md` を Read する。

### 3. 前回セッションの引き継ぎ確認

`/root-project/dev-journal/progress-management/session-log.md` を Read する。

ファイルが存在しない場合は「引き継ぎなし（初回セッション）」として続行する。

### 4. ブロッカー issue 確認

`/root-project/dev-journal/issues/open/` のファイルを Glob で確認する。

- ファイルが存在する場合: ファイル名を一覧表示し、ブロッカー issue として報告する
- ファイルが存在しない場合: 「未対応 issue なし」と報告する

### 5. 未解決レビュー指摘の確認

`/root-project/dev-journal/review-findings/open/` のファイルを Glob で確認する。

- ファイルが存在する場合: ファイル名を一覧表示し、未解決の codex 指摘として報告する
- ファイルが存在しない場合: 「未解決指摘なし」と報告する

### 6. セッションゴール提案

上記で読み込んだ情報を元に、以下の優先順位でセッションのゴールをユーザーに提案する。

1. 未解決の review-findings があれば `/review-findings` 対応を優先提案
2. ブロッカー issue があれば `/issue 対応` を優先提案
3. progress.md の次タスクを提案（依存先が全て完了していることを確認してから）
4. session-log.md の「次にやること」と整合させる

提案時は「今日のゴール候補: ～」と明示し、ユーザーの合意を得てから作業に入ること。

### 7. 作業計画策定

ゴール合意後、対象チケットごとに workflow.md のフローに沿った作業計画を作成し、ユーザーに提示する。セッション中の進捗管理に使い、各ステップ完了時にチェックを入れる。
