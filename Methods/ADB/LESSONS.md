# ADB Lessons

Append-only record of defects in the method itself, found by real projects (P61A).

This file is not an issue tracker. Project problems belong in that project's `adb/08-OPEN-ISSUES.md`. Only findings whose root cause is ADB itself belong here.

Nothing here changes the method until the user adopts it. STATUS says whether that happened.

No `PROJECT:` field: the factory is public, so an entry names no project, account, tool, or person. When the kind of project matters, SYMPTOM says it. The field was dropped and earlier entries anonymized on 2026-09-08 (L-045).

---

## L-001 — Setup never enforced the issue-register location

DATE: 2026-08-26
SYMPTOM: The project kept its issue register at the repository root as `OPEN-ISSUES.md`, declared that file canonical inside the file itself, and also carried an `## Open issues` section in `adb/07-STATUS.md`. `adb/08-OPEN-ISSUES.md` did not exist although the Source of Truth was not collapsed. Three candidate locations, and the STATUS section claimed `0` open issues while real unresolved conflicts existed.
ROOT CAUSE: P15 forbids alternate filenames and P23 names the register, but nothing in the method verifies the register's location once a project is running. The inherited `AGENTS.md` already routed ADB projects to `adb/08-OPEN-ISSUES.md`, so the method and its own rules file disagreed in practice with no point responsible for noticing. Method silent where the project needed a rule.
PROPOSED CHANGE: Give the status review an explicit Source-of-Truth layout check: the numbered files present, no ADB content living under non-ADB filenames, no topic duplicated between a numbered file and an ad-hoc one.
STATUS: ADOPTED — added as Step 2A of `/adb-status`, 2026-08-26.

---

## L-002 — No terminating condition for open issues

DATE: 2026-08-26
SYMPTOM: The product could sit indefinitely in "almost complete". P61 correctly refused to call it complete, but nothing forced any open issue toward an exit, so a status review could run any number of times and produce the same verdict with no progress.
ROOT CAUSE: P50 defines what blocks release and P61 defines what completion means, but neither bounds how long an issue may stay OPEN. A gate that can be re-failed forever is a report, not a gate.
PROPOSED CHANGE: Count how many reviews each issue survives and force an exit — FIX, ACCEPT or REJECT — at a fixed count.
STATUS: ADOPTED — added as P50A ISSUE CONVERGENCE and the `CARRIED` field in P25, 2026-08-26.

---

## L-003 — Project copies of the method have no age

DATE: 2026-08-26
SYMPTOM: The project's `ADB.md` was modified but uncommitted. Its working copy was byte-identical to the canonical `SKILL.md`, so the committed version was some older method revision — but which one, and how old, was not answerable from the repository.
ROOT CAUSE: Setup copies the method into the project and the copy carries no provenance. A copy with no version is unfalsifiable.
PROPOSED CHANGE: Stamp the copy with the canonical repository's short git sha and date on its first line.
STATUS: ADOPTED — added as P1A METHOD VERSION, 2026-08-26.

---

## L-004 — P1A collided with the frontmatter it was written for

DATE: 2026-08-26
SYMPTOM: P1A demanded the `METHOD-VERSION` stamp on the first line of the project `ADB.md`. The canonical `SKILL.md` opens with a YAML frontmatter block, and the project copy keeps it. Following P1A literally would have pushed `---` to line 3 and broken the block for any harness that parses it.
ROOT CAUSE: The point was written without checking the file it governs. A rule about a copy must hold for the actual shape of that copy.
PROPOSED CHANGE: Allow the stamp as the first line after the frontmatter block, and forbid placing it above frontmatter.
STATUS: ADOPTED — P1A reworded 2026-08-26, same day it was introduced.

---

## L-005 — Slash commands were installed into the user home

DATE: 2026-08-26
SYMPTOM: `/adb-define` and the other four commands appeared in every Cursor, Codex and Claude session, including projects without `METHOD: ADB`.
ROOT CAUSE: `install-commands.sh` targeted `$HOME/.cursor/commands`, `$HOME/.codex/prompts` and `$HOME/.claude/commands`. P1 forbids ADB from affecting ordinary work in unrelated projects. A home-level command list is exactly that.
PROPOSED CHANGE: Install into the project's own harness directories. Remove leftover home-level links. State the rule in P1.
STATUS: ADOPTED — installer is project-scoped; P1 forbids home-level installs; `--remove-global` cleans leftovers, 2026-08-26.

---

## L-006 — Project helpers copied ADB.md without stamp, commands, or adb/08

DATE: 2026-08-26
SYMPTOM: Project helpers wrote `METHOD.md` and a bare `ADB.md`, but left no `METHOD-VERSION` stamp, installed no project-local slash commands, and still created a root `OPEN-ISSUES.md` that contradicts the issue-register rule.
ROOT CAUSE: Setup lived outside the method. The method gained a version stamp, project-scoped commands and the numbered issue register; the helpers were never updated.
PROPOSED CHANGE: One `setup-into-project.sh` that stamps and installs commands into the project. Do not auto-create Vision/Spec — that is DEFINE.
STATUS: ADOPTED — 2026-08-26.

---

## L-007 — Chip labels vs A/B/C Decision Questions

DATE: 2026-08-26/27
SYMPTOM: Draft decision UI used Perplexity-style chip labels. Agents and drafts drifted toward long label text instead of single-letter answers. That conflicted with global `AGENTS.md` Decision Questions (A/B/C + „Entscheide du“).
ROOT CAUSE: A feature sketch taught a discarded interaction. The method and the reading copy already followed A/B/C; the feature note still named “chips” and looked like an open path.
PROPOSED CHANGE: Keep A/B/C + „Entscheide du“ as the only rule. Mark chips rejected. Rename the feature note so the filename does not teach chips.
STATUS: SUPERSEDED — 2026-09-01 by L-019: owner wants chips; keep labels short. Long Perplexity-style chip sentences stay forbidden.

---

## L-008 — Project copy of the method was a second source

DATE: 2026-08-28
SYMPTOM: Setup copied `SKILL.md` into every project as `ADB.md`, then needed a version stamp, a STALE check, and slash commands that restated the method so they would not cite a stale copy. Agents had two method files. P60 was cited though it had no own section.
ROOT CAUSE: A copy ages. Machinery to keep the copy honest became larger than the method. Commands restated `SKILL.md` instead of pointing at it.
PROPOSED CHANGE: Do not copy the method into the project. `METHOD.md` is the switch. Agents read canonical `SKILL.md`. Commands stay short. Leftover `ADB.md` is ignored; `--refresh` removes it. Drop the P60 citation.
STATUS: ADOPTED — 2026-08-28.

---

## L-009 — Rulebook should state who sets the destination

