# Factory repair validation

Implementation acceptance is defined in `WORKFLOW-CHECKS.md` and the factory README. This file records evidence; it adds no rules to product projects.

- Original committed factory baseline: `check-factory.sh` passed in an isolated Git archive on Windows with Git Bash and Python 3.
- Structural distribution: `check-layout.py --self-test` passed; four isolated mutations (duplicate AGENTS, changed command copy, missing target section, extra command procedure) were rejected, and each restored layout passed.
- Full factory suite: passed on Windows with Git Bash and Python 3. Covered Start, PLAIN/ADB switching, risk selection, ownership preservation, real historical hook removal/restoration, secret/hidden-content checks, CRLF hooks and incomplete factory copies.
- Refresh preservation suite: passed. Covered unchanged project rules, owner settings, reading page, method choice, product documents and unrelated files; read-only checks; foreign harness/command/hook conflicts before writes; integrated and retired project hooks; external hook paths; current and historical CRLF commands.
- Skill metadata: ADB, Start and product-readiness passed the skill validator with UTF-8 input.
- Independent source review: ownership findings corrected and rechecked. A separate Git query reproduced the historical-command path bug (0 relative-path results, 18 root-anchored results); the corrected lookup was independently confirmed.
- Independent command runtime checks: historical release `f78057f89d5b910b61a3254c0dd05b4383be24b0` with CRLF passed dry-run without changes and actual installation with all 21 copies matching. A foreign change in the last harness blocked both operations before any partial update. Repeated successfully against the final standalone-directory guard; a file replacing a harness directory also blocked dry-run, installation and removal with the complete fixture unchanged. Independent verdict: PASS in the tested scope, no remaining findings.
- Independent instruction scenarios: new-product scope approval, a precise tiny task, mandatory MEDIUM findings, missing capabilities, project rules, explicit bounded exceptions, delegated choices/current corrections, no recursive teams and issue aging produced the intended next actions. These are instruction evaluations, not actual product builds.

After the full suites, setup's obsolete fixed-question warning was aligned with Start, and the historical-command fixture was pinned to an older release selection so it remains historical after committing. A standalone command-directory guard received focused validation separately; unrelated passing suite evidence remains applicable. No interrupted run was counted as a passing suite.

Final independently exercised installer SHA256: `9B252EA7CFF34D891BBDA090403CD79ED540C3FC457784F3F5F8AEF5FFADEE82` (working-tree bytes). The commit containing this record identifies the complete implementation; no product repository is part of this change.

Native symlink creation was unavailable under the host's Windows permissions. That conditional runtime case is UNVERIFIED, not included in the PASS claim. Installed commands use ordinary files. Historical ownership migration requires sufficient factory Git history; unknown older content is preserved/refused when the history is absent.

No target product was refreshed. No live service was deployed. Harness reference syntax was checked against the official documentation linked in README; this is not an end-to-end execution claim for every harness. Workflow scenario evaluation is distinct from script tests and does not prove future model compliance.
