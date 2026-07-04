---
name: promote-skill
description: >
  Layer 2（手順書・学び）を Layer 3（実行可能スキル）へ昇格させるスキル。
  「このノートをスキル化して」「layer2 を昇格して」「スキルに昇格して」「promote-skill」
  と言われたら使うこと。昇格基準の審査から SKILL.md 生成までを行う。
---

# promote-skill — Layer 2 → Layer 3 の昇格

`layer2_skills/` や `layer2_learnings/` のノートを、合言葉で起動できる
実行可能スキル（`.claude/skills/<name>/SKILL.md`）へ昇格させます。

## 実行手順

### Step 1: 昇格基準の審査（門番）

対象ノートが `layer3_skills/_index.md` の **4基準をすべて満たすか** 確認する:

1. 起動できるワークフローである（毎回ほぼ同じ手順）
2. 実績がある（直近3ヶ月で2回以上使った）
3. 手順が安定している（使うたびに書き換えていない）
4. 呼び出す価値がある（即起動したい場面がある）

**1つでも満たさなければ昇格しない。** その旨と理由をユーザーに伝え、Layer 2 に留める。
単発の学び・教訓（`layer2_learnings/` の多く）は基準1を満たさないので昇格させない。

### Step 2: スキル名と description を決める

- `name`: 英語 kebab-case（例: `deploy-site`, `format-invoice`）
- `description`: **いつ起動するか（トリガーフレーズ）を必ず含める**。Claude はこの description を見て起動を判断する

### Step 3: SKILL.md を生成する

`.claude/skills/<name>/SKILL.md` を作成する:

```markdown
---
name: <name>
description: >
  <何をするスキルか>。
  「<トリガーフレーズ1>」「<トリガーフレーズ2>」と言われたら使うこと。
---

# <スキル名>

<1〜2文の概要>

## 実行手順

### Step 1: ...
### Step 2: ...

## 守ること / ハマりどころ
- （元ノートの学びをここに凝縮する）
```

手順が長い・参照データが多い場合は `.claude/skills/<name>/references/` に分割する。

### Step 4: 昇格の後始末

1. 元の layer2 ノートは**削除しない**。frontmatter に `promoted_to: .claude/skills/<name>` を追記して残す
2. `layer3_skills/_index.md` の「現在の Layer 3 スキル一覧」と「昇格記録」に1行ずつ追記する
3. git を使っているなら commit する

## 守ること

- **description のトリガーが命** — ここが曖昧だとスキルが呼ばれない。「いつ使うか」を具体的な言葉で
- **元ノートを消さない** — 週次エージェントの再生成と衝突しないよう、`promoted_to:` を付けて残す
- **昇格しすぎない** — 使わないスキルが増えると棚が散らかる。4基準を厳格に適用する