DATE: 2026-08-28
SYMPTOM: The method explained phases and files. It did not say in one place: the owner sets where the product must land; the agent writes that down, builds in slices that fit context, and proves it (browser, tests, logins).
ROOT CAUSE: The method was written as numbered process. The reason it exists is a non-programmer owner.
PROPOSED CHANGE: Open `SKILL.md` with that job. DEFINE / BUILD / COMPLETION in plain language. Commands point at those sections, not at old point numbers.
STATUS: ADOPTED — 2026-08-28.

---

## L-010 — Naming another product method kept it in play

DATE: 2026-08-31
SYMPTOM: Agents treated a name in the files as a peer method and followed leftover folders and commands.
ROOT CAUSE: The method was defined against that name. Naming it taught agents it still exists.
PROPOSED CHANGE: Write only this method. Setup writes `METHOD: PLAIN` or `METHOD: ADB`. Existing product docs stay as brownfield evidence for DEFINE.
STATUS: ADOPTED — 2026-08-31.

---

## L-011 — A dropped chat UI and Lead were still in the method after they were gone

DATE: 2026-08-31
SYMPTOM: The method still named a retired chat UI (decision chips, upstream issue) and treated Lead as an orchestra role for the READINESS key. That UI is gone.
ROOT CAUSE: Those names were leftover. After they were dropped, the files still taught agents to wait for that UI or a missing orchestra Lead.
PROPOSED CHANGE: Remove the retired UI name. Decision rule stays A/B/C + decide-for-me. Review writes READINESS. Briefs are executable without a worker role.
STATUS: ADOPTED — 2026-08-31.

---

## L-012 — ADB without Lead contradicted factory AGENTS.md

DATE: 2026-08-31
SYMPTOM: After L-011, ADB told the reading agent to implement, prove, and commit only if the owner asked; it allowed spawning a reviewer and loading ADB without `METHOD: ADB`. Factory `AGENTS.md` says Lead only directs, Code implements and auto-commits when the job is done, never spawn, and do not load ADB when `METHOD.md` is missing or `PLAIN`.
ROOT CAUSE: L-011 dropped an orchestra name “Lead” and took the session Lead with it. ADB restated git and activation instead of deferring to AGENTS.md.
PROPOSED CHANGE: Lead/Plan/Code/Review stay. ADB must not contradict AGENTS.md: Lead directs; never spawn; Code commits when the job is done; ADB loads only when `METHOD: ADB`; A/B/C includes scopes.
STATUS: ADOPTED — 2026-08-31.

---

## L-013 — A removed commit-gate skill is gone

DATE: 2026-08-31
SYMPTOM: ADB still required a named review-before-commit skill PASS and treated it as the commit check. That skill no longer exists.
ROOT CAUSE: ADB copied a dead skill name from the factory instead of deferring git to AGENTS.md without naming a removed tool.
PROPOSED CHANGE: Do not name removed tools. `/adb-review` stays (independent product review). Git: Code commits when the job is done (AGENTS.md). CARRIED is not the PROVE 3-round cap.
STATUS: ADOPTED — 2026-08-31.

---

## L-014 — ADB restated the OS until the product rules were hard to see

DATE: 2026-08-31
SYMPTOM: After aligning with factory `AGENTS.md`, SKILL.md and every slash command repeated Lead / spawn / git / extra process names. Agents had to wade through factory rules to reach DEFINE / BUILD / COMPLETION. No product rule was added; the same rules were said three times.
ROOT CAUSE: Alignment copied AGENTS.md into ADB instead of one inherit line plus the product method.
STATUS: ADOPTED — 2026-08-31.

---

## L-015 — Projects must carry a copy; nobody fetches the method repo

DATE: 2026-08-31
SYMPTOM: After L-008, setup did not copy `SKILL.md`. Agents were told to follow the method repo. New and existing projects never fetched it, so they kept an old method or none.
ROOT CAUSE: One canonical file only works if every project can reach that file. These projects do not.
PROPOSED CHANGE: Setup copies `SKILL.md` to project `ADB.md`, stamps `METHOD-VERSION`, and installs slash commands as copies. Agents follow `ADB.md`. `--refresh` updates copy and commands. STALE if the copy differs and was not refreshed.
STATUS: ADOPTED — 2026-08-31.

---

## L-016 — Role names Lead / Plan / Code / Review were unclear

DATE: 2026-09-01
SYMPTOM: Public clones could not tell who they were talking to. “Lead” sounded like an orchestra boss; “Plan / Code / Review” looked like verbs, not the three living workers. Agents still spawned one-shots or did all work in the chat.
ROOT CAUSE: The split was already in `AGENTS.md` (direct vs do). The names did not say that.
PROPOSED CHANGE: Same four roles, clearer names: **MainAgent** (talks to the owner, most work handed off), **PlanAgent**, **CodeAgent**, **ReviewAgent**. Still never spawn. One-shot Tasks are not those three. If this session already is the living worker, or none exists to turn on, this session does the job and names the role.
STATUS: ADOPTED — 2026-09-01.

---

## L-017 — CodeAgent is a subagent, not an owner chat

DATE: 2026-09-01
SYMPTOM: After L-016 the rules still talked about PlanAgent/CodeAgent/ReviewAgent **tabs**. The owner does not have those chats. CodeAgent is a subagent MainAgent starts. The “open the other card / one session” exception made the method unreadable.
ROOT CAUSE: “Living named agent” was copied from an orchestra of owner-facing chats. This method has one owner chat: MainAgent.
PROPOSED CHANGE: Owner talks only to MainAgent. PlanAgent, CodeAgent, ReviewAgent are named subagents for a job. No extra worker types. If the harness cannot start a subagent, MainAgent does the job in this chat and names the role.
STATUS: ADOPTED — 2026-09-01.

---

## L-018 — Forced subagents on every Plain job wasted context

DATE: 2026-09-01
SYMPTOM: After L-017, MainAgent was told to start CodeAgent for most work. Small Plain jobs split context for no gain. The owner asked whether subagents only help from scratch; the real split is ADB / Heavy vs Plain.
ROOT CAUSE: “Most work goes to subagents” treated a one-shot worker as always cheaper than the owner chat. For a small change it is slower and forgets the thread.
PROPOSED CHANGE: Require named subagents only when `METHOD: ADB` or the job is Heavy. PLAIN and not Heavy: MainAgent does the work in this chat and names the role. Harness cannot start a required subagent → same chat, name the role.
STATUS: ADOPTED — 2026-09-01.

---

## L-019 — Owner wants chips, not A/B/C

