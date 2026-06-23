---
name: /sFlutterCheck
description: Flutter-specific code and distribution readiness check. Three layers: OWASP MASVS security audit, flutter analyze code quality pass, and sprnova distribution scout — what platforms this codebase is ready for, close to, or needs to rethink.
allowed-tools: Read, Write, Bash
---

## Who this is

/sFlutterCheck is anchored to OWASP MASVS — the mobile security standard from the same organization as OWASP LLM Top 10, applied to Flutter. It is not a general code review. It is specifically the check you run on a Flutter codebase to know: is this secure, is this clean, and where can this go next?

The third layer — sprnova — is not an audit. It is a scout. It reads the same code as the first two layers and asks the opposite question: not what's broken, but what's possible. What platforms is this codebase already close to? What would it cost to get there? What's a free win? The sprnova layer leaves the session with momentum, not just a defect list.

## What it cares about

Security posture against the six MASVS domains. Static analysis cleanliness via flutter analyze. And distribution potential — what this build is already ready for, what's close, and what would need rethinking before a new platform target becomes real.

## When it shows up

Before any TestFlight or App Store submission. After any significant auth, storage, or network change. Before starting a new platform sprint — to know where you're starting from, not where you hope to be.

## What it won't do

/sFlutterCheck is not a penetration test. It does not audit infrastructure outside the codebase. It is not a UI review — that's /taste and /design-review. It is the check that answers: is this secure, is this clean, and what can this become?

---

## Dependencies

flutter CLI must be installed. Check on entry:
```bash
which flutter || echo "FLUTTER NOT FOUND"
```
If not found, halt immediately. Do not run a partial check. A partial check produces false confidence — worse than no check.

---

## OWASP MASVS Reference

| Domain | What it means in Flutter |
|--------|--------------------------|
| MASVS-STORAGE | SharedPreferences, local files, sensitive data at rest |
| MASVS-CRYPTO | Key handling, hardcoded secrets, random number generation |
| MASVS-AUTH | Session tokens, auth state persistence, sign-out completeness |
| MASVS-NETWORK | Cleartext traffic, certificate handling, API endpoint exposure |
| MASVS-PLATFORM | Deep links, clipboard, inter-app communication, platform channels |
| MASVS-CODE | Third-party packages, debug artifacts in prod, dependency vetting |

---

## sprnova Distribution Platform Reference

| Platform | Flutter support | Input model | Canvas |
|----------|----------------|-------------|--------|
| iOS / Android | Stable | Touch | Mobile portrait |
| iPad | Stable (universal) | Touch + keyboard | Tablet landscape/portrait |
| Android TV | Experimental | D-pad + remote | 1080p/4K landscape |
| tvOS | Community only | Siri Remote (D-pad) | 1080p/4K landscape |
| LG WebOS | None native | D-pad + pointer | 1080p landscape |

**sprnova signal tiers:**
- **Ready** — translates without code change, distribution only
- **Close** — existing patterns, minor adaptation, named investment
- **Rethink** — input model or layout assumption needs revisiting, alternative named
- **Rebuild** — architectural dependency absent on this platform

---

## Action

1. Check dependency:
   ```bash
   which flutter || echo "FLUTTER NOT FOUND"
   ```
   If flutter not found — halt and tell the user. Do not continue.

2. Read `dt-foundry/brief.md` and `dt-foundry/room.md` — derive declared platform targets. If neither declares targets beyond mobile, assume mobile-only and note: *"Platform targets not declared — update /room if distribution scope extends beyond mobile."*

3. Read `dt-foundry/mode.md` — set severity framing:
   - **Code:** Fix Now / Fix Before QA / Fix Before Ship / Monitor
   - **QA:** Fix Now / Fix Next Build / Monitor
   - **Ship:** Fix Now / Monitor

4. Read `dt-foundry/sfluttercheck.md` if it exists — carry forward KNOWN/ACCEPTED findings. Only re-open a closed finding if the code changed in that area since the last report.

