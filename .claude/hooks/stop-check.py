"""Stop hook: 未コミットの変更がある場合に警告を表示（ブロックはしない）"""
import sys
import json
import os
import subprocess
from datetime import datetime

try:
    data = json.load(sys.stdin)

    # 各リポジトリの未コミット変更を確認
    project_dir = os.environ.get("CLAUDE_PROJECT_DIR", os.getcwd())
    uncommitted = []

    for sub in [".", "expense-saas", "ai-dev-framework", "dev-journal"]:
        repo = os.path.join(project_dir, sub) if sub != "." else project_dir
        git_dir = os.path.join(repo, ".git")
        if not os.path.exists(git_dir):
            continue
        result = subprocess.run(
            ["git", "status", "--porcelain"],
            capture_output=True, text=True, cwd=repo,
        )
        if result.stdout.strip():
            name = os.path.basename(repo) if sub != "." else "root-project"
            uncommitted.append(name)

    if uncommitted:
        repos = ", ".join(uncommitted)
        msg = f"⚠ 未コミットの変更があります（{repos}）。コミット・progress.md更新を確認してください。"
        print(msg, file=sys.stderr)

        # ログファイルに記録
        log_dir = os.path.join(project_dir, "dev-journal", "logs", "hooks")
        os.makedirs(log_dir, exist_ok=True)
        log_file = os.path.join(log_dir, "hook-warnings.log")
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        with open(log_file, "a", encoding="utf-8") as f:
            f.write(f"[{timestamp}] stop-check: 未コミット変更あり（{repos}）\n")
except Exception:
    pass

sys.exit(0)
