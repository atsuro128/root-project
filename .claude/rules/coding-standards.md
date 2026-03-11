---
paths:
  - "expense-saas/**/*.go"
  - "expense-saas/**/*.{ts,tsx}"
---

# コーディング規約

## Go
- フォーマット: `gofmt` 準拠を維持（CI で確認）
- `go vet` 警告ゼロを維持
- `golangci-lint run` エラーゼロを維持
- `panic()` 禁止（テストコード除く）— エラーは `error` 型で返す
- 命名: Go 標準規約（exported: PascalCase, unexported: camelCase）
- エラーは構造化 JSON で返す（`code`, `message`, `details`）

## TypeScript
- 命名: camelCase
- strict mode 必須
- `any` / `as any` 禁止
