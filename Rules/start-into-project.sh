#!/usr/bin/env bash
# Apply Start answers into a product project. Does not interview.
# The Start skill offers chips; this script only writes files.
#
# --language is any language: tag (it, sq, pt-BR, ja) or a name (Italiano, Shqip,
# 日本語). Native LESEN templates exist for de and en. Any other language gets
# the English page plus TRANSLATE: so the Start skill rewrites LESEN.html and
# the human lines in OWNER.md into that language before Start is done.
#
# Usage:
#   ./Rules/start-into-project.sh --project DIR \
#     --language LANG --address du|sie|name --tone direct|calm|short \
#     --method plain|adb --risk none|yes --product TEXT \
#     [--language-name NAME] [--why TEXT]
#   ./Rules/start-into-project.sh --lesen-only --project DIR
#   ./Rules/start-into-project.sh --check ...
#   ./Rules/start-into-project.sh --refresh ...
#
# Exit 0 on success. Prints CHANGED: lines like setup-into-project.sh.

set -euo pipefail

RULES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SYSTEM_ROOT="$(cd "$RULES_ROOT/.." && pwd)"
SETUP="$SYSTEM_ROOT/Methods/ADB/setup-into-project.sh"
TEMPLATES="$RULES_ROOT/templates"
RESOLVER="$TEMPLATES/resolve-language.py"

CHECK=0
REFRESH=0
LESEN_ONLY=0
PROJECT=""
LANGUAGE=""
LANGUAGE_NAME=""
ADDRESS=""
TONE=""
METHOD=""
RISK=""
PRODUCT=""
WHY=""

usage() {
  echo "usage: $0 --project DIR --language LANG --address du|sie|name --tone direct|calm|short --method plain|adb --risk none|yes --product TEXT [--language-name NAME] [--why TEXT] [--check] [--refresh]" >&2
  echo "       $0 --lesen-only --project DIR [--check]" >&2
  exit 2
}

while [ $# -gt 0 ]; do
  case "$1" in
    --check) CHECK=1; shift ;;
    --refresh) REFRESH=1; shift ;;
    --lesen-only) LESEN_ONLY=1; shift ;;
    --project) PROJECT="${2:-}"; shift 2 ;;
    --language) LANGUAGE="${2:-}"; shift 2 ;;
    --language-name) LANGUAGE_NAME="${2:-}"; shift 2 ;;
    --address) ADDRESS="${2:-}"; shift 2 ;;
    --tone) TONE="${2:-}"; shift 2 ;;
    --method) METHOD="${2:-}"; shift 2 ;;
    --risk) RISK="${2:-}"; shift 2 ;;
    --product) PRODUCT="${2:-}"; shift 2 ;;
    --why) WHY="${2:-}"; shift 2 ;;
    -*) echo "unknown argument: $1" >&2; usage ;;
    *) echo "unexpected argument: $1" >&2; usage ;;
  esac
done

[ -n "$PROJECT" ] || usage
[ -x "$SETUP" ] || { echo "setup missing: $SETUP" >&2; exit 1; }
[ -f "$RESOLVER" ] || { echo "resolver missing: $RESOLVER" >&2; exit 1; }

is_factory() {
  local p="$1"
  [ -f "$p/AGENTS.md" ] && [ -f "$p/Methods/ADB/SKILL.md" ] && [ -f "$p/Rules/start-into-project.sh" ]
}

if [ -e "$PROJECT" ]; then
  PROJECT="$(cd "$PROJECT" && pwd -P)"
fi

if [ -n "$PROJECT" ] && is_factory "$PROJECT"; then
  echo "refusing: $PROJECT is the method factory, not an app" >&2
  echo "give --project a product folder" >&2
  exit 1
fi

# A refresh never rewrites interview answers or the owner's reading page.
if [ $REFRESH -eq 1 ]; then
  [ $LESEN_ONLY -eq 0 ] || { echo "--refresh cannot combine with --lesen-only" >&2; exit 2; }
  refresh_args=(--refresh)
  [ $CHECK -eq 0 ] || refresh_args+=(--check)
  exec "$SETUP" "${refresh_args[@]}" "$PROJECT"
fi

read_owner_field() {
  local file="$1" key="$2"
  sed -n "s/^${key}: //p" "$file" | head -n 1
}

