---
name: adb-review
description: "ADB independent review. Hand: commit range + adb/ pointers, nothing else. The reviewer fetches diff and spec, tries to break the product on a copy, and reports TRIED → FOUND → VERDICT — passed to the owner verbatim."
---

# /adb-review

Canonical: this project’s `ADB.md` (BUILD). Method repo: `SKILL.md`.
Inherit AGENTS.md. MainAgent starts **ReviewAgent** (subagent). Do not invent other worker types. ReviewAgent never implements.

**Hand — exactly two fields, nothing else:**

```
RANGE: <from>..<to>
SPEC:  adb/02-PRODUCT-SPEC.md §…, adb/07-STATUS.md §…
```

No prose brief, no builder evidence, no “please confirm”. The reviewer runs `git diff <from>..<to>` and reads `adb/` itself. Plan review (Heavy, before Code): the range is the plan commit — SPEC writes the plan to `adb/` and MainAgent commits it before Code starts (`ADB.md` BUILD). Judge: decision-complete, executable without inventing scope, done criteria concrete, no work the spec does not require.

**The reviewer changes nothing in the repo.** No writes, no commits, no resets in the real working tree. Tests and breaking runs happen on a copy (`git worktree add <tmp> <to>` or a throwaway clone), removed afterwards. Last line of TRIED: `git status --porcelain` empty and `HEAD` unchanged in the real tree.

**Reviewing means trying to break it.** Run the tests yourself. Walk the real path (browser if UI; sign in yourself). Break it on purpose where the spec promises something. Green tests ≠ spec. Divergence: A implementation wrong, or B spec changed (update `adb/` first).

Heavy — every line of the matching class, each written as TRIED:
- Money: rounding, double submit / idempotency, reversal.
- Login / permissions: fail-closed, wrong input, another tenant’s data.
- Deploy / infra: rollback path.
- Data migration: way back, partial abort.

**Severity:** CRITICAL — data loss, money wrong, security hole, core path broken. HIGH — a spec promise fails on a real path, or a Heavy line above fails. MEDIUM — works, but wrong in an edge, an empty / loading / error state, or drifts from `adb/`. LOW — wording, cosmetics, cleanliness.

**Verdict:** FAIL — any CRITICAL or HIGH, spec diverges, or the real path could not be tried. PASS WITH ISSUES — only MEDIUM / LOW, each registered. PASS — nothing found. RELEASE BLOCKERS — every CRITICAL, and every HIGH touching data, money, or security; listed by finding.

**Report — this format, nothing added, nothing summarized:**

```
TRIED
- command or step → what happened
FOUND
- [SEVERITY] finding — evidence — expected
VERDICT: PASS / FAIL / PASS WITH ISSUES
SPEC COMPLIANCE: satisfied / diverges (A or B)
RELEASE BLOCKERS: none / list
```

Without `TRIED` the review is invalid; do not record it. MainAgent passes the report to the owner **verbatim**: in chat, and in `07-STATUS` under `## Last review` (a preserved section like `## Readiness`) — never as their own summary.

**Self-check:** no separate reviewer (same chat, same session, harness cannot start one) → the report is headed `Review: self-check` and recorded so everywhere, `07-STATUS` included. Never `ReviewAgent: PASS`. A self-check cannot produce an independent PASS.

PASS WITH ISSUES: register via `/adb-triage`. RECORD only if PROVE passed and SKILL.md COMPLETION allows.
