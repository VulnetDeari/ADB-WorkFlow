#!/usr/bin/env bash
# Behavior checks: project-owned content and failed preflight must survive byte-for-byte.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SETUP="$ROOT/Methods/ADB/setup-into-project.sh"
START="$ROOT/Rules/start-into-project.sh"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/adb-preservation.XXXXXXXX")"
trap 'case "$fixture" in */adb-preservation.*) rm -rf -- "$fixture";; esac' EXIT
project="$fixture/project"
mkdir -p "$project"
# Standalone command installation/removal must reject an invalid parent before writing.
printf 'project-owned file\n' > "$project/.claude"
cp "$project/.claude" "$fixture/parent-file"
for action in --check --copy --remove; do
  if (cd "$project" && "$ROOT/Methods/ADB/install-commands.sh" "$action") >"$fixture/parent-conflict.log" 2>&1; then
    echo "FAIL: $action accepted a non-directory harness parent" >&2; exit 1
  fi
  grep -q CONFLICT "$fixture/parent-conflict.log"
  cmp "$fixture/parent-file" "$project/.claude"
  [ "$(find "$project" -type f | wc -l)" -eq 1 ]
done
rm "$project/.claude"
git -C "$project" init -q
"$SETUP" "$project" >"$fixture/setup.log" 2>&1
printf 'custom owner\n' > "$project/OWNER.md"
printf 'custom reading page\n' > "$project/LESEN.html"
printf 'Amounts are stored as integer cents.\n' > "$project/PROJECT-RULES.md"
mkdir -p "$project/adb" "$project/_bmad"
printf 'approved product\n' > "$project/adb/02-PRODUCT-SPEC.md"
printf 'unrelated engine\n' > "$project/_bmad/keep"
snapshot() {
  (cd "$project" && find . -type f ! -path './.git/*' -print0 | sort -z | xargs -0 cksum)
}
before="$(snapshot)"
"$SETUP" --check --refresh "$project" >"$fixture/check.log" 2>&1
[ "$before" = "$(snapshot)" ]
"$START" --refresh --project "$project" >"$fixture/refresh.log" 2>&1
[ "$before" = "$(snapshot)" ]
for rel in .claude/commands/start.md .claude/commands/adb.md; do
  sed 's/\r$//' "$project/$rel" | sed 's/$/\r/' > "$fixture/command-crlf"
  cp "$fixture/command-crlf" "$project/$rel"
done
"$SETUP" --refresh "$project" >"$fixture/command-crlf.log" 2>&1
cmp <(sed 's/\r$//' "$ROOT/Methods/ADB/commands/adb.md") <(sed 's/\r$//' "$project/.claude/commands/adb.md")
# Previous released commands must also be recognized after a Windows checkout.
legacy_command_revision="$(git -C "$ROOT" rev-list --all -- Methods/ADB/commands/adb.md 2>/dev/null | tail -n 1 || true)"
if [ -n "$legacy_command_revision" ] && git -C "$ROOT" show "$legacy_command_revision:Methods/ADB/commands/adb.md" >"$fixture/old-command" 2>/dev/null; then
  sed 's/\r$//' "$fixture/old-command" | sed 's/$/\r/' > "$project/.claude/commands/adb.md"
  "$SETUP" --refresh "$project" >"$fixture/old-command-crlf.log" 2>&1
  cmp <(sed 's/\r$//' "$ROOT/Methods/ADB/commands/adb.md") <(sed 's/\r$//' "$project/.claude/commands/adb.md")
else
  echo 'UNVERIFIED: historical command migration requires factory Git history'
fi
for rel in CLAUDE.md .claude/commands/start.md .claude/commands/adb.md; do
  cp "$project/$rel" "$fixture/original"
  printf 'foreign project instructions\n' > "$project/$rel"
  before="$(snapshot)"
  if "$SETUP" --refresh "$project" >"$fixture/conflict.log" 2>&1; then
    echo "FAIL: accepted foreign $rel" >&2; exit 1
  fi
  grep -q CONFLICT "$fixture/conflict.log"
  [ "$before" = "$(snapshot)" ]
  mv "$fixture/original" "$project/$rel"