if [ $LESEN_ONLY -eq 1 ]; then
  [ -d "$PROJECT" ] || { echo "not a directory: $PROJECT" >&2; exit 1; }
  [ -f "$PROJECT/OWNER.md" ] || { echo "OWNER.md missing: $PROJECT/OWNER.md" >&2; exit 1; }
  LANGUAGE="$(read_owner_field "$PROJECT/OWNER.md" LANGUAGE)"
  if [ -z "$LANGUAGE_NAME" ]; then
    LANGUAGE_NAME="$(read_owner_field "$PROJECT/OWNER.md" LANGUAGE-NAME)"
  fi
  ADDRESS="$(read_owner_field "$PROJECT/OWNER.md" ADDRESS)"
  TONE="$(read_owner_field "$PROJECT/OWNER.md" TONE)"
  METHOD="$(read_owner_field "$PROJECT/OWNER.md" METHOD | tr '[:upper:]' '[:lower:]')"
  RISK="$(read_owner_field "$PROJECT/OWNER.md" RISK)"
  PRODUCT="$(read_owner_field "$PROJECT/OWNER.md" PRODUCT)"
  WHY="$(read_owner_field "$PROJECT/OWNER.md" WHY)"
fi

[ -n "$LANGUAGE" ] || { echo "--language is required (or OWNER.md LANGUAGE with --lesen-only)" >&2; exit 2; }

resolved="$(python3 "$RESOLVER" "$LANGUAGE")" || { echo "could not read language: $LANGUAGE" >&2; exit 2; }
LANGUAGE="${resolved%%$'\t'*}"
resolved_name="${resolved#*$'\t'}"
if [ -z "$LANGUAGE_NAME" ]; then
  LANGUAGE_NAME="$resolved_name"
fi
LANGUAGE_PRIMARY="${LANGUAGE%%-*}"

case "$ADDRESS" in du|sie|name) ;; *) echo "address must be du, sie, or name" >&2; exit 2 ;; esac
case "$TONE" in direct|calm|short) ;; *) echo "tone must be direct, calm, or short" >&2; exit 2 ;; esac
case "$RISK" in none|yes) ;; *) echo "risk must be none or yes" >&2; exit 2 ;; esac
case "$METHOD" in plain|adb|PLAIN|ADB)
  METHOD="$(printf '%s' "$METHOD" | tr '[:upper:]' '[:lower:]')"
  ;;
*) echo "method must be plain or adb" >&2; exit 2 ;; esac
[ -n "$PRODUCT" ] || { echo "--product is required (or OWNER.md PRODUCT with --lesen-only)" >&2; exit 2; }

OVERRIDE=""
if [ "$RISK" = "yes" ] && [ "$METHOD" = "plain" ]; then
  METHOD=adb
  OVERRIDE=1
fi

WHY_DE=0
[ "$LANGUAGE_PRIMARY" = "de" ] && WHY_DE=1

if [ -z "$WHY" ]; then
  if [ $WHY_DE -eq 1 ]; then
    if [ "$METHOD" = "adb" ] && [ "$OVERRIDE" = "1" ]; then
      WHY="Klein gewählt, aber Geld/Login/Live/fremde Daten → große Methode (ADB)."
    elif [ "$METHOD" = "adb" ]; then
      WHY="Große App — ADB."
    else
      WHY="Kleine App — nur die normale Methode."
    fi
  else
    if [ "$METHOD" = "adb" ] && [ "$OVERRIDE" = "1" ]; then
      WHY="Picked small, but money/login/live/other people's data → large method (ADB)."
    elif [ "$METHOD" = "adb" ]; then
      WHY="Large app — ADB."
    else
      WHY="Small app — plain method only."
    fi
  fi
elif [ "$OVERRIDE" = "1" ]; then
  if [ $WHY_DE -eq 1 ]; then
    WHY="${WHY} Klein gewählt, aber Risiko → ADB."
  else
    WHY="${WHY} Picked small, but risk → ADB."
  fi
fi

label_address() {
  case "$1" in
    du) [ $WHY_DE -eq 1 ] && echo "Du" || echo "Informal you" ;;
    sie) [ $WHY_DE -eq 1 ] && echo "Sie" || echo "Formal" ;;
    name) [ $WHY_DE -eq 1 ] && echo "Vorname" || echo "First name" ;;
  esac
}