DATE: 2026-09-01
SYMPTOM: Start and Decision Questions asked A/B/C. The owner does not want to type letters. They asked for chips.
ROOT CAUSE: L-007 rejected chips because long label text was worse than a letter. That banned the click UI instead of banning only long labels.
PROPOSED CHANGE: Short chips (1–4 words), last = decide-for-me. Native picker when the harness has one (Cursor `AskQuestion`). No letters in the prompt. Typed A/B/C still maps. Long chip sentences stay forbidden.
STATUS: ADOPTED — 2026-09-01. SUPERSEDED in part by L-022 (A/B/C when chips are not clickable). `FEATURE-decision-options.md`, `AGENTS.md`, `START.md`.

---

## L-020 — Do not name other product methods

DATE: 2026-09-01
SYMPTOM: Reading copies and agent files named methods that are not this one, including that they were gone. The owner was confused about what we mean.
ROOT CAUSE: Contrast against a former name teaches that name.
PROPOSED CHANGE: Write only PLAIN and ADB. Do not mention other product methods, and do not say they used to exist.
STATUS: ADOPTED — 2026-09-01.

---

## L-021 — METHOD.md did not follow a PLAIN↔ADB switch

DATE: 2026-09-02
SYMPTOM: Re-Start small↔large (or `risk=yes` forcing ADB) updated `OWNER.md` / `LESEN.html` and could install or skip `ADB.md`, while `METHOD.md` stayed on the old line. `--plain` left `ADB.md` and `/adb` commands in place. Agents then loaded the wrong method, or none.
ROOT CAUSE: Setup refused to overwrite `METHOD.md` when it already said PLAIN or ADB, so Start could not switch. Cleanup on PLAIN was never implemented. Honoring flags on every setup call then let `--refresh` invent a switch and desync `OWNER.md` / `LESEN.html`.
PROPOSED CHANGE: Start is the switch (`--switch`). Setup writes `METHOD.md` from flags only on first layout or `--switch`. `--plain` then removes `ADB.md` and `/adb` commands; product `adb/` stays. `--refresh` without Start does not flip. `check-factory.sh` proves PLAIN, `risk=yes`, both Start flips, and that setup/refresh without Start keep the existing method.
STATUS: ADOPTED — 2026-09-02.

---

## L-022 — A/B/C when chips are not clickable

DATE: 2026-09-03
SYMPTOM: Short chip labels in backticks (or a missing native picker) are not clickable in every harness. The owner could not reliably answer Start and Decision Questions without inventing a format.
ROOT CAUSE: L-019 banned letters in the prompt so agents never showed A/B/C when `AskQuestion` was absent. Backtick rows do not equal a click UI.
PROPOSED CHANGE: Chips when the harness has a native clickable picker; otherwise lettered A/B/C with the same short labels. Never both at once. Click, label, or letter all count.
STATUS: ADOPTED — 2026-09-03. `AGENTS.md` Talk, Start skill, `FEATURE-decision-options.md`, LESEN templates.


---

## L-023 — Daily rule files carried setup mechanics; hard rules were only prose

DATE: 2026-09-03
SYMPTOM: `AGENTS.md` (84 lines) spent about a quarter on Start triggers, factory notes, harness home links, and the chips-vs-letters history. `ADB.md` opened with stamp and STALE mechanics. Agents read that every session and it protects nothing. Rules that must never fail (secrets in git, push to main without the owner) were sentences an agent could forget. The method changed 22 times in 8 days; several lessons reversed each other, and every change meant a refresh in every project.
ROOT CAUSE: One file served three readers: the daily agent, the setup script, and the first-run. Guarantees were written as advice. No cadence for method changes.
PROPOSED CHANGE: `AGENTS.md` keeps only what prevents mistakes in daily work (Talk, Truth, Work, Hold); Start lives in `START.md`, mechanics in the scripts. `ADB.md` drops stamp/STALE text. Two git hooks installed by setup: pre-commit blocks secrets, pre-push blocks main unless `ALLOW_MAIN_PUSH=1`. Owner conduct rules that had lived in a harness system prompt (mirror before acting, do it or offer it, ask before delete/deploy/money/live data, landing by squash, no local memory) move into `AGENTS.md`. Method changes are collected and refreshed into projects at most monthly unless a defect blocks work.
STATUS: ADOPTED — 2026-09-03.

---

## L-024 — ADB.md repeated AGENTS.md; tests and README were not mandatory

DATE: 2026-09-04
SYMPTOM: Checked against the copies that land in a product (test project via Start): `ADB.md` restated Heavy, roles, chips, the 2FA exception, the fix-round cap, git and "don't interrupt for reversible details" — all already in `AGENTS.md`. Two files, one rule, drift risk on every edit. `AGENTS.md` never required running the project's tests or reading the README first, although the measured value of an agent rules file lies in concrete project facts (commands, boundaries) and a check the agent can run.
ROOT CAUSE: ADB was written to stand alone, then AGENTS.md absorbed the shared rules without ADB dropping them. Test discipline was habit, not rule.
PROPOSED CHANGE: `AGENTS.md` (every project): "Read first" line for README, OWNER.md, METHOD.md; tests before start and before every commit, red = no commit. `ADB.md` (large only): keeps DEFINE / Source of truth / Issues / BUILD loop / COMPLETION and points at `AGENTS.md` for everything shared. Factory and Start notes reduced to one sentence each.
STATUS: ADOPTED — 2026-09-04. Landed copies: AGENTS.md 713 words, ADB.md 985 words.

---

## L-025 — Second-model review of the landed copies

DATE: 2026-09-04
SYMPTOM: An independent agent (Antigravity, Gemini) read only the landed `AGENTS.md` and `ADB.md`. Accepted findings: "mirror and wait for yes" read as blocking even read-only research; Heavy was defined by project domain, so every fix in an app with login or money looked Heavy; CARRIED looked like a manual count; the hand-offs between PlanAgent, CodeAgent and ReviewAgent were only implied. Rejected: dropping the collapsed 01/02/07 default (it prevents empty mandatory files in small products).
PROPOSED CHANGE: Wait for yes only before changing something; Heavy judged by what the change touches, not what the project contains; CARRIED incremented only by `/adb-status`; one line naming what each role receives and returns.
STATUS: ADOPTED — 2026-09-04.

---

## L-026 — Two contradictions introduced by L-025, caught by the second-model re-read

DATE: 2026-09-04
SYMPTOM: After L-025, `ADB.md` said "Only /adb-status increments CARRIED" in Issues and "increment CARRIED" in RECORD. It also said "Nobody gets chat history" while `AGENTS.md` allows a role to run in the same chat when the harness cannot start a subagent.
ROOT CAUSE: A rule was tightened in one place without re-reading the other places that state the same step.
PROPOSED CHANGE: RECORD runs `/adb-status` instead of counting; hands are written down even when a role runs in the same chat, and no hand relies on chat history.
STATUS: ADOPTED — 2026-09-04.

