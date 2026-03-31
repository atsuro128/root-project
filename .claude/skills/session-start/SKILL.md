---
name: session-start
description: |
  セッション開始時に必要な情報を全て読み込み、ワークフロー手順を復習してから作業に入る。
  Use when: セッションの最初のアクションとして必ず実行する。ユーザーが「次の作業は？」「どこまで進んだ？」「続きをやろう」と言った時も同様。
  DO NOT use when: セッション途中での呼び出し（セッション開始時の1回のみ実行）
---

セッション開始時の読み込み手順を実行してください。

## 目的

以下の違反を防止するため、作業着手前に全ての情報を読み込む。

- workflow.md を読まずに作業開始し、フロー手順を飛ばす（例: codex レビュー前マージ）
- 上流 issue の判断を見落としてサブエージェントに渡す
- progress.md を確認せず、依存先が未完了のタスクに着手する

## 実行手順

### 1. ワークフロー読み込み

`/root-project/ai-dev-framework/guide/workflow.md` を Read する。

読み込み後、以下の PR フロー手順を復習として自分に確認する（チェックリスト形式で内部確認）:

```
PR フロー（expense-saas/ 編集時）:
  0. チケット起票 → progress.md 更新
  1. ブランチ作成 + 実装
  2. PR 作成
  3. 内部レビュー（reviewer エージェント）— PASS まで繰り返す
  4. codex レビュー（/codex-review）— PASS まで繰り返す  ← マージはここより後
  5. スカッシュマージ

設計成果物フロー（dev-journal/ 編集時）:
  0. チケット起票 → progress.md 更新
  1. 成果物作成
  2. 内部レビュー（reviewer エージェント）— PASS まで繰り返す
  3. コミット
  4. codex レビュー（/codex-review）
  5. codex 指摘対応（/review-findings）

絶対禁止:
  - codex レビュー前のマージ
  - reviewer 以外（指揮役の差分確認）での PASS 判定
  - ユーザー承認なしのコミット・マージ
```

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

### 6. メモリ読み込み

`/root-project/.claude/memory/MEMORY.md` を Read し、インデックスに記載された全メモリファイルを Read する。

### 7. セッションゴール提案

上記で読み込んだ情報を元に、以下の優先順位でセッションのゴールをユーザーに提案する。

1. 未解決の review-findings があれば `/review-findings` 対応を優先提案
2. ブロッカー issue があれば `/issue 対応` を優先提案
3. progress.md の次タスクを提案（依存先が全て完了していることを確認してから）
4. session-log.md の「次にやること」と整合させる

提案時は「今日のゴール候補: ～」と明示し、ユーザーの合意を得てから作業に入ること。

### 8. 指揮役の作業計画策定

ゴール合意後、対象チケットごとにフロー全ステップを書き下した作業計画を作成し、ユーザーに提示する。

例:
```
## 作業計画

### チケット A
- [ ] 1. architect → 計画策定（入力: チケット + 上流 issue）
- [ ] 2. 実装エージェント → ブランチ作成 + 実装
- [ ] 3. push → PR 作成
- [ ] 4. reviewer → 内部レビュー（PR 番号指定）
- [ ] 5. codex → レビュー（/codex-review）
- [ ] 6. 指摘対応 → 再レビュー（あれば）
- [ ] 7. ユーザー承認 → マージ

### チケット B
- [ ] 1. architect → 計画策定
  ...
```

この計画をセッション中の進捗管理に使い、各ステップ完了時にチェックを入れる。
「今どのステップにいるか」を見失わないための指揮役自身の計画書である。
