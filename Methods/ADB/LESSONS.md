# ADB Lessons

Append-only record of defects in the method itself, found by real projects (P61A).

This file is not an issue tracker. Project problems belong in that project's `adb/08-OPEN-ISSUES.md`. Only findings whose root cause is ADB itself belong here.

Nothing here changes the method until the user adopts it. STATUS says whether that happened.

---

## L-001 — Setup never enforced the issue-register location

DATE: 2026-08-26
PROJECT: buchhaltung-web
SYMPTOM: The project kept its issue register at the repository root as `OPEN-ISSUES.md`, declared that file canonical inside the file itself, and also carried an `## Open issues` section in `adb/07-STATUS.md`. `adb/08-OPEN-ISSUES.md` did not exist although the Source of Truth was not collapsed. Three candidate locations, and the STATUS section claimed `0` open issues while real unresolved conflicts existed.
ROOT CAUSE: P15 forbids alternate filenames and P23 names the register, but nothing in the method verifies the register's location once a project is running. The inherited `AGENTS.md` already routed ADB projects to `adb/08-OPEN-ISSUES.md`, so the method and its own rules file disagreed in practice with no point responsible for noticing. Method silent where the project needed a rule.
PROPOSED CHANGE: Give the status review an explicit Source-of-Truth layout check: the numbered files present, no ADB content living under non-ADB filenames, no topic duplicated between a numbered file and an ad-hoc one.
STATUS: ADOPTED — added as Step 2A of `/adb-status`, 2026-08-26.

---

## L-002 — No terminating condition for open issues

DATE: 2026-08-26
PROJECT: buchhaltung-web
SYMPTOM: The product could sit indefinitely in "almost complete". P61 correctly refused to call it complete, but nothing forced any open issue toward an exit, so a status review could run any number of times and produce the same verdict with no progress.
ROOT CAUSE: P50 defines what blocks release and P61 defines what completion means, but neither bounds how long an issue may stay OPEN. A gate that can be re-failed forever is a report, not a gate.
PROPOSED CHANGE: Count how many reviews each issue survives and force an exit — FIX, ACCEPT or REJECT — at a fixed count.
STATUS: ADOPTED — added as P50A ISSUE CONVERGENCE and the `CARRIED` field in P25, 2026-08-26.

---

## L-003 — Project copies of the method have no age

DATE: 2026-08-26
PROJECT: buchhaltung-web
SYMPTOM: The project's `ADB.md` was modified but uncommitted. Its working copy was byte-identical to the canonical `SKILL.md`, so the committed version was some older method revision — but which one, and how old, was not answerable from the repository.
ROOT CAUSE: Setup copies the method into the project and the copy carries no provenance. A copy with no version is unfalsifiable.
PROPOSED CHANGE: Stamp the copy with the canonical repository's short git sha and date on its first line.
STATUS: ADOPTED — added as P1A METHOD VERSION, 2026-08-26.

---

## L-004 — P1A collided with the frontmatter it was written for

DATE: 2026-08-26
PROJECT: buchhaltung-web
SYMPTOM: P1A demanded the `METHOD-VERSION` stamp on the first line of the project `ADB.md`. The canonical `SKILL.md` opens with a YAML frontmatter block, and the project copy keeps it. Following P1A literally would have pushed `---` to line 3 and broken the block for any harness that parses it.
ROOT CAUSE: The point was written without checking the file it governs. A rule about a copy must hold for the actual shape of that copy.
PROPOSED CHANGE: Allow the stamp as the first line after the frontmatter block, and forbid placing it above frontmatter.
STATUS: ADOPTED — P1A reworded 2026-08-26, same day it was introduced.

---

## L-005 — Slash commands were installed into the user home

DATE: 2026-08-26
PROJECT: ADB method repo
SYMPTOM: `/adb-define` and the other four commands appeared in every Cursor, Codex and Claude session, including projects without `METHOD: ADB`.
ROOT CAUSE: `install-commands.sh` targeted `$HOME/.cursor/commands`, `$HOME/.codex/prompts` and `$HOME/.claude/commands`. P1 forbids ADB from affecting ordinary work in unrelated projects. A home-level command list is exactly that.
PROPOSED CHANGE: Install into the project's own harness directories. Remove leftover home-level links. State the rule in P1.
STATUS: ADOPTED — installer is project-scoped; P1 forbids home-level installs; `--remove-global` cleans leftovers, 2026-08-26.