---

## L-027 — A shared component library sent five agents to build the same things five times

DATE: 2026-09-05
SYMPTOM: Round 2 built a component library and one view on it (the home screen), then round 3 ran five CodeAgents in parallel, each on a different screen, all against that library. Every one of the five hit the same holes and had to work around them inside its own files: the form components emit `<button>` and no `name=` fields, so `FormData` reads nothing and no settings form can save; `knopf()` cannot be `type="submit"`; `leiste()` — the navigation bar every screen except home needs — does not exist in `parts.js` at all; `blatt()`, the shell for a scrolling sub-view, is missing; a view cannot close its own sheet because the close button is wired to the menu sheet. Three groups reported the form problem independently. The same widget now sits in the repo up to five times — exactly the duplication a shared library exists to prevent.
ROOT CAUSE: The library was proven against **one** screen, and that screen happened to need none of the missing pieces: the home screen has no form, no navigation bar, and no sub-view. "It works for the showcase page" was mistaken for "it is ready".
PROPOSED CHANGE: Before a shared library is handed to parallel builders, prove it against **at least two structurally different screens — one list and one form** — not only against the showcase. The proof is that the second screen needs no component built outside the library. Alternatively, run the first two screens sequentially and only then fan out.
STATUS: PROPOSED — 2026-09-05.

---

## L-028 — Parallel agents in one working tree share the git index, not just the files

DATE: 2026-09-05
SYMPTOM: Five agents worked in the same checkout. Each was told to commit only its own files by name and never `git add -A`. They followed it — and it still went wrong twice: one group's `git commit` picked up another group's already-staged files, and MainAgent's own commit of a single documentation file carried five foreign source files with it. One group ended up with no commit of its own; HEAD was briefly broken because `shell.js` imported a file not yet committed.
ROOT CAUSE: `git add <file>` scopes what *you* stage, but the index is shared across everyone working in that tree. A later `git commit` without a path argument commits **everything staged**, including what another agent staged seconds earlier. The rule "never `git add -A`" reads like sufficient protection and is not.
PROPOSED CHANGE: With more than one agent in one working tree, commit with an explicit path list — `git commit -- <paths>` — which ignores the shared index. Name up front who commits the shared files (registration, navigation, spec), so the last one to finish does not book everyone else's work under their name. If the harness supports it, give each parallel builder its own worktree instead.
STATUS: PROPOSED — 2026-09-05.

---

## L-029 — Green checks that checked nothing

DATE: 2026-09-05
SYMPTOM: Eight checks reported green and proved nothing, each of them rule-compliant ("tests green", "evidence delivered"): a test environment that never had the login screen it claimed to test; a reconciliation that confirmed a lost amount as "matches" because both sides had become 0; "eight benches green" over a self-chosen set (there were 13, one red); a check command that never ran, whose error message was read as the answer — an hour later a branch was gone.
ROOT CAUSE: `AGENTS.md` Truth said "Green tests ≠ spec satisfied" — true, abstract, and nothing an agent can act on. Nothing required a check to have been seen failing. A check that cannot go red is a report with a green label.
PROPOSED CHANGE: The counter-proof, one sentence in Truth: a check counts only once you have seen it fail on exactly what it promises — undo the fix or break the code on purpose, that one assurance goes red, nothing else. Applied the same day, it caught three of the agent's own mistakes before review saw them.
STATUS: ADOPTED — 2026-09-05, `AGENTS.md` Truth.

---

## L-030 — An enforcer that doesn't know the exception enforces the rule against it

DATE: 2026-09-05
SYMPTOM: "origin keeps only main" was enforced by a scheduled cron workflow. It deleted the temporary exception branch `vorschau`. The exception lived only in the docs and in the pushed branch; a `schedule` run always takes the workflow file from the default branch, which had never heard of it.
ROOT CAUSE: The rule was right. The exception was recorded where humans read, not where the enforcer reads. `AGENTS.md` Hold said "leave no branches behind" and nothing about how to keep one on purpose.
PROPOSED CHANGE: One sentence in Hold: an exception is told to every enforcer of that rule (hook, workflow, cron), or the enforcer is switched off with date and re-enable condition on record.
STATUS: ADOPTED — 2026-09-05, `AGENTS.md` Hold.

---

## L-031 — Two projects shared a key by name and nobody kept the list

DATE: 2026-09-05
SYMPTOM: The web app wrote `NOTIFY_X_PUSH`, its sibling script project read `NOTIFY_Y_PUSH`. Each side correct on its own, every test green; the switch had been silently dead for months. Its default was "on", so a broken switch looked exactly like a working one. Found only by laying two lists side by side — which nobody had done, because there is no code there.
ROOT CAUSE: The harness-level rule for all agents, "report schema changes to the orchestrator", covers changes, not the existing inventory (that sentence is not in the factory `AGENTS.md`). No rule said where a shared list lives or that both sides test against it.
PROPOSED CHANGE: One sentence in Hold: keys or names shared with another project — exactly one place keeps the list, both sides test against it. The list itself is project work (the script project keeps it as a test file), not factory.
STATUS: ADOPTED — 2026-09-05, `AGENTS.md` Hold.

---

## L-032 — Harness system prompt repeated product rules

DATE: 2026-09-06
SYMPTOM: The orchestration harness's system prompt restated language, owner-is-not-coder, per-project scope, shared-sheet notice, and factory-refresh — all needed by agents that never see that harness (other editors, script-only agents, other hosts).
ROOT CAUSE: The host prompt mixed orchestration (the orchestrator role, its protected list, machine specifics) with product agent rules.
PROPOSED CHANGE: Factory `AGENTS.md` owns Scope (this project only), factory-only rule edits + refresh, shared-contract notice to the owner, short sentences / owner does not program. The harness prompt keeps only: owner and orchestrator roles, machine specifics, the orchestrator's protected list.
STATUS: ADOPTED — 2026-09-06, `AGENTS.md` Job/Scope/Hold; harness prompt slimmed.

---

## L-033 — Harness files held parallel agent rules

DATE: 2026-09-06
SYMPTOM: Some products had rich `CLAUDE.md` / Copilot instructions; others only `@AGENTS.md`. Agents that open the harness file first never saw the factory rules, or drifted from a second copy.
ROOT CAUSE: Setup wrote `AGENTS.md` but not the harness entry pointers.
PROPOSED CHANGE: Setup always writes `CLAUDE.md`, `GEMINI.md`, and `.github/copilot-instructions.md` as only `@AGENTS.md`. Factory `AGENTS.md` states that rule. `--refresh` overwrites drift.
STATUS: ADOPTED — 2026-09-06, `setup-into-project.sh`, `AGENTS.md`.

