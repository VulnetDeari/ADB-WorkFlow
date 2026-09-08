---
name: adb-status
description: "Rewrite ADB STATUS and judge the work against completion."
---

# /adb-status

Canonical: this project’s `ADB.md`. Method repo: `SKILL.md`.
Reload existing `adb/` files. Those files outrank chat.

1. **Rewrite** `07-STATUS` header only: PHASE, NOW, NEXT, BLOCKERS, OPEN, READINESS. Concise overwrite, not a changelog. Preserve `## Open issues` (collapsed), `## Execution plan`, `## Slice plan`, `## Readiness`, `## Last review` verbatim. Do not invent READINESS — it is the reviewer's block from `/adb-ready`, entered verbatim, never altered.
2. **Layout** — numbered `adb/` names only; one issue register (08, or STATUS while collapsed — not both). `ADB.md` is the method copy.
3. **Drift** — code vs `adb/`. Accidental code is not new product truth.
4. **CARRIED** — this review counts (SKILL.md Issues).
5. **Whole product** — COMPLETION is the **app**, not this slice. A finished slice can stand without a READINESS stamp. Do not set next=`/adb-ready` just because a stamp is missing. `/adb-ready` only when the owner asks about the whole app. ALPHA is never whole-product complete.
6. **Optional** — method defect → append `LESSONS.md` in the ADB repo. Still fix the project.

Return: phase, now, next, blockers, open count.
