"""PreToolUse hook: ソースコードが expense-saas/ 外で編集されないことを確認"""
import sys
import json

try:
    data = json.load(sys.stdin)
    file_path = data.get("tool_input", {}).get("file_path", "")

    source_extensions = (
        ".rs", ".ts", ".tsx", ".js", ".jsx",
        ".css", ".scss", ".html", ".sql",
    )

    if file_path.lower().endswith(source_extensions):
        normalized = file_path.replace("\\", "/")
        if "expense-saas" not in normalized:
            print(
                f"スコープ逸脱: ソースコードの編集は expense-saas/ 配下のみで行ってください。(対象: {file_path})",
                file=sys.stderr,
            )
            sys.exit(2)
except Exception:
    pass

sys.exit(0)