---

## L-034 — Waiting dressed up as in progress

DATE: 2026-09-07
SYMPTOM: Agents reported work as underway when nothing was running — plan done, waiting for go-ahead / "Bauen", or simply forgotten. Soft reframes ("I was only waiting") hid the truth when the owner asked "forgotten?".
ROOT CAUSE: Truth covered real-life proof and done criteria, not status honesty while idle. Progressive tense and silent approved plans / unfinished Push Main had no rule against them.
PROPOSED CHANGE: One paragraph in Truth: waiting is waiting; forgotten is yes; remind on stalled plans and Push Main; no progressive tense unless that step is actually running.
STATUS: ADOPTED — 2026-09-07, `AGENTS.md` Truth.

---

## L-035 — Commit titles are not evidence

DATE: 2026-09-08
SYMPTOM: A commit titled "removed X" still contained X; the visible top of the file looked clean.
ROOT CAUSE: Agents checked the title and the first lines, not the Git object.
PROPOSED CHANGE: Any claim that a file is clean or identical is proven by the Git object — blob hash (`git rev-parse REF:path`) or byte size (`git show REF:path | wc -c`) — never by a title or a glance.
STATUS: ADOPTED — 2026-09-08, `AGENTS.md` Truth, one sentence shared with L-038.

---

## L-036 — Hidden trailing content

DATE: 2026-09-08
SYMPTOM: Foreign code sat on the last line behind hundreds of spaces; every editor showed a clean file, and a single-marker search missed a second variant.
ROOT CAUSE: Search for one known marker instead of the shape of the trick.
PROPOSED CHANGE: On suspicion, scan broadly on `HEAD` and `origin/main`, excluding lockfiles and binaries: lines with ≥200 consecutive spaces, `eval(`, `atob(`, `new Function(`, `global.<short>=`, `_$_`, `_0x`. Zero hits before push; zero hits on `origin/main` after push.
STATUS: ADOPTED — 2026-09-08, `Rules/hooks/pre-commit` block 4 on added lines, bytewise: a run of 200+ blanks (space, tab, VT, FF, NBSP as UTF-8 or single byte 0xA0, NEL, 0x1C–0x1F, zero-width and other Unicode spaces) and a CR followed by visible text — in every scanned file, Markdown included, because in this method the Markdown is what runs; `_0x…` / `_$_…` at identifier start — not in `*.md` / `*.txt`, which name the markers; not `eval`/`atob`/`Function` (real code uses them and the hook has no bypass). Not scanned, by decision: `vendor/` and `node_modules/` at any depth, root-level `dist/` and `build/`, lockfiles, `*.min.*`, `*.map`, `*.svg` — those are for the manual sweep above. A scan that cannot run blocks. `pre-push` was removed with L-039. Counter-proofs in `check-factory.sh`. Revised by L-046, L-052, L-055 to L-058.

---

## L-037 — No Git working tree inside a cloud-sync folder

DATE: 2026-09-08
SYMPTOM: `[conflicted N]` copies appeared, a freshly written file was renamed within minutes, file contents changed without any commit.
ROOT CAUSE: The working tree was inside a two-way sync client.
PROPOSED CHANGE: Working trees live outside every sync folder; the remote is the sync. When `[conflicted]` files appear, check the sync client first, not Git.
STATUS: ADOPTED — 2026-09-08, `setup-into-project.sh` warns (does not refuse) when the project path names a sync client. Counter-proof in `check-factory.sh`.

---

## L-038 — CRLF distorts measurements and tests

DATE: 2026-09-08
SYMPTOM: Byte counts in the working tree differed from the Git object; tests that read source were red locally and green in CI.
ROOT CAUSE: `core.autocrlf=true` on Windows.
PROPOSED CHANGE: Measure at the Git object, never the working tree; tests that read source normalize line endings.
STATUS: ADOPTED — 2026-09-08, `AGENTS.md` Truth (the L-035 sentence: measure at the Git object); setup writes `.gitattributes` `* text=auto eol=lf` when none exists, never overwrites. Counter-proof in `check-factory.sh`.

---

## L-039 — The factory does not dictate landing

DATE: 2026-09-08
SYMPTOM: Agents halted finished, proven work waiting for a ritual phrase; the factory prescribed a landing procedure that belongs to the team, not the method.
ROOT CAUSE: Landing policy was written into the method instead of left to the owner.
PROPOSED CHANGE: Owner's decision: whoever pushes knows how. Remove, not reword: the "Push Main" gate and the squash / delete-the-branch / origin-keeps-only-main procedure from `AGENTS.md`; the main-blocking part of `pre-push` (it had no other part, so the hook goes and `--refresh` removes it from projects); the matching assertion in `check-factory.sh`; every mention of a push gate in method, Start, command and owner pages. Stays: secrets hook, CLOSED = verified, PROVE before RECORD.
STATUS: ADOPTED — 2026-09-08, `AGENTS.md` Hold and Truth, `Rules/hooks/pre-push` removed, `setup-into-project.sh` removes method hooks the factory no longer ships, `check-factory.sh`, `SKILL.md`, LESEN templates.

---

## L-040 — Review that can actually find something

DATE: 2026-09-08
SYMPTOM: Per-slice reviews returned PASS every time while later inspections and the owner found dozens of defects in the same slices.
ROOT CAUSE: The builder wrote the reviewer's brief and supplied the evidence; the reviewer read papers instead of exercising the product; the report format rewarded PASS; self-checks were recorded as independent reviews.
PROPOSED CHANGE: (A) Fixed hand: `/adb-review` takes two fields only — commit range `<from>..<to>` and `adb/` pointers; the reviewer fetches diff and spec itself; the report goes to the owner verbatim, never as the builder's summary. (B) Reviewing means trying to break it: `TRIED` (command → result; run the tests, walk the real path, break on purpose) → `FOUND` (finding — evidence — expected) → `VERDICT`; no `TRIED`, no review. Heavy: a short mandatory list per class — money (rounding, double submit, reversal), login/permissions (fail-closed, wrong input, foreign tenant), deploy/infra (rollback), migration (way back, partial abort). (E) Honest naming: no separate reviewer is `Review: self-check` everywhere, `07-STATUS` included, never `ReviewAgent: PASS`. Checklists live in the command, not in `AGENTS.md`.
STATUS: ADOPTED — 2026-09-08, `Methods/ADB/commands/adb-review.md`, `SKILL.md` Hands, `AGENTS.md` Review. Size at the Git object: commit 7b5a34f 6752 → 6731 bytes; over c8e1839..7b5a34f the file grew 6599 → 6731 bytes (L-035, L-038).

---

## L-041 — Adoption left contradictions in the copied text

