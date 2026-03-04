# GitHub 運用ルール（Claude向け）

## Issue作成

```bash
gh issue create \
  --title "feat: ○○機能の実装" \
  --body "## 概要\n\n## 実装内容\n\n## 完了条件" \
  --label "feat,area: backend,priority: medium" \
  --repo atsuro128/expense-saas
```

### タイトル形式
`<type>: <内容>` — typeはConventional Commitsと同じ (feat / bug / chore / refactor / test)

### 必須ラベル
- typeラベル（feat / bug / chore / refactor / test）いずれか1つ
- areaラベル（backend / frontend / db / infra / auth）いずれか1つ
- priorityラベル（high / medium / low）いずれか1つ

## ブランチ命名

```
<type>/issue-<番号>-<概要>
例: feat/issue-12-jwt-auth
    bug/issue-34-tenant-id-leak
```

## PR作成とIssueリンク

```bash
gh pr create \
  --title "feat: ○○機能の実装" \
  --body "## 変更内容\n\n## テスト\n\nCloses #<Issue番号>" \
  --repo atsuro128/expense-saas
```

- `Closes #番号` をPR本文に含めるとマージ時にIssueが自動クローズされる

## ProjectsボードへのIssue追加

Issue作成後に自動追加されない場合:
```bash
gh project item-add 1 --owner atsuro128 --url <issue-url>
```

## gh コマンドのPATH

```bash
export PATH="$PATH:/c/Program Files/GitHub CLI"
```

セッションごとに必要。`~/.bashrc` に記載済み。
