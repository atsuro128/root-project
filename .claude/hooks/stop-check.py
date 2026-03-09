"""Stop hook: 未コミットの変更がある場合にブロック（3回連続発火でループ回避）"""
import sys
import io
import json
import os
import subprocess
import tempfile
from datetime import datetime

# Windows環境でstderrのUTF-8出力を保証
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding="utf-8")

try:
    data = json.load(sys.stdin)

    project_dir = os.environ.get("CLAUDE_PROJECT_DIR", os.getcwd())
    log_dir = os.path.join(project_dir, "dev-journal", "logs", "hooks")
    os.makedirs(log_dir, exist_ok=True)
    counter_file = os.path.join(tempfile.gettempdir(), ".claude-stop-check-counter")
    log_file = os.path.join(log_dir, "hook-warnings.log")

    # 各リポジトリの未コミット変更を確認
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

    if not uncommitted:
        # 未コミット変更なし → カウンターリセット
        if os.path.exists(counter_file):
            os.remove(counter_file)
        sys.exit(0)

    # カウンター読み込み・インクリメント
    count = 0
    if os.path.exists(counter_file):
        with open(counter_file, "r") as f:
            try:
                count = int(f.read().strip())
            except ValueError:
                count = 0
    count += 1

    with open(counter_file, "w") as f:
        f.write(str(count))

    repos = ", ".join(uncommitted)
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    if count >= 3:
        # 3回連続 → ループ回避のため警告のみで通過、カウンターリセット
        os.remove(counter_file)
        msg = f"⚠ 未コミット変更あり（{repos}）。3回連続のためブロックをスキップします。"
        print(msg, file=sys.stderr)
        with open(log_file, "a", encoding="utf-8") as f:
            f.write(f"[{timestamp}] stop-check: ループ回避スキップ（{repos}）\n")
        sys.exit(0)
    else:
        # ブロック
        msg = f"未コミットの変更があります（{repos}）。ai-dev-framework/rules/commit-message.md を参照し、手順に従ってコミットしてください。（{count}/3回目）"
        print(msg, file=sys.stderr)
        sys.exit(2)

except Exception:
    pass

sys.exit(0)