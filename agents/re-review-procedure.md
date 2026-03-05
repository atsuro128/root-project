# 再レビュー手順

指摘対応後の再レビューを行う場合は、以下の手順に従う。

## Step 1: 再レビュー対象の確認

**`progress-management/pending-review/`** を確認し、再レビュー待ちの issue 一覧を把握する。

## Step 2: 対応内容の確認

各 issue に紐付く `review-findings/NNN-kebab-case.md` を参照し、対応内容を確認する。

## Step 3: レビュー結果の処理

レビュー結果に応じて issue を処理する（`rules/issue-management.md` のライフサイクルに従う）。

- **対応が妥当**: issue を `resolved/` へ移動し、`review-findings/NNN-kebab-case.md` を `review-findings/resolved/` へ移動する。
- **対応が不十分**: 追加指摘を issue に記載し、`pending-review/` から `issues/` へ差し戻す。

---

## `review-findings/` フォルダ運用ルール

```
review-findings/
├── NNN-kebab-case.md      # 対応中・レビュー待ちの指摘詳細
└── resolved/
    └── NNN-kebab-case.md  # 再レビュー完了済みの指摘詳細
```

- `review-findings/` 直下にあるファイル = 未クローズ（対応中 or レビュー待ち）
- `review-findings/resolved/` にあるファイル = 再レビュー完了・クローズ済み
