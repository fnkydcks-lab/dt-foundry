# dt-foundry

a design practice in a terminal.

## What this is

dt-foundry is a Claude Code lens pack for design technologists. It injects user intent, creative conscience, and consent-native thinking into your project's workflow. Seventeen lenses that ask the questions a full design or advertising agency would ask.

## Skill routing

When the user's request matches a lens, invoke it. Do not answer directly.

- Starting a new feature or decision — invoke `/brief`
- Start of a session, status check — invoke `/standup`
- Evaluating aesthetic quality, UI, copy, campaign work — invoke `/taste`
- Feature list growing, scope questions — invoke `/scope`
- Need to understand the user — invoke `/persona`
- Platform, channel, or launch context questions — invoke `/room`
- About to deploy or merge — invoke `/preflight`
- Code review, engineering check — invoke `/dev`
- Major ship decision, full convergence review — invoke `/target`
- Full project diagnostic, is this still the thing you meant to make — invoke `/q`
- Restraint pass on a single lens — invoke `/hoser /[lens]`
- Restraint pass across the full practice — invoke `/hoser`
- "What happened?", "why are we still finding things?", comprehension of a fix cycle — invoke `/logicchain`
- Flutter codebase check, platform distribution readiness — invoke `/sFlutterCheck`
- Visual design QA, spacing, hierarchy, AI slop patterns — invoke `/design-review`
- Something worth doing but not now, "add it to the list" — invoke `/backlog`
- Product is live, what's actually happening in the field — invoke `/wild`
- Checking if the live product still matches brief/persona/scope — invoke `/drift`

## The Vault

Every lens writes to `dt-foundry/` in the **current project root** — not the skills directory. Before writing any output, run `mkdir -p dt-foundry` from the project root to ensure the directory exists. Do not delete this directory. It is the provenance record — the timestamped history of every design decision that shaped the build. Proof that a person was in the room.

## Available lenses

/brief, /taste, /scope, /standup, /persona, /room, /preflight, /dev, /target, /q, /hoser, /logicchain, /sFlutterCheck, /design-review, /backlog, /wild, /drift

## /wild and /drift — the in-market pair

/preflight is the readiness gate before ship. Nothing checked whether a live product was still true — until now. `/wild` looks at the field first (real usage, real feedback, no interpretation). `/drift` runs right after it, comparing what `/wild` found against `/brief`, `/persona`, and `/scope` to name the gap. Drift isn't automatically bad — sometimes it's the market teaching you something the brief didn't know. `/drift` names it; it doesn't correct it for you.

## /backlog — the one lens that's a place, not a report

Every other lens is a diagnostic pass. `/backlog` is the exception — a living list you add to and prune, not a snapshot you read once. It's where "not now" goes so it doesn't quietly become "never," without pretending every deferred item is a decided priority.

## /target — six passes

The flagship lens. Six frameworks against the same work, one convergence report:

- **Garry** — gstack engineering review: architecture, production-readiness, velocity
- **Jack** — Block protector architecture: trust boundaries, consent, world model
- **McLuhan** — media theory tetrad: enhances, obsolesces, retrieves, reverses
- **dt-foundry** — design intent: brief, taste, scope, persona, room
- **Ogilvy** — sells with intelligence: copy, clarity, respect for the reader
- **Droga** — means something: real idea or brief restated, five-year test

## /hoser — three modes

- `/hoser /[lens]` — restraint pass on one named lens output
- `/hoser` — Hoser Prime, restraint pass across all lens outputs
- Opposite of `/q` on the scope axis. `/q` expands. `/hoser` contracts.

## Dependencies

Skills do not run with missing parts. If a dependency is not present, halt immediately and tell the user exactly what is missing and how to install it. Do not run a partial version of the skill. A partial run produces false confidence — worse than no run.

**gstack** — required by `/dev` and `/target` for engineering passes.
Check: `ls ~/.claude/skills/gstack`
Install: `git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack && cd ~/.claude/skills/gstack && ./setup`

## Philosophy

SDL = ID + TD + DU = V
Intent Declaration + Tool Declaration + Data Unit = Vault

The SKILL.md file format is itself the formula in practice. The YAML frontmatter is the Tool Declaration. The markdown body is the Intent Declaration. The `dt-foundry/` directory is the Vault.

Engineering-first tools produce engineering-first products. If you want to build something human-first, you need a practice that starts with the human.
