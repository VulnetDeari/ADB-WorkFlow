#!/usr/bin/env bash
# Copy factory files into a product project so Cloud Agents see them without the Mac.
#
# Does, idempotently:
#   1. Copy factory AGENTS.md into the project as AGENTS.md (always) and stamp METHOD-VERSION
#   2. Write harness pointers CLAUDE.md, GEMINI.md, .github/copilot-instructions.md
#      as only `@AGENTS.md` (always; --refresh overwrites content drift)
#   3. Copy Rules/skills/start/SKILL.md as START.md and install /start (always)
#   4. Unless --plain: METHOD.md = METHOD: ADB; copy SKILL.md as ADB.md;
#      install /adb commands. Writes a new METHOD.md. Does not switch an
#      existing PLAIN/ADB line unless --switch (Start small↔large / risk=yes).
#   5. --plain: METHOD.md = METHOD: PLAIN; remove ADB.md and /adb commands.
#      Product adb/ docs stay. Existing ADB line: same rule as (4) — need --switch.
#   6. Remove stray engine folders that are not this method
#   7. Optionally ensure adb/08-OPEN-ISSUES.md (--register only; ADB mode)
#   8. --refresh: overwrite AGENTS.md, START.md, harness pointers and (unless PLAIN) ADB.md from factory; reinstall commands
#   9. Write .gitattributes (* text=auto eol=lf; *.bat and *.cmd CRLF) when none exists — never overwrite;
#      warn when the project path sits inside a cloud-sync folder
#
# OWNER.md and LESEN.html are written by Rules/start-into-project.sh, not this script.
#
# Usage:
#   ./setup-into-project.sh /path/to/project
#   ./setup-into-project.sh --plain /path/to/project
#   ./setup-into-project.sh --check /path/to/project
#   ./setup-into-project.sh --refresh /path/to/project
#   ./setup-into-project.sh --register /path/to/project
#   ./setup-into-project.sh --switch --plain /path/to/project   # Start only: flip method
#
# Exit 0 on success. Prints changed paths, one per line, prefixed with CHANGED:

set -euo pipefail

ADB_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SYSTEM_ROOT="$(cd "$ADB_ROOT/../.." && pwd)"
SKILL="$ADB_ROOT/SKILL.md"
AGENTS_SRC="$SYSTEM_ROOT/AGENTS.md"
START_SKILL="$SYSTEM_ROOT/Rules/skills/start/SKILL.md"
START_CMD="$SYSTEM_ROOT/Rules/commands/start.md"
INSTALLER="$ADB_ROOT/install-commands.sh"

CHECK=0
REFRESH=0
REGISTER=0
PLAIN=0
SWITCH=0
PROJECT=""

for arg in "$@"; do
  case "$arg" in
    --check) CHECK=1 ;;
    --refresh) REFRESH=1 ;;
    --register) REGISTER=1 ;;
    --plain) PLAIN=1 ;;
    --switch) SWITCH=1 ;;
    -*) echo "unknown argument: $arg" >&2; exit 2 ;;
    *)
      if [ -n "$PROJECT" ]; then
        echo "unexpected extra argument: $arg" >&2
        exit 2
      fi
      PROJECT=$arg
      ;;
  esac
done

[ -n "$PROJECT" ] || { echo "usage: $0 [--check] [--refresh] [--register] [--plain] [--switch] /path/to/project" >&2; exit 2; }
[ -d "$PROJECT" ] || { echo "not a directory: $PROJECT" >&2; exit 1; }
[ -f "$AGENTS_SRC" ] || { echo "AGENTS.md missing: $AGENTS_SRC" >&2; exit 1; }
grep -q 'MainAgent' "$AGENTS_SRC" || { echo "AGENTS.md source is not the product rules: $AGENTS_SRC" >&2; exit 1; }
[ -f "$START_SKILL" ] || { echo "START skill missing: $START_SKILL" >&2; exit 1; }
[ -f "$START_CMD" ] || { echo "start command missing: $START_CMD" >&2; exit 1; }