---

## L-006 — Project helpers copied ADB.md without stamp, commands, or adb/08

DATE: 2026-08-26
PROJECT: ADB method + Shared/Scripts
SYMPTOM: Project helpers wrote `METHOD.md` and a bare `ADB.md`, but left no `METHOD-VERSION` stamp, installed no project-local slash commands, and still created a root `OPEN-ISSUES.md` that contradicts the issue-register rule.
ROOT CAUSE: Setup lived outside the method. The method gained a version stamp, project-scoped commands and the numbered issue register; the helpers were never updated.
PROPOSED CHANGE: One `setup-into-project.sh` that stamps and installs commands into the project. Do not auto-create Vision/Spec — that is DEFINE.
STATUS: ADOPTED — 2026-08-26.

---

## L-007 — Chip labels vs A/B/C Decision Questions

DATE: 2026-08-26/27
PROJECT: ADB method
SYMPTOM: Draft decision UI used Perplexity-style chip labels. Agents and drafts drifted toward long label text instead of single-letter answers. That conflicted with global `AGENTS.md` Decision Questions (A/B/C + „Entscheide du“).
ROOT CAUSE: A feature sketch taught a discarded interaction. The method and the reading copy already followed A/B/C; the feature note still named “chips” and looked like an open path.
PROPOSED CHANGE: Keep A/B/C + „Entscheide du“ as the only rule. Mark chips rejected. Rename the feature note so the filename does not teach chips.
STATUS: SUPERSEDED — 2026-09-01 by L-019: owner wants chips; keep labels short. Long Perplexity-style chip sentences stay forbidden.

---

## L-008 — Project copy of the method was a second source

DATE: 2026-08-28
PROJECT: ADB method
SYMPTOM: Setup copied `SKILL.md` into every project as `ADB.md`, then needed a version stamp, a STALE check, and slash commands that restated the method so they would not cite a stale copy. Agents had two method files. P60 was cited though it had no own section.
ROOT CAUSE: A copy ages. Machinery to keep the copy honest became larger than the method. Commands restated `SKILL.md` instead of pointing at it.
PROPOSED CHANGE: Do not copy the method into the project. `METHOD.md` is the switch. Agents read canonical `SKILL.md`. Commands stay short. Leftover `ADB.md` is ignored; `--refresh` removes it. Drop the P60 citation.
STATUS: ADOPTED — 2026-08-28.

---

## L-009 — Rulebook should state who sets the destination

DATE: 2026-08-28
PROJECT: ADB method
SYMPTOM: The method explained phases and files. It did not say in one place: the owner sets where the product must land; the agent writes that down, builds in slices that fit context, and proves it (browser, tests, logins).
ROOT CAUSE: The method was written as numbered process. The reason it exists is a non-programmer owner.
PROPOSED CHANGE: Open `SKILL.md` with that job. DEFINE / BUILD / COMPLETION in plain language. Commands point at those sections, not at old point numbers.
STATUS: ADOPTED — 2026-08-28.

---

## L-010 — Naming another product method kept it in play

DATE: 2026-08-31
PROJECT: ADB method
SYMPTOM: Agents treated a name in the files as a peer method and followed leftover folders and commands.
ROOT CAUSE: The method was defined against that name. Naming it taught agents it still exists.
PROPOSED CHANGE: Write only this method. Setup writes `METHOD: PLAIN` or `METHOD: ADB`. Existing product docs stay as brownfield evidence for DEFINE.
STATUS: ADOPTED — 2026-08-31.

---

## L-011 — A dropped chat UI and Lead were still in the method after they were gone

DATE: 2026-08-31
PROJECT: ADB method
SYMPTOM: The method still named a retired chat UI (decision chips, upstream issue) and treated Lead as an orchestra role for the READINESS key. That UI is gone.
ROOT CAUSE: Those names were leftover. After they were dropped, the files still taught agents to wait for that UI or a missing orchestra Lead.
PROPOSED CHANGE: Remove the retired UI name. Decision rule stays A/B/C + decide-for-me. Review writes READINESS. Briefs are executable without a worker role.
STATUS: ADOPTED — 2026-08-31.

