作業中に発見した課題・改善提案を issue として起票してください。

入力: $ARGUMENTS
（例: "/issue RBAC の権限マトリクスが未定義" や "/issue security テナント分離テストの方針が不明"）

## 手順

### 1. 既存 issue の確認
- progress-management/issues/ 配下の全 issue を確認し、重複がないか検証する
- 類似の issue がある場合は、既存 issue への追記を提案する

### 2. issue 番号の採番
- progress-management/issues/ と progress-management/resolved/ 配下の全ファイルから最大の番号を取得し、+1 する

### 3. カテゴリの判定
入力内容から適切なカテゴリを判定する（迷う場合はユーザーに確認）：
- requirements — 要件の不明点・矛盾
- domain — ドメインモデル・ビジネスルールの課題
- architecture — アーキテクチャ・技術選定の課題
- ui-design — 画面設計・UXの課題
- detail-design — API・DB・詳細設計の課題
- testing — テスト方針・テストケースの課題
- implementation — 実装上の課題・バグ
- security — セキュリティの課題
- infrastructure — インフラ・CI/CDの課題
- project-management — プロジェクト管理・プロセスの課題

### 4. issue ファイルの作成
以下のテンプレートで progress-management/issues/{カテゴリ}/{番号}-{slug}.md を作成する：

```markdown
# {タイトル}

## 発見日
{今日の日付}

## 関連ステップ
{該当するステップ番号、または「各ステップで段階的に対処」}

## カテゴリ
{カテゴリ名}

## 問題
{問題の具体的な説明}

## 影響
{この問題を放置した場合のリスク・影響}

## 提案
{解決策の提案。ステップとの紐付けがあれば記載}

## 解決内容


## 解決日

```

### 5. 報告
作成した issue のパスと概要を報告する。
