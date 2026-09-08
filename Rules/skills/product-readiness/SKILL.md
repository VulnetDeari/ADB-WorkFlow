---
name: product-readiness
description: "Whole-app Alpha / Beta / Live walk. Only when the owner asks about the whole app — not after a job whose plan is met."
---

# product-readiness

Canonical for ADB products: that project’s `ADB.md` COMPLETION, plus this walk. Inherit the project’s `AGENTS.md`.

Use only when the owner asks about the **whole app** (Alpha / Beta / Live / “is the whole app done”). A job that matches its plan can be done while the app could still grow later. Bare “done” after a met plan is Talk in AGENTS.md, not this skill.

MainAgent starts **ReviewAgent** (subagent). ReviewAgent never implements. The reviewer's block replaces `READINESS` and `## Readiness`; MainAgent enters it verbatim and never alters it.

Hand and rules as `/adb-review`: two fields (`RANGE: HEAD`, `SPEC`), the reviewer fetches the rest itself, changes nothing in the real tree, breaks on a copy. Walk the current product on a real path (browser if UI; sign in yourself). Proof as `TRIED`: what you tried, what happened. A self-check must not return `LIVE`.

```
READINESS: NICHT_FERTIG | ALPHA | BETA | LIVE
READINESS-BY: independent | self-check
TRIED
- command or step → what happened
GAPS: none | ISSUE-IDs
STALE-NEXT: later RECORD / spec this walk covered changes
```

| Key | Meaning |
|---|---|
| `NICHT_FERTIG` | Core path broken, spec unsatisfied, or release blockers. |
| `ALPHA` | Core path works. Gaps registered. Not real operations. **Never product complete.** |
| `BETA` | Agreed scope matches `adb/`. Important flows + empty/loading/error on a real path. |
| `LIVE` | BETA + bar clear + production items in `adb/05`. Not “already online.” |

The bar chooses BETA vs LIVE, not ALPHA vs BETA. Stale after a later RECORD or spec change this walk covered. No separate reviewer → the block is headed `Review: self-check`.
