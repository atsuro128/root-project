---
name: commit
description: |
  コミット規約に従ってコミットを実行する。
  Use when: ユーザーが「コミットして」「変更まとめて」と依頼した時
  DO NOT use when: ユーザーの指示なしにコミットする場合（禁止）
argument-hint: "[コミットメッセージ（省略時は自動生成）]"
allowed-tools: Read, Write, Edit, Bash(git *), Bash(date *), Bash(pwd), Bash(mkdir *)
---

コミット規約に従ってコミットを実行してください。

コミットメッセージ指定: $ARGUMENTS

## Git リポジトリの対応

リポジトリは4つ存在する。変更ファイルに応じて正しいリポジトリでコミットすること。

| 変更内容 | コミット先 |
|---------|-----------|
| ソースコード関連 | `expense-saas/` |
| AI運用・ルール関連 | `ai-dev-framework/` |
| 進捗・日報・ログ関連 | `dev-journal/` |
| メタ設定 | `root-project/` |

**コミット対象のリポジトリディレクトリに移動してから git 操作を行うこと。**

## コミット手順（必ずこの順序で実行）

1. **セッションログ追記**: `/session-log` スキルの手順に従い、今回の作業内容を記録する
2. **git add**: 変更ファイルとセッションログをステージする
3. **ステージ確認**: `git diff --cached --name-only` で意図したファイルがすべて含まれていることを確認する
4. **git commit**: コミットを実行する
5. **コミット検証**: `git show --stat` でコミット内容を確認する

## メッセージ形式

- 言語: 日本語
- 形式: Conventional Commits（`feat:`, `fix:`, `chore:` 等）

## 必須フッター

全コミットの末尾に必ず付与する:
`Co-Authored-By: Claude <noreply@anthropic.com>`

## 注意事項

- ファイル作成・操作時は絶対パスを使うか、`pwd` で作業ディレクトリを確認してから実行すること
- `.env` ファイルのコミット禁止
- ユーザー指示なしの `git push` 禁止
