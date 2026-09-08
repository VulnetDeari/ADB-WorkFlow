---
name: adb
description: "Ask. Decide. Build. Product method for large or risky projects. Active only when METHOD.md says METHOD: ADB. AGENTS.md applies unchanged; this file adds only the method."
---

# ADB

Ask. Decide. Build. `AGENTS.md` applies unchanged — talk, proof, tests, roles, git. This file adds only the method and never repeats it. Active only when `METHOD.md` says `METHOD: ADB`; missing or `PLAIN` → do not load. Setup copies and stamps this file; never hand-edit the copy.

**Job:** write where the product must land in `adb/`, then build it in user-visible slices that fit in one context window and prove each one. Not a fake company.

Product truth is `adb/`. Chat is not. A later agent reads `adb/`, not the interview. Existing product docs in the app are DEFINE evidence, not `adb/`.

Each rule judges the product. If it does not apply, extra work is forbidden.

⸻

# DEFINE

No product code. MainAgent directs **PlanAgent**.

**Done when** a fresh agent can build from `adb/` without inventing important behavior, and leftover uncertainty does not block the first slice. More research possible ≠ keep DEFINE open.

**Greenfield** — nothing exists yet. **Brownfield** — inspect first: exists / works / wrong / unclear / keep / what the owner wants. Existing code is evidence, not automatically the destination.

Ask the **product**, not the owner, for what repo, docs, tests or research can answer. One decision at a time. Record in `06`, or in `02` while collapsed. Challenge choices that hurt usability, safety, or coherence — not taste. If the owner knows WHAT but not HOW it should look: PlanAgent owns a coherent direction. No generic AI look.

Every material fact: KNOWN / UNKNOWN / ASSUMED / CONFLICTING / NEEDS RESEARCH / NEEDS USER DECISION. Never silently turn an assumption into product truth.

## Source of truth

Default small: `01-VISION`, `02-PRODUCT-SPEC`, `07-STATUS`. Split 03–06 and 08 only when merged would hide truth. Setup does **not** create 08. Numbered names only. No extra permanent docs without a concrete need.

- **01** — what it is, who, why, what it is not.
- **02** — behavior: features, rules, states, data, errors, examples.
- **03** — screens, flows, empty / loading / error.
- **04** — stack, boundaries, deploy, security — only what matters, with WHY.
- **05** — what DONE means for this product.
- **06** — important WHY, not trivia.
- **07** — header only: PHASE, NOW, NEXT, BLOCKERS, OPEN, READINESS. Several slices: `## Execution plan`. Preserve `## Readiness` and `## Last review` — ReviewAgent writes them. MainAgent does not change the key.
- **08** — real unresolved problems, or `## Open issues` in 07 while collapsed.

## Issues

No wishes. Stable `ISSUE-00N`. Only these fields:

```
### ISSUE-00N — TITLE
SEVERITY: CRITICAL | HIGH | MEDIUM | LOW
PROBLEM:
EVIDENCE:
STATUS: OPEN | WAITING ON USER | CLOSED
CARRIED: n
RESOLUTION:   (when CLOSED)
VERIFIED BY:  (when CLOSED)
```

**CARRIED:** status reviews survived while OPEN. New = 0. Only `/adb-status` increments it — never by hand, never from memory. A review is: slice RECORD, before release, or the owner asks status. Not the fix-round cap. At **3**: FIX, ACCEPT (not for CRITICAL, not for HIGH data/security), or REJECT. WAITING ON USER freezes the count. Don't delete closed issues.

Leave DEFINE: could a fresh team build from these files without the interview? Does any UNKNOWN / CONFLICTING / NEEDS USER DECISION block the first slice? Then ask **once**: start BUILD / still open points / decide for me. No BUILD on silence. Do not restart DEFINE as a whole.

⸻

# BUILD

Stop interviewing. `adb/` governs. A slice is done when its SPEC done-criteria are proved. Next slice only if already in `## Execution plan` or the owner asks. Don't park this slice's leftover work as a note with no next move.

User-visible slices — not "entire backend first". Parallel only when jobs don't share files or unfinished deps. Large product: `## Execution plan` in 07.

Hands, always in writing: PlanAgent gets the job + `adb/` and returns plan + done criteria. CodeAgent gets the brief — what, where, done, `adb/` pointers, proof — and returns diff + evidence + commit hash. ReviewAgent gets a commit range and `adb/` pointers, fetches diff and spec itself, and returns TRIED → FOUND → VERDICT, handed to the owner verbatim; no separate reviewer = `Review: self-check`, in STATUS too. A hand is written down even when a role runs in this same chat (`AGENTS.md` fallback); no hand relies on chat history or the builder's story. Heavy (`AGENTS.md`): PlanAgent's plan + done criteria before CodeAgent builds.

**SPEC → BUILD → PROVE → RECORD**

- **SPEC** — what this slice must do, from `adb/`. Heavy: PlanAgent's plan + done criteria written to `adb/` (`## Execution plan`) and committed by MainAgent before Code — that commit is the plan review's range.
- **BUILD** — CodeAgent, smallest safe change. Delete dead code when safe.
- **PROVE** — vs `adb/`, on a real path (`AGENTS.md` Truth).
- **RECORD** — update `adb/` + STATUS, then run `/adb-status` (it increments CARRIED and applies CARRIED-3). Then commit (`AGENTS.md` Hold).

PROVE fails: do not RECORD as done. CodeAgent fixes or registers; fix-round cap in `AGENTS.md`.

`/adb-review` PASS WITH ISSUES: register; RECORD only if PROVE passed and release blockers allow.

Drift is a bug or an intentional spec change — never silent. Spec change → update `adb/` first. Accidental code is not new product truth. Accounting/payment: correctness over brevity; no silent schema change.

Brownfield: KEEP / IMPROVE / REPLACE / REMOVE. Don't rebuild what's right. Don't mechanically port old code.

⸻

# COMPLETION

Not complete because it compiles. Intended behavior exists, real path, spec satisfied, issues under the bar, READINESS stamp current.

| Key | Meaning |
|---|---|
| `NICHT_FERTIG` | Core path broken, spec unsatisfied, or release blockers. |
| `ALPHA` | Core path works. Gaps registered. Not real operations. **Never product complete.** |
| `BETA` | Agreed scope matches `adb/`. Important flows + empty/loading/error on a real path. Only MEDIUM/LOW if the bar allows. |
| `LIVE` | BETA + bar clear + 05 production items. Not "already online." A self-check must not return LIVE. |

The bar chooses BETA vs LIVE, not ALPHA vs BETA. `/adb-ready` only when the owner asks about the **whole app**, not after a slice whose plan is met. ReviewAgent walks the product, writes `READINESS` and overwrites `## Readiness`; MainAgent does not change the key. Stale after a later RECORD or spec change this walk covered.

Method silent, method conflict, or method caused the defect → append `LESSONS.md` in the factory. Still fix the project.

Curious in DEFINE. Aggressive about a product that holds. Conservative about extra code. **The smallest coherent system that delivers the full intended product.**
