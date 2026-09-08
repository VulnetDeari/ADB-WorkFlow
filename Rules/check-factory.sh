#!/usr/bin/env bash
# Prove this clone is a usable method factory. Exit 0 only if Start can lay AGENTS.md.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() { echo "FAIL: $*" >&2; exit 1; }

[ -f AGENTS.md ] || fail "root AGENTS.md missing"
[ -f Rules/start-into-project.sh ] || fail "Rules/start-into-project.sh missing"
[ -f Rules/skills/start/SKILL.md ] || fail "Start skill missing"
[ -f Methods/ADB/SKILL.md ] || fail "ADB SKILL.md missing"
[ -x Methods/ADB/setup-into-project.sh ] || fail "setup-into-project.sh missing or not executable"
[ -x Rules/start-into-project.sh ] || fail "start-into-project.sh not executable"

head -1 AGENTS.md | grep -qx '# Agent rules' || fail "root AGENTS.md must be the product rules (# Agent rules)"
grep -q 'MainAgent' AGENTS.md || fail "root AGENTS.md is not the product rules"
grep -q 'Chips when clickable, else A/B/C' AGENTS.md || fail "AGENTS.md must use chips when clickable, else A/B/C"
grep -q 'Offer \*\*chips\*\* when clickable, else A/B/C' Rules/skills/start/SKILL.md || fail "Start skill must offer chips when clickable, else A/B/C"
if grep -q 'A) BUILD' Methods/ADB/commands/adb-define.md; then
  fail "adb-define still offers A) B) C)"
fi
if grep -q 'offers letters' Rules/start-into-project.sh; then
  fail "start-into-project.sh header still says letters"
fi
if grep -q 'I will type' Rules/skills/start/SKILL.md; then
  fail "Start English chips still over 4 words"
fi
if grep -rniE '\bbmad\b' --include='*.md' --include='*.html' .; then
  fail "method text still names a former method"
