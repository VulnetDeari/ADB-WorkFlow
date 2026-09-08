# ADB

Ask. Decide. Build. A product workflow for AI coding agents, not Android Debug Bridge.

The canonical method is [SKILL.md](SKILL.md), copied into products as `ADB.md`; shared rules come from the factory's root `AGENTS.md`. Read the [factory README](../../README.md) for setup, ownership, refresh, prerequisites and validation commands.

ADB records approved product behavior, then delivers usable slices with appropriate proof. MainAgent can handle small, clear, low-risk changes itself. PlanAgent, CodeAgent and ReviewAgent are used according to the concrete work; subagents do not recursively form teams. Without separate review the result is labeled self-check.

Choosing ADB does not approve a product specification. The product proposal and explicit scope approval or delegation are recorded before new-product BUILD. Existing precise authorizations are reused. A failed mandatory requirement blocks completion regardless of its impact label.

The [commands](commands/) reference the canonical method and add no rules. Installed product copies work without access to this factory. Factory harness command copies must match their reference source; synchronize them when changing commands and run the factory checks. `install-commands.sh` defaults to regular copies for Windows compatibility; existing project-specific commands conflict before replacement.

Project-specific rules live in `PROJECT-RULES.md` and survive refresh. The factory creates no product specs at setup. The project records its authorization, spec, plan and evidence in `adb/`, without permanent per-agent documents or duplicate reports.

[LESSONS.md](LESSONS.md) is historical maintenance evidence, not an additional active rulebook. Current behavior is defined only by AGENTS and the installed ADB method.
