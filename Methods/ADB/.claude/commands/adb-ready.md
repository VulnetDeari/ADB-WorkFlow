---
name: adb-ready
description: "ADB whole-product readiness walk. Review + product-readiness; stamp in STATUS. Not per slice."
---

# /adb-ready

Canonical: this project’s `ADB.md` (COMPLETION). Method repo: `SKILL.md`.
Follow COMPLETION in `ADB.md`. Factory extra if present: `Rules/skills/product-readiness/SKILL.md`.
Inherit AGENTS.md.

MainAgent starts **ReviewAgent** (subagent). Not per slice. No product-code edits. The READINESS key and `## Readiness` carry the reviewer's block; MainAgent enters it verbatim and never alters it — no reviewer block, no stamp.

**Hand — exactly two fields, nothing else.** `/adb-review` rules apply: the reviewer fetches the rest itself, changes nothing in the real tree, breaks on a copy.

```
RANGE: HEAD   (the whole product, no diff)
SPEC:  adb/ pointers
```

The reviewer reads `07-STATUS`, the issue register and the project `AGENTS.md` (URLs) itself. Never the builder’s story.

Walk the **current product** on a real path (browser if UI; sign in yourself). Register issues in the existing register. Do not create a new numbered ADB file. The reviewer's block replaces `READINESS` and `## Readiness`, entered by MainAgent verbatim. A self-check must not return `LIVE`.

```
TRIED
- command or step → what happened
READINESS: NICHT_FERTIG | ALPHA | BETA | LIVE
READINESS-BY: independent | self-check
GAPS: none | ISSUE-IDs
STALE-NEXT: later RECORD / spec this walk covered changes
```

No separate reviewer → the block is headed `Review: self-check` and `READINESS-BY: self-check`; never an independent stamp.
