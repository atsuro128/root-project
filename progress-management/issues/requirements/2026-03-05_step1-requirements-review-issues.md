# Issue: Step1要件定義レビューでの仕様不整合（RBAC中心）

- 発生日: 2026-03-05
- カテゴリ: requirements
- ステータス: 未解決
- 影響度: 高

## 概要
Step1要件定義成果物（8ファイル）レビューの結果、RBAC・操作権限・状態遷移の接続に複数の矛盾が確認された。  
この状態では Step2 以降の設計判断（ドメイン責務/API責務/テスト仕様）に分岐が生じる。

## 主な不整合
1. レポート作成可能ロールが文書間で不一致（Memberのみ / Member+Admin / Member+Admin+Approver）
2. Adminの編集可否が不一致（不可 / 可）
3. 「作成可能ロール」と「提出可能ロール（Member限定）」の接続が未定義
4. 提出取消の記述が「判断中」と「決定済み（対象外）」で混在

## 参照
- `review-findings/2026-03-05_step1-requirements-review.md`

## 対応案
1. `deliverables/docs/10_requirements/rbac.md` を認可仕様の正本に固定
2. `requirements.md / usecases.md / workflow.md / preliminary/04_business-rules.md` を正本に同期
3. 同期後に `progress-management/resolved/` へ移動（解決日・解決内容を追記）
