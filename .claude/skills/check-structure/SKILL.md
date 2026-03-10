---
name: check-structure
description: |
  ディレクトリ構成ドキュメントと実際のファイル構成を比較し差分を報告する。
  Use when: ユーザーが「構成チェックして」「ディレクトリ確認して」「ファイル構成の差分を見て」と依頼した時
  DO NOT use when: 単にファイルを探している時、実装作業中
context: fork
agent: Explore
allowed-tools: Read, Grep, Glob, Bash(ls *)
---

`dev-journal/references/directory-structures/` 内の各ディレクトリ構成ファイルと、実際のファイル構成を比較し、差分を報告してください。

## 手順

1. `dev-journal/references/directory-structures/` 内の全ファイルを読み込み、各リポジトリのツリーに記載されたファイル・ディレクトリの一覧を把握する
2. 実際のファイルシステムを Glob で走査し、各リポジトリの実ファイルを取得する
   - 対象: `root-project/`（`.claude/` 含む）, `ai-dev-framework/`, `expense-saas/`, `dev-journal/`
3. 以下の2種類の差分を洗い出す:
   - **ドキュメントに未記載**: 実際に存在するがツリーに載っていないファイル・ディレクトリ
   - **実在しない**: ツリーに記載があるが実際には存在しないファイル・ディレクトリ
4. 差分をリポジトリ別の表形式でユーザーに報告する

## 注意

- 空ディレクトリは Glob では検出できないため、`ls` で存在確認すること
- `YYYY-MM-DD` のようなプレースホルダは実ファイル名と一致しなくても差分としない
- `.gitignore` で除外されているファイル・ディレクトリは差分として報告しない