PROJECT="$(cd "$PROJECT" && pwd -P)"

# A working tree inside a two-way sync client gets [conflicted] copies and edits without commits.
if printf '%s' "$PROJECT" | grep -qiE 'pcloud|dropbox|onedrive|google ?drive|icloud|com~apple~clouddocs|syncthing'; then
  echo "WARN: $PROJECT sits inside a cloud-sync folder." >&2
  echo "WARN: a Git working tree in a two-way sync client gets [conflicted] copies and changes without commits. Keep the checkout outside the sync folder; the remote is the sync." >&2
fi
sha="$(git -C "$SYSTEM_ROOT" rev-parse --short HEAD 2>/dev/null || echo unknown)"
if ! git -C "$SYSTEM_ROOT" diff HEAD --quiet -- Methods/ADB/SKILL.md AGENTS.md 2>/dev/null; then
  sha="${sha}-dirty"
fi
day="$(date +%Y-%m-%d)"
stamp="METHOD-VERSION: ${sha} ${day}"

note_changed() {
  printf 'CHANGED: %s\n' "$1"
}

strip_stamp() {
  awk '
    BEGIN { fm=0; fm_closed=0; removed=0; past_h1=0 }
    /^# / { past_h1=1 }
    past_h1 { print; next }
    NR==1 && $0=="---" { fm=1; print; next }
    NR==1 && $0 ~ /^METHOD-VERSION:/ { removed=1; next }
    fm==1 {
      print
      if ($0=="---") { fm=0; fm_closed=1 }
      next
    }
    fm_closed && !removed && $0 ~ /^METHOD-VERSION:/ { removed=1; next }
    fm_closed && removed && $0 ~ /^METHOD-VERSION:/ { next }
    { print }
  ' "$1"
}

remove_stamp_above_frontmatter() {
  local file="$1"
  local tmp first second
  tmp="$(mktemp)"
  first="$(head -1 "$file" 2>/dev/null || true)"
  second="$(sed -n '2p' "$file" 2>/dev/null || true)"
  if [[ "$first" =~ ^METHOD-VERSION: ]] && [ "$second" = "---" ]; then
    tail -n +2 "$file" > "$tmp"
    mv "$tmp" "$file"
    return 0
  fi
  return 1
}

stamp_copy() {
  local file="$1"
  local tmp
  tmp="$(mktemp)"

  if [ ! -s "$file" ]; then
    echo "WARN: $file is empty — cannot stamp." >&2
    rm -f "$tmp"
    return 1
  fi

  if [ "$(head -1 "$file")" = "---" ]; then
    if ! awk 'BEGIN{fm=0; found=0} /^---/{fm++} fm==2{found=1; exit} END{exit !found}' "$file"; then
      echo "WARN: $file has frontmatter without a closing --- — cannot stamp." >&2
      rm -f "$tmp"
      return 1
    fi
  fi

  if [ $CHECK -eq 0 ]; then
    remove_stamp_above_frontmatter "$file" || true
  fi

  # Stamp first: files that start with `# ` (AGENTS.md) used to skip the stamp
  # because the heading rule ran before NR==1.
  awk -v stamp="$stamp" '
    BEGIN { fm=0; fm_closed=0; stamp_done=0 }
    NR==1 && $0=="---" { fm=1; print; next }
    NR==1 && $0 ~ /^METHOD-VERSION:/ { print stamp; stamp_done=1; next }
    NR==1 { print stamp; stamp_done=1; print; next }
    fm==1 {
      print
      if ($0=="---") {
        fm=0
        fm_closed=1
        print stamp
        stamp_done=1
      }
      next
    }
    fm_closed && !stamp_done && $0 ~ /^METHOD-VERSION:/ { print stamp; stamp_done=1; next }
    fm_closed && stamp_done && $0 ~ /^METHOD-VERSION:/ { next }
    { print }
    END {
      if (!stamp_done) print stamp
    }
  ' "$file" > "$tmp"

  if cmp -s "$file" "$tmp"; then
    rm -f "$tmp"
    return 1
  fi
  if [ $CHECK -eq 1 ]; then
    rm -f "$tmp"
    return 0
  fi
  mv "$tmp" "$file"
  return 0
}

