#!/usr/bin/env bash
# on-session-end.sh — Claude Code の Stop hook
# セッション終了時に 日記/YYYY-MM-DD.md の「## ログ」欄へ1行サマリーを追記し、git があれば自動コミットする。
#
# 使い方: ~/.claude/settings.json の hooks.Stop に登録する（README 4章参照）。
#   "command": "VAULT_DIR=\"/path/to/vault\" bash \"/path/to/vault/scripts/on-session-end.sh\""
set +e

VAULT_DIR="${VAULT_DIR:-$HOME/vault}"
DAILY_DIR="$VAULT_DIR/日記"
LOG="$VAULT_DIR/.sync.log"
TODAY=$(date +%Y-%m-%d)
DAILY_FILE="$DAILY_DIR/$TODAY.md"
NOW=$(date +%H:%M)

mkdir -p "$DAILY_DIR"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] on-session-end" >> "$LOG"

# git があれば最新を取得（他端末/自動処理の書き込みを保護）
if [ -d "$VAULT_DIR/.git" ]; then
  git -C "$VAULT_DIR" pull --rebase origin main >> "$LOG" 2>&1 || true
fi

# 日記ノートが無ければ templates/daily-note.md ベースで作成（COSAの日本語テンプレートに合わせる）
if [ ! -f "$DAILY_FILE" ]; then
  WEEKDAY=$(TODAY="$TODAY" python3 -c "
import os, datetime
names = ['月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日', '日曜日']
print(names[datetime.date.fromisoformat(os.environ['TODAY']).weekday()])
" 2>/dev/null || echo "")
  TEMPLATE="$VAULT_DIR/templates/daily-note.md"
  if [ -f "$TEMPLATE" ]; then
    sed "s/{{date}}/$TODAY/; s/{{weekday}}/$WEEKDAY/" "$TEMPLATE" > "$DAILY_FILE"
  else
    printf -- "---\ndate: %s\nweekday: %s\ntype: daily\ntags:\n  - 日記\n---\n\n## 予定\n\n## ログ\n\n## 考えたこと\n\n## リンク\n" \
      "$TODAY" "$WEEKDAY" > "$DAILY_FILE"
  fi
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Created daily note: $DAILY_FILE" >> "$LOG"
fi

# hook から stdin で渡される JSON を読む
INPUT=$(cat 2>/dev/null || true)
CWD=$(python3 -c "
import sys, json
try:
    print(json.loads(sys.argv[1] if len(sys.argv) > 1 else '{}').get('cwd', ''))
except Exception:
    print('')
" "$INPUT" 2>/dev/null || echo "")

LABEL=$([ -n "$CWD" ] && basename "$CWD" || echo "session")
DEVICE=$(hostname -s 2>/dev/null || echo "device")
ENTRY="- $NOW [$DEVICE] セッション終了 (cwd: $LABEL)"

# 「## ログ」セクションの末尾に1行追記（Python でセクション先頭に挿入）
export DAILY_FILE ENTRY
python3 -c '
import os
f = os.environ["DAILY_FILE"]
e = os.environ["ENTRY"]
with open(f) as fh:
    lines = fh.readlines()
out, in_log, done = [], False, False
for l in lines:
    if l.strip() == "## ログ":
        in_log = True; out.append(l); continue
    if in_log and l.startswith("## ") and not done:
        out.append(e + "\n\n"); done = True; in_log = False
    out.append(l)
if in_log and not done:
    out.append(e + "\n\n")
with open(f, "w") as fh:
    fh.writelines(out)
' 2>/dev/null || echo "$ENTRY" >> "$DAILY_FILE"

# git があれば追記分を commit / push（失敗しても素通り）
if [ -d "$VAULT_DIR/.git" ]; then
  git -C "$VAULT_DIR" add "日記/$TODAY.md" >> "$LOG" 2>&1
  if ! git -C "$VAULT_DIR" diff --cached --quiet; then
    git -C "$VAULT_DIR" commit -m "log: $TODAY session end" >> "$LOG" 2>&1
    git -C "$VAULT_DIR" pull --rebase origin main >> "$LOG" 2>&1 || true
    git -C "$VAULT_DIR" push origin main >> "$LOG" 2>&1 || true
  fi
fi

exit 0
