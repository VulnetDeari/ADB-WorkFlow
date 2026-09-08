---
name: adb
description: "Ask. Decide. Build. Product clarification, scoped delivery and verification when the project selects METHOD: ADB."
---

# ADB

## Entry

`AGENTS.md` owns shared rules, authorization, project-rule conflicts, role selection and proof. This file adds the workflow; setup installs it as `ADB.md`. Read Entry and the current phase/role section; read Source of truth when writing records. Load unrelated specs and historical reviews only when needed. Commands reference these sections and contain no separate method.

Natural language and slash commands use the same workflow: new product/unresolved scope → DEFINE; approved work → BUILD; review → REVIEW; progress → STATUS; whole-product assessment → COMPLETION. Small, clear work may be done by MainAgent with self-check. ADB alone never requires three agents.

Setup completion is neither product definition nor permission to build. Before BUILD, the executing agent checks current scope and its authorization record itself. `PHASE: BUILD`, a plan commit or another agent's assertion alone is not authorization. Missing evidence: MainAgent retrieves the existing user instruction or obtains the missing decision. Never fabricate approval.

## Source of truth

Default: `adb/01-VISION.md`, `adb/02-PRODUCT-SPEC.md`, `adb/07-STATUS.md`. Split when useful: 03 screens/flows, 04 architecture/security/deploy, 05 acceptance/production criteria, 06 decisions/WHY, 08 issues. No duplicate registers or per-agent documents. Reference existing project documentation rather than copying it unnecessarily.

01 describes purpose, audience and boundaries. 02 holds observable behavior, states, errors and examples, with stable requirement IDs for material promises. A small task can use one concise requirement. Facts: KNOWN / UNKNOWN / ASSUMED / CONFLICTING / NEEDS RESEARCH / NEEDS USER DECISION. Material requirements cite their origin: user instruction, approved proposal or delegated decision with its boundary. An assumption cannot silently become approved. Technical details within approved scope need no individual vote.

07 has a short header: PHASE, NOW, NEXT, BLOCKERS, OPEN, READINESS. Preserve useful sections, without making a chat log:
- `## Authorization`: approved scope/requirement IDs and revision, date, relevant user words or an accessible decision reference, and delegation limits. Do not copy private chat history. New explicit corrections update affected requirements and authorization before dependent work; old files never overrule the user.
- `## Execution plan`: map of slices, only when multiple slices are useful.
- `## Slice plan`: current task, done criteria, risks and selected roles; small work may use a few lines.
- `## Evidence`: requirement → check/path, observed result, environment, limitations and target revision. Reference existing output; no report file per agent.
- `## Last review`: latest reviewer report preserved faithfully, or a durable report reference plus verdict/blockers. History stays in Git where available. In chat give outcome, important findings and location, without copying the full report again.
- `## Open issues` if 08 is absent; `## Readiness` for whole-product assessment.

## DEFINE

No product implementation. MainAgent may clarify directly or use PlanAgent according to AGENTS Roles.

Inspect first: existing behavior, working paths, defects, constraints and what to preserve. Distinguish new from existing products. Reuse explicit answers and project-owned rules; do not borrow another project's preferences.

Present a coherent proposal in the user's language: purpose/audience, main journey, included behavior, excluded scope, material assumptions and choices. A short request may need one short proposal. Ask only product decisions that evidence cannot resolve; offer recommendations or bounded delegation. No fixed number of product questions and no endless interview once the first slice is decision-complete.

Before BUILD obtain approval of that proposal or identify an existing explicit approval of the same scope. Options may be build / change a point / decide within stated limits. Silence and method selection never count. A precise instruction for a small existing-task change can itself authorize it: record it without another approval ceremony. Delegated choices authorize only the stated boundaries, not arbitrary expansion or deployment.

Record authorization in 07 and approved requirements in 02. Unresolved assumptions affecting the first slice block that slice; unrelated questions may stay open. A later scope change reopens only affected decisions, not all DEFINE.

## BUILD

SPEC → BUILD → PROVE → RECORD. Planned slices continue under existing authorization. Do not ask permission for every routine step. Stop at unresolved product decisions and scope boundaries.

SPEC: check authorization; derive a bounded user-visible slice. Identify files/boundaries, risks, roles and acceptance criteria. Each criterion states precondition, action, observable outcome and a feasible check. Implementation-string searches do not substitute for behavior. Missing tooling is a limitation to resolve, not a presumed pass. MainAgent records the plan and commits it before delegated implementation when using revision handoffs. Heavy or unresolved implementation risk calls for plan review.

BUILD: MainAgent or CodeAgent implements within permitted files and approved scope. KEEP what works; IMPROVE, REPLACE or REMOVE when the task warrants it. Do not add features or redesign architecture merely for test convenience.

PROVE: implementer checks each promised journey, relevant visible/error states and important edges. Record automated, manual, simulated and unverified evidence distinctly in 07. Apply AGENTS Proof and review. Unit tests alone cannot close a UI task. Use REVIEW when selected/required; small low-risk tasks use self-check.

