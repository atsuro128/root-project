# Step 0 査読時の気づき・改善事項

## 1. project/ のディレクトリ構成と技術スタックの不整合 ✅ 解決済み

- **解決日**: 2026-03-04
- **解決内容**: `references/project-structure.md` を Rust + React 構成に合わせて修正。`apps/api/package.json` → `Cargo.toml` に置換、`packages/db/` を削除、`packages/` をフロントエンド専用として整理。構成の判断根拠も追記。

### 問題
`project/apps/api/` に `package.json` が存在するが、バックエンドは Rust (Actix Web) であり `Cargo.toml` であるべき。現在の `package.json` はスタブだが、Phase 1 のプロジェクト初期化時にこの構造を正しく作り直す必要がある。

また、`project/packages/` 配下に `ui/`, `config/`, `types/`, `db/` があるが、これは Node.js モノレポの構成パターン。Rust バックエンド + React フロントエンドの構成では以下の整理が必要:
- `packages/ui/` → `apps/web/` 内の共有コンポーネントとして管理するか、shadcn/ui のコピー先として使うか
- `packages/types/` → TypeScript の型定義。バックエンドが Rust なのでフロント専用
- `packages/db/` → Rust 側は SQLx で `database/migrations/` を参照。このパッケージの役割が不明確
- `packages/config/` → 共有設定。ESLint/TSConfig 等の共通設定用か

### 提案
Phase 1 着手前に `project/` のディレクトリ構成を再確認し、Rust + React 構成に適した形に修正する。具体的には:
- `apps/api/` を Cargo プロジェクトとして初期化（`package.json` → `Cargo.toml`）
- `packages/` の必要性を再検討（Rust/TS 混在モノレポで npm workspaces をどこまで使うか）

## 2. references/directory-structure.md の内容が古い

### 問題
`references/directory-structure.md` は `project/backend/`, `project/frontend/`, `project/migrations/` という構成を記載しているが、実際の構成は `project/apps/api/`, `project/apps/web/`, `project/database/` になっている。

### 提案
`project-structure.md` の内容に合わせて更新する。ただし `project-structure.md` 自体もこの2つが重複しているので、一方に統合して片方は参照にすることも検討。

## 3. ADR テンプレートが空

### 問題
`templates/ADR-template.md` がヘッダーのみで、テンプレート本文がない。Step 3（アーキテクチャ設計）で ADR を本格的に書く前に、雛形を用意すべき。

### 提案
Step 1（要件定義）着手前に ADR テンプレートを整備する。標準的な構成:
- Title / Date / Status (Proposed/Accepted/Deprecated)
- Context（背景・課題）
- Decision（選択した方針）
- Consequences（影響・トレードオフ）

## 4. 却下後の再申請フローの詳細が未確定

### 問題
PROJECT_SUMMARY.md では「却下後の再申請: 新規レポートとして作成（元レポートへの参照を保持）」とあるが、DB スキーマ上の `expense_reports` テーブルに参照元レポートIDのカラムがない。

### 提案
Step 2（ドメイン設計）で以下を決める:
- `expense_reports` に `original_report_id` (nullable UUID FK) を追加するか
- または `rejection_reason` と合わせてコメント/参照を別テーブルで管理するか

## 5. rules/ の空ファイルが複数ある

### 現状
以下のファイルはヘッダーのみで本文なし:
- `rules/branching.md`
- `rules/review-checklist.md`
- `rules/security-policy.md`
- `rules/data-handling.md`

### 提案
portfolio_project_steps.md の各ステップの【root-project整備】に従い、対応するステップで肉付けする。
- `branching.md` → Step 7 Phase 1 着手前
- `review-checklist.md` → Step 6
- `security-policy.md` → Step 1
- `data-handling.md` → Step 5

現時点で無理に書く必要はないが、空ファイルの存在は「いつ肉付けするか」が管理されていることが前提。

## 6. prompts/ と skills/ の役割重複の懸念

### 問題
`project-structure.md` にも記載があるが、`prompts/` と `skills/` の境界が曖昧。両方とも「繰り返し使う指示文」を扱う可能性がある。

### 提案
以下の整理案:
- `skills/` → Claude Code の Skill 機能（`/review`, `/status` 等）として実際に呼び出すもの
- `prompts/` → 手動でコピー&ペーストする指示文テンプレート、または skills に昇格する前の下書き

運用しながら統合先を決める形で問題ないが、Step 1 以降で混乱しないよう方針を早めに決めると良い。

## 7. git リポジトリの分離について

### 現状
`project/` 配下に `.git/` があり、`root-project/` にはない。つまり `project/` のみが Git 管理対象で、`root-project/` の管理ファイル群はバージョン管理されていない。

### リスク
- `root-project/` の設定・ルール・仕様書が誤操作で消失する可能性がある
- 設計ドキュメントの変更履歴が追えない

### 提案
以下のいずれかを検討:
1. `root-project/` も別の private リポジトリで管理する
2. ローカルバックアップの仕組みを設ける
3. 重要なドキュメントは `deliverables/` → `project/docs/` へ転記する運用で公開リポジトリ側に残す（現在の想定通り）

現状の方針（project/ のみ公開）は合理的だが、root-project/ のバックアップは意識しておくべき。