5. **Layer 1 — MASVS Security:**

   **MASVS-STORAGE — sensitive data at rest:**
   ```bash
   grep -rn "SharedPreferences\|putString\|putBool\|putInt\|getApplicationDocumentsDirectory" lib/ --include="*.dart" | grep -v test | head -20
   ```
   Flag any tokens, user IDs, or credentials written to SharedPreferences unencrypted.

   **MASVS-AUTH — session and token handling:**
   ```bash
   grep -rn "currentSession\|currentUser\|accessToken\|refreshToken\|signOut\|signIn" lib/ --include="*.dart" | head -20
   ```
   Confirm: signOut clears all session state. Auth checks are DB-enforced, not UI-only. Tokens not stored in plaintext.

   **MASVS-NETWORK — cleartext and endpoint exposure:**
   ```bash
   grep -rn "http://" lib/ --include="*.dart" | grep -v "https\|test\|comment" | head -10
   grep -rn "NSAllowsArbitraryLoads\|allowsArbitraryLoads" ios/ 2>/dev/null | head -5
   ```
   Flag any cleartext HTTP calls or arbitrary load exceptions.

   **MASVS-CODE — debug artifacts and open TODOs:**
   ```bash
   grep -rn "debugPrint\|kDebugMode" lib/ --include="*.dart" | grep -v test | wc -l
   grep -rn "TODO\|FIXME\|HACK" lib/ --include="*.dart" | grep -i "auth\|token\|key\|secret\|password" | head -10
   ```
   Flag security-adjacent TODOs. Note debug print count — high count in production paths is a MASVS-CODE concern.

   **MASVS-PLATFORM — platform channels:**
   ```bash
   grep -rn "MethodChannel\|EventChannel" lib/ --include="*.dart" | head -10
   ```
   Note any platform channels — each one needs a platform-specific implementation for every distribution target.

   **MASVS-CRYPTO — hardcoded secrets:**
   ```bash
   grep -rn "password\|secret\|apiKey\|api_key" lib/ --include="*.dart" | grep -v "anon\|// public\|test\|_key =\|Key(" | head -10
   ```

6. **Layer 2 — flutter analyze:**
   ```bash
   flutter analyze lib/ 2>&1
   ```
   Report: error count, warning count, info count.
   - Errors → Fix Now in all modes
   - Warnings → Fix Before Ship in QA/Ship mode
   - Info → Monitor

   Check for outdated dependencies:
   ```bash
   flutter pub outdated 2>&1 | head -30
   ```
   Flag major version bumps available — note as Monitor unless security-relevant.

7. **Layer 3 — sprnova distribution scout:**

   Read `dt-foundry/room.md` for declared targets. For each platform — declared or worth flagging as opportunity:

   **iPad (iOS universal — lowest cost win):**
   - Check for portrait lock: `grep -rn "portraitUp\|DeviceOrientation" lib/ --include="*.dart"`
   - Check for hardcoded heights that assume phone canvas
   - Check for layout patterns that expand naturally on larger canvas
   - Signal: Ready / Close / Rethink with specific named patterns

   **Android (if iOS-only):**
   - Check pubspec for iOS-only packages: `grep -n "sign_in_with_apple\|ios" pubspec.yaml`
   - Check for any Swift/ObjC platform channels with no Android equivalent
   - Signal: Ready / Close / Rethink / Rebuild per dependency

   **Android TV / tvOS (10-foot UI):**
   - Flag touch-only handlers: `grep -rn "onTap\|GestureDetector" lib/ --include="*.dart" | wc -l`
   - Flag SSO auth flows (no TV sheet equivalent without rethink)
   - Flag bottom navigation patterns (wrong paradigm for remote)
   - Flag any text input that assumes a keyboard
   - Signal: Close / Rethink / Rebuild per pattern — name the investment

   **LG WebOS:**
   - Check for Flutter Web in pubspec platforms
   - Flag native-only packages with no web equivalent
   - Signal: Rebuild (architectural) unless Flutter Web already enabled — name the path

   For each platform write:
   - What's **Ready** — already translates, name it
   - What's **Close** — small investment, name the pattern and the cost
   - What's **Rethink** — name the assumption and the alternative
   - What's **Rebuild** — name the dependency

8. Write full report to `dt-foundry/sfluttercheck.md` with timestamp.

9. Print to terminal:
   - Layer 1: MASVS findings by severity, mode-adjusted
   - Layer 2: flutter analyze — error / warning / info count, any outdated major deps
   - Layer 3: distribution readiness by platform — Ready / Close / Rethink / Rebuild

---

## Data Unit — DU

**Input:** Full `lib/` directory, `pubspec.yaml`, `ios/` and `android/` for platform config. `dt-foundry/brief.md` and `dt-foundry/room.md` for declared platform targets.

**Permissions:** Read and Bash. /sFlutterCheck does not modify code. It names what's possible and what it costs.

**Scope:** The current build. Not a historical audit — what's live in the codebase right now.

---

## Vault — V

**What it hands you back:** A three-layer report. Security posture, code quality, and distribution potential. The audit tells you what's open. The scout tells you what's possible. Together: a complete picture of where this build stands and where it can go.

**What gets stored:** `dt-foundry/sfluttercheck.md` — the proof of record and the distribution roadmap. Accumulates across sessions. The honest map of what this codebase can reach.
