# Method factory

A public, project-local workflow for coding agents. Start installs shared rules and owner settings into another folder; daily work happens in that product. The factory contains no personal preferences or product specification.

## Files and ownership

| File in a product | Responsibility | Refresh |
|---|---|---|
| `AGENTS.md` | Shared rules, authority, role selection and proof | Factory-owned |
| `ADB.md` | ADB workflow; only in ADB mode | Factory-owned |
| `START.md` | Setup instructions | Factory-owned |
| Harness entries and commands | References to the canonical files | Factory-owned, conflicts checked first |
| `PROJECT-RULES.md` | Project-specific rules and authorized exceptions | Preserved; created only when needed |
| `OWNER.md` | Language, address, tone and setup answers | Preserved |
| `METHOD.md` | PLAIN or ADB choice | Preserved unless explicitly switched |
| `adb/` and other product docs | Product scope, authorization and evidence | Preserved |
| `LESEN.html` | Generated owner reading page | Preserved; regenerate explicitly |

There is one canonical `AGENTS.md` in this repository. `Methods/ADB/SKILL.md` is installed as `ADB.md`. Commands contain references, not alternate rulebooks. Small low-risk tasks can be handled by MainAgent in either method. Complexity and the concrete change's risk determine delegation and independent review.

## Start

Open the factory and say **Start**, supplying the target product folder, or invoke `/start` where available. Start reuses known answers and asks only for missing settings. Product context comes before estimating risk. ADB is valid for a small app too. `risk=yes` selects ADB without mandating three agents for every task.

After the conversation the agent runs:

```bash
./Rules/start-into-project.sh --project /path/to/app --language en --address du --tone direct --method adb --risk none --product "The agreed product sentence" --why "Reason for choosing ADB"
```

Use actual answers. Any language is supported through translation; German and English have shipped pages. Setup is complete only after any requested translation is finished. Setup does not approve product BUILD: the agent presents material behavior, records scope approval or explicit delegation, then builds. A precise authorized change to an existing product needs no repeated interview.

For provisioning without an interview:

```bash
./Methods/ADB/setup-into-project.sh --plain /path/to/app
./Methods/ADB/setup-into-project.sh /path/to/app
```

These copy method files without inventing OWNER/LESEN answers. The agent resolves missing settings before treating first-run setup as complete.

## Refresh and project rules

```bash
./Methods/ADB/setup-into-project.sh --check --refresh /path/to/app
./Methods/ADB/setup-into-project.sh --refresh /path/to/app
./Rules/start-into-project.sh --refresh --project /path/to/app
```

Both refresh entrypoints update method-owned files only. They preserve project rules, owner settings, product documents, method choice and the reading page. A repeated run with unchanged inputs is idempotent apart from the version date. Method copies are stamped; locally modified copies are not the place for custom project rules.

Existing foreign harness instructions, commands or pre-commit hooks cause a conflict before project files are written. Preserve local rules and their scope in PROJECT-RULES before explicitly converting a harness entry. Integrate existing hooks explicitly, keeping their behavior effective; the installer never quietly disables them. Unrelated methods and previous backups remain intact. A stamped method file is declared factory-owned: migrate any accidental local additions before refreshing it.

Historical ownership checks use the factory's Git history. Keep that history for upgrades: an archive or shallow clone may refuse unknown older command copies or retain retired hooks. Customized retired hooks are preserved with a notice, even when they still carry a method marker.

Normal Start changes settings and may switch PLAIN/ADB. It rewrites OWNER and regenerates LESEN, so preserve project-specific additions in PROJECT-RULES first. `./Rules/start-into-project.sh --lesen-only --project /path/to/app` explicitly regenerates LESEN from current OWNER. The project-owned PROJECT-RULES file can reference scoped local guidance; it never silently overrides the method or platform permissions.

## Harnesses and prerequisites

The workflow is plain Markdown and natural language. Slash commands, clickable choices and separate agents are optional capabilities. `CLAUDE.md` and `GEMINI.md` import `@AGENTS.md`. Copilot receives a relative Markdown reference; AGENTS-aware harnesses read the root file. The factory ships command copies for existing Claude/Codex/Cursor command locations, as conveniences rather than a promise that every release discovers those locations.

Sources checked for reference syntax: [Claude Code memory](https://code.claude.com/docs/en/memory), [Gemini CLI context](https://geminicli.com/docs/cli/gemini-md/), [GitHub Copilot repository instructions](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/add-custom-instructions/add-repository-instructions), [Cursor rules](https://cursor.com/docs/rules). These describe integration mechanisms; they do not prove agent compliance.

The scripts require Bash, Python 3, Git and standard Unix utilities. On Windows use Git Bash with Python available. Native PowerShell execution of `.sh` files is not supported. Do not infer a tested harness/OS combination from portable Markdown. Missing browser or independent review capability is recorded as a verification limit, not a successful check.

Setup installs a pre-commit check for common secret patterns and hidden trailing content. It is a heuristic, not complete secret detection or a user-approval gate. Hidden-content scanning excludes dependencies, root dist/build, lockfiles, minified files, maps and SVG; obfuscator-name patterns skip Markdown/text, but hidden whitespace checks do not. Existing `.gitattributes` is preserved; otherwise LF defaults and CRLF for bat/cmd are added. No push gate is installed.

## Maintaining and testing the factory

```bash
python3 Rules/check-layout.py --self-test
./Rules/check-factory.sh
./Rules/check-preservation.sh
```

The full suite provisions temporary projects, exercises method switching, hooks and preservation. `Rules/WORKFLOW-CHECKS.md` provides behavioral scenarios for independent evaluation; static tests cannot prove that an agent follows instructions. Keep validation claims scoped to observed results.

Approved method changes happen here. Record a generic entry in `Methods/ADB/LESSONS.md`; do not copy private chats or project identities into this public repository. Refresh target projects only within authorized scope, normally on a collected cadence or when a defect blocks work. Never install global rules as a prerequisite for project use.
