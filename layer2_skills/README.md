---
title: Layer 2 — 手順書
type: readme
---

# layer2_skills — 手順書（Layer 2）

生ログから抽出した、**毎回ほぼ同じ手順を踏む作業のレシピ**を置く場所です。

## 役割

「読む知識」の層。作業を始める前に Read して参考にする手順書。
生ログ（Layer 1）を週次で蒸留した結果がここに溜まる。

## 命名規則

```
layer2_skills/<テーマ-kebab>.md
例: gas-deploy手順.md
    surge-デプロイ手順.md
    instagram-carousel-制作.md
```

## 中身のフォーマット（推奨）

```markdown
---
title: <手順名>
type: skill-note
created: YYYY-MM-DD
updated: YYYY-MM-DD
source: "[[layer1_logs/YYYY-MM-DD_元ログ]]"
---

# <手順名>

## いつ使うか
- （トリガーとなる場面）

## 手順
1.
2.

## ハマりどころ
- （過去に詰まった点）
```

## 昇格

同じ手順を直近3ヶ月で2回以上使い、手順が安定していたら
`layer3_skills/_index.md` の基準を確認して実行スキル化を検討する。
昇格したら frontmatter に `promoted_to: .claude/skills/<name>` を追記し、このノートは残す。
