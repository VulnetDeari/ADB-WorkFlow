---
name: adb-define
description: "ADB DEFINE. Grill the product, not the user. Write adb/, then gate into BUILD."
---

# /adb-define

Canonical: this project’s `ADB.md` (DEFINE). Method repo: `SKILL.md`.
Inherit AGENTS.md. MainAgent directs **PlanAgent**. No product implementation.

1. **Mode** — GREENFIELD or BROWNFIELD, one line. Brownfield: inspect first. Existing planning docs are evidence, not destination.
2. **Don’t ask** what repo, docs, tests or research can answer.
3. **One decision** at a time. Chips: AGENTS.md. Record in `adb/` (collapsed default: `01`, `02`, `07`).
4. **Uncertainty** — KNOWN / UNKNOWN / ASSUMED / CONFLICTING / NEEDS RESEARCH / NEEDS USER DECISION. Never silently turn an assumption into product truth.
5. **Gate** — fresh team can build without inventing important behavior? Leftover uncertainty block the first slice? If yes, only that blockage. Don’t fill unused files.
6. **Once:** chips `BUILD starten` `Noch offene Punkte` `Entscheide du`. No BUILD on silence. Don’t restart DEFINE as a whole.

Forbidden: extra files, agents or reviews to tick a point; secrets in git or `adb/`.
