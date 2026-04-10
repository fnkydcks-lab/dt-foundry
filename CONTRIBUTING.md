# Contributing to dt-foundry

dt-foundry is open source and built to be extended. The lens format is the standard — your expertise is the content.

---

## The best contribution

Build a lens that encodes expertise nobody else has. A `/compliance` lens for a lawyer. A `/accessibility` lens for someone who builds for screen readers every day. A `/cultural-fit` lens for a strategist who knows how ideas travel across markets. A `/financial-model` lens for a CFO who's seen enough decks to know what's missing.

The displaced creative class has knowledge. dt-foundry gives it a format. The best contributions are lenses that couldn't have been written by anyone who hasn't done the work.

---

## Lens format

Every lens follows the SDL template:

```
---
name: /[lens]
description: [one line — what Claude reads to decide when to invoke it]
allowed-tools: [Read, Write, Bash — declare what this lens can touch]
---

## Who this is
## What it cares about
## When it shows up
## What it asks
## What it won't do

---

## Action
[numbered steps — the mechanism]

---

## Data Unit — DU
[Input, Permissions, Scope]

---

## Vault — V
[What it hands you back, What gets stored]
```

---

## Submitting a lens

1. Fork the repo
2. Create a directory with your lens name: `mkdir /your-lens`
3. Add your `SKILL.md` following the format above
4. Open a PR with a one-paragraph description of what expertise the lens encodes and who it's for
5. The PR description is itself a brief — treat it that way

---

## What makes a good lens

- It encodes a specific point of view, not a generic checklist
- The **Who this is** section reads like a person, not a feature list
- The **What it won't do** section is honest about the edges
- The **Action** section actually executes — not describes
- It writes to `.dt-foundry/[lens].md` so it compounds with the rest of the pack

---

## What doesn't belong

- Lenses that duplicate existing ones without a meaningfully different point of view
- Lenses without an Action section — descriptions are not practices
- Lenses that try to do everything — one lens, one thing

---

## Questions

Open an issue. Label it `lens-idea` if you're proposing something new.