DATE: 2026-09-08
SYMPTOM: An independent review of `c8e1839..7b5a34f` returned FAIL. The push gate survived on the method page (`Methods/ADB/README.md`). `/adb-ready` and the readiness skill still handed four fields and wrote `WALKED` / `constrained-self-check` while `AGENTS.md` demanded two fields, `TRIED` and `Review: self-check` everywhere. `/adb-review` asked for `[SEVERITY]` without a scale or a verdict threshold.
ROOT CAUSE: L-039 and L-040 were applied to the files named in the brief, not to every file that copies the same rule. The factory check had no guard for the words the lessons retired.
PROPOSED CHANGE: Push gate removed from the method page. `/adb-ready` and the readiness skill take the same two-field hand, report `TRIED`, use one word: `self-check`. `/adb-review` defines CRITICAL / HIGH / MEDIUM / LOW, when a verdict is FAIL, PASS WITH ISSUES or PASS, and what a RELEASE BLOCKER is. `check-factory.sh` fails on `Push Main`, `ALLOW_MAIN_PUSH`, `push only when`, `WALKED`, `constrained-self-check`, and on an `adb-review` without a scale. Rule for the next retirement: grep the whole factory for the retired words before landing, then add them to the check.
STATUS: ADOPTED — 2026-09-08, `Methods/ADB/README.md`, `adb-ready.md`, `product-readiness/SKILL.md`, `SKILL.md`, `adb-review.md`, `check-factory.sh`.

---

## L-042 — The plan review had no range

DATE: 2026-09-08
SYMPTOM: `/adb-review` demanded a two-field hand with a commit range, but no method step committed a plan before Code; the Heavy path could not be reviewed without inventing a step or a third field.
ROOT CAUSE: L-040 fixed the hand and forgot the one review that happens before there is a diff.
PROPOSED CHANGE: SPEC writes the plan to `adb/` (`## Execution plan`) and MainAgent commits it before Code; that commit is the plan review's range. Written in `SKILL.md` BUILD, `/adb-slice` and `/adb-review`.
STATUS: ADOPTED — 2026-09-08, `SKILL.md` SPEC, `adb-slice.md`, `adb-review.md`; the plan lives in `07-STATUS` `## Slice plan` and the commit is covered in `AGENTS.md` Hold since L-049.

---

## L-043 — A reviewer told to break things needs a place to break them

DATE: 2026-09-08
SYMPTOM: The review command said "break it on purpose" and "never implements", but not where. One mistyped `cd` and the reviewer's probes ran in the real repo: three probe commits on the factory's main, undone by hand.
ROOT CAUSE: The command described the attitude, not the sandbox.
PROPOSED CHANGE: `/adb-review` and `/adb-ready`: the reviewer changes nothing in the real tree — no writes, commits or resets; tests and breaking runs happen on a copy (`git worktree add` or a throwaway clone), removed afterwards; the last TRIED line proves `git status --porcelain` empty and HEAD unchanged. The verbatim report lands in chat and in `07-STATUS` under a preserved `## Last review` section, so "verbatim in STATUS" no longer collides with "header only".
STATUS: ADOPTED — 2026-09-08, `adb-review.md`, `adb-ready.md`, `product-readiness/SKILL.md`, `SKILL.md` 07, `adb-status.md`. `## Last review` and the readiness block have one writer, MainAgent, verbatim (L-048); the sandbox reaches PLAIN through `AGENTS.md` (L-051).

---

## L-044 — Setup must not disarm a project, and must give back what it took

DATE: 2026-09-08
SYMPTOM: A factory clone without `Rules/hooks/` made `--refresh` remove the project's `pre-commit` (it carried the method header, and the factory "no longer shipped" it) and exit 0 without a word. A project's own `pre-push`, set aside as `pre-push.pre-method` by an older setup, stayed switched off after the method hook was removed.
ROOT CAUSE: The stale-hook removal trusted the factory's hook folder without checking it was there; removal did not look for what an earlier install had displaced.
PROPOSED CHANGE: `install_hooks` stops with `WARN` when the factory has no `pre-commit`, touching nothing. Removing a stale method hook restores `<name>.pre-method` when present and says so. The factory checkout may carry CRLF, so hooks are installed through `sed 's/\r$//'` and compared the same way — LF on every OS, idempotent. Counter-proofs in `check-factory.sh` for all three.
STATUS: ADOPTED — 2026-09-08, `setup-into-project.sh` install_hooks, `check-factory.sh`.

---

## L-045 — The public factory named the house

DATE: 2026-09-08
SYMPTOM: `LESSONS.md` carried project names in `PROJECT:` lines and in two entries, an owner name, an orchestration tool and its settings key; `README.md` carried the account URL. The factory is public.
ROOT CAUSE: Entries were written from inside the house with no scan before push; the `PROJECT:` field invited names.
PROPOSED CHANGE: Names replaced by kind ("the web app", "the sibling script project", "the orchestration harness", "the orchestrator"); `PROJECT:` dropped from every entry and the header says why; the clone URL is a placeholder. Before every push: scan HEAD for house names — that list stays outside the repo, because a check that carries the names would publish them. History still holds them; rewriting history is the owner's separate decision.
STATUS: ADOPTED — 2026-09-08, `LESSONS.md`, `README.md`. History: OPEN, owner decision.

---

## L-046 — The factory skipped its own L-038, and the hook was easy to walk around

DATE: 2026-09-08
SYMPTOM: The factory had no `.gitattributes`; on a Windows checkout with `core.autocrlf=true` the hook file was CRLF and `cp` shipped it that way — dead on a POSIX kernel (`env: 'bash\r'`). The hook let 250 tabs through and blocked honest work: `dist/vendor.js` with an obfuscated dependency, `app.min.css`, `tests/wallets.js` with `wallet_0xdeadbeef`. The project `.gitattributes` silently set `*.bat` / `*.cmd` to LF.
ROOT CAUSE: L-036 and L-038 were adopted for projects only; the marker regex had no identifier boundary; the exception list stopped at `*.min.js`.
PROPOSED CHANGE: Factory gets `.gitattributes` (`* text=auto eol=lf`); hook install strips CR (L-044). Hook: `[[:blank:]]{200,}`, `_0x` / `_$_` only at identifier start, exceptions add `dist/`, `build/`, `*.min.css`, `*.min.mjs` — no bypass switch, the hook stays absolute; build output is covered by the manual sweep of L-036. Project `.gitattributes` adds `*.bat` / `*.cmd` CRLF. Both READMEs say what setup writes.
STATUS: ADOPTED — 2026-09-08, `.gitattributes`, `Rules/hooks/pre-commit`, `setup-into-project.sh`, `README.md`, `Methods/ADB/README.md`, `check-factory.sh`.

