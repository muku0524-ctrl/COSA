#!/bin/bash
# 毎朝 8:00 — 日記振り返りリマインダー
# launchd: ~/Library/LaunchAgents/com.cosa.morning-recap.plist

set -euo pipefail

VAULT="${COSA_VAULT:-$HOME/Documents/COSA}"

PROMPT='昨日分を日記にまとめて。
やったこと（ログ）と考えたことに書き込んで。
昨日に作業がなければログ・考えたこととも「無し」と書いて（空欄にしない）。'

printf '%s' "$PROMPT" | pbcopy

osascript <<'APPLESCRIPT'
display notification "Cursor が開いたら ⌘L → ⌘V → Enter で送信" with title "COSA 日記の時間" sound name "Glass"
APPLESCRIPT

if command -v cursor >/dev/null 2>&1; then
  cursor "$VAULT" >/dev/null 2>&1 &
elif [ -d "/Applications/Cursor.app" ]; then
  open -a "Cursor" "$VAULT"
fi