fi
if grep -qE 'Push Main|ALLOW_MAIN_PUSH|push only when' AGENTS.md README.md Methods/ADB/README.md Methods/ADB/SKILL.md Rules/skills/start/SKILL.md Methods/ADB/commands/*.md Rules/templates/*.html; then
  fail "a push gate came back (L-039)"
fi
if grep -qE 'constrained-self-check|WALKED' Methods/ADB/SKILL.md Methods/ADB/commands/adb-ready.md Rules/skills/product-readiness/SKILL.md; then
  fail "readiness still speaks its own review vocabulary (L-040)"
fi
grep -q 'CRITICAL' Methods/ADB/commands/adb-review.md || fail "adb-review has no severity scale"
grep -q 'changes nothing in the repo' Methods/ADB/commands/adb-review.md || fail "adb-review lets the reviewer touch the real tree"
grep -q 'plan commit' Methods/ADB/commands/adb-review.md || fail "adb-review plan review has no executable range"
grep -q 'This folder is the method factory' AGENTS.md && fail "root AGENTS.md is still the old pointer"

if grep -q 'MainAgent' Rules/AGENTS.md 2>/dev/null; then
  :
else
  grep -q '\.\./AGENTS.md' Rules/AGENTS.md || fail "Rules/AGENTS.md should point at ../AGENTS.md"
fi

# Refuse Start against the factory
ERR="$(mktemp)"
if Rules/start-into-project.sh --project "$ROOT" --language de --address du --tone direct --method plain --risk none --product "x" >/dev/null 2>"$ERR"; then
  rm -f "$ERR"
  fail "Start must refuse the factory folder"
fi
grep -qi 'factory' "$ERR" || { cat "$ERR" >&2; rm -f "$ERR"; fail "Start refusal did not mention factory"; }
rm -f "$ERR"

has_adb_commands() {
  local root="$1" f
  for f in \
    "$root/.cursor/commands"/adb.md \
    "$root/.cursor/commands"/adb-*.md \
    "$root/.claude/commands"/adb.md \
    "$root/.claude/commands"/adb-*.md \
    "$root/.codex/prompts"/adb.md \
    "$root/.codex/prompts"/adb-*.md
  do
    [ -e "$f" ] && return 0
  done
  return 1
}

assert_adb_app() {
  local root="$1" why="$2"
  [ -s "$root/AGENTS.md" ] || fail "$why: AGENTS.md missing"
  [ -s "$root/START.md" ] || fail "$why: START.md missing"
  [ -s "$root/ADB.md" ] || fail "$why: ADB.md missing"
  grep -qx 'METHOD: ADB' "$root/METHOD.md" || fail "$why: METHOD.md is not ADB"
  has_adb_commands "$root" || fail "$why: /adb commands missing"
  [ -f "$root/.cursor/commands/start.md" ] || fail "$why: /start command missing"
  if [ -f "$root/OWNER.md" ]; then
    grep -q '^METHOD: ADB' "$root/OWNER.md" || fail "$why: OWNER.md METHOD is not ADB"
  fi
  if [ -f "$root/LESEN.html" ]; then
    grep -q 'Große Methode' "$root/LESEN.html" || fail "$why: LESEN.html is not ADB"
  fi
}

assert_plain_app() {
  local root="$1" why="$2"
  [ -s "$root/AGENTS.md" ] || fail "$why: AGENTS.md missing"
  [ -s "$root/START.md" ] || fail "$why: START.md missing"
  grep -qx 'METHOD: PLAIN' "$root/METHOD.md" || fail "$why: METHOD.md is not PLAIN"
  [ ! -e "$root/ADB.md" ] || fail "$why: leftover ADB.md"
  if has_adb_commands "$root"; then
    fail "$why: leftover /adb commands"
  fi
  [ -f "$root/.cursor/commands/start.md" ] || fail "$why: /start command missing"
  if [ -f "$root/OWNER.md" ]; then
    grep -q '^METHOD: PLAIN' "$root/OWNER.md" || fail "$why: OWNER.md METHOD is not PLAIN"
  fi
  if [ -f "$root/LESEN.html" ]; then
    grep -q 'Kleine Methode' "$root/LESEN.html" || fail "$why: LESEN.html is not PLAIN"
  fi
}

start_into() {
  local root="$1" method="$2" risk="$3"
  Rules/start-into-project.sh \
    --project "$root" \
    --language de \
    --address du \
    --tone direct \
    --method "$method" \
    --risk "$risk" \
    --product "Factory check" >/dev/null
}

APP="$(mktemp -d)"
PLAIN_APP="$(mktemp -d)"
SETUP_PLAIN="$(mktemp -d)"
RISK_APP="$(mktemp -d)"
trap 'rm -rf "$APP" "$PLAIN_APP" "$SETUP_PLAIN" "$RISK_APP"' EXIT

start_into "$APP" adb none
assert_adb_app "$APP" "Start ADB"
mkdir -p "$APP/adb"
printf '%s\n' '# Vision' > "$APP/adb/01-VISION.md"
[ -s "$APP/OWNER.md" ] || fail "Start did not write OWNER.md"
[ -s "$APP/LESEN.html" ] || fail "Start did not write LESEN.html"
grep -q '^METHOD-VERSION:' "$APP/AGENTS.md" || fail "app AGENTS.md has no METHOD-VERSION"
head -1 "$APP/AGENTS.md" | grep -q '^METHOD-VERSION:' || fail "app AGENTS.md stamp is not first line"
grep -q 'MainAgent' "$APP/AGENTS.md" || fail "app AGENTS.md is not the product rules"
grep -q '^LANGUAGE: de' "$APP/OWNER.md" || fail "OWNER.md language was not stored"
if grep -qiE '\bbmad\b' "$APP/LESEN.html" "$APP/AGENTS.md" "$APP/ADB.md" "$APP/START.md"; then
  fail "app copies still name a former method"
fi

start_into "$PLAIN_APP" plain none
assert_plain_app "$PLAIN_APP" "Start PLAIN"
[ -s "$PLAIN_APP/OWNER.md" ] || fail "PLAIN Start did not write OWNER.md"
grep -q '^METHOD: PLAIN' "$PLAIN_APP/OWNER.md" || fail "PLAIN OWNER.md METHOD is not PLAIN"

Methods/ADB/setup-into-project.sh --plain "$SETUP_PLAIN" >/dev/null
assert_plain_app "$SETUP_PLAIN" "setup --plain"
[ ! -f "$SETUP_PLAIN/OWNER.md" ] || fail "setup-without-interview wrote OWNER.md"

start_into "$APP" plain none
assert_plain_app "$APP" "Start flip to PLAIN"
[ -f "$APP/adb/01-VISION.md" ] || fail "PLAIN cleanup deleted product adb/"

start_into "$APP" adb none
assert_adb_app "$APP" "Start flip to ADB"

start_into "$RISK_APP" plain yes
assert_adb_app "$RISK_APP" "risk=yes from PLAIN"
grep -q '^METHOD: ADB' "$RISK_APP/OWNER.md" || fail "risk=yes OWNER.md METHOD is not ADB"

NO_SWITCH="$(mktemp)"
Methods/ADB/setup-into-project.sh --plain "$APP" >/dev/null 2>"$NO_SWITCH"
assert_adb_app "$APP" "setup --plain without Start stays ADB"
grep -qi 'not switching' "$NO_SWITCH" || fail "setup --plain on ADB without Start should warn"
[ -f "$APP/adb/01-VISION.md" ] || fail "setup --plain without Start deleted product adb/"

Methods/ADB/setup-into-project.sh --refresh "$PLAIN_APP" >/dev/null 2>"$NO_SWITCH"
assert_plain_app "$PLAIN_APP" "--refresh without --plain stays PLAIN"
grep -qi 'not switching' "$NO_SWITCH" || fail "--refresh on PLAIN without Start should warn"
rm -f "$NO_SWITCH"

# --- Git hooks: secrets blocked at commit; the method does not gate pushes ---
HOOK_APP="$(mktemp -d)"
HOOK_REMOTE="$(mktemp -d)"
trap 'rm -rf "$APP" "$PLAIN_APP" "$SETUP_PLAIN" "$RISK_APP" "$HOOK_APP" "$HOOK_REMOTE"' EXIT
git init -q -b main "$HOOK_APP"
git -C "$HOOK_APP" config user.email factory@check
git -C "$HOOK_APP" config user.name factory
git init -q --bare -b main "$HOOK_REMOTE"
git -C "$HOOK_APP" remote add origin "$HOOK_REMOTE"
Methods/ADB/setup-into-project.sh --plain "$HOOK_APP" >/dev/null
[ -x "$HOOK_APP/.git/hooks/pre-commit" ] || fail "setup did not install pre-commit hook"
[ ! -e "$HOOK_APP/.git/hooks/pre-push" ] || fail "setup installed a pre-push hook; the method does not gate pushes"

printf 'harmless\n' > "$HOOK_APP/README.md"
git -C "$HOOK_APP" add README.md
git -C "$HOOK_APP" commit -q -m "harmless" || fail "pre-commit blocked a harmless commit"

printf 'DB_PASSWORD=real-secret-value-123\n' > "$HOOK_APP/.env"
git -C "$HOOK_APP" add -f .env
if git -C "$HOOK_APP" commit -q -m "leak" 2>/dev/null; then
  fail "pre-commit did not block a staged .env"
fi
git -C "$HOOK_APP" reset -q HEAD .env; rm -f "$HOOK_APP/.env"

printf 'key = "AKIAABCDEFGHIJKLMNOP"\n' > "$HOOK_APP/config.py"
git -C "$HOOK_APP" add config.py
if git -C "$HOOK_APP" commit -q -m "leak2" 2>/dev/null; then
  fail "pre-commit did not block an AWS key in content"
fi
git -C "$HOOK_APP" reset -q HEAD config.py; rm -f "$HOOK_APP/config.py"

printf 'DB_PASSWORD=changeme-example\n' > "$HOOK_APP/.env.example"
git -C "$HOOK_APP" add .env.example
git -C "$HOOK_APP" commit -q -m "example" || fail "pre-commit blocked .env.example"

git -C "$HOOK_APP" push -q origin main 2>/dev/null || fail "push to main was blocked; the method does not gate pushes"
git -C "$HOOK_APP" checkout -q -b feature
# A stale method pre-push from an older factory goes on refresh; a foreign hook stays.
printf '#!/usr/bin/env bash\n# Method hook (installed by setup-into-project.sh). Old push gate.\nexit 1\n' > "$HOOK_APP/.git/hooks/pre-push"
chmod +x "$HOOK_APP/.git/hooks/pre-push"
printf '#!/usr/bin/env bash\nexit 0\n' > "$HOOK_APP/.git/hooks/post-checkout"
chmod +x "$HOOK_APP/.git/hooks/post-checkout"
if git -C "$HOOK_APP" push -q origin feature 2>/dev/null; then
  fail "the stale pre-push stand-in did not block; this counter-proof proves nothing"
fi
Methods/ADB/setup-into-project.sh --refresh --plain "$HOOK_APP" >/dev/null 2>&1 || fail "refresh failed on the stale-hook fixture"
[ ! -e "$HOOK_APP/.git/hooks/pre-push" ] || fail "refresh left a stale method pre-push hook in place"
[ -x "$HOOK_APP/.git/hooks/post-checkout" ] || fail "refresh removed a foreign hook"
git -C "$HOOK_APP" push -q origin feature 2>/dev/null || fail "a push was blocked after refresh"
# A foreign pre-push an older setup had set aside comes back when the method hook goes.
printf '#!/usr/bin/env bash\nexit 0\n' > "$HOOK_APP/.git/hooks/pre-push.pre-method"; chmod +x "$HOOK_APP/.git/hooks/pre-push.pre-method"
printf '#!/usr/bin/env bash\n# Method hook (installed by setup-into-project.sh). Old push gate.\nexit 1\n' > "$HOOK_APP/.git/hooks/pre-push"; chmod +x "$HOOK_APP/.git/hooks/pre-push"
Methods/ADB/setup-into-project.sh --refresh --plain "$HOOK_APP" >/dev/null 2>&1 || fail "refresh failed on the displaced-hook fixture"
[ -x "$HOOK_APP/.git/hooks/pre-push" ] || fail "refresh did not restore the project's own pre-push"
if grep -q 'Method hook' "$HOOK_APP/.git/hooks/pre-push"; then fail "restored pre-push is still the method hook"; fi
[ ! -e "$HOOK_APP/.git/hooks/pre-push.pre-method" ] || fail "pre-method copy left behind after restore"
rm -f "$HOOK_APP/.git/hooks/pre-push"
[ "$(tr -cd '\r' < "$HOOK_APP/.git/hooks/pre-commit" | wc -c)" -eq 0 ] || fail "installed pre-commit carries CR bytes"

# --- Hook: hidden trailing content blocked; the same line under vendor/ passes ---
printf 'export const a = 1;%250s// trailing\n' '' > "$HOOK_APP/trail.js"
git -C "$HOOK_APP" add trail.js
if git -C "$HOOK_APP" commit -q -m "trail" 2>/dev/null; then
  fail "pre-commit did not block a 250-space trailing line"
fi
git -C "$HOOK_APP" reset -q HEAD trail.js; rm -f "$HOOK_APP/trail.js"

printf 'var _0x%s = 1;\n' 'a1b2c3' > "$HOOK_APP/obf.js"
git -C "$HOOK_APP" add obf.js
if git -C "$HOOK_APP" commit -q -m "obf" 2>/dev/null; then
  fail "pre-commit did not block an obfuscator name"
fi
git -C "$HOOK_APP" reset -q HEAD obf.js; rm -f "$HOOK_APP/obf.js"

mkdir -p "$HOOK_APP/vendor"
printf 'export const a = 1;%250s// trailing\n' '' > "$HOOK_APP/vendor/trail.js"
git -C "$HOOK_APP" add vendor/trail.js
git -C "$HOOK_APP" commit -q -m "vendored" || fail "pre-commit blocked the same line under vendor/"

{ printf 'export const a = 1;'; head -c 250 /dev/zero | tr '\0' '\t'; printf '// trailing\n'; } > "$HOOK_APP/tabs.js"
git -C "$HOOK_APP" add tabs.js
if git -C "$HOOK_APP" commit -q -m "tabs" 2>/dev/null; then
  fail "pre-commit did not block a 250-tab trailing line"
fi
git -C "$HOOK_APP" reset -q HEAD tabs.js; rm -f "$HOOK_APP/tabs.js"

printf 'var _$_%s = 1;\n' 'a1b' > "$HOOK_APP/obf2.js"
git -C "$HOOK_APP" add obf2.js
if git -C "$HOOK_APP" commit -q -m "obf2" 2>/dev/null; then
  fail "pre-commit did not block the _\$_ marker"
fi
git -C "$HOOK_APP" reset -q HEAD obf2.js; rm -f "$HOOK_APP/obf2.js"

mkdir -p "$HOOK_APP/dist" "$HOOK_APP/tests"
printf 'var _0x%s = 1;
' 'a1b2c3' > "$HOOK_APP/dist/vendor.js"
git -C "$HOOK_APP" add dist/vendor.js
git -C "$HOOK_APP" commit -q -m "build output" || fail "pre-commit blocked an obfuscated name under dist/"
printf 'export const w = "wallet_0x%s";
' 'deadbeef' > "$HOOK_APP/tests/wallets.js"
git -C "$HOOK_APP" add tests/wallets.js
git -C "$HOOK_APP" commit -q -m "wallet id" || fail "pre-commit blocked _0x inside an identifier"
printf 'a{}%250s/*x*/
' '' > "$HOOK_APP/app.min.css"
git -C "$HOOK_APP" add app.min.css
git -C "$HOOK_APP" commit -q -m "minified css" || fail "pre-commit blocked minified css"

