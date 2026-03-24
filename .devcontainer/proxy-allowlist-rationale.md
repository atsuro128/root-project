# Proxy Allowlist Rationale

最終更新: 2026-03-24

## 目的

`proxy-allowlist.txt` は Squid / firewall が参照する実行用ファイルとし、この文書は各ドメインの許可理由を監査可能な形で残す。
プロンプトインジェクション対策として、許可先は最小限に絞り、用途不明のドメインは原則追加しない。

## 運用ルール

- ドメインを追加・削除する場合は `proxy-allowlist.txt` と本書を同時に更新する
- 用途・利用ツール・削除条件が説明できないドメインは allowlist に追加しない
- 定期的に「今も必要か」を見直し、不要なドメインは削除する
- 必要性が不明なドメインは issue を起票してから判断する

## 記録項目

| 項目 | 意味 |
|------|------|
| ドメイン | allowlist に記載するホスト名 |
| 用途 | 何の通信に使うか |
| 利用ツール | どのツール・コマンドが利用するか |
| 許可理由 | なぜ許可が必要か |
| 削除条件 | どの条件なら削除できるか |
| 状態 | `必須` / `要確認` / `削除候補` |

## 許可ドメイン一覧

| ドメイン | 用途 | 利用ツール | 許可理由 | 削除条件 | 状態 |
|---------|------|-----------|----------|----------|------|
| `registry.npmjs.org` | npm パッケージ取得 | `npm`, `pnpm` | Node 依存解決に必要 | Node パッケージ管理を使わない場合 | 必須 |
| `api.anthropic.com` | Anthropic API | Claude Code 関連ツール | Claude 系 API 呼び出しに必要 | Anthropic を使わない運用に切り替えた場合 | 必須 |
| `platform.claude.com` | Claude 関連認証・サービス到達 | Claude Code 関連ツール | Claude 関連の利用・認証導線で必要な可能性が高い | Claude 利用をやめる、または不要と確認できた場合 | 要確認 |
| `sentry.io` | エラー収集・テレメトリ | Claude / VS Code / 拡張機能の可能性 | 現時点で明確な必須用途を確認できていない | 不要と確認できた場合 | 要確認 |
| `statsig.anthropic.com` | Feature flag / telemetry の可能性 | Claude 関連ツールの可能性 | 現時点で明確な必須用途を確認できていない | 不要と確認できた場合 | 要確認 |
| `statsig.com` | Feature flag / telemetry の可能性 | Claude 関連ツールの可能性 | 現時点で明確な必須用途を確認できていない | 不要と確認できた場合 | 要確認 |
| `marketplace.visualstudio.com` | VS Code 拡張取得 | VS Code / DevContainer | 拡張機能のインストール・更新に必要 | 拡張の追加更新をコンテナ内で行わない場合 | 要確認 |
| `vscode.blob.core.windows.net` | VS Code 配布物取得 | VS Code / DevContainer | VS Code 拡張や関連配布物の取得先として使われる | 不要と確認できた場合 | 要確認 |
| `update.code.visualstudio.com` | VS Code 更新確認 | VS Code | VS Code 更新確認に使われる可能性がある | 更新確認を不要とする場合 | 削除候補 |
| `github.com` | Git リモート / PR | `git`, `gh` | ソース管理・PR 運用に必要 | GitHub を使わない場合 | 必須 |
| `api.github.com` | GitHub API | `gh`, 一部 `git` | PR・認証・API 操作に必要 | GitHub API を使わない場合 | 必須 |
| `raw.githubusercontent.com` | 生ファイル取得 | `curl`, 一部ツール | GitHub 上の raw ファイル取得に使う | raw 取得を使わない場合 | 要確認 |
| `objects.githubusercontent.com` | GitHub オブジェクト配信 | `git`, `gh` | GitHub 配下のオブジェクト取得で必要になる | GitHub 利用をやめる場合 | 必須 |
| `githubusercontent.com` | GitHub 配下コンテンツ配信 | `gh`, ブラウザ, 一部ダウンロード | 広すぎるため用途を絞れていない | `objects` / `raw` 等で代替できると確認した場合 | 削除候補 |
| `codeload.github.com` | GitHub アーカイブ取得 | `gh`, zip/tarball 取得 | リポジトリのアーカイブ取得で使われる | アーカイブ取得を使わない場合 | 要確認 |
| `uploads.github.com` | GitHub アップロード API | `gh` | Release asset や一部 API で必要になる可能性がある | その用途を使わないと確認した場合 | 要確認 |
| `github-releases.githubusercontent.com` | GitHub release 配布 | `gh`, 各種 CLI | GitHub release バイナリ取得で使われる | release 配布物を取得しない場合 | 要確認 |
| `proxy.golang.org` | Go module proxy | `go` | Go 依存解決に必要 | Go module を使わない場合 | 必須 |
| `sum.golang.org` | Go checksum database | `go` | Go module 検証に必要 | Go の checksum 検証を使わない場合 | 必須 |
| `storage.googleapis.com` | Go / VS Code / 配布物取得 | `go`, VS Code, 各種 CLI の可能性 | 現時点で用途が広く、どの取得に必要か未整理 | 具体用途を特定して不要なら削除 | 要確認 |
| `pypi.org` | Python パッケージ取得 | `pip` | Python 依存解決に必要 | Python パッケージ管理を使わない場合 | 必須 |
| `files.pythonhosted.org` | PyPI 配布ファイル取得 | `pip` | Python パッケージ本体のダウンロードに必要 | Python パッケージ管理を使わない場合 | 必須 |
| `chatgpt.com` | OpenAI 関連認証・サービス到達 | OpenAI 関連ツール | OpenAI 関連の利用・認証導線で必要な可能性がある | 不要と確認できた場合 | 要確認 |
| `api.openai.com` | OpenAI API | Codex / OpenAI API 利用 | モデル推論 API 呼び出しに必要 | OpenAI を使わない運用に切り替えた場合 | 必須 |
| `auth.openai.com` | OpenAI 認証 | Codex / OpenAI 関連ツール | 認証系フローに必要 | 認証方式が変わる、または不要と確認できた場合 | 必須 |

## 次回見直し候補

- `sentry.io`
- `statsig.anthropic.com`
- `statsig.com`
- `update.code.visualstudio.com`
- `githubusercontent.com`
- `storage.googleapis.com`
- `chatgpt.com`
- `platform.claude.com`

上記は現時点で「完全に不要」とは断定できないが、許可理由の具体性が弱いため優先的に見直す。