---

## L-012 — ADB without Lead contradicted factory AGENTS.md

DATE: 2026-08-31
PROJECT: ADB method
SYMPTOM: After L-011, ADB told the reading agent to implement, prove, and commit only if the owner asked; it allowed spawning a reviewer and loading ADB without `METHOD: ADB`. Factory `AGENTS.md` says Lead only directs, Code implements and auto-commits when the job is done, never spawn, and do not load ADB when `METHOD.md` is missing or `PLAIN`.
ROOT CAUSE: L-011 dropped an orchestra name “Lead” and took the session Lead with it. ADB restated git and activation instead of deferring to AGENTS.md.
PROPOSED CHANGE: Lead/Plan/Code/Review stay. ADB must not contradict AGENTS.md: Lead directs; never spawn; Code commits when the job is done; ADB loads only when `METHOD: ADB`; A/B/C includes scopes.
STATUS: ADOPTED — 2026-08-31.

---

## L-013 — A removed commit-gate skill is gone

DATE: 2026-08-31
PROJECT: ADB method
SYMPTOM: ADB still required a named review-before-commit skill PASS and treated it as the commit check. That skill no longer exists.
ROOT CAUSE: ADB copied a dead skill name from the factory instead of deferring git to AGENTS.md without naming a removed tool.
PROPOSED CHANGE: Do not name removed tools. `/adb-review` stays (independent product review). Git: Code commits when the job is done (AGENTS.md). CARRIED is not the PROVE 3-round cap.
STATUS: ADOPTED — 2026-08-31.

---

## L-014 — ADB restated the OS until the product rules were hard to see

DATE: 2026-08-31
PROJECT: ADB method
SYMPTOM: After aligning with factory `AGENTS.md`, SKILL.md and every slash command repeated Lead / spawn / git / extra process names. Agents had to wade through factory rules to reach DEFINE / BUILD / COMPLETION. No product rule was added; the same rules were said three times.
ROOT CAUSE: Alignment copied AGENTS.md into ADB instead of one inherit line plus the product method.
STATUS: ADOPTED — 2026-08-31.

---

## L-015 — Projects must carry a copy; nobody fetches the method repo

DATE: 2026-08-31
PROJECT: ADB method
SYMPTOM: After L-008, setup did not copy `SKILL.md`. Agents were told to follow the method repo. New and existing projects never fetched it, so they kept an old method or none.
ROOT CAUSE: One canonical file only works if every project can reach that file. These projects do not.
PROPOSED CHANGE: Setup copies `SKILL.md` to project `ADB.md`, stamps `METHOD-VERSION`, and installs slash commands as copies. Agents follow `ADB.md`. `--refresh` updates copy and commands. STALE if the copy differs and was not refreshed.
STATUS: ADOPTED — 2026-08-31.

---

## L-016 — Role names Lead / Plan / Code / Review were unclear

DATE: 2026-09-01
PROJECT: ADB method
SYMPTOM: Public clones could not tell who they were talking to. “Lead” sounded like an orchestra boss; “Plan / Code / Review” looked like verbs, not the three living workers. Agents still spawned one-shots or did all work in the chat.
ROOT CAUSE: The split was already in `AGENTS.md` (direct vs do). The names did not say that.
PROPOSED CHANGE: Same four roles, clearer names: **MainAgent** (talks to the owner, most work handed off), **PlanAgent**, **CodeAgent**, **ReviewAgent**. Still never spawn. One-shot Tasks are not those three. If this session already is the living worker, or none exists to turn on, this session does the job and names the role.
STATUS: ADOPTED — 2026-09-01.

---

## L-017 — CodeAgent is a subagent, not an owner chat

DATE: 2026-09-01
PROJECT: ADB method
SYMPTOM: After L-016 the rules still talked about PlanAgent/CodeAgent/ReviewAgent **tabs**. The owner does not have those chats. CodeAgent is a subagent MainAgent starts. The “open the other card / one session” exception made the method unreadable.
ROOT CAUSE: “Living named agent” was copied from an orchestra of owner-facing chats. This method has one owner chat: MainAgent.
PROPOSED CHANGE: Owner talks only to MainAgent. PlanAgent, CodeAgent, ReviewAgent are named subagents for a job. No extra worker types. If the harness cannot start a subagent, MainAgent does the job in this chat and names the role.
STATUS: ADOPTED — 2026-09-01.

