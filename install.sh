#!/usr/bin/env bash
# Content Machine — cross-tool installer.
# Scaffolds config/ content/ scripts/ into your project and wires up native commands
# for Claude Code, Cursor, and/or Codex CLI. Works from a clone or via curl | bash.
#
#   ./install.sh                        # auto-detect tools, scaffold into the current dir
#   ./install.sh --tool cursor          # only set up Cursor
#   ./install.sh --tool all --target ~/my-content   # everything, into a chosen project dir
#
# Tools: claude | cursor | codex | agents | all   (agents = universal AGENTS.md only)

set -euo pipefail

REPO_URL="https://github.com/rohit-fitmint/personal-content-machine"
STAGES=(oracle interview draft council lessons repurpose setup-voice)

# ---- args ----------------------------------------------------------------
TOOL=""
TARGET="$PWD"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --tool)   TOOL="${2:-}"; shift 2 ;;
    --target) TARGET="${2:-}"; shift 2 ;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

say()  { printf '\033[1;36m%s\033[0m\n' "$*"; }
ok()   { printf '  \033[1;32m✓\033[0m %s\n' "$*"; }
note() { printf '  \033[0;33m•\033[0m %s\n' "$*"; }

# ---- locate the plugin source (clone if we're piped via curl) ------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "")"
if [[ -n "$SCRIPT_DIR" && -d "$SCRIPT_DIR/templates" && -d "$SCRIPT_DIR/commands" ]]; then
  SRC="$SCRIPT_DIR"
else
  SRC="$(mktemp -d)"
  say "Fetching Content Machine…"
  git clone --depth 1 "$REPO_URL" "$SRC" >/dev/null 2>&1
  ok "cloned to $SRC"
fi

mkdir -p "$TARGET"
TARGET="$(cd "$TARGET" && pwd)"
say "Installing Content Machine into: $TARGET"

