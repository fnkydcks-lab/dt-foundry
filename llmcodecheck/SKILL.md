---
name: /llmcodecheck
description: AI code gap audit. Anchored in the OWASP Top 10 for LLMs — finds the specific failure patterns that AI-generated code leaves behind. Not a general security audit. Specifically: what the model got wrong, what it left open, and what it assumed was handled when it wasn't.
allowed-tools: Read, Write, Bash
---

## Who this is

/llmcodecheck exists because AI-generated code has a distinct failure pattern from human-written code. A senior engineer forgets to add an index. An LLM forgets to scope a policy. A senior engineer leaves a TODO. An LLM leaves an open permission and writes "// TODO: tighten this" and the TODO never ships. The gaps are different. The audit has to be different.

This skill is anchored in the **OWASP Top 10 for LLMs** — the accepted standard for AI-generated code vulnerabilities, maintained by the same organization that publishes the web application security standard. It is not a full security audit. It is specifically the check you run when you know AI wrote meaningful portions of your codebase and you want to know what it missed.

The Garry lens from /target asks: would a senior engineer be embarrassed by this? /llmcodecheck asks the prior question: did the AI leave any doors open that a senior engineer would have locked on the way out?

## What it cares about

The specific gaps AI code leaves:
- **Permissions assumed, not enforced** — RLS policies that are too broad, missing ownership checks, INSERT/UPDATE/DELETE policies that don't scope to the authenticated user
- **Secrets in source** — API keys, service role keys, tokens hardcoded in constants files, migration SQL, or edge functions
- **Auth bypasses that shipped** — dev convenience routes left in production, auth checks that are UI-only rather than DB-enforced
- **Excessive trust** — service role key used where anon key would suffice, edge functions that skip auth validation, storage policies that allow public write
- **Unhandled failure paths** — AI code is optimistic. It writes the happy path and wraps the rest in `catch (_) {}`. These are the gaps.
- **Policy drift** — old policies that were never dropped when new ones replaced them, leaving double-coverage that can be exploited if the old policy is more permissive

## When it shows up

Before any build that goes to external testers. Before submitting to an app store. After any major Supabase schema or RLS change. Any time AI generated a significant portion of a feature end-to-end without a human review pass on the security layer specifically.

## What it won't do

/llmcodecheck is not a penetration test. It does not attempt to exploit vulnerabilities — it identifies them. It does not audit infrastructure outside the codebase (hosting, DNS, CDN). It does not replace a professional security review for regulated industries. It is the check that catches what the model missed, not the check that replaces human expertise.

---

## OWASP LLM Top 10 Reference

The ten failure categories this skill checks against, mapped to what they mean in a mobile + Supabase context:

| OWASP LLM | What it means here |
|-----------|-------------------|
| LLM01 — Prompt Injection | N/A for non-AI features. Flag if any user input is passed to an LLM without sanitization. |
| LLM02 — Insecure Output Handling | Edge functions returning raw DB data without field filtering. |
| LLM03 — Training Data Poisoning | N/A unless the product trains models. |
| LLM04 — Model Denial of Service | N/A unless calling external AI APIs — rate limit check if so. |
| LLM05 — Supply Chain Vulnerabilities | Unvetted packages, edge function imports from CDN without version pinning. |
| LLM06 — Sensitive Information Disclosure | Secrets in source, API keys in constants, service role keys in SQL. |
| LLM07 — Insecure Plugin Design | Edge functions with no auth check, webhook endpoints with no signature validation. |
| LLM08 — Excessive Agency | Service role key used where RLS + anon key would suffice. Functions that can do more than they need to. |
| LLM09 — Overreliance | Auth that is UI-enforced only — not DB-enforced. RLS missing on tables. |
| LLM10 — Model Theft | N/A unless the product exposes a trained model. |

The relevant categories for a mobile + Supabase stack are: LLM02, LLM05, LLM06, LLM07, LLM08, LLM09.

---

## Action

1. Read `.dt-foundry/brief.md` for schema and feature context.

2. Run the six relevant OWASP checks:

   **LLM06 — Secrets in source:**
   ```bash
   grep -rn "sk_\|service_role\|eyJhbGci\|AIza\|Bearer " lib/ supabase/ --include="*.dart" --include="*.ts" --include="*.sql" | grep -v "// public\|anon"
   ```
   Flag any live credential that isn't the public anon key.

   **LLM09 — Missing or overly permissive RLS:**
   ```bash
   # Check migrations for table creation without RLS enable
   grep -n "CREATE TABLE\|ENABLE ROW LEVEL SECURITY\|CREATE POLICY" supabase/migrations/*.sql | head -60
   ```
   For every `CREATE TABLE`: confirm there is a matching `ENABLE ROW LEVEL SECURITY`. For every `CREATE POLICY`: confirm the USING clause scopes to `auth.uid()` where appropriate.

   **LLM08 — Excessive agency (service role misuse):**
   ```bash
   grep -rn "service_role\|SUPABASE_SERVICE_ROLE" supabase/functions/ lib/ --include="*.ts" --include="*.dart"
   ```
   Flag any use of service role outside of edge functions. Inside edge functions: confirm each use is necessary (reading across RLS boundaries) rather than lazy (used because it was convenient).

   **LLM07 — Edge functions with no auth validation:**
   ```bash
   grep -n "Deno.serve\|req.json\|Authorization" supabase/functions/*/index.ts
   ```
   For each edge function: confirm it either validates the caller (checks Authorization header, validates JWT) or is intentionally a trusted internal function called only via service role.

   **LLM02 — Raw data exposure:**
   ```bash
   grep -rn "\.select()\|\.select('\*')" lib/ --include="*.dart" | head -20
   ```
   Flag any select() with no field list — these return every column including ones that shouldn't go to the client.

   **LLM05 — Unversioned CDN imports:**
   ```bash
   grep -rn "esm.sh\|cdn.jsdelivr\|unpkg" supabase/functions/ --include="*.ts"
   ```
   Flag any CDN import without a pinned version tag (e.g. `@supabase/supabase-js` without `@2.x.x`).

3. For each finding:
   - Name the OWASP category
   - Quote the exact line
   - State the risk in plain language (not jargon)
   - State the fix

4. Write report to `.dt-foundry/llmcodecheck.md` with timestamp.

5. Print to terminal: findings by severity — **fix before ship**, **fix before public launch**, **monitor**.

---

## Data Unit — DU

**Input:** Full codebase — lib/, supabase/functions/, supabase/migrations/. The brief for schema context.

**Permissions:** Read and Bash. /llmcodecheck does not modify code. It names what needs fixing and lets the human decide.

**Scope:** The current build. Not a historical audit — what's live in the code right now.

---

## Vault — V

**What it hands you back:** An OWASP-anchored gap report. Every finding named, categorized, and prioritized. The fixes are named — not implied. Credible enough to share with anyone who asks "did you audit the AI-generated code?"

**What gets stored:** `.dt-foundry/llmcodecheck.md` — the proof of record. This is the document that answers "how do you know the AI didn't leave anything open?" You run /llmcodecheck. You show them the report.
