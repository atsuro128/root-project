---
name: status
description: |
  プロジェクトの現在の状況を確認して報告する。
  Use when: ユーザーが「今どうなってる？」「状況教えて」「進捗は？」など現在の状態を聞いた時
  DO NOT use when: 特定のファイルの中身を聞かれた時、実装作業中
---

プロジェクトの現在の状況を確認して報告してください。

## 事前取得データ

### 作業ツリー状態（root-project）
!`git status --short 2>&1`

### 直近コミット（root-project）
!`git log --oneline -10 2>&1`

### 作業ツリー状態（expense-saas）
!`cd expense-saas && git status --short 2>&1 || echo "リポジトリなし"`

### 直近コミット（expense-saas）
!`cd expense-saas && git log --oneline -5 2>&1 || echo "リポジトリなし"`

## 手順

1. 上記の事前取得データを分析する
2. 未解決の課題（TODO, FIXME, HACK コメント）をソースコード内から検索
3. 上記の結果を簡潔にまとめて報告
