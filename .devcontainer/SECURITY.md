# DevContainer Security Notes

最終更新: 2026-04-16

## 現在の設計

この DevContainer の通信モデルは、次の 2 点を中心に構成する。

1. コンテナ内ツールは `HTTP_PROXY` / `HTTPS_PROXY` / `ALL_PROXY` で `127.0.0.1:3127` のローカル Squid を使う
2. firewall は default-deny とし、Squid プロセス以外の外向き `tcp/80` と `tcp/443` を拒否する

これにより、proxy を使わない直接外向き通信は fail-closed で失敗する。
また、追加 capability を避けるため Squid の ICMP pinger は無効化する。

## 意図的にやめたこと

- transparent interception
- `ssl_bump`
- 証明書生成と Squid cert DB 初期化
- すべての host gateway 通信の包括許可

理由は、実運用上の安全性を落とさずに説明容易性と監査容易性を上げるため。

## host gateway の扱い

### inbound（ホスト → コンテナ）

host gateway からの inbound は、`HOST_GATEWAY_TCP_PORTS` で明示したポートだけ許可する。

既定値:

- `3000`
- `8080`

新しいポートを host から使う必要がある場合だけ、この環境変数を更新する。

### outbound（コンテナ → ホスト）

コンテナから host gateway への outbound は、`HOST_GATEWAY_OUTBOUND_TCP_PORTS` で明示したポートだけ許可する。

既定値: なし（空）

現在の設定値:

- `5433`（テスト用 PostgreSQL）

用途はホスト側で起動した Docker サービス（DB 等）への接続。DB ポートは既定で開けず、ローカルテスト実行時に必要なポートだけ設定する。

注意: outbound 許可ポートは「host のそのポートに信頼できるサービスだけが待ち受ける」ことが前提。host 側で当該ポートに TCP proxy / SSH port-forward / socat 等を立てると、コンテナから外部宛通信の踏み台になり Squid allowlist を迂回できる。outbound ポートは用途を固定し、汎用 proxy / tunnel に使わないこと。

## Docker（DinD / DooD）を採用しない理由

ops-107 の検討で DinD / DooD を分析し、いずれも不採用とした。

- **DinD**: `--privileged` または SYS_ADMIN + seccomp=unconfined が必要。`no-new-privileges` と矛盾し、firewall の FORWARD DROP とも競合する。現行セキュリティ方針を根本的に破壊する
- **DooD**: docker.sock マウントはホスト Docker への実質 root 相当アクセスを付与する。issue 061（mount 最小化）と矛盾し、Squid proxy/allowlist もバイパスされる

代替として「ホスト側で Docker サービスを起動し、コンテナから host gateway 経由で接続する」方式を採用する。これにより devcontainer のセキュリティモデルを維持したまま、Backend integration テストの実行が可能になる。

## 残余リスク

- allowlist に入っている宛先にはデータ送信できる
- DNS は許可しているため、問い合わせ先ホスト名のメタデータは見える
- proxy 非対応ツールは fail-closed で失敗する可能性がある
- `/home/node/.codex` と `/home/node/.claude` は named volume に残るため、古い認証情報の破棄は運用で行う必要がある

## codex sandbox の制約

WSL2 カーネルが非特権 user namespace を許可していないため、codex のデフォルト sandbox（bubblewrap 依存）が動作しない。`codex exec --full-auto`（`workspace-write` sandbox）および `apply_patch` による書き込みも失敗する。

対応として `--sandbox danger-full-access` を使用する。公式 docs でこのオプションは「外部でサンドボックスされた環境（container / CI runner）」向けとされており、この DevContainer の egress firewall（default-deny + allowlist）がその前提に合致する。

## 運用メモ

- 変更後は起動時 bootstrap で `init-devcontainer.sh` / `init-firewall.sh` が成功すること
- `verify-egress.sh` で `auth.openai.com` と `api.openai.com` が proxy 経由で到達できること
- proxy を使わない `https://api.openai.com` への直接通信が失敗すること
- `example.com` が proxy 経由でも拒否されること
- 許可ドメインの理由は `proxy-allowlist-rationale.md` に記録し、`proxy-allowlist.txt` と同期すること

## volume の扱い

認証情報をリセットしたい場合は、対象 DevContainer の named volume を削除して再作成する。

対象例:

- `codex-config-*`
- `claude-code-config-*`

削除前に、現在利用中の container / volume を確認してから操作すること。
