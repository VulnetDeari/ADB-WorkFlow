# ADB

**Ask. Decide. Build.**

ADB is a product method for AI coding agents. The owner sets where the product must land. Roles follow the project’s `AGENTS.md` (setup copy): the owner talks only to MainAgent; on ADB, PlanAgent, CodeAgent and ReviewAgent are required subagents. It is not an agent framework, a fake company, or a pile of extra process.

This is not the Android Debug Bridge.

The method is [`SKILL.md`](SKILL.md). Setup copies it into each project as `ADB.md`, and copies factory `AGENTS.md` as `AGENTS.md`. **Start** (`/start`, `Rules/skills/start/SKILL.md`) chooses PLAIN vs ADB with offered options (chips when clickable, else A/B/C) and writes `OWNER.md` + `LESEN.html`. Agents in a project follow those copies.

## Use it in a project

**First run with the owner:** Start (`/start`). It asks language (and the rest) with chips when clickable, else A/B/C, then writes `AGENTS.md`, `OWNER.md`, `LESEN.html`, `METHOD.md`, and `ADB.md` into the **app**. Do not add `METHOD.md` by hand and skip language.

Without the interview (no language question — not a finished first run if the owner is in chat):

```text
./Rules/start-into-project.sh --project /path/to/project --language de --address du --tone direct --method adb --risk none --product "..."
./setup-into-project.sh /path/to/project              # AGENTS.md + START.md + ADB
./setup-into-project.sh --plain /path/to/project      # AGENTS.md + START.md only
./setup-into-project.sh --check /path/to/project
./setup-into-project.sh --refresh /path/to/project    # overwrite copies from factory
./setup-into-project.sh --register /path/to/project   # optional: create adb/08-OPEN-ISSUES.md
```

`setup-into-project.sh` copies factory `AGENTS.md` to project `AGENTS.md` (stamped `METHOD-VERSION`). First layout follows the flags: without `--plain` it writes `METHOD: ADB`, **copies `SKILL.md` to `ADB.md`**, and installs slash commands as **copies**. `--plain` writes `METHOD: PLAIN` and **removes** `ADB.md` and `/adb` commands. Product `adb/` docs stay. An existing `METHOD.md` line does **not** flip unless Start passes `--switch` (small↔large or `risk=yes`). `--refresh` updates copies; it does not invent a method switch or owner answers. It **does not** create `adb/08-OPEN-ISSUES.md` unless you pass `--register`. Start writes `OWNER.md` / `LESEN.html`; setup without the interview does not. If a copy is older than the factory file, setup reports `STALE` and does not stamp. Setup also writes `.gitattributes` (`* text=auto eol=lf`, `*.bat`/`*.cmd` CRLF) when none exists, installs the git hook against secrets and hidden content (not scanned: dependency folders, root-level `dist/` and `build/`, lockfiles, minified files, maps, SVG; obfuscator-name markers are not checked in `*.md` / `*.txt`, blank runs and CR tricks are), and warns when the project sits inside a cloud-sync client.

Slash commands (`/adb`, `/adb-define`, `/adb-slice`, `/adb-review`, `/adb-status`, `/adb-triage`, `/adb-ready`) live in [`commands/`](commands/). They point at the project’s `ADB.md`.

Inside this repository, `.cursor/commands/`, `.claude/commands/` and `.codex/prompts/` hold **copies** of `commands/` (symlinks were 28-byte stubs on Windows). Edit `commands/`, then run `./install-commands.sh --copy` here; `check-factory.sh` fails when a copy drifts.

```text
./install-commands.sh                 # install into the current directory
./install-commands.sh --check         # report only
./install-commands.sh --remove        # remove from the current directory
./install-commands.sh --remove-global # delete leftover home-level installs
```

Follow only this app’s `ADB.md` and `AGENTS.md`.

Defects in the method itself, found by real projects, go in [`LESSONS.md`](LESSONS.md). Ordinary project issues do not.

Vision, Product Spec and the rest of `adb/01`…`adb/07` are **not** created by setup. They are written in DEFINE. The issue register starts in `adb/07-STATUS.md` for collapsed products; split to `adb/08-OPEN-ISSUES.md` when the list needs its own file.

## What it does

- **Ask** — grill the product, not the user. Research what can be discovered. Offer real choices. `Decide for me` is valid.
- **Decide** — keep that in `adb/`. Small products may collapse to Vision, Product Spec and Status. Larger products use `adb/01` … `adb/08`. Uncertain findings get registered, not swallowed.
- **Build** — CodeAgent executes against `adb/` (MainAgent directs). Prove on a real path (browser, tests, logins). Missing required behavior is fixed or written down, not ignored. Git: AGENTS.md (commit when the job is done).

The full method is in [`SKILL.md`](SKILL.md).

Zum Lesen auf Deutsch: [`ADB-LESEN-DE.html`](ADB-LESEN-DE.html). Agenten in einem Projekt folgen `ADB.md` — nicht dieser Datei.
