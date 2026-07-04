#!/usr/bin/env bash
# weekly-lint.sh — 週次の vault 整合性チェック（任意）
# 壊れた wikilink・欠けている daily ノート・frontmatter 無しファイルを検出する。
# 週次昇格プロンプトの前に走らせると、蒸留対象の抜け漏れに気づきやすい。
set +e

VAULT="${VAULT_DIR:-$HOME/vault}"
ISSUES=""
IC=0

add() { ISSUES="${ISSUES}"$'\n'"- $1"; IC=$((IC + 1)); }

echo "--- 壊れた wikilink をチェック ---"
while IFS= read -r -d '' f; do
  while IFS= read -r link; do
    [ -z "$link" ] && continue
    [ ! -f "$VAULT/${link}.md" ] && add "Broken: [[${link}]] in $(basename "$f")"
  done < <(grep -oE '\[\[[^]|#]+' "$f" 2>/dev/null | sed 's/\[\[//')
done < <(find "$VAULT" -name "*.md" -not -path "*/.obsidian/*" -not -path "*/.git/*" -print0 2>/dev/null)

echo "--- 過去7日の daily ノートをチェック ---"
for i in $(seq 1 7); do
  d=$(date -v-"${i}d" +%Y-%m-%d 2>/dev/null || date -d "-${i} days" +%Y-%m-%d 2>/dev/null || continue)
  [ ! -f "$VAULT/日記/${d}.md" ] && add "Missing daily: ${d}"
done

echo "--- frontmatter 無しファイルをチェック ---"
while IFS= read -r -d '' f; do
  case "$(head -1 "$f" 2>/dev/null)" in
    "---"|"<!-- SYNCED: DO NOT EDIT -->"|"# "*) ;;
    *) add "Missing frontmatter: $(basename "$f")" ;;
  esac
done < <(find "$VAULT/layer1_logs" "$VAULT/layer2_skills" "$VAULT/layer2_learnings" -name "*.md" -print0 2>/dev/null)

if [ "$IC" -gt 0 ]; then
  printf "Lint: %s 件の指摘%s\n" "$IC" "$ISSUES"
else
  echo "Lint: 問題なし"
fi

exit 0