# ---- 1. scaffold the tool-agnostic core ----------------------------------
scaffold_core() {
  mkdir -p "$TARGET"/content/{ideas,interviews,drafts,published,assets}
  mkdir -p "$TARGET/scripts" "$TARGET/config"
  cp "$SRC/scripts/parse-sessions.mjs" "$TARGET/scripts/"
  cp "$SRC/scripts/git-digest.sh"      "$TARGET/scripts/"
  chmod +x "$TARGET"/scripts/*.sh "$TARGET"/scripts/*.mjs 2>/dev/null || true
  for f in voice-guide style-guide oracle-sources content-lessons humanizer personas; do
    cp -n "$SRC/templates/config/$f.md" "$TARGET/config/$f.md"
  done
  cp -n "$SRC/templates/content/idea-dump.md" "$TARGET/content/idea-dump.md" 2>/dev/null || true
  cp "$SRC/AGENTS.md" "$TARGET/AGENTS.md"          # the universal entry point (safe to refresh)
  ok "scaffolded config/, content/, scripts/, AGENTS.md"
}

# ---- transform a stage file for a given tool -----------------------------
# $1 = source file, $2 = out file, $3 = mode (claude|cursor|codex)
emit_command() {
  local src="$1" out="$2" mode="$3"
  case "$mode" in
    claude) sed 's|/content-machine:|/|g' "$src" > "$out" ;;                   # local /oracle
    cursor) sed -e 's|/content-machine:|/|g' \
                -e 's/\$ARGUMENTS/the input you were given (idea number, topic, or file path)/g' \
                "$src" > "$out" ;;                                             # Cursor: no $ARGUMENTS
    codex)  sed 's|/content-machine:|/cm-|g' "$src" > "$out" ;;                # /cm-oracle, keeps $ARGUMENTS
  esac
}

# strip YAML frontmatter and prepend a one-line description (for the daily orchestrator)
emit_daily() {
  local out="$1" mode="$2" prefix="$3"
  { echo "---"
    echo "description: Run the whole daily content pipeline as a guided conductor (pauses at every human touchpoint)"
    echo "---"
    awk 'BEGIN{fm=0} /^---[[:space:]]*$/{fm++; next} fm>=2{print}' "$SRC/skills/daily-content/SKILL.md"
  } > "$out.tmp"
  case "$mode" in
    cursor) sed -e 's|/content-machine:|/|g' \
                -e 's/\$ARGUMENTS/your instructions/g' "$out.tmp" > "$out" ;;
    codex)  sed 's|/content-machine:|/cm-|g' "$out.tmp" > "$out" ;;
  esac
  rm -f "$out.tmp"
}

install_cursor() {
  mkdir -p "$TARGET/.cursor/commands" "$TARGET/.cursor/rules"
  for s in "${STAGES[@]}"; do
    emit_command "$SRC/commands/$s.md" "$TARGET/.cursor/commands/$s.md" cursor
  done
  emit_daily "$TARGET/.cursor/commands/daily.md" cursor ""
  # a rule so ordinary Cursor chat also respects the voice when writing posts
  cat > "$TARGET/.cursor/rules/content-machine.mdc" <<'MDC'
---
description: Content Machine — write X posts in the user's real voice, no AI slop
alwaysApply: false
---
When writing or editing social/X content in this project, obey these files as hard constraints,
in priority order: `config/voice-guide.md` > `config/content-lessons.md` > `config/humanizer.md`,
plus `config/style-guide.md` for identity/product. Never fabricate numbers, names, or dates.
Prefer running the stage commands: /oracle, /interview, /draft, /council, /lessons, /daily.
MDC
  ok "Cursor: .cursor/commands/{${STAGES[*]// /,},daily}.md + .cursor/rules/content-machine.mdc"
  note "invoke in Cursor as /oracle, /draft, /daily, …"
}

install_codex() {
  local pdir="${CODEX_HOME:-$HOME/.codex}/prompts"
  mkdir -p "$pdir"
  for s in "${STAGES[@]}"; do
    emit_command "$SRC/commands/$s.md" "$pdir/cm-$s.md" codex
  done
  emit_daily "$pdir/cm-daily.md" codex ""
  ok "Codex: prompts written to $pdir (cm-*.md)"
  note "invoke in Codex as /cm-oracle, /cm-draft, /cm-daily, …"
  note "Codex reads AGENTS.md in your project root automatically."
}

install_claude_local() {
  mkdir -p "$TARGET/.claude/commands"
  for s in "${STAGES[@]}"; do
    emit_command "$SRC/commands/$s.md" "$TARGET/.claude/commands/$s.md" claude
  done
  emit_daily "$TARGET/.claude/commands/daily.md" claude ""
  # merge the read-only script allowlist into .claude/settings.json
  local st="$TARGET/.claude/settings.json"
  if [[ -f "$st" ]] && command -v node >/dev/null 2>&1; then
    node -e '
      const fs=require("fs"), p=process.argv[1];
      const s=JSON.parse(fs.readFileSync(p,"utf8"));
      s.permissions=s.permissions||{}; s.permissions.allow=s.permissions.allow||[];
      for (const e of ["Bash(node scripts/parse-sessions.mjs:*)","Bash(bash scripts/git-digest.sh:*)","Bash(date:*)"])
        if(!s.permissions.allow.includes(e)) s.permissions.allow.push(e);
      fs.writeFileSync(p, JSON.stringify(s,null,2)+"\n");
    ' "$st"
  else
    cp -n "$SRC/templates/settings.allowlist.json" "$st"
  fi
  ok "Claude Code (local): .claude/commands/*.md + settings allowlist"
  note "invoke as /oracle, /draft, /daily — or use the marketplace plugin for /content-machine:*"
}

# ---- pick tools ----------------------------------------------------------
if [[ -z "$TOOL" ]]; then
  TOOL="agents"                                   # universal default
  [[ -d "$TARGET/.cursor" ]] && TOOL="cursor"
  [[ -d "${CODEX_HOME:-$HOME/.codex}" ]] && TOOL="${TOOL},codex"
  [[ -d "$TARGET/.claude" ]] && TOOL="${TOOL},claude"
  say "Auto-detected tools: $TOOL  (override with --tool)"
fi

scaffold_core
IFS=',' read -ra TOOLS <<< "$TOOL"
for t in "${TOOLS[@]}"; do
  case "$t" in
    all)    install_cursor; install_codex; install_claude_local ;;
    cursor) install_cursor ;;
    codex)  install_codex ;;
    claude) install_claude_local ;;
    agents) ok "Universal: AGENTS.md is in place — any AGENTS.md-aware agent can run it." ;;
    *) echo "Unknown --tool: $t" >&2 ;;
  esac
done

# ---- next steps ----------------------------------------------------------
say ""
say "Done. Next steps:"
note "1. Run setup-voice (paste 10–20 of your best posts) — the mandatory first step."
note "2. Edit config/oracle-sources.md — handle, repos, watch accounts, idea-dump source."
note "3. (Optional) connect Slack/Notion/Granola/Gmail via your tool's MCP config."
note "Then run oracle daily, or say 'run the daily content process'. Nothing ever auto-posts."
