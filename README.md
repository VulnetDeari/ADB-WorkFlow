# Method factory

One repository. Two methods. **Start** asks with offered options (chips when clickable, else A/B/C), then copies files **into each product project**.

This folder is the factory, not an app. The file `AGENTS.md` at the top of this repo is the living agent rules. After Start, the **app** gets its own copy. Daily work happens in the app.

**First run** (clone this repo, open it, say **Start** or `/start`):

The owner picks **any language** (chips or A/B/C for common ones, or they type the name), address, tone, small or large, risk, and the **app folder**. They do not invent options. **When the owner is in chat, this interview is the first run.** Do not skip it with `setup-into-project.sh` — that path does not ask language.

Start writes into the **app**: `METHOD.md`, `AGENTS.md`, `OWNER.md`, `LESEN.html` in that language, `START.md`, and `/start`. Large also gets `ADB.md` and `/adb` commands. Deutsch and English use shipped pages; any other language is translated from the English page before Start is done.

```bash
# After the interview the agent runs this. You can run it yourself with the same answers:
./Rules/start-into-project.sh \
  --project /path/to/app \
  --language it \
  --address du \
  --tone direct \
  --method plain \
  --risk none \
  --product "Prodotto in questa cartella"
```

`--risk yes` always selects ADB, even if `--method plain`.

**Without the interview** (same copies, **no language question**, no `OWNER.md` / `LESEN.html` — not a finished first run if the owner is in chat):

**Small / plain:**

```bash
./Methods/ADB/setup-into-project.sh --plain /path/to/app
```

Writes `AGENTS.md` (copy of this repo’s `AGENTS.md`), harness pointers `CLAUDE.md` / `GEMINI.md` / `.github/copilot-instructions.md` (only `@AGENTS.md`), `START.md`, `/start`, and `METHOD: PLAIN`. Also `.gitattributes` (`* text=auto eol=lf`, `*.bat`/`*.cmd` CRLF; only when none exists) and the git hook against secrets and hidden content (not scanned: dependency folders, root-level `dist/` and `build/`, lockfiles, minified files, maps, SVG; obfuscator-name markers are not checked in `*.md` / `*.txt`, blank runs and CR tricks are); setup warns when the folder sits inside a cloud-sync client. Factory preview: `Rules/LESEN-DE.html`.

**Large / ADB:**

```bash
./Methods/ADB/setup-into-project.sh /path/to/app
```

Also writes `METHOD: ADB`, `ADB.md` (copy of `SKILL.md`), `/adb` commands, and the same `.gitattributes` and hook. Factory preview: `Methods/ADB/ADB-LESEN-DE.html`.

`--refresh` overwrites the method copies from the factory (`AGENTS.md`, `ADB.md`, `START.md`, and the harness pointers). It does not invent new owner answers and does not switch PLAIN↔ADB. Re-run `/start` to change language, tone, or small↔large — Start passes `--switch` so `METHOD.md` matches (`risk=yes` forces ADB) and PLAIN removes leftover `ADB.md` / `/adb` commands. `./Rules/start-into-project.sh --lesen-only --project /path/to/app` rebuilds `LESEN.html` from `OWNER.md`.

## Change cadence

The method changes only in this factory, after the owner approves. Collect changes; refresh product projects (`setup-into-project.sh --refresh`) at most once a month, unless a defect blocks real work. Every change gets a `LESSONS.md` entry. Hard rules go into `Rules/hooks/` (git hooks setup installs), not into more prose.

## Clone

```bash
git clone <url of this repository>
cd adb
```

Then **Start**. `Rules/install-skills.sh` is optional (home links). Apps do not need it.

Daily: open the **app** folder. Cloud Agent: the **app** GitHub repo after the copies are committed.

## Layout

```text
AGENTS.md                    living agent rules — setup copies into the app
CLAUDE.md / GEMINI.md / …    harness entry — setup writes only `@AGENTS.md`
Rules/skills/start/SKILL.md  Start interview — setup copies as START.md
Rules/start-into-project.sh  writes OWNER.md + LESEN.html, then setup
Methods/ADB/SKILL.md         ADB method — setup copies as ADB.md
```
