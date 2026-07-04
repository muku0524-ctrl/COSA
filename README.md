# COSA

個人ナレッジ用 Obsidian vault（daily 中心）。

## フォルダ構成

```
COSA/
├── 日記/          … 毎日のログ（YYYY-MM-DD.md）
├── templates/     … ノートのひな形
├── system/        … ルール（自動同期・手動編集禁止）
├── skills/        … 将来用（自動同期）
└── memory/        … 将来用（自動同期）
```

## 使い方

1. **Obsidian** で「保管庫を開く」→ このフォルダ（`COSA`）を選ぶ
2. **Cursor** でこのフォルダを開いて AI と一緒にメモを書く
3. 毎日 `日記/YYYY-MM-DD.md` にログを書く

## 朝の振り返り（翌朝 8 時・昨日分）

夕方にまとめなくても OK。**翌朝 8 時ごろ**に Cursor チャット（⌘+L）で次を送る:

```
昨日分を日記にまとめて。
やったこと（ログ）と考えたことに書き込んで。
```

AI が **昨日の日付** の `日記/YYYY-MM-DD.md` に自動で書き込む。
ルールは `.cursor/rules/daily-recap.mdc` を参照。

**その日にやったことがないとき**は、ログ・考えたこととも **`無し`** と書く（空欄にしない）。今日と昨日をまとめる依頼でも同じ。

### 朝 8 時リマインダー（半自動）

毎朝 8:00 に Mac が通知し、Cursor で COSA を開き、プロンプトをクリップボードにコピーする。

**あなたがやること（3 キー）:** `⌘L` → `⌘V` → `Enter`

```bash
# 初回のみ: リマインダーを有効化
cp ~/Documents/COSA/scripts/com.cosa.morning-recap.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.cosa.morning-recap.plist

# 今すぐ試す
bash ~/Documents/COSA/scripts/morning-recap-reminder.sh

# 止めたいとき
launchctl unload ~/Library/LaunchAgents/com.cosa.morning-recap.plist
```

## Git バックアップ

- リモート: https://github.com/muku0524-ctrl/COSA （プライベート）
- 初回セットアップ:

```bash
cd ~/Documents/COSA
git init
git add .
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/muku0524-ctrl/COSA.git
gh auth login   # 未設定の場合
git push -u origin main
```

## ルール

詳細は `CLAUDE.md` を参照。
