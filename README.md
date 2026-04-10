# dt-foundry

**a design practice in a terminal**

dt-foundry is a Claude Code lens pack for design technologists. It injects user intent, creative conscience, and consent-native thinking into your project's workflow.

While most skill packs are built for engineers to ship PRs, `dt-foundry` asks the questions a full design or advertising agency would ask. It's built on a single argument: Engineering-first tools produce engineering-first products. If you want to build something human-first, you need a practice that starts with the human.

---

## Why this exists

Most skill packs in this space are built for engineers. They review code, check architecture, run tests, ship PRs. They are excellent at what they do.

When did you last use a dev tool that asked who this is for?

dt-foundry is built on a single argument: the tools you use to build encode the values of whoever made them. Engineering-first tools produce engineering-first products. If you want to build something human-first, you need a practice that starts with the human.

Every lens in dt-foundry is structured using the SDL formula:

**ID + TD + DU = V**
Intent Declaration + Tool Declaration + Data Unit = Vault

Every run writes to a `.dt-foundry/` directory in your project root. That directory is the Vault — a timestamped provenance record of every design decision that shaped the build. Proof that a person was in the room.

---

## The lenses

| Lens | What it does |
|------|-------------|
| `/brief` | Captures and crystallizes project intent before a line of code is written |
| `/taste` | Evaluates aesthetic and experiential quality. Committee: Rams, Ive, Ogilvy, Droga |
| `/scope` | Holds the line on what the build is and isn't |
| `/standup` | Daily status check — what moved, what's blocked, what's next |
| `/persona` | Builds the human who will use this. Not a demographic — a person |
| `/room` | Reads the context the work will live in — product, advertising, or marketing |
| `/preflight` | Pre-deploy checklist with a design conscience. Stack-agnostic |
| `/dev` | Engineering review. Delegates to gstack: `/review`, `/plan-eng-review`, `/cso`, `/health` |
| `/target` | Flagship convergence lens. Six passes: Garry, Jack, McLuhan, dt-foundry, Ogilvy, Droga |
| `/q` | God mode. Full diagnostic. Asks: is this still the thing you meant to make? |
| `/hoser` | Restraint modifier. `/hoser /[lens]` for one lens. `/hoser` for the full practice |

---

## The /target lens

The flagship. Six frameworks against the same work. One convergence report.

- **Garry lens** — gstack engineering review. Architecture, production-readiness, velocity
- **Jack lens** — Block protector architecture. Trust boundaries, consent, world model
- **McLuhan lens** — media theory tetrad. Enhances, obsolesces, retrieves, reverses
- **dt-foundry lens** — design intent. Brief, taste, scope, persona, room
- **Ogilvy lens** — sells with intelligence. Copy, clarity, respect for the reader
- **Droga lens** — means something. Real idea or brief restated. Five-year test

Where they agree — confidence. Where they conflict — the decision you need to make.

---

## Install

**Step 1 — Install gstack** (required for `/dev` and `/target`)

```bash
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack && cd ~/.claude/skills/gstack && ./setup
```

**Step 2 — Install dt-foundry**

```bash
git clone https://github.com/fnkydcks-lab/dt-foundry.git ~/.claude/skills/dt-foundry
```

**Step 3 — Verify**

```bash
ls ~/.claude/skills/dt-foundry/
```

Should show: brief, dev, hoser, persona, preflight, q, room, scope, standup, target, taste

**Step 4 — Start**

Open a Claude Code session in your project and run `/brief`.

---

## Usage

Run any lens as a slash command in Claude Code:

```
/brief          — start here, before anything else
/standup        — start of every session
/taste          — after something is visible
/scope          — when the feature list starts moving
/persona        — before design decisions
/room           — before launch or distribution decisions
/dev            — before merge to main
/preflight      — before deploy
/target         — before a major ship decision
/hoser /taste   — restraint pass on a single lens
/hoser          — restraint pass across the full practice
/q              — before anything that can't be undone
```

Every run appends to `.dt-foundry/` in your project root. The directory accumulates. By the time you run `/q`, it has a full record to read.

---

## Philosophy

dt-foundry is the first implementation of the Sprnova Declaration Layer (SDL). The SKILL.md file format is itself an intent declaration — the YAML frontmatter is the Tool Declaration, the markdown body is the Intent Declaration. The two halves of every lens file are ID + TD in the same document, separated by nothing but `---`.

The `.dt-foundry/` directory is the Vault. The consent transaction happens where intent meets data. The philosophy runs in the files.

This work is anchored in *Soul in the Machine* — Whitepaper No. 2 in the Sprnova series on consent-native design. Published Q2 2026.

---

## Built by

[Sprnova](https://sprnova.xyz) — a neo-modernist cultural design foundry.

---

## License

MIT. Free forever. Fork it, extend it, encode your own expertise into lenses and share them.

The lens format is open. The standard is yours to build on.
