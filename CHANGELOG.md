# Changelog

All notable changes to dt-foundry will be documented here.

---

## [1.1.0] — 2026-08-13

### Lenses

- `/backlog` — the living deferred-items list. A place you edit, not a report you read
- `/wild` — what's actually happening now that something is live. Ground truth, no interpretation
- `/drift` — the gap between `/brief`/`/persona`/`/scope` and what `/wild` found. Runs right after `/wild`

### Why

`/preflight` covers readiness before ship — nothing covered whether a live product was still true to what it meant to be. `/wild` + `/drift` fill that in-market gap as a pair: observe, then compare. `/backlog` fills a separate gap — a place for things surfaced mid-work that are real but not now, distinct from `/standup`'s append-only daily log.

---

## [1.0.0] — 2026-04-09

Initial release.

### Lenses

- `/brief` — intent declaration before code
- `/taste` — aesthetic evaluation. Committee: Rams, Ive, Ogilvy, Droga
- `/scope` — scope integrity
- `/standup` — daily status check with running session log
- `/persona` — human declaration for the build
- `/room` — context fit across product, advertising, and marketing
- `/preflight` — pre-deploy checklist, stack-agnostic
- `/dev` — engineering review delegating to gstack
- `/target` — six-pass convergence report: Garry, Jack, McLuhan, dt-foundry, Ogilvy, Droga
- `/q` — full practice diagnostic
- `/hoser` — restraint modifier with three zoom levels

### Architecture

- SDL formula: ID + TD + DU = V
- `dt-foundry/` directory as Vault — timestamped provenance record per project
- Stack-agnostic preflight detection: Flutter, Node, Rust, Python, Go, Swift
- gstack dependency for `/dev` and `/target` engineering passes

### Philosophy

First implementation of the Sprnova Declaration Layer. Anchored in *Soul in the Machine* — Whitepaper No. 2, Q2 2026.
