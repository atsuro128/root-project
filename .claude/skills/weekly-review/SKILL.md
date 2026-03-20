---
name: weekly-review
description: |
  指定期間の日報・セッションログ・Git履歴を読み込み、総評を作成する。
  Use when: ユーザーが「総評書いて」「週次レビューして」「振り返りして」と依頼した時
  DO NOT use when: 変遷分析（/analyze を使う）、日報作成（/daily-report を使う）
argument-hint: "[期間: M/D~M/D | 直近N日]"
allowed-tools: Read, Write, Grep, Glob, Bash(git *), Bash(date *), Agent
---

指定期間の総評を作成してください。

## 現在の日時

!`date "+%Y-%m-%d %H:%M"`

## 引数

$ARGUMENTS

（引数がない場合は期間をユーザーに確認すること）

## 固定パラメータ

- **出力フォーマット**: 総評（下記の構成に従う）
- **想定読者**: 自分用
- **出力先**: `private-materials/review-YYYY-MM-DD-to-DD.md`
- **言語**: 日本語

## 手順

### Phase 1: 期間確定

引数から開始日・終了日を特定する。相対表現（「直近1週間」「先週」等）は絶対日付に変換する。

### Phase 2: ソース収集

以下のソースを **Agent ツールで並列に** 収集する。日数が4日以上の場合はセッションログと日報を別エージェントに分ける。

| ソース | パス | 用途 |
|--------|------|------|
| 引き継ぎメモ | `dev-journal/progress-management/handoff.md`, `handoff-archive.md` | セッション単位の作業ログ・判断・学び |
| 日報 | `dev-journal/daily-reports/YYYY-MM-DD.md` | 日ごとの成果サマリー |
| ADR | `dev-journal/references/decisions/ADR-*.md` | 期間内に作成・変更されたもの |
| 進捗管理 | `dev-journal/progress-management/progress.md` | Step 進行状況 |
| Git 履歴 | `git log --since=START --until=END+1 --oneline --format="%h %ad %s" --date=short` | コミット単位の変更履歴 |

### Phase 3: 分析

以下の観点で情報を整理する:

1. **プロダクト進捗**: Step の進行状況、expense-saas へのコード追加有無、ブロッカー
2. **基盤・ツーリング整備**: 何にどれだけ時間を使ったか、各項目への所感
3. **意思決定の質**: 良かった判断、場当たり的だった判断、見落とし
4. **繰り返しパターン**: 期間を通じて見えた傾向や癖（ポジティブ・ネガティブ両方）
5. **数値**: セッション数、コミット数、プロダクトコード行数、Issue 数、Revert 数など

### Phase 4: 執筆

以下の構成で `private-materials/review-YYYY-MM-DD-to-DD.md` に書き出す。

```markdown
# 総評: YYYY-MM-DD 〜 YYYY-MM-DD

## 概要
（3行以内で期間全体を要約）

---

## 1. プロダクト進捗
（Step の進行、expense-saas のコード量、ブロッカー。表形式を活用）

## 2. 基盤・ツーリング整備
（分野ごとに小見出しをつけ、事実 + 所感。時間の使い方を率直に評価）

## 3. 意思決定の質
（良かった点 / 気になった点に分けて箇条書き）

## 4. 気になるパターン
（パターン名 + 具体例 + 示唆。2〜4個程度）

## 5. 数値サマリー
（表形式で主要指標を列挙）

## 6. 次週への示唆
（3〜5項目。具体的なアクションを含む）
```

執筆上のルール:
- 事実ベースで書く。推測には「〜かもしれない」「要確認」を付ける
- 良い点と懸念を両方書く。懸念は具体的な改善案とセットにする
- 「明日以降のタスク」が複数日にわたり繰り越されていたら、その事実を明記する

### Phase 5: 検証

- 日付・コミットハッシュ・Issue 番号がソースと一致することを確認する
- 作成した資料をユーザーに提示し、修正点を確認する