RECORD: reconcile code, approved spec and evidence. Mandatory failures or required verification gaps mean not complete: register with a next action. Record review/issues, update STATUS and commit scoped work under AGENTS. Do not change requirements to make accidental behavior pass. A deliberate scope change needs an authorized decision first, then spec, then implementation.

Fix rounds: implementer owns code repairs, planner/MainAgent owns plan repairs, MainAgent routes product decisions to the user when not delegated. Findings cite expected behavior and evidence, not mandatory patch recipes. Recheck the defect and affected existing behavior. Reuse passing evidence only when it remains applicable to the target revision. Three failed rounds: AGENTS escalation rule.

## REVIEW

The reviewer loads this section and AGENTS directly even without a slash command. MainAgent supplies review type, target revision (range for code, plan revision for plan review, whole snapshot for readiness), requirement/authorization pointers and necessary environment limits. No builder success narrative. Read target-revision files rather than a moving working tree; explicitly identify additional working-tree changes.

Plan review checks authorization, scope completeness, feasibility and executable criteria. Product implementation is not required before plan approval. Use a bounded experiment on a copy only for a specific uncertain mechanism; do not build the whole product as a review prerequisite.

Implementation review runs relevant tests independently, walks required real paths, checks usability and tries meaningful failure cases. Heavy checks match the change: money rounding/idempotency/reversal; permissions denied access/isolation; infrastructure rollback; migrations partial failure/recovery. Omit irrelevant classes with a reason. Isolation and capability limits follow AGENTS.

**Severity:** CRITICAL means severe security/data/money loss or unusable core; HIGH means major failure; MEDIUM means limited/edge failure; LOW means minor impact. Severity describes impact, not permission to ignore a requirement.

**Verdict:** FAIL if mandatory behavior diverges, authorization is missing or a required path is unverified. PASS WITH ISSUES only if every mandatory requirement is satisfied and remaining optional/nonblocking findings are registered. PASS when requirements are satisfied and no findings remain. RELEASE BLOCKERS include unresolved mandatory failures and actual release risks; low severity cannot turn a broken promise into completion.

Report concisely, with enough reproduction evidence:
```
REVIEW-TYPE: plan | implementation | readiness
REVIEW-BY: independent | self-check
TARGET: revision or identified snapshot
TRIED:
- requirement / path / check -> observed outcome; environment and limits
FOUND:
- impact; requirement or optional; evidence; expected behavior
SPEC COMPLIANCE: satisfied | diverges | unverified
VERDICT: PASS | FAIL | PASS WITH ISSUES
RELEASE BLOCKERS: none | findings
```
Missing TRIED, compliance, target or verdict makes the report incomplete. MainAgent obtains missing evidence before acceptance. Reject a verdict that contradicts findings; do not silently relabel it. Same-session review is headed `Review: self-check`, never called independent. Plan compliance means plan vs approved scope, without demanding nonexistent code execution.

## ISSUES

One register: 08 or 07's Open issues. Stable ISSUE-00N IDs. Fields: SEVERITY, PROBLEM, EVIDENCE, STATUS (OPEN / WAITING ON USER / CLOSED / ACCEPTED / REJECTED), CARRIED. CLOSED requires RESOLUTION and VERIFIED BY. ACCEPTED requires an authorized disposition/reason and cannot waive mandatory behavior without approved scope change or characterize critical/security/data loss as safe. REJECTED requires evidence that the report is invalid/outside scope. Preserve entries.

CARRIED starts at 0. Increment once per completed slice RECORD or release assessment carrying an OPEN issue; record its event ID/revision as LAST-COUNTED so retries cannot count twice. Progress questions never age issues. WAITING ON USER freezes the count. At 3 fix, reject with evidence or seek explicit acceptance; never silently delete/close. This works without slash commands.

## STATUS

Read current records and new user instructions; reconcile authorized corrections. Update actual phase, now, next, blockers and open count, preserving authorization/plan/evidence/review/issue sections. Never fabricate readiness or call waiting work running. Mark readiness stale when assessed behavior changes. Return short factual status; missing readiness does not create another task automatically.

## COMPLETION

A slice is complete when approved criteria are proven and mandatory findings resolved. Whole-product readiness is assessed only when requested, not after each slice. Apply REVIEW to agreed product scope and production criteria (05, or 02 when collapsed). MainAgent records the assessor's block in 07:
```
READINESS: NICHT_FERTIG | ALPHA | BETA | LIVE
READINESS-BY: independent | self-check
TARGET: revision or snapshot
GAPS: none | issue IDs / verification limits
STALE-NEXT: changes affecting assessed behavior
```
NICHT_FERTIG: broken core or unmet required behavior. ALPHA: core demonstration works, gaps registered, not product complete. BETA: agreed scope and required journeys/states proven; only permitted nonblocking gaps. LIVE: BETA plus production/release criteria proven and independent review. A self-check must not return LIVE. An online deployment is not proof of readiness.
