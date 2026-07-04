---
type: schema
title: COSA Vault Rules
updated: 2026-07-04
---

# COSA Vault Rules

個人ナレッジ vault（daily 中心）。本文は日本語、フォルダ名・タグは日本語。

## ファイル区分

| 区分 | パス | 編集 |
|------|------|------|
| 編集可 | `日記/`, `templates/`, `メモ/`, `layer1_logs/`, `layer2_skills/`, `layer2_learnings/`, `inbox/` | ユーザー・LLM とも編集可 |
| 自動同期のみ | `system/`, `skills/`, `memory/` | 手動編集禁止（`<!-- SYNCED: DO NOT EDIT -->` 付き） |
| ルール定義 | `CLAUDE.md`, `.cursor/rules/`, `layer3_skills/_index.md` | セットアップ時 / 昇格判定の更新時のみ変更 |
| 実行スキル | `.claude/skills/<name>/SKILL.md` | Layer 2 → 3 昇格時のみ追加（`promote-skill` 経由） |

## 書き込みルール

- **`.md` ファイルのみ** YAML frontmatter を付ける（1 行目から `---` で囲む）
- frontmatter 対象外: `.gitignore`, `scripts/*`, `.cursor/rules/*.mdc`
- 日付フォーマット: ISO 8601（`YYYY-MM-DD`）
- 本文の主言語: **日本語**
- SYNCED 対象の `.md` は frontmatter 閉じタグ `---` の直後に `<!-- SYNCED: DO NOT EDIT -->` を置く

```
---
type: synced
updated: YYYY-MM-DD
---

<!-- SYNCED: DO NOT EDIT -->

# タイトル
```

## リンク規約

- 内部リンク: `[[フォルダ/ファイル名]]`（拡張子 `.md` は省略可）
- 例: `[[日記/2026-05-24]]`, `[[system/global-rules]]`
- 外部 URL: Markdown 標準 `[表示名](https://...)`

## 命名規則

| 種別 | フォルダ | ファイル名 | 例 |
|------|---------|-----------|-----|
| daily | `日記/` | `YYYY-MM-DD.md` | `日記/2026-05-24.md` |
| template | `templates/` | `{種別}-note.md` | `templates/daily-note.md` |
| memo | `メモ/` | 内容に応じた名前 | `メモ/4ペイン画面の開き方.md` |
| 生ログ（Layer 1） | `layer1_logs/` | `YYYY-MM-DD_作業名.md` | `layer1_logs/2026-07-04_引っ越し作業.md` |
| 手順書（Layer 2） | `layer2_skills/` | `<テーマ-kebab>.md` | `layer2_skills/gas-deploy手順.md` |
| 学び（Layer 2） | `layer2_learnings/` | `YYYY-MM-DD_<テーマ>.md` | `layer2_learnings/2026-07-04_pull失敗の真因.md` |
| 実行スキル（Layer 3） | `.claude/skills/` | `<name>/SKILL.md` | `.claude/skills/weekly-review/SKILL.md` |
| synced | `system/`, `skills/`, `memory/` | 内容に応じた名前 | `system/global-rules.md` |

## 禁止事項

- 顧客名・取引先名の外部送信禁止
- 価格・経営判断の AI 単独実行禁止
- メール / Slack の無断送信禁止（下書きまで可）
- `rm -rf` / `git push --force` / `git reset --hard` の無断実行禁止

## LLM のふるまい

- 簡潔・構造化（不要な前置きを省く）
- 図解（Markdown 表 / ASCII 図）を優先
- 曖昧な指示は要件定義を逆提示してから着手
- 提案は Pros / Cons / 第 3 の視点を併記

## 知識昇格パイプライン（Layer 1 → 2 → 3）

日々の作業ログを段階的に蒸留し、Claude が呼び出せる「実行スキル」へ育てる仕組み。

```
Layer 1  生ログ      layer1_logs/                     ← 毎セッション残す（daily-log スキル）
Layer 2  蒸留知識    layer2_skills/ layer2_learnings/  ← 週次で手動 or 自動蒸留（weekly-review スキル）
Layer 3  実行スキル  .claude/skills/                   ← 4基準を満たしたら手動昇格（promote-skill スキル）
```

- **`日記/`** はこれまでどおり手動で書く「手厚い日次振り返り」。`daily/` は別途作らず、
  セッション終了ログ（1行サマリー）も `日記/YYYY-MM-DD.md` の `## ログ` 欄に統合する
- **毎セッション終了時**: 「今日の作業をまとめて」で `daily-log` スキルが `layer1_logs/` に生ログを残す
- **同じ作業が2〜3回登場したら**: `layer2_skills/` へ手順書として昇格を提案する
- **重要な気づき・失敗の教訓**: `layer2_learnings/` へ学びとして昇格を提案する
- **AI との認識ズレが繰り返される**: この `CLAUDE.md` の作業ルールに追記して再発防止する
- **Layer 2 → 3 昇格基準**: `layer3_skills/_index.md` の4基準（起動できる／実績がある／手順が安定／呼び出す価値がある）を**すべて**満たすもののみ
- **週次レビュー**: 「週次レビュー」で `weekly-review` スキルが今週の振り返り＋昇格候補を提案する
- **inbox/**: 外部で拾った情報の一時置き場。「inbox を整理して」で各層へ振り分ける
- セッション終了フック（`scripts/on-session-end.sh`）と週次自動蒸留（`scripts/weekly-promote-prompt.md`）は
  同梱済みだが、**`~/.claude/settings.json` への Stop フック登録はまだ行っていない**（有効化は今後の判断）

## Git 認証

- リモート: `https://github.com/muku0524-ctrl/COSA.git`（プライベート）
- 認証: `gh auth login`（HTTPS）または SSH 鍵を推奨
- **禁止:** PAT / パスワードを remote URL に埋め込まない
- macOS: `git config --global credential.helper osxkeychain` で Keychain 利用可
