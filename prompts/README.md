# prompts/ — 指示文テンプレート

`.claude/commands/` に昇格する前の下書きを管理するフォルダ。

## .claude/commands/ との違い

| フォルダ | 用途 | 呼び出し方 |
|---|---|---|
| `.claude/commands/` | Claude Code のスラッシュコマンド（`/review`, `/status` 等） | `/コマンド名` で自動実行 |
| `prompts/` | 下書き・検討中のテンプレート | 手動コピー＆ペースト |

よく使うプロンプトが定まったら `.claude/commands/` に昇格させる。

## 昇格済み

- `requirement.md` → `/requirement`
- `implementation.md` → 実装フェーズ（Step 7）で `/implementation` として作成予定
- `refactor.md` → 実装フェーズ（Step 7）で `/refactor` として作成予定

## カテゴリ（将来用）

ファイルが増えた場合、以下のカテゴリでサブフォルダを作成する：

- `architecture/` — 設計レビュー観点、ADR作成等
- `backend/` — バックエンド実装関連
- `frontend/` — フロントエンド実装関連
- `db/` — データベース関連
- `security/` — セキュリティ関連
- `release/` — リリース関連