---

## L-018 — Forced subagents on every Plain job wasted context

DATE: 2026-09-01
PROJECT: ADB method
SYMPTOM: After L-017, MainAgent was told to start CodeAgent for most work. Small Plain jobs split context for no gain. The owner asked whether subagents only help from scratch; the real split is ADB / Heavy vs Plain.
ROOT CAUSE: “Most work goes to subagents” treated a one-shot worker as always cheaper than the owner chat. For a small change it is slower and forgets the thread.
PROPOSED CHANGE: Require named subagents only when `METHOD: ADB` or the job is Heavy. PLAIN and not Heavy: MainAgent does the work in this chat and names the role. Harness cannot start a required subagent → same chat, name the role.
STATUS: ADOPTED — 2026-09-01.

---

## L-019 — Owner wants chips, not A/B/C

DATE: 2026-09-01
PROJECT: ADB method
SYMPTOM: Start and Decision Questions asked A/B/C. The owner does not want to type letters. They asked for chips.
ROOT CAUSE: L-007 rejected chips because long label text was worse than a letter. That banned the click UI instead of banning only long labels.
PROPOSED CHANGE: Short chips (1–4 words), last = decide-for-me. Native picker when the harness has one (Cursor `AskQuestion`). No letters in the prompt. Typed A/B/C still maps. Long chip sentences stay forbidden.
STATUS: ADOPTED — 2026-09-01. SUPERSEDED in part by L-022 (A/B/C when chips are not clickable). `FEATURE-decision-options.md`, `AGENTS.md`, `START.md`.

---

## L-020 — Do not name other product methods

DATE: 2026-09-01
PROJECT: ADB method
SYMPTOM: Reading copies and agent files named methods that are not this one, including that they were gone. The owner was confused about what we mean.
ROOT CAUSE: Contrast against a former name teaches that name.
PROPOSED CHANGE: Write only PLAIN and ADB. Do not mention other product methods, and do not say they used to exist.
STATUS: ADOPTED — 2026-09-01.

---

## L-021 — METHOD.md did not follow a PLAIN↔ADB switch

DATE: 2026-09-02
PROJECT: ADB method
SYMPTOM: Re-Start small↔large (or `risk=yes` forcing ADB) updated `OWNER.md` / `LESEN.html` and could install or skip `ADB.md`, while `METHOD.md` stayed on the old line. `--plain` left `ADB.md` and `/adb` commands in place. Agents then loaded the wrong method, or none.
ROOT CAUSE: Setup refused to overwrite `METHOD.md` when it already said PLAIN or ADB, so Start could not switch. Cleanup on PLAIN was never implemented. Honoring flags on every setup call then let `--refresh` invent a switch and desync `OWNER.md` / `LESEN.html`.
PROPOSED CHANGE: Start is the switch (`--switch`). Setup writes `METHOD.md` from flags only on first layout or `--switch`. `--plain` then removes `ADB.md` and `/adb` commands; product `adb/` stays. `--refresh` without Start does not flip. `check-factory.sh` proves PLAIN, `risk=yes`, both Start flips, and that setup/refresh without Start keep the existing method.
STATUS: ADOPTED — 2026-09-02.

---

## L-022 — A/B/C when chips are not clickable

DATE: 2026-09-03
PROJECT: ADB method
SYMPTOM: Short chip labels in backticks (or a missing native picker) are not clickable in every harness. The owner could not reliably answer Start and Decision Questions without inventing a format.
ROOT CAUSE: L-019 banned letters in the prompt so agents never showed A/B/C when `AskQuestion` was absent. Backtick rows do not equal a click UI.
PROPOSED CHANGE: Chips when the harness has a native clickable picker; otherwise lettered A/B/C with the same short labels. Never both at once. Click, label, or letter all count.
STATUS: ADOPTED — 2026-09-03. `AGENTS.md` Talk, Start skill, `FEATURE-decision-options.md`, LESEN templates.


---

## L-023 — Daily rule files carried setup mechanics; hard rules were only prose