done
cp "$project/.git/hooks/pre-commit" "$fixture/method-hook"
printf '\n# Project-specific check\nexit 7\n' >> "$project/.git/hooks/pre-commit"
cp "$project/.git/hooks/pre-commit" "$fixture/integrated-hook"
if "$SETUP" --refresh "$project" >"$fixture/integrated.log" 2>&1; then
  echo 'FAIL: accepted customized method hook' >&2; exit 1
fi
cmp "$fixture/integrated-hook" "$project/.git/hooks/pre-commit"
cp "$fixture/method-hook" "$project/.git/hooks/pre-commit"

# A retired method marker can coexist with project checks; preserve both it and its backup.
printf '#!/bin/sh\n# Method hook (customized legacy hook)\nexit 7\n' > "$project/.git/hooks/pre-push"
printf '#!/bin/sh\nexit 3\n' > "$project/.git/hooks/pre-push.pre-method"
cp "$project/.git/hooks/pre-push" "$fixture/custom-stale"
cp "$project/.git/hooks/pre-push.pre-method" "$fixture/custom-backup"
"$SETUP" --check --refresh "$project" >"$fixture/stale-check.log" 2>&1
cmp "$fixture/custom-stale" "$project/.git/hooks/pre-push"
cmp "$fixture/custom-backup" "$project/.git/hooks/pre-push.pre-method"
"$SETUP" --refresh "$project" >"$fixture/stale.log" 2>&1
cmp "$fixture/custom-stale" "$project/.git/hooks/pre-push"
cmp "$fixture/custom-backup" "$project/.git/hooks/pre-push.pre-method"
grep -q 'preserved unrecognized or customized retired hook' "$fixture/stale.log"

mkdir "$fixture/shared-hooks"
git -C "$project" config core.hooksPath "$fixture/shared-hooks"
before="$(snapshot)"
if "$SETUP" --refresh "$project" >"$fixture/external.log" 2>&1; then
  echo 'FAIL: wrote to external hooks directory' >&2; exit 1
fi
[ -z "$(find "$fixture/shared-hooks" -type f -print)" ]
[ "$before" = "$(snapshot)" ]
git -C "$project" config --unset core.hooksPath

"$START" --project "$project" --language en --address du --tone direct --method plain --risk none --product fixture >"$fixture/plain.log" 2>&1
printf 'METHOD: PLAIN\r\n' > "$project/METHOD.md"
cp "$project/METHOD.md" "$fixture/method-crlf"
"$SETUP" --refresh "$project" >"$fixture/crlf.log" 2>&1
cmp "$fixture/method-crlf" "$project/METHOD.md"
[ ! -e "$project/ADB.md" ]

# Test actual symlinks when this OS permits creating them. Never count a copied file as a link.
mkdir -p "$project/commands" "$project/.claude/commands"
printf 'foreign command\n' > "$project/commands/adb.md"
if MSYS=winsymlinks:nativestrict ln -s ../../commands/adb.md "$project/.claude/commands/adb.md" 2>"$fixture/symlink.log" && [ -L "$project/.claude/commands/adb.md" ]; then
  before="$(snapshot)"
  if "$SETUP" --refresh "$project" >"$fixture/link-conflict.log" 2>&1; then
    echo 'FAIL: replaced foreign command symlink' >&2; exit 1
  fi
  [ -L "$project/.claude/commands/adb.md" ]
  [ "$before" = "$(snapshot)" ]
  rm "$project/.claude/commands/adb.md"
  echo 'PASS: foreign relative command symlink preserved'
else
  echo 'UNVERIFIED: native symlink creation unavailable on this host'
  [ ! -e "$project/.claude/commands/adb.md" ] || rm "$project/.claude/commands/adb.md"
fi
printf '#!/bin/sh\nexit 7\n' > "$project/.git/hooks/pre-commit"
before="$(snapshot)"
if "$START" --project "$project" --language en --address du --tone short --method adb --risk none --product changed >"$fixture/hook.log" 2>&1; then
  echo 'FAIL: replaced foreign hook' >&2; exit 1
fi
grep -q CONFLICT "$fixture/hook.log"
[ "$before" = "$(snapshot)" ]
grep -q 'exit 7' "$project/.git/hooks/pre-commit"
echo 'PASS: refresh preservation, read-only check, harness/command/hook preflight, integrated and retired hooks, external hooks path, CRLF method and command copies'