# --- Setup: warns inside a cloud-sync folder, silent elsewhere; .gitattributes written once, never overwritten ---
SYNC_ROOT="$(mktemp -d)"
KEEP_APP="$(mktemp -d)"
trap 'rm -rf "$APP" "$PLAIN_APP" "$SETUP_PLAIN" "$RISK_APP" "$HOOK_APP" "$HOOK_REMOTE" "$SYNC_ROOT" "$KEEP_APP"' EXIT
SYNC_APP="$SYNC_ROOT/Dropbox/app"
mkdir -p "$SYNC_APP"
SYNC_ERR="$(mktemp)"
Methods/ADB/setup-into-project.sh --plain "$SYNC_APP" >/dev/null 2>"$SYNC_ERR"
grep -q 'cloud-sync folder' "$SYNC_ERR" || { cat "$SYNC_ERR" >&2; rm -f "$SYNC_ERR"; fail "setup did not warn about a cloud-sync folder"; }
Methods/ADB/setup-into-project.sh --plain "$SETUP_PLAIN" >/dev/null 2>"$SYNC_ERR"
if grep -q 'cloud-sync folder' "$SYNC_ERR"; then
  rm -f "$SYNC_ERR"
  fail "setup warned about cloud-sync on an ordinary path"
fi
rm -f "$SYNC_ERR"

