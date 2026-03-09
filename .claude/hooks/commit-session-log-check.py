"""PreToolUse hook: git commit 前にセッションログの存在を確認"""
import sys
import io
import json
import os
from datetime import datetime

# Windows環境でstderrのUTF-8出力を保証
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding="utf-8")

try:
    data = json.load(sys.stdin)
    command = data.get("tool_input", {}).get("command", "")

    if "git commit" not in command:
        sys.exit(0)

    today = datetime.now().strftime("%Y-%m-%d")
    project_dir = os.environ.get("CLAUDE_PROJECT_DIR", os.getcwd())
    session_log = os.path.join(
        project_dir, "dev-journal", "logs", today, "session-log.md"
    )

    if not os.path.exists(session_log):
        print(
            f"セッションログが未記録です。コミット前に dev-journal/logs/{today}/session-log.md を作成してください。（rules/session-log.md 参照）",
            file=sys.stderr,
        )
        sys.exit(2)
except Exception:
    pass

sys.exit(0)
