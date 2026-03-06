`references/directory-structure.md` に記載されたディレクトリツリーと、実際のファイル構成を比較し、差分を報告してください。

## 手順

1. `references/directory-structure.md` を読み込み、ツリーに記載されたファイル・ディレクトリの一覧を把握する
2. 実際のファイルシステムを Glob で走査し、root-project/ 直下の各ディレクトリの実ファイルを取得する
   - 対象: `.claude/`, `guide/`, `progress-management/`, `rules/`, `prompts/`, `templates/`, `references/`, `scripts/`, `deliverables/`, `daily-reports/`, `logs/`
   - `project/` は対象外（別ドキュメントで管理）
3. 以下の2種類の差分を洗い出す:
   - **ドキュメントに未記載**: 実際に存在するがツリーに載っていないファイル・ディレクトリ
   - **実在しない**: ツリーに記載があるが実際には存在しないファイル・ディレクトリ
4. 差分を表形式でユーザーに報告する

## 注意

- 空ディレクトリは Glob では検出できないため、`ls` で存在確認すること
- `YYYY-MM-DD` のようなプレースホルダは実ファイル名と一致しなくても差分としない
- `project/` 配下は `references/project-structure.md` の管轄なので対象外とする