label_tone() {
  case "$1" in
    direct) [ $WHY_DE -eq 1 ] && echo "Direkt" || echo "Direct" ;;
    calm) [ $WHY_DE -eq 1 ] && echo "Ruhig" || echo "Calm" ;;
    short) [ $WHY_DE -eq 1 ] && echo "Knapp" || echo "Short" ;;
  esac
}

LANG_LABEL="$LANGUAGE_NAME"
ADDR_LABEL="$(label_address "$ADDRESS")"
TONE_LABEL="$(label_tone "$TONE")"

pick_template() {
  local kind=plain
  [ "$METHOD" = "adb" ] && kind=adb
  local cand
  NEEDS_TRANSLATE=0
  for cand in "$LANGUAGE" "$LANGUAGE_PRIMARY" en; do
    if [ -f "$TEMPLATES/lesen-${kind}.${cand}.html" ]; then
      TEMPLATE="$TEMPLATES/lesen-${kind}.${cand}.html"
      if [ "$cand" = "en" ] && [ "$LANGUAGE_PRIMARY" != "en" ]; then
        NEEDS_TRANSLATE=1
      fi
      return 0
    fi
  done
  echo "no LESEN template for method=$METHOD language=$LANGUAGE" >&2
  return 1
}

write_owner() {
  local dest="$1"
  local method_up translate_field
  method_up="$(printf '%s' "$METHOD" | tr '[:lower:]' '[:upper:]')"
  if [ $NEEDS_TRANSLATE -eq 1 ]; then
    translate_field="yes"
  else
    translate_field="no"
  fi
  python3 - "$dest" "$LANGUAGE" "$LANGUAGE_NAME" "$ADDRESS" "$TONE" "$method_up" "$RISK" "$PRODUCT" "$WHY" "$LANG_LABEL" "$ADDR_LABEL" "$TONE_LABEL" "$translate_field" "$WHY_DE" <<'PY'
import sys
from pathlib import Path
(
    dest, language, language_name, address, tone, method_up, risk, product, why,
    lang_label, addr_label, tone_label, translate_field, why_de,
) = sys.argv[1:]

def one_line(s):
    return " ".join(s.split())

product = one_line(product)
why = one_line(why)
if why_de == "1":
    human = (
        f"Agenten: sprich {lang_label}. Anrede {addr_label}. Ton {tone_label}. "
        "Nicht gegen `AGENTS.md` verstoßen. Menschen lesen `LESEN.html`.\n\n"
        "Du bist nicht der Coder. Ziel steht oben. Start nochmal: `/start`."
    )
else:
    human = (
        f"Agents: speak {lang_label}. Address {addr_label}. Tone {tone_label}. "
        "Do not contradict `AGENTS.md`. Humans read `LESEN.html`.\n\n"
        "The owner is not the coder. Destination is PRODUCT above. Run Start again with `/start`."
    )
body = f"""# Owner

LANGUAGE: {language}
LANGUAGE-NAME: {one_line(language_name)}
ADDRESS: {address}
TONE: {tone}
METHOD: {method_up}
RISK: {risk}
PRODUCT: {product}
WHY: {why}
TRANSLATE: {translate_field}

{human}
"""
Path(dest).write_text(body, encoding="utf-8")
PY
}

fill_lesen() {
  local src="$1" dest="$2"
  command -v python3 >/dev/null 2>&1 || { echo "python3 is required" >&2; exit 1; }
  python3 - "$src" "$dest" "$PRODUCT" "$LANG_LABEL" "$ADDR_LABEL" "$TONE_LABEL" "$WHY" "$LANGUAGE" "$LANGUAGE_NAME" "$NEEDS_TRANSLATE" <<'PY'
import html, sys
from pathlib import Path
src, dest, product, language, address, tone, why, tag, name, needs = sys.argv[1:11]
text = Path(src).read_text(encoding="utf-8")
repl = {
    "{{PRODUCT}}": html.escape(product, quote=True),
    "{{LANGUAGE}}": html.escape(language, quote=True),
    "{{ADDRESS}}": html.escape(address, quote=True),
    "{{TONE}}": html.escape(tone, quote=True),
    "{{WHY}}": html.escape(why, quote=True),
}
for k, v in repl.items():
    text = text.replace(k, v)
if needs == "1":
    comment = f"<!-- TRANSLATE-TO: {html.escape(tag, quote=True)} {html.escape(name, quote=True)} -->\n"
    if "<head>" in text:
        text = text.replace("<head>", comment + "<head>", 1)
    else:
        text = comment + text
Path(dest).write_text(text, encoding="utf-8")
PY
}