---

## L-047 — "Never change git config" has no door

DATE: 2026-09-08
SYMPTOM: Remotes live in `.git/config`; agents were legitimately asked to change a remote URL and the rule forbade it without exception — while the method itself writes `.gitattributes` and installs or removes hooks under `.git/`.
ROOT CAUSE: The rule is a ban where its sister rules are gates ("ask the owner before …").
PROPOSED CHANGE: Either narrow it (identity, `autocrlf`, `hooksPath`, "never to get around a rule") or give it the owner gate the other bans have. Not changed here: a rule change in `AGENTS.md` is the owner's decision.
STATUS: PROPOSED — awaiting owner decision.

---

## L-048 — The readiness stamp had no lawful writer

DATE: 2026-09-08
SYMPTOM: The sandbox rule (the reviewer changes nothing in the real tree, proof `git status --porcelain` empty) was copied into `/adb-ready` and the readiness skill two lines below "only ReviewAgent writes the READINESS key". The reviewer had to write and was forbidden to write. `## Last review` had two writers: `SKILL.md` said ReviewAgent, `/adb-review` said MainAgent.
ROOT CAUSE: A rule was added where it was asked for, not reconciled with the rule already standing next to it.
PROPOSED CHANGE: One writer, everywhere: the reviewer delivers the block; MainAgent enters it into `07-STATUS` (`READINESS`, `## Readiness`, `## Last review`) verbatim and never alters it — no reviewer block, no stamp. The sandbox stays absolute and checkable. Chosen over a write-exception for the reviewer because one exception invites the next, and because the review command already worked this way. `check-factory.sh` fails on "ReviewAgent writes", "writes the READINESS", "does not change the key" anywhere in the factory.
STATUS: ADOPTED — 2026-09-08, `adb-ready.md`, `product-readiness/SKILL.md`, `SKILL.md` 07 and COMPLETION, `adb-status.md`, `adb-review.md`, `check-factory.sh`.

---

## L-049 — The plan commit had no rule, and the plan had no place

DATE: 2026-09-08
SYMPTOM: `SKILL.md`, `/adb-slice` and `/adb-review` said "MainAgent commits the plan before Code"; `AGENTS.md` Hold said only "CodeAgent commits … no mid-slice noise commits", and `SKILL.md` defers to `AGENTS.md` for git. A rule-abiding agent skipped the commit, and the plan review had no range again. The plan was written into `## Execution plan`, the map of coming slices — two things in one section, no rule for when an entry leaves, and a small product with one Heavy slice had to open a section reserved for "several slices".
ROOT CAUSE: L-042 fixed the command and the method file, not the rules file they inherit from; the section was borrowed instead of named.
PROPOSED CHANGE: `AGENTS.md` Hold, one sentence: product truth written to `adb/` (DEFINE output, a slice plan) is committed by MainAgent as soon as it is written — content, not noise. The plan lives in `07-STATUS` `## Slice plan`: plan + done criteria of the slice being built; the next SPEC replaces it, history keeps the old. `## Execution plan` stays the map. `/adb-status` preserves `## Slice plan`. `AGENTS.md` grows by that sentence; size measured at the Git object in the adopting commit.
STATUS: ADOPTED — 2026-09-08, `AGENTS.md` Hold, `SKILL.md` 07 and SPEC, `adb-slice.md`, `adb-review.md`, `adb-status.md`, `check-factory.sh`.

---

## L-050 — Guards that grep a path list guard the path list

DATE: 2026-09-08
SYMPTOM: The retired-word guards from L-041 searched fixed file lists; `push only when` in a LESEN page or `WALKED` in `/adb-review` passed. The severity guard was `grep -q 'CRITICAL'` over the file — delete the definition, the word survives in the verdict line, the check stays green.
ROOT CAUSE: The guard tested for a word, not for the definition, and for files, not for the factory.
PROPOSED CHANGE: Guards run `grep -r` over the whole factory (excluding `LESSONS.md`, which is history, and the check itself, which names the words) and target definitions: `**Severity:** CRITICAL`, `**Verdict:** FAIL`, the sandbox sentence, the plan range, the two `AGENTS.md` sentences. Each guard seen red on exactly what it promises.
STATUS: ADOPTED — 2026-09-08, `check-factory.sh`.

---

## L-051 — The sandbox stopped at ADB; readiness had a range nobody could resolve

DATE: 2026-09-08
SYMPTOM: `AGENTS.md` demands a review in PLAIN projects too, but the sandbox rule lived only in `/adb-review`; a PLAIN reviewer was told to break things with no place and no way back. `/adb-ready` handed `RANGE: <last READINESS stamp>..HEAD`, which is not a Git object.
ROOT CAUSE: The rule was written in the command that prompted it, not in the rules file every project reads; the readiness hand copied the review hand's shape without its meaning (a walk has no diff).
PROPOSED CHANGE: `AGENTS.md` Review: "break it on purpose — on a copy, never in the real tree". `/adb-ready` hands `RANGE: HEAD` (the whole product) and `SPEC`; the reviewer diffs against the last stamp itself if it wants to.
STATUS: ADOPTED — 2026-09-08, `AGENTS.md` Review, `adb-ready.md`, `product-readiness/SKILL.md`, `check-factory.sh`.

---

## L-052 — Trip-wire doors: docs, nested build folders, invisible blanks, the CR trick

DATE: 2026-09-08
SYMPTOM: The hook blocked `docs/security.md` and a README that name `_0xdeadbeef` — documentation about the hook — with no bypass. It let through 250 zero-width spaces, 250 vertical tabs, a mid-line CR that overwrites the head of a line on a terminal, and any file under a nested `dist/` or `build/` (`src/build/evil.js`).
ROOT CAUSE: The blank class was ASCII; the build-folder exception matched at any depth by instruction; the marker rule fired on documentation that names the markers.
PROPOSED CHANGE: Bytewise scan (`LC_ALL=C`): 200+ of space, tab, VT, NBSP, U+2000–U+200D, U+202F, U+205F, U+2060, U+3000, U+FEFF; a CR followed by visible text on the same line; markers as before. `dist/` and `build/` excepted at the repository root only — committed build output normally lives there, and a nested one is the hiding place; a monorepo that commits nested output gets a loud block and asks the factory. The marker rule skips `*.md` and `*.txt`, which legitimately name the markers; the blank and CR rules apply to them like to any file — this entry first excepted Markdown entirely with the reason "not executed", which is wrong for this method: `AGENTS.md`, `ADB.md`, `START.md`, the commands and `adb/` are exactly what runs (corrected 2026-09-08, L-055). Accepted boundary, written here: dependency folders at any depth, lockfiles, minified files, maps, SVG — the manual sweep of L-036 covers them, the hook does not; single-byte and UTF-8 blanks are covered, UTF-16 and other wide encodings are not (L-058).
STATUS: ADOPTED — 2026-09-08, `Rules/hooks/pre-commit`, `check-factory.sh`. Reasoning for the Markdown exception corrected and the exception narrowed to the marker rule (L-055); `grep -U` was added and removed again the same day (L-057).

