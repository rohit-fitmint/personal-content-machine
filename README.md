# Content Machine

A Claude-native daily content system for building in public — packaged as an installable
[Claude Code plugin](https://code.claude.com/docs/en/plugins).

It reads what you **actually did** — your Claude sessions, git commits, meetings, and idea notes —
and hands you **15 ranked post ideas** every morning. Then it interviews you, drafts in a voice built
from your **own real posts**, scrubs 33 AI-writing tells, runs a writers' council until it scores
9+/10, and learns from every edit you make. You copy the final post to X yourself.

**No blank pages, no AI slop. Nothing auto-posts.**

> Adapted from Alex Lieberman's ([@businessbarista](https://x.com/businessbarista)) 6-step
> anti-AI-slop content workflow (Oracle → Interview → Draft → Council → Lessons → Repurpose),
> rebuilt as Claude Code commands + config + read-only scripts.

---

## Install

In Claude Code:

```
/plugin marketplace add rohit-fitmint/personal-content-machine
/plugin install content-machine@content-machine
```

Then, **in the folder you want to be your content project**, scaffold and set it up:

```
/content-machine:init
/content-machine:setup-voice
```

- **`/content-machine:init`** creates `config/`, `content/`, and `scripts/` in the current folder and
  installs the read-only script allowlist. It never overwrites config you've already filled in.
- **`/content-machine:setup-voice`** is the mandatory, highest-leverage step — paste 10–20 of your
  best/most-you X posts (plus a flop or two) and it builds your real `config/voice-guide.md` and
  `config/style-guide.md`. **Do this before drafting anything.**

Requirements: [Node.js](https://nodejs.org) (for the session-parsing script) and, optionally, `git`
(for the commit digest). Optional MCP connectors (Slack, Notion, Granola, Gmail) add more idea
sources but are never required — the machine works from Claude sessions + git + your own posts.

---

## Daily flow

```
/content-machine:oracle → pick an idea → [/content-machine:interview] → /content-machine:draft
    → [/content-machine:council] → post it yourself → /content-machine:lessons
```

`[bracketed]` = skippable. A quick build-in-public update can be just Oracle → draft → post. A meaty
opinion post runs the whole chain. Or just tell Claude **"run the daily content process"** and the
built-in orchestrator (the `daily-content` skill) conducts the whole flow, pausing at every point
where it needs you.

## Commands

| Command | What it does |
|---|---|
| `/content-machine:init` | One-time scaffold of `config/`, `content/`, `scripts/` + the script allowlist. |
| `/content-machine:setup-voice` | One-time onboarding — builds your voice + style guides from your real posts. |
| `/content-machine:oracle` | Mines every source and produces today's 15 ranked ideas (10 content + 5 engagement). |
| `/content-machine:interview` | An AI persona panel extracts your real thinking, one question at a time. |
| `/content-machine:draft` | Writes the post in your voice, then runs the 33-pattern humanize pass. |
| `/content-machine:council` | A writers' council scores + auto-revises the draft to 9+/10. |
| `/content-machine:lessons` | Diffs what you published vs the machine's first draft and learns your edits. |
| `/content-machine:repurpose` | Re-angles one post into a thread, several posts, or an article. |

## What it creates in your project

```
config/     voice-guide · style-guide · oracle-sources · content-lessons · humanizer · personas
scripts/    parse-sessions.mjs · git-digest.sh   (read-only, allowlisted)
content/
  idea-dump.md   your raw idea backlog (the Oracle reads this first)
  ideas/         daily Oracle output
  interviews/    interview transcripts
  drafts/        posts awaiting review (each keeps the machine's original first draft)
  published/     what you actually posted (feeds the lessons loop)
```

Everything personal is created at setup time. The plugin ships only engine + empty templates.

## Design principles (why it beats generic "AI writes my tweets")

- **Voice is the highest-leverage artifact** — every draft keys off a `voice-guide.md` built from
  your *real* posts, not invented patterns.
- **Write from your words, not the model's** — the interview transcribes your thinking before drafting.
- **Never fabricate** — no invented numbers, names, dates, or citations, ever.
- **One idea = one source** — every idea traces to a single, linkable source.
- **Hard 7-day window** on sources (30 days for your idea-dump backlog). A thin week is a real signal.
- **The lessons loop diffs from the machine's original first draft**, not the polished one — so the
  *cold* draft gets better over time.
- **Nothing auto-posts** — you keep final control, and the learning loop needs the real published version.

## Credits & license

- Workflow adapted from **Alex Lieberman** ([@businessbarista](https://x.com/businessbarista)).
- The humanizer is a vendored, tuned adaptation of **[blader/humanizer](https://github.com/blader/humanizer)**
  (MIT) — 33 patterns from Wikipedia's "Signs of AI writing." For a standalone `/humanizer` command:
  `/plugin marketplace add blader/humanizer`.
- MIT licensed. See [LICENSE](LICENSE).
