---
description: One-time setup — scaffold config/, content/, scripts/ and the script allowlist into this project
argument-hint: (run once, in the folder you want to be your content-machine project)
---

You are running the Content Machine **initializer**. Scaffold this project so every stage command
(`/content-machine:oracle`, `/content-machine:draft`, …) has the local `config/`, `content/`, and
`scripts/` it reads, plus the read-only script allowlist. Be **idempotent**: never overwrite a
config file the user has already filled in.

The plugin's shipped files live under `${CLAUDE_PLUGIN_ROOT}` (templates, scripts). The user's
personal state is created **here, in the current working directory** — this folder becomes their
content-machine project.

## 1. Confirm the target
State the current directory (`pwd`) and tell the user this folder will become their content-machine
project (`config/`, `content/`, `scripts/` will be created here). If it already looks initialized
(a `config/` with filled guides), say so and skip to step 5 — don't clobber their data.

## 2. Scaffold folders, scripts, and config templates
Run this (it copies templates without overwriting anything that already exists):

```bash
set -e
ROOT="${CLAUDE_PLUGIN_ROOT}"

# content/ tree
mkdir -p content/ideas content/interviews content/drafts content/published content/assets

# scripts/ (engine — safe to refresh to the shipped version)
mkdir -p scripts
cp "$ROOT/scripts/parse-sessions.mjs" scripts/parse-sessions.mjs
cp "$ROOT/scripts/git-digest.sh"      scripts/git-digest.sh
chmod +x scripts/git-digest.sh scripts/parse-sessions.mjs 2>/dev/null || true

# config/ (personal — copy templates ONLY if the file doesn't exist yet; -n = no-clobber)
mkdir -p config
for f in voice-guide.md style-guide.md oracle-sources.md content-lessons.md humanizer.md personas.md; do
  cp -n "$ROOT/templates/config/$f" "config/$f"
done

# local idea-dump fallback (used if no Slack idea-dump channel is configured)
cp -n "$ROOT/templates/content/idea-dump.md" content/idea-dump.md 2>/dev/null || true

echo "Scaffolded config/, content/, scripts/ into $(pwd)"
ls -1 config/ content/
```

## 3. Install the read-only script allowlist
The Oracle runs two read-only scripts and `date` without permission prompts. Merge these into this
project's `.claude/settings.json` (create it if absent; if it exists, add any missing entries to the
`permissions.allow` array — do NOT drop the user's existing settings):

```
Bash(node scripts/parse-sessions.mjs:*)
Bash(bash scripts/git-digest.sh:*)
Bash(date:*)
```

Read `${CLAUDE_PLUGIN_ROOT}/templates/settings.allowlist.json` for the exact entries. Read the
existing `.claude/settings.json` first if present, union the `allow` arrays, and write it back.
Show the user the final allow list.

## 4. Add a .gitignore hint (optional)
If this project is a git repo, suggest the user gitignore their personal content if they don't want
it public: `content/published/`, `content/drafts/`, `content/interviews/` (their private material).
The `config/` guides are theirs to keep private too. Don't force it — just mention it.

## 5. Point the user at the next steps
Print this checklist, in order:
1. **`/content-machine:setup-voice`** — the mandatory, highest-leverage step. Paste 10–20 of your
   best/most-you X posts (plus a flop or two). It writes a real `config/voice-guide.md` and
   interviews you to fill `config/style-guide.md`. **Do this before drafting anything.**
2. **Edit `config/oracle-sources.md`** — set your X handle, the repo path(s) to scan, the accounts
   to watch, and your priority idea-dump source (a Slack channel id, or just use the local
   `content/idea-dump.md`). Every placeholder is commented.
3. **(Optional) Authorize connectors** — Slack / Notion / Granola / Gmail as extra idea sources. Run
   `/mcp` in an interactive session to connect them. The machine works without them (Claude sessions
   + git + your own posts via the browser) — connectors just add sources. Flip toggles in
   `oracle-sources.md`.
4. **Run it daily** — `/content-machine:oracle` for ideas, or ask me to "run the daily content
   process" to have the orchestrator conduct the whole flow.

Remind them: nothing ever auto-posts — finished drafts land in `content/drafts/` for them to copy to
X themselves.