DATE: 2026-09-03
PROJECT: ADB method
SYMPTOM: `AGENTS.md` (84 lines) spent about a quarter on Start triggers, factory notes, harness home links, and the chips-vs-letters history. `ADB.md` opened with stamp and STALE mechanics. Agents read that every session and it protects nothing. Rules that must never fail (secrets in git, push to main without the owner) were sentences an agent could forget. The method changed 22 times in 8 days; several lessons reversed each other, and every change meant a refresh in every project.
ROOT CAUSE: One file served three readers: the daily agent, the setup script, and the first-run. Guarantees were written as advice. No cadence for method changes.
PROPOSED CHANGE: `AGENTS.md` keeps only what prevents mistakes in daily work (Talk, Truth, Work, Hold); Start lives in `START.md`, mechanics in the scripts. `ADB.md` drops stamp/STALE text. Two git hooks installed by setup: pre-commit blocks secrets, pre-push blocks main unless `ALLOW_MAIN_PUSH=1`. Owner conduct rules that had lived in a harness system prompt (mirror before acting, do it or offer it, ask before delete/deploy/money/live data, landing by squash, no local memory) move into `AGENTS.md`. Method changes are collected and refreshed into projects at most monthly unless a defect blocks work.
STATUS: ADOPTED — 2026-09-03.

---

## L-024 — ADB.md repeated AGENTS.md; tests and README were not mandatory

DATE: 2026-09-04
PROJECT: ADB method
SYMPTOM: Checked against the copies that land in a product (test project via Start): `ADB.md` restated Heavy, roles, chips, the 2FA exception, the fix-round cap, git and "don't interrupt for reversible details" — all already in `AGENTS.md`. Two files, one rule, drift risk on every edit. `AGENTS.md` never required running the project's tests or reading the README first, although the measured value of an agent rules file lies in concrete project facts (commands, boundaries) and a check the agent can run.
ROOT CAUSE: ADB was written to stand alone, then AGENTS.md absorbed the shared rules without ADB dropping them. Test discipline was habit, not rule.
PROPOSED CHANGE: `AGENTS.md` (every project): "Read first" line for README, OWNER.md, METHOD.md; tests before start and before every commit, red = no commit. `ADB.md` (large only): keeps DEFINE / Source of truth / Issues / BUILD loop / COMPLETION and points at `AGENTS.md` for everything shared. Factory and Start notes reduced to one sentence each.
STATUS: ADOPTED — 2026-09-04. Landed copies: AGENTS.md 713 words, ADB.md 985 words.

---

## L-025 — Second-model review of the landed copies

DATE: 2026-09-04
PROJECT: ADB method
SYMPTOM: An independent agent (Antigravity, Gemini) read only the landed `AGENTS.md` and `ADB.md`. Accepted findings: "mirror and wait for yes" read as blocking even read-only research; Heavy was defined by project domain, so every fix in an app with login or money looked Heavy; CARRIED looked like a manual count; the hand-offs between PlanAgent, CodeAgent and ReviewAgent were only implied. Rejected: dropping the collapsed 01/02/07 default (it prevents empty mandatory files in small products).
PROPOSED CHANGE: Wait for yes only before changing something; Heavy judged by what the change touches, not what the project contains; CARRIED incremented only by `/adb-status`; one line naming what each role receives and returns.
STATUS: ADOPTED — 2026-09-04.

---

## L-026 — Two contradictions introduced by L-025, caught by the second-model re-read

DATE: 2026-09-04
PROJECT: ADB method
SYMPTOM: After L-025, `ADB.md` said "Only /adb-status increments CARRIED" in Issues and "increment CARRIED" in RECORD. It also said "Nobody gets chat history" while `AGENTS.md` allows a role to run in the same chat when the harness cannot start a subagent.
ROOT CAUSE: A rule was tightened in one place without re-reading the other places that state the same step.
PROPOSED CHANGE: RECORD runs `/adb-status` instead of counting; hands are written down even when a role runs in the same chat, and no hand relies on chat history.
STATUS: ADOPTED — 2026-09-04.

---

## L-027 — A shared component library sent five agents to build the same things five times

