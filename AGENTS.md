# Content Machine — AGENTS.md

A Claude-native daily content system for building in public, made portable. This file is the
**tool-agnostic entry point**: any coding agent that reads `AGENTS.md` (Codex, Cursor, Windsurf,
Copilot, Gemini CLI, Zed, Aider, …) can run the whole workflow from here. Claude Code users get the
same thing as a native plugin (see the "Claude Code" section).

It reads what you **actually did** — your Claude/agent sessions, git commits, meetings, idea notes —
and produces **15 ranked X post ideas**, then interviews you, drafts in a voice built from your
**own real posts**, scrubs 33 AI-writing tells, runs a writers' council to 9+/10, and learns from
every edit. **Nothing auto-posts** — you copy the final post to X yourself.

---

## How to run it in your agent

The pipeline is a set of **stages**. Each stage's full instructions live in a markdown file under
`commands/`. How you invoke a stage depends on your tool:

| Tool | How you invoke a stage | Set up by |
|------|------------------------|-----------|
| **Claude Code** | `/content-machine:oracle`, `:draft`, … (native plugin) | `/plugin install` then `/content-machine:init` |
| **Cursor** | `/oracle`, `/draft`, … (files in `.cursor/commands/`) | `./install.sh --tool cursor` |
| **Codex CLI** | `/cm-oracle`, `/cm-draft`, … (prompts in `~/.codex/prompts/`) | `./install.sh --tool codex` |
| **Any other agent** | Just say *"run the oracle stage"* / *"draft this idea"* — the agent reads the stage file below and follows it | `./install.sh --tool agents` |

If your agent has no slash-command system, **name the stage and point it at the file**, e.g.
*"Follow `commands/oracle.md` and generate today's ideas."* Every stage file is self-contained.

---

## The daily flow

```
oracle  →  pick an idea  →  [interview]  →  draft  →  [council]  →  you post it  →  lessons
```

`[bracketed]` = skippable. A quick build-in-public update can be just **oracle → draft → post**. A
meaty opinion post runs the whole chain. `repurpose` is an optional side-branch (one post → thread /
several posts / article). `setup-voice` is the one-time onboarding step.

### Orchestrated (guided conductor)
To run the whole day in one go, tell your agent: **"run the daily content process."** It should
conduct the flow but **stop and wait at every human touchpoint** — the idea pick, each interview
question, and pasting your real published text — and never post for you. (In Claude Code this is the
`daily-content` skill; in any other agent, follow this section.)

---

## The stages

| Stage | File | What it does |
|-------|------|--------------|
| **init** | (installer) | One-time scaffold of `config/`, `content/`, `scripts/`. Run `./install.sh`. |
| **setup-voice** | `commands/setup-voice.md` | One-time: builds `config/voice-guide.md` + `config/style-guide.md` from YOUR real posts. **Do this first.** |
| **oracle** | `commands/oracle.md` | Mines every source → today's 15 ranked ideas (10 content + 5 engagement). Then stops for your picks. |
| **interview** | `commands/interview.md` | An AI persona panel asks one sharp question at a time to extract your real thinking. |
| **draft** | `commands/draft.md` | Writes the post in your voice, then runs the 33-pattern humanize pass. Preserves the machine-original first draft. |
| **council** | `commands/council.md` | A 4-member writers' council scores 1–10 and auto-revises to 9+/10. |
| **lessons** | `commands/lessons.md` | Diffs what you published vs the machine's ORIGINAL first draft and learns your edits. |
| **repurpose** | `commands/repurpose.md` | Re-angles one post into a thread, several posts, or an article. |

> Note on arguments: stage files use `$ARGUMENTS` for "the idea number / topic / path you pass".
> Claude Code and Codex substitute this automatically; in Cursor and other tools, just type the
> idea number or topic after the command (or in your message) and the agent will use it.

---

## Hard rules (enforce these in every stage)

These are what separate this from a generic "AI writes my tweets" tool:

- **Date discipline.** Run `date +%F` FIRST and use only that for every time window + filename.
  Never trust a remembered date.
- **7-day window** on every source, no exceptions — EXCEPT your priority idea-dump, which gets **30
  days** (it's a backlog, not events). A thin week is a real signal, not a problem to paper over.
- **Voice is the highest-leverage artifact.** Everything keys off `config/voice-guide.md`, built
  from your real posts. Priority when guides conflict: **voice-guide > content-lessons > humanizer.**
- **Write from your words, not the model's.** The interview transcribes your thinking before drafting.
- **Never fabricate** numbers, names, dates, revenue, or citations. If a real detail isn't in the
  source, write plainly or ask.
- **One idea = one source.** Never stitch two meetings/threads into one idea.
- **Privacy filter** on personal/work sources (Slack, Granola, Gmail, Notion): they can *inspire* a
  post about a lesson; never quote them or expose names, customers, financials, or confidential
  plans. When unsure, tag "sensitive — confirm before posting."
- **The lessons loop diffs from the machine's ORIGINAL first draft**, not the polished one — so the
  *cold* draft improves over time. `draft` always preserves a
  `## MACHINE ORIGINAL — first draft (do not edit)` block for this.
- **Nothing auto-posts.** You keep final control, and the lessons loop needs the *real* published version.
- **Connectors are optional.** If a source isn't authed, say so in one line and continue. Never block.

---

## Setup

1. **Scaffold** — run `./install.sh` (see below). It creates `config/`, `content/`, `scripts/` in
   your project and wires up your agent's commands.
2. **`setup-voice`** — the mandatory, highest-leverage step. Paste 10–20 of your best/most-you X
   posts (plus a flop or two); it writes your real `config/voice-guide.md` and `config/style-guide.md`.
3. **Edit `config/oracle-sources.md`** — your handle, repo path(s), accounts to watch, and your
   priority idea-dump source (a Slack channel, or just the local `content/idea-dump.md`).
4. **(Optional) connectors** — Slack / Notion / Granola / Gmail as extra idea sources, via your
   tool's MCP config (`.cursor/mcp.json`, `~/.codex/config.toml`, or `/mcp` in Claude Code). The
   machine works without them (agent sessions + git + your own posts via the browser).

## Scripts (read-only)

- `scripts/parse-sessions.mjs` (Node) — digests your `~/.claude/projects/**/*.jsonl` transcripts over
  the last N days. Run: `node scripts/parse-sessions.mjs --days 7`.
- `scripts/git-digest.sh` (bash) — commits / files / net change over the window for your configured
  repos. Run: `bash scripts/git-digest.sh --days 7`.

Both are read-only. In Claude Code they're allowlisted automatically; in other tools, approve them
when prompted (or allowlist `node scripts/parse-sessions.mjs` and `bash scripts/git-digest.sh`).

## Credits & license

Workflow adapted from Alex Lieberman (@businessbarista). The humanizer is a vendored adaptation of
[blader/humanizer](https://github.com/blader/humanizer) (MIT). MIT licensed — see `LICENSE`.
