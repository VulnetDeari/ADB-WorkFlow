---
name: adb-slice
description: "ADB BUILD one slice. Closes only after PROVE and RECORD."
---

# /adb-slice

Canonical: this project’s `ADB.md` (BUILD). Method repo: `SKILL.md`.
Inherit AGENTS.md. If DEFINE was not approved → `/adb-define`. MainAgent directs; CodeAgent builds and proves.

1. **Plan** — user-visible slices from `adb/`. Not “entire backend first”. Parallel only when jobs don’t share files or unfinished deps.
2. **Brief** — goal, path, `adb/` pointers, scope, proof. Heavy: Plan writes plan + done criteria into `07-STATUS` `## Slice plan`, MainAgent commits them before Code (the plan review's range). Do not skip Plan.
3. **Loop** — SPEC → BUILD → PROVE → RECORD. PROVE fail → not done. Fix-round cap 3, then the owner (not `CARRIED`). Git: AGENTS.md.
4. **Close** — RECORD + CARRIED. SPEC met → this slice is done; do not invent a next slice. Next only if already in `## Execution plan` or the owner asks. Else: what’s left in the plan.

Accounting or payment: correctness over brevity; no silent schema change.