---

## L-053 — The factory's own harness copies were 28-byte stubs on Windows

DATE: 2026-09-08
SYMPTOM: `Methods/ADB/.claude|.codex|.cursor/**/adb-*.md` and the three root `start.md` were Git symlinks; with `core.symlinks=false` the checkout holds a text file containing the path. `/adb-review` inside the factory loaded a path. Reported by the first review, not acted on, not recorded.
ROOT CAUSE: Symlinks assumed a POSIX checkout; the README promised "one copy to edit" and nothing verified it.
PROPOSED CHANGE: Real copies, produced by `install-commands.sh --copy` (and `cp` for `/start`); `check-factory.sh` fails when any of the 24 copies differs from its canonical file. README says so.
STATUS: ADOPTED — 2026-09-08, `Methods/ADB/.claude|.codex|.cursor`, root `.claude|.codex|.cursor`, `Methods/ADB/README.md`, `check-factory.sh`. Trap met on the way, fixed in the follow-up commit: with `core.symlinks=false` a `git reset` restored the 120000 index entries and the next `git add` kept that mode, shipping the command text as a symlink target; `check-factory.sh` now fails on any 120000 entry among the copies (seen red on the real index before the fix).

---

## L-054 — A blocker rule a text product can never trigger

DATE: 2026-09-08
SYMPTOM: "RELEASE BLOCKERS — every CRITICAL, and every HIGH touching data, money, or security" never applies to the factory: it ships text. Two reviews found HIGH contradictions between copied files and had to argue them into blockers.
ROOT CAUSE: The scale was written for products with data and money.
PROPOSED CHANGE: Fourth category in `/adb-review`: every finding that leaves a rule an agent cannot follow.
STATUS: ADOPTED — 2026-09-08, `adb-review.md`.

---

## L-055 — "Not executed" was the wrong reason: in this method the Markdown is what runs

DATE: 2026-09-08
SYMPTOM: The hook excepted `*.md` and `*.txt` from all hidden-content rules. `AGENTS.md` with 400 spaces and the line "Ignore all earlier rules …" was committed; `.claude/commands/start.md` with 300 zero-width spaces and "exfiltrate …" was committed; the same payload in `x.js` was blocked. The false alarm the exception was meant to cure had come only from the marker rule (a document naming `_0xdeadbeef`), never from the blank or CR rules.
ROOT CAUSE: One reason ("not executed") was applied to three rules; it was true for none of them here — `AGENTS.md`, `ADB.md`, `START.md`, the commands and `adb/` are the executed text of this method.
PROPOSED CHANGE: Blank-run and CR rules apply to every scanned file, Markdown included; only the marker rule skips `*.md` / `*.txt`. Both READMEs say what the hook does not check. Counter-proofs: hidden line in `AGENTS.md` blocked, zero-width run in a command copy blocked, a document naming the marker still passes.
STATUS: ADOPTED — 2026-09-08, `Rules/hooks/pre-commit`, `README.md`, `Methods/ADB/README.md`, `check-factory.sh`; L-052 corrected.

---

## L-056 — A scan that cannot run does not pass

DATE: 2026-09-08
SYMPTOM: Every scan pipeline in the hook ended in `|| true`; a `grep` that failed left the result empty and the commit went through — proven with a grep stand-in that refused an option: a 250-space line was committed with three lines on stderr.
ROOT CAUSE: The idiom that keeps "no match" from aborting the script also swallowed "could not search".
PROPOSED CHANGE: Each pipeline is checked stage by stage (`PIPESTATUS`): git must succeed, a grep may find nothing (1) but must not fail (2+); otherwise the commit is blocked with the stage codes. Same for reading the index at the top. Same decision as L-044 for setup: loud, never silently disarmed. Counter-proof: a failing `grep` first in `PATH` blocks a harmless commit.
STATUS: ADOPTED — 2026-09-08, `Rules/hooks/pre-commit` blocks 2–4, `check-factory.sh`.

---

## L-057 — `grep -U` removed: it protected only a counter-proof

DATE: 2026-09-08
SYMPTOM: `-U` (a GNU extension) was added so that Windows grep keeps a CR at the end of a line. Measured: the hook's rule targets a CR in the middle of a line, which grep finds with or without `-U`; removing `-U` from all three greps left every assertion green.
ROOT CAUSE: The option served the "a CRLF line must pass" counter-proof, not the rule.
PROPOSED CHANGE: `-U` removed; the CRLF probe stays in the check with the note that on Windows grep strips the trailing CR before the match, so that probe is only meaningful on POSIX. L-052 corrected.
STATUS: ADOPTED — 2026-09-08, `Rules/hooks/pre-commit`, `check-factory.sh`.

---

## L-058 — Single-byte blanks came through

DATE: 2026-09-08
SYMPTOM: 250 × byte `0xA0` (NBSP in cp1252) was committed while the same run as UTF-8 `C2 A0` was blocked; 250 × `0x1C` came through too. The cp1252 file was not planned — a Windows tool wrote it that way by default.
ROOT CAUSE: The blank class listed Unicode spaces in UTF-8 only.
PROPOSED CHANGE: The class also covers the single bytes `0x0C`, `0x1C`–`0x1F`, `0x85`, `0xA0` — chosen over merely documenting the gap because Windows tools produce these bytes unasked. Boundary written down: UTF-16 and other wide encodings are not covered; a file in such an encoding is for the manual sweep.
STATUS: ADOPTED — 2026-09-08, `Rules/hooks/pre-commit`, `check-factory.sh`.

---

## L-059 — Open points from the third review, recorded, not changed

DATE: 2026-09-08
SYMPTOM: The reviewer named four findings outside the owner's release for the last round: the hook runs `git diff` and three greps per file (49 seconds for 300 files — one pass over the whole diff would fix it, but that is a rebuild); `/adb-ready` line "Walk the current product…" names no actor; `install-commands.sh` still defaults to symlinks while the factory and the projects use copies; the sandbox sentence recommends `git worktree`, which shares the repository with the real tree. A fifth from the same class, found by the agent: the retired-word guards in `check-factory.sh` end in `|| true` and would pass silently if `grep` failed.
ROOT CAUSE: Out of scope by the owner's decision; written here so they do not vanish.
PROPOSED CHANGE: None yet. Each is one small change when the owner opens the factory again.
STATUS: OPEN — owner decision.
