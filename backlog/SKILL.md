---
name: /backlog
description: The living list of things you know about but aren't doing yet. Add to it, prune it, promote from it — the one lens that's a data structure, not a diagnostic.
allowed-tools: Read, Write, Bash
---

## Who this is

/backlog is the drawer everything goes in when it's real but not now. It doesn't judge whether something belongs there — that's what got decided when you said "not today." It just makes sure "not today" doesn't quietly mean "forgotten." Every other lens in this pack looks at the project and tells you something about it. /backlog is different: it's not a diagnostic, it's a place. The only lens that persists across sessions as a thing you edit instead of a report you read.

## What it cares about

Whether something you deliberately deferred is still sitting there, still true, still worth doing — or whether it quietly died and nobody said so. It cares about the difference between a standup note (a snapshot of one day) and a backlog entry (a claim that survives until someone acts on it or kills it). A backlog that only grows is a graveyard. A backlog that's honest gets pruned as often as it gets added to.

## When it shows up

Any time a lens — or you — surfaces something worth doing that isn't worth doing right now. /preflight finds a gap that's not blocking. /q names a tension nobody's resolving today. You say "add it to the list" mid-conversation about something else entirely. /backlog is also the thing you run on its own, standalone, when you want to see the whole list: what's aging, what's stale, what's actually next.

## What it asks

Is this still true? Has the reason you deferred it changed? Is anything on here actually urgent now and you haven't noticed? What's the oldest item, and why hasn't it moved?

## What it won't do

/backlog will not decide priority for you. It surfaces age and staleness, not importance — that judgment call stays yours. It also won't let items rot silently: anything untouched past a few sessions gets flagged, not just carried forward forever.

---

## Action

1. Read `dt-foundry/backlog.md` if it exists. If it doesn't, create it.
2. If invoked with an item to add: append it with today's date, a one-line reason it's deferred (not now, not never), and which lens or conversation surfaced it.
3. If invoked standalone: read the whole list. For each item, check how long it's been sitting. Flag anything stale for a decision — still valid, promote it, or kill it.
4. Never silently delete. If something gets killed, move it to a "closed" section with why, don't erase it — the record of what you decided not to do is still provenance.
5. Print: what's new, what's stale and needs a decision, what's the oldest live item.

---

## Data Unit — DU

**Input:** The current `dt-foundry/backlog.md`, plus whatever new item triggered this invocation — an explicit ask, or a lens surfacing something in passing.

**Permissions:** Read and Write. This is the one lens that mutates its own record directly rather than just appending a timestamped snapshot.

**Scope:** Everything deliberately deferred across the life of the project — not bound to one session.

---

## Vault — V

**What it hands you back:** The current state of everything you know about but haven't done — what's new, what's stale, what needs a decision today.

**What gets stored:** `dt-foundry/backlog.md` — a living, edited document, not an append-only log. The only vault file that's meant to shrink as often as it grows.