# Sync one factory file into the project. Sets SYNC_STALE=1 if dest body differs and was not refreshed.
SYNC_STALE=0
sync_stamped_copy() {
  local src="$1"
  local dest="$2"
  local rel="$3"
  local canon="$4"
  local fresh=0
  local stamp_file="$dest"
  SYNC_STALE=0

  if [ ! -f "$dest" ]; then
    if [ $CHECK -eq 1 ]; then
      echo "WOULD CREATE $dest (stamped $stamp)"
    else
      cp "$src" "$dest"
      note_changed "$rel"
      fresh=1
    fi
  fi

  if [ -f "$dest" ]; then
    local src_body dest_body
    src_body="$(mktemp)"
    dest_body="$(mktemp)"
    strip_stamp "$src" > "$src_body"
    strip_stamp "$dest" > "$dest_body"
    if ! diff -q "$src_body" "$dest_body" >/dev/null; then
      SYNC_STALE=1
    fi
    rm -f "$src_body" "$dest_body"
  fi

  if [ $SYNC_STALE -eq 1 ] && [ $REFRESH -eq 1 ]; then
    if [ $CHECK -eq 1 ]; then
      echo "WOULD REFRESH $dest (body differs from $canon)"
      stamp_file="$src"
    else
      cp "$src" "$dest"
      note_changed "$rel"
      fresh=1
    fi
    SYNC_STALE=0
  fi

  if [ -f "$stamp_file" ] && [ $SYNC_STALE -eq 0 ]; then
    if stamp_copy "$stamp_file"; then
      if [ $CHECK -eq 1 ]; then
        echo "WOULD STAMP $dest ($stamp)"
      elif [ $fresh -eq 0 ]; then
        note_changed "$rel"
      fi
    fi
  elif [ $SYNC_STALE -eq 1 ]; then
    echo "STALE: $dest body differs from $canon."
    echo "STALE: not stamping — a stamp would claim a version this file does not have."
    echo "STALE: run with --refresh to update the body, or record a decision to stay on the older version."
  fi
}

# --- METHOD.md ---
# Flags are the requested method on first write. An existing PLAIN/ADB line
# changes only with --switch (Start). setup-without-interview does not write
# OWNER.md / LESEN.html and does not invent a method switch.
method_md="$PROJECT/METHOD.md"
write_method_line() {
  printf '%s\n' "$1" > "$method_md"
  note_changed "METHOD.md"
}

if [ $PLAIN -eq 1 ]; then
  desired_method='METHOD: PLAIN'
else
  desired_method='METHOD: ADB'
fi

existing_method=""
if [ -f "$method_md" ]; then
  if grep -qx 'METHOD: PLAIN' "$method_md" 2>/dev/null; then
    existing_method='METHOD: PLAIN'
  elif grep -qx 'METHOD: ADB' "$method_md" 2>/dev/null; then
    existing_method='METHOD: ADB'
  fi
fi

if [ $SWITCH -eq 1 ] || [ -z "$existing_method" ]; then
  if [ ! -f "$method_md" ]; then
    if [ $CHECK -eq 1 ]; then
      echo "WOULD CREATE $method_md ($desired_method)"
    else
      write_method_line "$desired_method"
    fi
  elif grep -qx "$desired_method" "$method_md" 2>/dev/null; then
    :
  else
    if [ $CHECK -eq 1 ]; then
      echo "WOULD WRITE $desired_method in $method_md"
    else
      write_method_line "$desired_method"
    fi
  fi
