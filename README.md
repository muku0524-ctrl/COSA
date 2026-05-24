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
