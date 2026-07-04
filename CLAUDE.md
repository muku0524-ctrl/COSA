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
| 編集可 | `日記/`, `templates/`, `メモ/` | ユーザー・LLM とも編集可 |
| 自動同期のみ | `system/`, `skills/`, `memory/` | 手動編集禁止（`<!-- SYNCED: DO NOT EDIT -->` 付き） |
| ルール定義 | `CLAUDE.md`, `.cursor/rules/` | セットアップ時のみ変更 |

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

## Git 認証

- リモート: `https://github.com/muku0524-ctrl/COSA.git`（プライベート）
- 認証: `gh auth login`（HTTPS）または SSH 鍵を推奨
- **禁止:** PAT / パスワードを remote URL に埋め込まない
- macOS: `git config --global credential.helper osxkeychain` で Keychain 利用可
