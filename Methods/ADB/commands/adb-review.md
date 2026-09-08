---
name: adb-review
description: "ADB independent review. Hand: commit range + adb/ pointers, nothing else. The reviewer fetches diff and spec, tries to break the product, and reports TRIED → FOUND → VERDICT — passed to the owner verbatim."
---

# /adb-review

Canonical: this project’s `ADB.md` (BUILD). Method repo: `SKILL.md`.
Inherit AGENTS.md. MainAgent starts **ReviewAgent** (subagent). Do not invent other worker types. ReviewAgent never implements.

**Hand — exactly two fields, nothing else:**

```
RANGE: <from>..<to>
SPEC:  adb/02-PRODUCT-SPEC.md §…, adb/07-STATUS.md §…
```

No prose brief, no builder evidence, no “please confirm”. The reviewer runs `git diff <from>..<to>` and reads `adb/` itself. Plan review (Heavy, before Code): the range holds the written plan; judge decision-complete, executable without inventing scope, done criteria concrete, no work the spec does not require.

**Reviewing means trying to break it.** Run the tests yourself. Walk the real path (browser if UI; sign in yourself). Break it on purpose where the spec promises something. Green tests ≠ spec. Divergence: A implementation wrong, or B spec changed (update `adb/` first).

Heavy — every line of the matching class, each written as TRIED:
- Money: rounding, double submit / idempotency, reversal.
- Login / permissions: fail-closed, wrong input, another tenant’s data.
- Deploy / infra: rollback path.
- Data migration: way back, partial abort.

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

Without `TRIED` the review is invalid; do not record it. MainAgent passes the report to the owner **verbatim** (STATUS and chat), never as their own summary.

**Self-check:** no separate reviewer (same chat, same session, harness cannot start one) → the report is headed `Review: self-check` and recorded so everywhere, `07-STATUS` included. Never `ReviewAgent: PASS`. A self-check cannot produce an independent PASS.

PASS WITH ISSUES: register via `/adb-triage`. RECORD only if PROVE passed and SKILL.md COMPLETION allows.
