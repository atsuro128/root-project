---
name: adr
description: "ADR 作成。Use when: 「ADR書いて」「意思決定を残して」"
argument-hint: "[判断の概要]"
---

ADR を作成してください。

対象: $ARGUMENTS

## フォルダ構成

```
dev-journal/references/decisions/
├── ADR-NNN-kebab-case.md
```

## 手順

1. **採番**: `dev-journal/references/decisions/` 内の既存 ADR から最大番号を取得し、+1 する
2. **情報収集**: 以下から判断の背景を収集する
   - ユーザーの説明（$ARGUMENTS）
   - 直近のセッションログ（`dev-journal/progress-management/session-log.md`）
   - 関連する issue や review-findings
3. **下書き作成**: テンプレート `ai-dev-framework/templates/ADR-template.md` に従い下書きを作成
4. **ユーザー確認**: 下書きをユーザーに提示し、内容を確認してもらう
5. **保存**: 承認後 `dev-journal/references/decisions/ADR-NNN-kebab-case.md` として保存

## 記載ルール

- ステータスは初回作成時 `承認済` とする（ユーザー確認後に保存するため）
- 日付は作成日を記入する
- 背景は問題が複数ある場合、サブセクションに分けて具体的に記述する
- 検討した選択肢が1つしかない場合でも「他に検討しなかった理由」を明記する
- 用語は `dev-journal/deliverables/docs/01_glossary.md` に準拠する