DATE: 2026-09-05
PROJECT: BuchWeb (UI rebuild, round 3)
SYMPTOM: Round 2 built a component library and one view on it (the home screen), then round 3 ran five CodeAgents in parallel, each on a different screen, all against that library. Every one of the five hit the same holes and had to work around them inside its own files: the form components emit `<button>` and no `name=` fields, so `FormData` reads nothing and no settings form can save; `knopf()` cannot be `type="submit"`; `leiste()` — the navigation bar every screen except home needs — does not exist in `parts.js` at all; `blatt()`, the shell for a scrolling sub-view, is missing; a view cannot close its own sheet because the close button is wired to the menu sheet. Three groups reported the form problem independently. The same widget now sits in the repo up to five times — exactly the duplication a shared library exists to prevent.
ROOT CAUSE: The library was proven against **one** screen, and that screen happened to need none of the missing pieces: the home screen has no form, no navigation bar, and no sub-view. "It works for the showcase page" was mistaken for "it is ready".
PROPOSED CHANGE: Before a shared library is handed to parallel builders, prove it against **at least two structurally different screens — one list and one form** — not only against the showcase. The proof is that the second screen needs no component built outside the library. Alternatively, run the first two screens sequentially and only then fan out.
STATUS: PROPOSED — 2026-09-05.

---

## L-028 — Parallel agents in one working tree share the git index, not just the files

DATE: 2026-09-05
PROJECT: BuchWeb (UI rebuild, round 3)
SYMPTOM: Five agents worked in the same checkout. Each was told to commit only its own files by name and never `git add -A`. They followed it — and it still went wrong twice: one group's `git commit` picked up another group's already-staged files, and MainAgent's own commit of a single documentation file carried five foreign source files with it. One group ended up with no commit of its own; HEAD was briefly broken because `shell.js` imported a file not yet committed.
ROOT CAUSE: `git add <file>` scopes what *you* stage, but the index is shared across everyone working in that tree. A later `git commit` without a path argument commits **everything staged**, including what another agent staged seconds earlier. The rule "never `git add -A`" reads like sufficient protection and is not.
PROPOSED CHANGE: With more than one agent in one working tree, commit with an explicit path list — `git commit -- <paths>` — which ignores the shared index. Name up front who commits the shared files (registration, navigation, spec), so the last one to finish does not book everyone else's work under their name. If the harness supports it, give each parallel builder its own worktree instead.
STATUS: PROPOSED — 2026-09-05.

---

## L-029 — Green checks that checked nothing

DATE: 2026-09-05
PROJECT: BuchWeb (UI rebuild)
SYMPTOM: Eight checks reported green and proved nothing, each of them rule-compliant ("tests green", "evidence delivered"): a test environment that never had the login screen it claimed to test; a reconciliation that confirmed a lost amount as "matches" because both sides had become 0; "eight benches green" over a self-chosen set (there were 13, one red); a check command that never ran, whose error message was read as the answer — an hour later a branch was gone.
ROOT CAUSE: `AGENTS.md` Truth said "Green tests ≠ spec satisfied" — true, abstract, and nothing an agent can act on. Nothing required a check to have been seen failing. A check that cannot go red is a report with a green label.
PROPOSED CHANGE: The counter-proof, one sentence in Truth: a check counts only once you have seen it fail on exactly what it promises — undo the fix or break the code on purpose, that one assurance goes red, nothing else. Applied the same day, it caught three of the agent's own mistakes before review saw them.
STATUS: ADOPTED — 2026-09-05, `AGENTS.md` Truth.

---

## L-030 — An enforcer that doesn't know the exception enforces the rule against it

DATE: 2026-09-05
PROJECT: BuchWeb
SYMPTOM: "origin keeps only main" was enforced by a scheduled cron workflow. It deleted the temporary exception branch `vorschau`. The exception lived only in the docs and in the pushed branch; a `schedule` run always takes the workflow file from the default branch, which had never heard of it.
ROOT CAUSE: The rule was right. The exception was recorded where humans read, not where the enforcer reads. `AGENTS.md` Hold said "leave no branches behind" and nothing about how to keep one on purpose.
PROPOSED CHANGE: One sentence in Hold: an exception is told to every enforcer of that rule (hook, workflow, cron), or the enforcer is switched off with date and re-enable condition on record.
STATUS: ADOPTED — 2026-09-05, `AGENTS.md` Hold.

---

## L-031 — Two projects shared a key by name and nobody kept the list