else
  if [ "$existing_method" != "$desired_method" ]; then
    echo "WARN: $method_md is $existing_method — not switching to ${desired_method#METHOD: }. Re-run Start to switch." >&2
  fi
  if [ "$existing_method" = 'METHOD: PLAIN' ]; then
    PLAIN=1
  else
    PLAIN=0
  fi
fi

if [ $PLAIN -eq 0 ]; then
  [ -f "$SKILL" ] || { echo "SKILL.md missing: $SKILL" >&2; exit 1; }
  [ -x "$INSTALLER" ] || { echo "install-commands.sh missing or not executable: $INSTALLER" >&2; exit 1; }
fi

# ADB.md and /adb commands are method copies. Product adb/ (vision, spec, …) stays.
remove_adb_method_artifacts() {
  local path rel
  if [ -e "$PROJECT/ADB.md" ] || [ -L "$PROJECT/ADB.md" ]; then
    if [ $CHECK -eq 1 ]; then
      echo "WOULD REMOVE leftover $PROJECT/ADB.md"
    else
      rm -f "$PROJECT/ADB.md"
      note_changed "ADB.md"
    fi
  fi
  local sub
  for sub in .cursor/commands .claude/commands .codex/prompts; do
    [ -d "$PROJECT/$sub" ] || continue
    shopt -s nullglob
    for path in "$PROJECT/$sub"/adb.md "$PROJECT/$sub"/adb-*.md "$PROJECT/$sub"/adb-*.md.pre-adb.*; do
      rel="${path#"$PROJECT"/}"
      if [ $CHECK -eq 1 ]; then
        echo "WOULD REMOVE leftover $path"
      else
        rm -f "$path"
        note_changed "$rel"
      fi
    done
    shopt -u nullglob
  done
}

if [ $PLAIN -eq 1 ]; then
  remove_adb_method_artifacts
fi

# --- AGENTS.md (copy of factory AGENTS.md; every product follows this file) ---
sync_stamped_copy "$AGENTS_SRC" "$PROJECT/AGENTS.md" "AGENTS.md" "AGENTS.md"
STALE_AGENTS=$SYNC_STALE

# --- Harness pointers: only @AGENTS.md (no parallel rules) ---
ensure_agents_pointer() {
  local rel="$1"
  local dest="$PROJECT/$rel"
  # Compare without trailing newlines — $(...) strips them and would always look stale.
  local want='@AGENTS.md'
  local parent have
  parent="$(dirname "$dest")"
  have=""
  if [ -f "$dest" ]; then
    have="$(tr -d '\r\n' < "$dest")"
  fi
  if [ $CHECK -eq 1 ]; then
    if [ ! -f "$dest" ]; then
      echo "WOULD CREATE $dest (harness pointer -> AGENTS.md)"
    elif [ "$have" != "$want" ]; then
      echo "WOULD REFRESH $dest (harness pointer must be only @AGENTS.md)"
    fi
    return 0
  fi
  mkdir -p "$parent"
  if [ -f "$dest" ] && [ "$have" = "$want" ]; then
    return 0
  fi
  printf '%s\n' "$want" > "$dest"
  note_changed "$rel"
}

ensure_agents_pointer "CLAUDE.md"
ensure_agents_pointer "GEMINI.md"
ensure_agents_pointer ".github/copilot-instructions.md"

# --- START.md (copy of the Start skill; /start in every product, plain and ADB) ---
sync_stamped_copy "$START_SKILL" "$PROJECT/START.md" "START.md" "Rules/skills/start/SKILL.md"
STALE_START=$SYNC_STALE

STALE_ADB=0
if [ $PLAIN -eq 0 ]; then
  # --- ADB.md (copy of SKILL.md; the project follows this file) ---
  sync_stamped_copy "$SKILL" "$PROJECT/ADB.md" "ADB.md" "SKILL.md"
  STALE_ADB=$SYNC_STALE
