---
name: start
description: "Set up or update project method and owner settings. Reuse known answers; setup does not approve product implementation."
---

# Start

Canonical: factory `Rules/skills/start/SKILL.md`, installed as `START.md`. Follow project `AGENTS.md` for shared rules. This is setup, not product DEFINE or BUILD.

## Entry

Use when the user requests setup/start, changes method or communication settings, or wants an app in a folder with incomplete settings. In the factory, the product folder must be elsewhere. Never create product METHOD/OWNER here. Refresh updates the method without a new interview.

MainAgent handles routine setup itself; delegate only when useful for the actual task. Read existing OWNER/METHOD/project rules and conversation first. Reuse explicit answers; never copy another project's preferences.

## Collect missing settings

Offer **chips** when clickable, else A/B/C. Ask one material decision at a time, in the user's language until language is selected. Short labels, free text where needed. Decide-for-me is offered only for a valid bounded choice. Do not repeat answered questions; changing tone does not require a new full interview.

| Field | Obtain from | Explicitly delegated default |
|---|---|---|
| PROJECT | Current app folder or supplied path, never factory | Current folder only if it is an app; otherwise require a path |
| PRODUCT | User's sentence: what it does and for whom | If explicitly undecided, localized “Product in this folder”; never invent features |
| LANGUAGE / LANGUAGE-NAME | Offer common languages and any typed language | Conversation language |
| ADDRESS | Informal, formal, first name if already supplied | Informal (`du`) |
| TONE | Direct, calm, short | Direct |
| METHOD | Explicit PLAIN/ADB choice or recommendation from known scope | ADB is valid even for a small app |
| RISK | Actual money, access/security, live operations or others' data | Assess known behavior, never infer safety from size |

Product context comes before estimating method/risk. `risk=yes` selects ADB without mandating three agents for later edits. Choosing ADB alone does not establish other answers or BUILD approval. Material unknown risk needs clarification, not an invented `none`. Defaults require explicit delegation, never silence.

Store ADDRESS `du|sie|name`, TONE `direct|calm|short`, METHOD `plain|adb`, RISK `none|yes`. Map language with `Rules/templates/resolve-language.py` or its `language-tags.txt`; unknown name uses `und` and its supplied display name.

## Apply

After missing settings are resolved, run the factory script with the collected values. Do not manually recreate its outputs:
```bash
./Rules/start-into-project.sh --project /path/to/app --language en --address du --tone direct --method adb --risk none --product "The agreed product sentence" --why "Reason for this method"
```
Use actual values, not the examples. Optional `--language-name` preserves a typed display name. Preflight conflicts must be resolved before replacement: preserve existing project rules in PROJECT-RULES, retain their original scope and keep unrelated hooks effective. Never bypass a conflict by deleting its source.

On script failure, report the error and repair within authorized scope; do not claim completion or invent a manual layout. Confirm nonempty AGENTS/START/METHOD, ADB when selected, and OWNER/LESEN after Start.

If TRANSLATE is reported, translate all visible LESEN text and OWNER human sentences/WHY. Preserve HTML structure, keys, filenames and commands; set page language, remove TRANSLATE-TO and set OWNER TRANSLATE to no. Do not add/drop rules in translation.

Report method/reason, files written and link to the project's LESEN.html. Setup is complete. If a product was already requested, continue to ADB DEFINE or PLAIN product clarification; otherwise wait for a product task. Never silently begin BUILD from setup.

## Refresh and changes

`./Rules/start-into-project.sh --refresh --project /path/to/app` and setup `--refresh` update method-owned files only, preserving PROJECT-RULES, OWNER, LESEN, method choice and product docs. Inspect conflicts before writes. One refresh does not authorize refreshing other projects.

For settings changes, collect only changed/missing answers and run normal Start. Normal Start rewrites OWNER and regenerates LESEN, switching method through its internal `--switch`. Preserve project-specific additions from OWNER in PROJECT-RULES before regeneration. `--lesen-only` explicitly rebuilds LESEN from current OWNER.

## Capabilities

The workflow works in plain language without slash commands, chips or subagents. Setup scripts require Bash, Python 3 and Git tools; native PowerShell execution is not claimed. If unavailable, name the prerequisite and use an available supported runtime. Do not claim tools ran or integrations were tested when they were not.
