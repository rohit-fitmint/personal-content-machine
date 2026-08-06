#!/usr/bin/env bash
# git-digest.sh — summarize recent work in one or more git repos as build-in-public fuel.
#
# For each repo it prints: commit subjects (with dates), files touched, and a
# net line-change stat over the window. Mechanical only — /oracle reads this and
# decides what's post-worthy.
#
# Usage:
#   bash scripts/git-digest.sh                       # repos from config, last 7 days
#   bash scripts/git-digest.sh --days 3
#   bash scripts/git-digest.sh /path/to/repo [/path/to/another]
#
# Repo list resolution order:
#   1. Paths passed as CLI args (after any --days N)
#   2. REPOS env var (colon-separated)
#   3. config/oracle-sources.md  ->  lines under "## Repos" that start with "- "
#
# Default repo if nothing configured: the SaaS project.

set -uo pipefail

DAYS=7
REPO_ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --days) DAYS="${2:-7}"; shift 2 ;;
    *) REPO_ARGS+=("$1"); shift ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCES_FILE="$SCRIPT_DIR/../config/oracle-sources.md"

# --- resolve repo list ---
REPOS=()
if [[ ${#REPO_ARGS[@]} -gt 0 ]]; then
  REPOS=("${REPO_ARGS[@]}")
elif [[ -n "${REPOS:-}" ]]; then
  IFS=':' read -r -a REPOS <<< "${REPOS}"
elif [[ -f "$SOURCES_FILE" ]]; then
  # grab bullet lines in the "## Repos" section
  in_section=0
  while IFS= read -r line; do
    if [[ "$line" =~ ^##[[:space:]]+Repos ]]; then in_section=1; continue; fi
    if [[ "$line" =~ ^## ]] && [[ $in_section -eq 1 ]]; then in_section=0; fi
    if [[ $in_section -eq 1 ]] && [[ "$line" =~ ^-[[:space:]]+(.+) ]]; then
      path="${BASH_REMATCH[1]}"
      path="${path/#\~/$HOME}"          # expand ~
      path="$(echo "$path" | sed 's/#.*//' | xargs)"  # strip trailing comments/space
      [[ -n "$path" ]] && REPOS+=("$path")
    fi
  done < "$SOURCES_FILE"
fi

# fallback: if no repos were passed as args, set via $REPOS, or listed under
# "## Repos" in oracle-sources.md, just scan the current working directory.
if [[ ${#REPOS[@]} -eq 0 ]]; then
  REPOS=("$PWD")
fi

SINCE="${DAYS} days ago"
echo "# Git digest — last ${DAYS} days"
echo "_Scanned ${#REPOS[@]} repo(s). Mine for: shipped features, fixes, decisions, refactors worth a build-in-public post._"
echo

for repo in "${REPOS[@]}"; do
  if [[ ! -d "$repo/.git" ]]; then
    echo "---"
    echo "## $repo"
    echo "_(not a git repo or path missing — skipped)_"
    echo
    continue
  fi
  name="$(basename "$repo")"
  echo "---"
  echo "## $name  ($repo)"
  branch="$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null)"
  echo "_branch: ${branch:-unknown}_"
  echo

  count="$(git -C "$repo" log --since="$SINCE" --oneline 2>/dev/null | wc -l | xargs)"
  if [[ "$count" == "0" ]]; then
    echo "No commits in window."
    echo
    continue
  fi

  echo "### Commits (${count})"
  git -C "$repo" log --since="$SINCE" --date=short \
    --pretty=format:'- %ad  %s' 2>/dev/null
  echo
  echo

  echo "### Files changed"
  git -C "$repo" log --since="$SINCE" --name-only --pretty=format: 2>/dev/null \
    | sed '/^$/d' | sort | uniq -c | sort -rn | head -25 \
    | awk '{printf "- %s (×%s)\n", $2, $1}'
  echo

  echo "### Net change"
  git -C "$repo" log --since="$SINCE" --numstat --pretty=format: 2>/dev/null \
    | awk 'NF==3 {add+=$1; del+=$2} END {printf "+%d / -%d lines across the window\n", add, del}'
  echo
done