DATE: 2026-09-05
PROJECT: BuchWeb + BuchScript (shared Google Sheet)
SYMPTOM: BuchWeb wrote `NOTIFY_PREISERHOEHUNG_PUSH`, BuchScript read `NOTIFY_PREISSCHWANKUNG_PUSH`. Each side correct on its own, every test green; the switch had been silently dead for months. Its default was "on", so a broken switch looked exactly like a working one. Found only by laying two lists side by side — which nobody had done, because there is no code there.
ROOT CAUSE: The harness-level rule for all agents, "report schema changes to Chef", covers changes, not the existing inventory (that sentence is not in the factory `AGENTS.md`). No rule said where a shared list lives or that both sides test against it.
PROPOSED CHANGE: One sentence in Hold: keys or names shared with another project — exactly one place keeps the list, both sides test against it. The list itself is project work (BuchScript keeps it as `scripts/test-push-schluessel.js`), not factory.
STATUS: ADOPTED — 2026-09-05, `AGENTS.md` Hold.

---

## L-032 — Harness system prompt repeated product rules

DATE: 2026-09-06
PROJECT: factory (Paseo host prompt)
SYMPTOM: Paseo `appendSystemPrompt` restated language, owner-is-not-coder, per-project scope, shared-sheet notice, and factory-refresh — all needed by agents that never see Paseo (Cursor, clasp-only, other hosts).
ROOT CAUSE: Host prompt mixed orchestration (Chef, protected repos, host paths) with product agent rules.
PROPOSED CHANGE: Factory `AGENTS.md` owns Scope (this project only), factory-only rule edits + refresh, shared-contract notice to the owner, short sentences / owner does not program. Paseo system prompt keeps only: Owner/Chef, host paths, protected list for Chef.
STATUS: ADOPTED — 2026-09-06, `AGENTS.md` Job/Scope/Hold; Paseo prompt slimmed.

---

## L-033 — Harness files held parallel agent rules

DATE: 2026-09-06
PROJECT: factory
SYMPTOM: Some products had rich `CLAUDE.md` / Copilot instructions; others only `@AGENTS.md`. Agents that open the harness file first never saw the factory rules, or drifted from a second copy.
ROOT CAUSE: Setup wrote `AGENTS.md` but not the harness entry pointers.
PROPOSED CHANGE: Setup always writes `CLAUDE.md`, `GEMINI.md`, and `.github/copilot-instructions.md` as only `@AGENTS.md`. Factory `AGENTS.md` states that rule. `--refresh` overwrites drift.
STATUS: ADOPTED — 2026-09-06, `setup-into-project.sh`, `AGENTS.md`.

---

## L-034 — Waiting dressed up as in progress

DATE: 2026-09-07
PROJECT: factory (owner: Bubby)
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
STATUS: ADOPTED — 2026-09-08, `Rules/hooks/pre-commit` block 4 on added lines: runs of ≥200 spaces, `_0x…`, `_$_…`; not `eval`/`atob`/`Function` (real code uses them and the hook has no bypass). Excepted: vendored and `node_modules`, lockfiles, `*.min.js`, `*.map`, `*.svg`, this file. `pre-push` inspects refs only, so no block there. Counter-proof in `check-factory.sh`.

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
PROPOSED CHANGE: (A) Fixed hand: `/adb-review` takes two fields only — commit range `<from>..<to>` and `adb/` pointers; the reviewer fetches diff and spec itself; the report goes to the owner verbatim, never as the builder's summary. (B) Reviewing means trying to break it: `TRIED` (command → result; run the tests, walk the real path, break on purpose) → `FOUND` (finding — evidence — expected) → `VERDICT`; no `TRIED`, no review. Heavy: a short mandatory list per class — money (rounding, double submit, reversal), login/permissions (fail-closed, wrong input, foreign tenant), deploy/infra (rollback), migration (way back, partial abort). (E) Honest naming: no separate reviewer is `Review: self-check` everywhere, `07-STATUS` included, never `ReviewAgent: PASS`. Checklists live in the command, not in `AGENTS.md`, which does not grow.
STATUS: ADOPTED — 2026-09-08, `Methods/ADB/commands/adb-review.md`, `SKILL.md` Hands, `AGENTS.md` Review (net shorter after L-039).