note_changed() {
  printf 'CHANGED: %s\n' "$1"
}

pick_template

if [ $LESEN_ONLY -eq 0 ] && [ ! -d "$PROJECT" ]; then
  if [ $CHECK -eq 1 ]; then
    echo "WOULD CREATE directory $PROJECT"
  else
    mkdir -p "$PROJECT"
    PROJECT="$(cd "$PROJECT" && pwd -P)"
    note_changed "$PROJECT"
  fi
fi

if [ $CHECK -eq 1 ] && [ ! -d "$PROJECT" ]; then
  echo "WOULD RUN setup into $PROJECT (METHOD: $METHOD)"
  echo "WOULD CREATE OWNER.md"
  echo "WOULD CREATE LESEN.html from $TEMPLATE"
  if [ $NEEDS_TRANSLATE -eq 1 ]; then
    echo "TRANSLATE: LESEN.html OWNER.md → $LANGUAGE_NAME ($LANGUAGE)"
  fi
  echo "Start (check only): method=$METHOD language=$LANGUAGE"
  exit 0
fi

PROJECT="$(cd "$PROJECT" && pwd -P)"

OWNER="$PROJECT/OWNER.md"
LESEN="$PROJECT/LESEN.html"

if [ $CHECK -eq 1 ]; then
  echo "WOULD WRITE $OWNER"
  echo "WOULD WRITE $LESEN (from $(basename "$TEMPLATE"))"
  if [ $LESEN_ONLY -eq 0 ]; then
    echo "WOULD RUN setup into $PROJECT (METHOD: $METHOD)"
  fi
  if [ $NEEDS_TRANSLATE -eq 1 ]; then
    echo "TRANSLATE: LESEN.html OWNER.md → $LANGUAGE_NAME ($LANGUAGE)"
  fi
  echo "Start (check only): method=$METHOD language=$LANGUAGE project=$PROJECT"
  exit 0
fi

# Preflight conflicts before writing personal settings.
if [ $LESEN_ONLY -eq 0 ]; then
  preflight_args=(--check --switch)
  [ "$METHOD" != plain ] || preflight_args+=(--plain)
  "$SETUP" "${preflight_args[@]}" "$PROJECT" >/dev/null
fi

# OWNER.md first so setup does not warn that Start skipped language.
if [ $LESEN_ONLY -eq 0 ] || [ ! -f "$OWNER" ]; then
  tmp_owner="$(mktemp)"
  write_owner "$tmp_owner"
  if [ ! -f "$OWNER" ] || ! cmp -s "$tmp_owner" "$OWNER"; then
    mv "$tmp_owner" "$OWNER"
    note_changed "OWNER.md"
  else
    rm -f "$tmp_owner"
  fi
fi

if [ $LESEN_ONLY -eq 0 ]; then
  setup_args=()
  [ $REFRESH -eq 1 ] && setup_args+=(--refresh)
  [ "$METHOD" = "plain" ] && setup_args+=(--plain)
  setup_args+=(--switch)
  setup_args+=("$PROJECT")
  "$SETUP" "${setup_args[@]}"
  [ -s "$PROJECT/AGENTS.md" ] || { echo "FAIL: setup did not write AGENTS.md in $PROJECT" >&2; exit 1; }
fi

tmp_lesen="$(mktemp)"
fill_lesen "$TEMPLATE" "$tmp_lesen"
if [ ! -f "$LESEN" ] || ! cmp -s "$tmp_lesen" "$LESEN"; then
  mv "$tmp_lesen" "$LESEN"
  note_changed "LESEN.html"
else
  rm -f "$tmp_lesen"
fi

echo "Start into project: $PROJECT"
echo "Method: $METHOD"
echo "Language: $LANGUAGE ($LANGUAGE_NAME)"
echo "OWNER.md: $OWNER"
echo "LESEN.html: $LESEN"
echo "Why: $WHY"
if [ $NEEDS_TRANSLATE -eq 1 ]; then
  echo "TRANSLATE: LESEN.html OWNER.md → $LANGUAGE_NAME ($LANGUAGE)"
fi
