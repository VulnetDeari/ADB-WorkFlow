# Agent rules

These shared rules are copied and stamped into each product project. Change the factory source, not the installed copy. Refresh updates method-owned files. In the factory (`Rules/start-into-project.sh` exists), never run Start against this folder or create a product `METHOD.md` here.

## Load and ownership

Read this file fully at session start, then the project's README, `OWNER.md`, `METHOD.md` and `PROJECT-RULES.md` when present. Missing owner/method settings in an app: follow `START.md`. Missing README in a new project is not a blocker. If `METHOD: ADB`, read `ADB.md` Entry and the applicable phase/role section before acting. PLAIN does not load ADB.

There is one shared rules file, `AGENTS.md`, and one additional method, `ADB.md`. Harness entries contain references only: `CLAUDE.md` and `GEMINI.md` import `@AGENTS.md`; other harnesses use a supported reference to the root file. Commands route to canonical sections and define no independent rules. Do not create nested rule copies or per-agent rule files.

`PROJECT-RULES.md` belongs to the project: conventions, domain constraints and authorized exceptions. `OWNER.md` holds communication preferences; product documents hold behavior. Refresh preserves these files. Before converting existing harness instructions, preserve their project-specific content and scope in `PROJECT-RULES.md`; resolve contradictions before replacing their source.

Platform/system and explicit user instructions take precedence. Project rules supplement this method. An undecided conflict: identify the exact conflicting rules, ask only for the necessary decision, and continue unaffected work. An intentional exception records affected rule, scope, reason, authorizing instruction and expiry/revisit condition where relevant. It cannot override platform permissions. Update affected checks so they know the exception.

Work only in the authorized project. Do not inherit another project's preferences or modify sibling repositories. The factory is public: examples, lessons and fixtures must be generic, without private names, paths, transcripts or account details. Record a method defect in the current project's issue record; propose a sanitized factory change without silently editing another repository.

## Talk and authorization

Use `OWNER.md` for language, address and tone; otherwise mirror the user. Explain impact first in short, plain sentences. **Bold the one point that matters.** Include technical details when they help a decision or substantiate a result.

A clear instruction authorizes the described work. Reuse existing approval; do not ask again for every edit or routine fix. Before a new product BUILD, present intended behavior and obtain scope approval (ADB DEFINE; PLAIN uses a brief equivalent). Method selection is not approval of invented features. Existing approval and explicitly delegated choices count; silence never does. Ask only for unresolved product decisions, irreversible actions, credentials or spending outside existing authorization.

Offer useful options for decisions only the user can make. Chips when clickable, else A/B/C; free text for a path or explanation. Never both forms. Offer decide-for-me only when a decision can safely be delegated within stated limits. Reuse answers already given. A current explicit correction overrides an older product document: update affected records before dependent implementation.

Research what files and tools can answer. The user sets intent and tradeoffs; agents implement and verify. Ask for unavoidable 2FA, captcha or inaccessible credentials, not routine click tours. Say whether work is running, waiting, not started or complete. Never announce work and silently leave it unstarted. Summarize results and link evidence; do not flood chat with internal handoffs or duplicate full reports.

## Roles and scope

MainAgent is the user's single contact and owns coordination, scope and integration. Small, clear, low-risk tasks are done by MainAgent, including in ADB: implement and label verification `Review: self-check`. Project size and method choice do not mandate subagents.

Delegate only concrete work that benefits from separation: PlanAgent clarifies/plans, CodeAgent implements/proves, ReviewAgent independently evaluates. Choose roles for this change's uncertainty, risks and dependencies. Subagents do not spawn further agents. Use existing product documents, without permanent per-agent plans, memories or competing specifications. Parallel jobs need independent files and dependencies.

Heavy means this change affects money correctness, security/login/permissions, live infrastructure/deployment, migrations or a public contract. A cosmetic edit in such a project is not Heavy. Heavy needs a written plan and independent review before completion/release when available. Without that capability, disclose the limitation, perform self-check and leave the independence requirement unresolved; never invent an independent PASS. Ordinary work remains executable without subagents.

Handoffs identify role, objective, permitted files, scope, canonical rules/spec pointers, baseline and required result. Workers load their own applicable canonical rules. A reviewer gets the target revision or identified snapshot, requirements/authorization pointers and necessary environment constraints, not the builder's narrative. Without Git use file hashes/diffs; do not initialize Git just for this method. Reviewers return findings; MainAgent records them.

## Proof and review

Run documented relevant baseline checks before implementation and required checks before committing. Investigate a red baseline before building on it; distinguish existing failures from new ones. Record when a new project has no suite. Choose tests for promised behavior, important edges and actual risks. For critical assurances or a defect fix, demonstrate that the check detects the relevant failure, on a copy, never in the real tree. Multiple related tests may fail; exactly one red test is not a quality criterion.

The implementer verifies promised user journeys end to end, including visible states, errors, input behavior and relevant viewport sizes. A function test does not establish usability. Use an available browser for UI work. If a required path cannot be exercised, record that gap; a simulated event is not proof of the real environment. Never call required unverified behavior proven.

Review against approved behavior. Separate impact severity from requirement compliance. A broken mandatory requirement, missing authorization or unverified required path blocks completion even if called MEDIUM. Optional improvements do not expand scope. ADB REVIEW defines its report and verdict. PLAIN records self-check or independent review, what was tried, findings and whether the agreed task is satisfied.

Fixes restore approved behavior without fresh approval. Changing promised behavior needs a scope decision first. Reproduce the defect, test the fix and neighboring affected behavior, then repeat relevant integration checks. After three unsuccessful fix rounds on the same slice, report causes and concrete options to the user; do not reset the count by renaming the work.

Destructive probes use isolated copies. Record the real tree's initial state and preserve it, including unrelated dirty files. Stop only task-owned processes by captured identities, never all processes of a runtime. Remove only verified task-owned temporary paths. A worktree shares Git metadata: use an independent clone/copy if the probe could alter repository state.

## Record and finish

Product truth written to `adb/` includes approval and provenance, not guesses presented as user decisions. Completion means the agreed plan is met, required paths proven and mandatory findings resolved. State outcome, evidence and limitations plainly. Whole-product readiness is separate from finishing a task.

In Git projects, commit scoped finished work after checks pass, unless the user requested otherwise. MainAgent may commit its own work; delegated CodeAgent reports its hash. Commit the approved ADB plan before delegated implementation when a revision is needed for the handoff. Do not stage unrelated files or make chat-only commits. Do not change Git configuration to bypass checks, force-push main or commit secrets. Compare actual blobs/hashes for identity claims; a commit title is not evidence.

Secrets never go into Git, logs, issues or chat. Never request passwords in chat or bypass checks with `--no-verify`. Ask before deleting user data, deploying, spending or changing live data unless that exact action is already authorized. Local implementation does not authorize deployment or refreshing other projects.