fi

# --- Stray engine folders that are not this method. Product docs stay. ---
remove_stray_path() {
  local rel="$1"
  local path="$PROJECT/$rel"
  if [ ! -e "$path" ] && [ ! -L "$path" ]; then
    return 0
  fi
  if [ $CHECK -eq 1 ]; then
    echo "WOULD REMOVE leftover $path"
    return 0
  fi
  rm -rf "$path"
  note_changed "$rel"
}

is_stray_core_config() {
  local f="$1"
  [ -f "$f" ] || return 1
  grep -qiE 'bmad-core|markdownExploder|prdFile|bmad_version|bmad-method|_bmad/' "$f"
}

for rel in _bmad .bmad bmad-agent bmad.config.yaml bmad-config.yaml bmad.config.js; do
  remove_stray_path "$rel"
done

shopt -s nullglob
for path in "$PROJECT"/.bmad-*; do
  remove_stray_path "${path#"$PROJECT"/}"
done
shopt -u nullglob

harness_cmd_roots=(
  ".cursor/commands"
  ".claude/commands"
  ".codex/prompts"
  ".cursor/rules"
  ".cursor/skills"
  ".claude/skills"
  ".codex/skills"
)
for root in "${harness_cmd_roots[@]}"; do
  [ -d "$PROJECT/$root" ] || continue
  while IFS= read -r -d '' path; do
    remove_stray_path "${path#"$PROJECT"/}"
  done < <(find "$PROJECT/$root" -maxdepth 1 \( -iname '*bmad*' \) -print0)
done

if is_stray_core_config "$PROJECT/core-config.yaml"; then
  remove_stray_path "core-config.yaml"
fi

# --- Issue register (optional, ADB mode) ---
register="$PROJECT/adb/08-OPEN-ISSUES.md"

write_register() {
  cat > "$1" <<'EOF'
# Open Issues

CANONICAL: This file (`adb/08-OPEN-ISSUES.md`)

Record real unresolved complaints, bugs, regressions, UX or design defects, data problems, specification conflicts, and failing critical behavior here.

Never record secrets, private data, or actionable vulnerability details in this tracked file. Use an explicitly private channel for sensitive security reports.

OPEN: 0

Closed issues stay in this file and stay traceable (SKILL.md Issues). Mark CLOSED only after the fix is tested and verified. Do not close by deleting the entry.

CARRIED: at 3 an issue must leave OPEN by FIX, ACCEPT or REJECT (SKILL.md Issues).
EOF
}

if [ $PLAIN -eq 0 ]; then
  if [ $REGISTER -eq 1 ]; then
    if [ ! -f "$register" ]; then
      if [ $CHECK -eq 1 ]; then
        echo "WOULD CREATE $PROJECT/adb/"
        echo "WOULD CREATE $register"
      else
        mkdir -p "$PROJECT/adb"
        write_register "$register"
        note_changed "adb/08-OPEN-ISSUES.md"
      fi
    fi
  elif [ $CHECK -eq 1 ] && [ ! -f "$register" ]; then
    echo "NOTE: no adb/08-OPEN-ISSUES.md — expected for collapsed Source of Truth (issues in adb/07-STATUS.md). Pass --register to create the file."
  fi
fi

# --- Slash commands (ADB mode: copies, so the project does not need this repo) ---
list_cmd_links() {
  (cd "$PROJECT" && find .cursor/commands .claude/commands .codex/prompts -name 'adb*.md' 2>/dev/null | sed 's|^\./||' | sort || true)
}

list_cmd_link_targets() {
  (cd "$PROJECT" && find .cursor/commands .claude/commands .codex/prompts -name 'adb*.md' -type l 2>/dev/null \
    | while IFS= read -r rel; do
        [ -n "$rel" ] || continue
        printf '%s -> %s\n' "$rel" "$(readlink "$rel" 2>/dev/null || echo '?')"
      done | sort || true)
}

