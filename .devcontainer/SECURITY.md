# DevContainer Security Notes

最終更新: 2026-03-16

## 現在の設計

この DevContainer の通信モデルは、次の 2 点を中心に構成する。

1. コンテナ内ツールは `HTTP_PROXY` / `HTTPS_PROXY` / `ALL_PROXY` で `127.0.0.1:3127` のローカル Squid を使う
2. firewall は default-deny とし、Squid プロセス以外の外向き `tcp/80` と `tcp/443` を拒否する

これにより、proxy を使わない直接外向き通信は fail-closed で失敗する。

## 意図的にやめたこと

- transparent interception
- `ssl_bump`
- 証明書生成と Squid cert DB 初期化
- すべての host gateway 通信の包括許可

理由は、実運用上の安全性を落とさずに説明容易性と監査容易性を上げるため。

## host gateway の扱い

host gateway からの inbound は、`HOST_GATEWAY_TCP_PORTS` で明示したポートだけ許可する。

既定値:

- `3000`
- `5432`
- `8080`

新しいポートを host から使う必要がある場合だけ、この環境変数を更新する。

## 残余リスク

- allowlist に入っている宛先にはデータ送信できる
- DNS は許可しているため、問い合わせ先ホスト名のメタデータは見える
- proxy 非対応ツールは fail-closed で失敗する可能性がある
- `/home/node/.codex` と `/home/node/.claude` は named volume に残るため、古い認証情報の破棄は運用で行う必要がある

## 運用メモ

- 変更後は `postStartCommand` で `init-firewall.sh` が成功すること
- `verify-egress.sh` で `auth.openai.com` と `api.openai.com` が proxy 経由で到達できること
- proxy を使わない `https://api.openai.com` への直接通信が失敗すること
- `example.com` が proxy 経由でも拒否されること

## volume の扱い

認証情報をリセットしたい場合は、対象 DevContainer の named volume を削除して再作成する。

対象例:

- `codex-config-*`
- `claude-code-config-*`

削除前に、現在利用中の container / volume を確認してから操作すること。
