"""PreToolUse hook: ソースコードが expense-saas/ 外で編集されようとしている場合に警告（ブロックはしない）"""
import sys
import io
import json
import os
from datetime import datetime

# Windows環境でstderrのUTF-8出力を保証
sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding="utf-8")

try:
    data = json.load(sys.stdin)
    file_path = data.get("tool_input", {}).get("file_path", "")

    source_extensions = (
        ".go", ".ts", ".tsx", ".js", ".jsx",
        ".css", ".scss", ".html", ".sql",
    )

    if file_path.lower().endswith(source_extensions):
        normalized = file_path.replace("\\", "/")
        if "expense-saas" not in normalized:
            msg = f"スコープ逸脱: ソースコードの編集は expense-saas/ 配下のみで行ってください。(対象: {file_path})"
            print(msg, file=sys.stderr)

            # ログファイルに記録
            project_dir = os.environ.get("CLAUDE_PROJECT_DIR", os.getcwd())
            log_dir = os.path.join(project_dir, "dev-journal", "logs", "hooks")
            os.makedirs(log_dir, exist_ok=True)
            log_file = os.path.join(log_dir, "hook-warnings.log")
            timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            with open(log_file, "a", encoding="utf-8") as f:
                f.write(f"[{timestamp}] edit-scope-check: {file_path}\n")

            sys.exit(0)
except Exception:
    pass

sys.exit(0)