list_cmd_checksums() {
  (cd "$PROJECT" && find .cursor/commands .claude/commands .codex/prompts -name 'adb*.md' -type f 2>/dev/null | sed 's|^\./||' \
    | while IFS= read -r rel; do
        [ -n "$rel" ] || continue
        printf '%s %s\n' "$rel" "$(cksum "$rel" 2>/dev/null || echo '?')"
      done | sort || true)
}

if [ $PLAIN -eq 1 ]; then
  :
elif [ $STALE_ADB -eq 1 ]; then
  echo "STALE: skipping slash commands — current commands would cite a method this ADB.md does not have."
  echo "STALE: run with --refresh to update both together."
elif [ $CHECK -eq 1 ]; then
  (cd "$PROJECT" && "$INSTALLER" --copy --check) || true
else
  before_paths="$(list_cmd_links)"
  before_targets="$(list_cmd_link_targets)"
  before_checksums="$(list_cmd_checksums)"
  (cd "$PROJECT" && "$INSTALLER" --copy) >/dev/null
  after_paths="$(list_cmd_links)"
  after_targets="$(list_cmd_link_targets)"
  after_checksums="$(list_cmd_checksums)"
  if [ "$before_paths" != "$after_paths" ] || [ "$before_targets" != "$after_targets" ] || [ "$before_checksums" != "$after_checksums" ]; then
    printf '%s\n' "$after_paths" | while IFS= read -r rel; do
      [ -n "$rel" ] || continue
      note_changed "$rel"
    done
  fi
fi

# --- /start (every product: copies, so Cloud Agents can re-run Start) ---
install_start_cmd() {
  local sub dest
  for sub in .cursor/commands .claude/commands .codex/prompts; do
    dest="$PROJECT/$sub/start.md"
    if [ $CHECK -eq 1 ]; then
      if [ ! -f "$dest" ] || [ -L "$dest" ] || ! cmp -s "$START_CMD" "$dest" 2>/dev/null; then
        echo "WOULD CREATE $dest"
      fi
      continue
    fi
    mkdir -p "$(dirname "$dest")"
    if [ -f "$dest" ] && [ ! -L "$dest" ] && cmp -s "$START_CMD" "$dest"; then
      continue
    fi
    rm -f "$dest"
    cp "$START_CMD" "$dest"
    note_changed "${sub}/start.md"
  done
}

if [ $STALE_START -eq 1 ]; then
  echo "STALE: skipping /start command copy — START.md body differs from the factory skill."
  echo "STALE: run with --refresh to update START.md and /start together."
else
  install_start_cmd
fi

