# コーディング規約

## Rust
- 命名: snake_case
- clippy 警告ゼロを維持
- `unwrap()` 禁止（テストコード除く）
- エラーは構造化 JSON で返す（`code`, `message`, `details`）

## TypeScript
- 命名: camelCase
- strict mode 必須
- `any` / `as any` 禁止
