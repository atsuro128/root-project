---
name: test
description: |
  ローカルテストを実行する。
  Use when: ユーザーが「テストして」「lint 通して」と依頼した時、PR 作成前のローカル検証時
  DO NOT use when: CI ワークフロー（ci.yml）の修正時
argument-hint: "[frontend|backend|all] [テスト対象のファイルやコンポーネント名（省略時は全件）]"
---

ローカルテストを実行してください。

対象: $ARGUMENTS

## スコープ判定

引数から実行スコープを判定する。

| 引数 | スコープ |
|------|---------|
| `frontend` / `fe` | Frontend のみ |
| `backend` / `be` | Backend のみ |
| `all` / 引数なし | Frontend → Backend の順に両方 |
| ファイル名やコンポーネント名が含まれる場合 | 対象を絞り込む |

## 実行パスの決定

テスト対象のブランチが worktree 上にある場合は、そのパスを使用する。

| 状態 | ベースパス |
|------|----------|
| master 上のテスト | `/root-project/expense-saas` |
| worktree 上の PR テスト | `/root-project/expense-saas/.claude/worktrees/agent-XXXXX`（worktree のパス） |

以降の手順では `$BASE` をベースパスとする。

## Frontend テスト

devcontainer 内で完結する。ホスト側の操作は不要。

```bash
cd $BASE/frontend

# 1. lint
npm run lint

# 2. 型チェック
npx tsc --noEmit

# 3. テスト実行
npm test                           # 全件
# npm test -- AttachmentUploader   # ファイル指定時

# 4. ビルド検証（省略可）
npm run build
```

各ステップを順次実行し、失敗したらその時点で停止して結果を報告する。

### 対象を絞り込む場合

引数にコンポーネント名やファイル名が含まれる場合、テスト実行を絞り込む:
- `npm test -- {対象}` でフィルタ実行
- lint と型チェックは全体を対象に実行（部分実行は不正確なため）

## Backend テスト

Backend の integration テストはホスト側で PostgreSQL が起動している必要がある。

### 1. DB 接続確認

```bash
timeout 3 bash -c "echo > /dev/tcp/$(ip route show default | awk '{print $3; exit}')/5433" 2>&1
```

### 2. 接続できない場合

ユーザーに以下を指示する:

> ホスト側（WSL2 ターミナル）で以下を実行してください:
> ```
> cd <expense-saas のパス>
> docker compose up db-test -d
> ```
> 起動後、このチャットに戻ってきてください。

ユーザーの確認を待ってから再度接続確認を行う。

### 3. テスト実行

```bash
cd $BASE

# host gateway IP を取得
HOST_GW=$(ip route show default | awk '{print $3; exit}')

# 1. lint
golangci-lint run ./...

# 2. 単体テスト（DB 不要）
go test ./...

# 3. integration テスト（DB 必要）
TEST_DATABASE_URL="postgres://testuser:testpass@${HOST_GW}:5433/expense_test?sslmode=disable" \
  go test -tags integration ./...
```

### 対象を絞り込む場合

引数にパッケージ名やファイル名が含まれる場合:
- `go test ./internal/handler/...` のようにパッケージを指定
- lint は全体を対象に実行

## 結果報告

テスト完了後、以下の形式で結果をユーザーに報告する:

```
## Local CI 結果
- [x/fail] Frontend lint
- [x/fail] Frontend tsc
- [x/fail] Frontend test (XX件 PASS)
- [x/fail] Frontend build
- [x/fail] Backend lint
- [x/fail] Backend unit test
- [x/fail] Backend integration test (XX件 PASS)
```

失敗がある場合はエラー内容を添えて報告する。

## 実行方針

- `Bash` で直接実行する（サブエージェントに委譲しない）
- 長時間かかるステップは `run_in_background: true` + `timeout: 600000` で実行する
- 失敗時はエラー内容を分析し、修正提案を行う（自動修正はしない）