# --- Git hooks (hard rule: no secrets in commits). A method hook the factory no longer ships is removed on refresh. ---
HOOKS_SRC="$SYSTEM_ROOT/Rules/hooks"
install_hooks() {
  local hooks_dir name src dest
  hooks_dir="$(git -C "$PROJECT" rev-parse --git-path hooks 2>/dev/null || true)"
  if [ -z "$hooks_dir" ]; then
    if [ $CHECK -eq 1 ]; then echo "NOTE: not a git repository — method hooks not installed."; fi
    return 0
  fi
  case "$hooks_dir" in
    /*) ;;
    [A-Za-z]:/*) ;;
    *) hooks_dir="$PROJECT/$hooks_dir" ;;
  esac
  # A half factory (no Rules/hooks, or no pre-commit in it) must not disarm a project: leave installed hooks alone and say so.
  if [ ! -f "$HOOKS_SRC/pre-commit" ]; then
    echo "WARN: $HOOKS_SRC has no pre-commit — this factory clone is incomplete. Installed hooks left untouched; the secrets hook was not refreshed." >&2
    return 0
  fi
  for name in pre-commit; do
    src="$HOOKS_SRC/$name"
    [ -f "$src" ] || continue
    dest="$hooks_dir/$name"
    if [ -f "$dest" ] && cmp -s <(sed 's/\r$//' "$src") "$dest"; then
      continue
    fi
    if [ -f "$dest" ] && ! grep -q '^# Method hook' "$dest"; then
      if [ $CHECK -eq 1 ]; then
        echo "WOULD BACK UP foreign hook $dest to $dest.pre-method"
      else
        mv "$dest" "$dest.pre-method"
        echo "WARN: existing $name hook moved to $dest.pre-method — merge it by hand if it matters." >&2
      fi
    fi
    if [ $CHECK -eq 1 ]; then
      echo "WOULD INSTALL $dest"
      continue
    fi
    mkdir -p "$hooks_dir"
    sed 's/\r$//' "$src" > "$dest"   # LF regardless of the factory checkout (L-038)
    chmod +x "$dest"
    note_changed "git hook $name"
  done
  # A method hook the factory no longer ships (header says so) must not keep enforcing a dropped rule. Foreign hooks stay.
  local stale
  for stale in "$hooks_dir"/*; do
    [ -f "$stale" ] || continue
    name="$(basename "$stale")"
    case "$name" in *.sample|*.pre-method) continue ;; esac
    [ -f "$HOOKS_SRC/$name" ] && continue
    grep -q '^# Method hook' "$stale" || continue
    if [ $CHECK -eq 1 ]; then
      echo "WOULD REMOVE stale method hook $stale"
      [ -f "$stale.pre-method" ] && echo "WOULD RESTORE $stale.pre-method"
      continue
    fi
    rm -f "$stale"
    note_changed "git hook $name removed"
    if [ -f "$stale.pre-method" ]; then
      mv "$stale.pre-method" "$stale"
      echo "WARN: restored the project's own $name hook from $name.pre-method (an older setup had set it aside)." >&2
      note_changed "git hook $name restored"
    fi
  done
}
install_hooks

# --- .gitattributes: LF in repository and working tree on every OS, so byte counts and tests match CI. Never overwrites. ---
gitattributes="$PROJECT/.gitattributes"
if [ ! -e "$gitattributes" ]; then
  if [ $CHECK -eq 1 ]; then
    echo "WOULD CREATE $gitattributes (* text=auto eol=lf)"
  else
    printf '%s\n' '# Method: one line ending in the repository and the working tree on every OS.' '* text=auto eol=lf' '*.bat text eol=crlf' '*.cmd text eol=crlf' > "$gitattributes"
    note_changed ".gitattributes"
  fi
fi

if [ $CHECK -eq 0 ]; then
  if [ ! -s "$PROJECT/AGENTS.md" ]; then
    echo "FAIL: AGENTS.md was not written to $PROJECT/AGENTS.md" >&2
    echo "FAIL: Start is not done. Do not continue without this file." >&2
    exit 1
  fi
  if [ ! -s "$PROJECT/START.md" ]; then
    echo "FAIL: START.md was not written to $PROJECT/START.md" >&2
    exit 1
  fi
  if [ $PLAIN -eq 0 ] && [ ! -s "$PROJECT/ADB.md" ]; then
    echo "FAIL: ADB.md was not written to $PROJECT/ADB.md" >&2
    exit 1
  fi
  if [ ! -f "$PROJECT/OWNER.md" ]; then
    echo "WARN: no OWNER.md — Start was not run; the owner was not asked language." >&2
    echo "WARN: when the owner is in chat, run Start (Q1 language). Do not treat this setup as a finished first run." >&2
  fi
fi

echo "Setup into project: $PROJECT"
echo "AGENTS.md copy: $PROJECT/AGENTS.md"
echo "START.md copy: $PROJECT/START.md"
if [ $PLAIN -eq 1 ]; then
  echo "Mode: PLAIN (no ADB)"
else
  echo "ADB.md copy: $PROJECT/ADB.md"
fi
echo "METHOD-VERSION target: $stamp"