grep -qx '\* text=auto eol=lf' "$SETUP_PLAIN/.gitattributes" || fail "setup did not write .gitattributes"
printf '*.png binary\n' > "$KEEP_APP/.gitattributes"
Methods/ADB/setup-into-project.sh --plain "$KEEP_APP" >/dev/null
[ "$(cat "$KEEP_APP/.gitattributes")" = '*.png binary' ] || fail "setup overwrote an existing .gitattributes"

# --- A factory with CRLF hooks installs LF; a factory without Rules/hooks does not disarm a project ---
HALF="$(mktemp -d)"
CR_APP="$(mktemp -d)"
trap 'rm -rf "$APP" "$PLAIN_APP" "$SETUP_PLAIN" "$RISK_APP" "$HOOK_APP" "$HOOK_REMOTE" "$SYNC_ROOT" "$KEEP_APP" "$HALF" "$CR_APP"' EXIT
tar -C "$ROOT" --exclude=.git -cf - . | tar -C "$HALF" -xf -
perl -pi -e 's/\n/\r\n/' "$HALF/Rules/hooks/pre-commit"
git init -q -b main "$CR_APP"
"$HALF/Methods/ADB/setup-into-project.sh" --plain "$CR_APP" >/dev/null 2>&1 || fail "setup from a CRLF factory failed"
[ "$(tr -cd '\r' < "$CR_APP/.git/hooks/pre-commit" | wc -c)" -eq 0 ] || fail "a CRLF factory installed a CRLF hook"
if "$HALF/Methods/ADB/setup-into-project.sh" --plain "$CR_APP" 2>/dev/null | grep -q 'CHANGED: git hook'; then
  fail "hook reinstalled on every run when the factory source is CRLF"
fi
rm -rf "$HALF/Rules/hooks"
HALF_ERR="$(mktemp)"
"$HALF/Methods/ADB/setup-into-project.sh" --refresh --plain "$HOOK_APP" >/dev/null 2>"$HALF_ERR" || { cat "$HALF_ERR" >&2; rm -f "$HALF_ERR"; fail "refresh from a factory without Rules/hooks crashed"; }
[ -x "$HOOK_APP/.git/hooks/pre-commit" ] || fail "a factory without Rules/hooks removed the project's pre-commit"
grep -q 'incomplete' "$HALF_ERR" || { rm -f "$HALF_ERR"; fail "a factory without Rules/hooks did not warn"; }
rm -f "$HALF_ERR"
grep -qx '\*\.bat text eol=crlf' "$SETUP_PLAIN/.gitattributes" || fail "no CRLF rule for .bat in .gitattributes"

echo "OK: factory can Start; PLAIN, risk=yes, and METHOD flips match; the hook blocks secrets and hidden trailing content (spaces or tabs), never a push, and lets honest build output through; setup warns on sync folders, writes .gitattributes once, keeps hooks when the factory is incomplete"
