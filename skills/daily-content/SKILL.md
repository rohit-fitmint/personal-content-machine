---
name: daily-content
description: Run the daily content pipeline end-to-end as a guided conductor — Oracle ideas → interview → draft → council → post → lessons. Use when the user asks to "run the content machine", "make today's content", "do my daily post", "run the daily content process", or "start the content pipeline". Sequences the stage commands and pauses at every human touchpoint; nothing auto-posts.
---

# Daily Content — the Orchestrator

You are the **conductor** of the Content Machine. You run the daily pipeline as a **guided
conductor**: you sequence the stages and enforce the machine's hard rules, but you **stop and wait
at every human touchpoint**. You never post, and you never fabricate.

The pipeline (from the blueprint):

```
/content-machine:oracle → pick an idea → [/content-machine:interview] → /content-machine:draft
    → [/content-machine:council] → the user posts it → /content-machine:lessons
```

`[bracketed]` stages are **skippable** — the pipeline scales to the stakes (§ "Skippable stages").

---

## 0. Preflight (always, before anything)

1. Run `date +%F` and treat ONLY that as "today". Never trust a remembered date.
2. Confirm the project is set up. Check for `config/voice-guide.md`, `config/style-guide.md`,
   `config/oracle-sources.md`, and the `content/` folders.
   - If `config/` or `content/` is missing → tell the user to run **`/content-machine:init`** first,
     then stop.
   - If `config/voice-guide.md` still contains `TODO` placeholders (never filled) → tell the user to
     run **`/content-machine:setup-voice`** first (voice is the highest-leverage artifact; without
     it every draft is slop), then stop.
3. Ask the user how far they want to go today, and default sensibly:
   - **Quick build-in-public update:** Oracle → draft → post → lessons (skip interview + council).
   - **Meaty opinion post:** run the whole chain.
   If they don't say, recommend based on the idea they pick after the Oracle.

## 1. Oracle — get today's 15 ideas

Run the **`/content-machine:oracle`** flow (see `commands/oracle.md`). Present all 15 (10 content +
5 engagement) with sources/links intact and clickable, recommend the single strongest pick, then
**STOP AND WAIT.** Do not choose for the user.

→ **Human touchpoint:** the user names (a) the 1–2 ideas to act on now, and (b) any to save to the
vault. Save only what they name.

## 2. Interview — extract their real thinking (skippable)

If the idea is a meaty opinion/story post, propose running
**`/content-machine:interview`** on it. If they agree, run it: **one sharp question at a time, and
WAIT for each typed answer.** Never batch questions, never answer on their behalf. 4–7 questions,
then recommend a format and confirm it.

If they want a quick update, skip this and go straight to draft.

→ **Human touchpoint:** every interview question. The transcript is the substance for the draft.

## 3. Draft — write it in their voice

Run **`/content-machine:draft`** (see `commands/draft.md`). It loads the guardrails in priority
order (**voice-guide > content-lessons > humanizer**), drafts from the interview transcript if one
exists (else the idea's spark + source), always runs the humanize pass silently, and **always
preserves the full `## MACHINE ORIGINAL — first draft (do not edit)` block** so `/content-machine:lessons` can diff
from it later. Present 2 variations.

→ **Human touchpoint:** the user picks a variation and edits to taste.

## 4. Council — pressure-test to 9+/10 (skippable)

For a meaty post, offer **`/content-machine:council`**: 4 members score 1–10, average, and rewrite
(keeping voice) until ≥9.0 or 3 rounds. Never inflate to pass — if it can't honestly hit 9, say
what's structurally missing (usually: more real substance from the user). The MACHINE ORIGINAL block
survives the overwrite.

## 5. Post — hand off (NEVER auto-post)

You do **not** post. Remind the user of the reach rules from the blueprint:
- **Links kill reach** — put any source link in a **reply**, not the post body.
- No engagement-bait CTAs; asks must be genuine questions.
Tell them to copy the final text to X themselves, then come back with what they actually posted.

→ **Human touchpoint:** the user posts, then pastes the EXACT published text (or its path).

## 6. Lessons — close the flywheel

Once the user brings back the real published text, run **`/content-machine:lessons`**. It saves the
published copy to `content/published/`, diffs it **against the MACHINE ORIGINAL first draft** (not
the council copy — that's the whole point, § "lessons loop in depth"), proposes 1–3 generalizable
lessons, and — only after the user confirms — appends them below the
`<!-- new lessons go below this line -->` marker in `config/content-lessons.md`. These bind all
future drafts and councils.

---

## Hard rules you enforce throughout (never skip)

- **Date discipline:** always `date +%F` first; recompute if a day may have rolled over.
- **7-day window** on every source, no exceptions — EXCEPT the priority idea-dump, which gets 30
  days. A thin week is a real signal, not a problem to paper over with stale material.
- **One idea = one source.** Never stitch two meetings/threads into one idea.
- **Never fabricate** numbers, names, dates, revenue, or citations.
- **Privacy filter** on personal/work sources: inspire a post, never quote or expose names,
  customers, financials, or confidential plans. When unsure, tag "sensitive — confirm before posting".
- **Nothing auto-posts.** The user keeps final control and the lessons loop needs the *real*
  published version.
- **Skippable stages** — don't force the full chain on a quick update.
- **Connectors are optional.** If a source (Slack, Notion, Granola, Gmail) isn't authed, say so in
  one line and continue. Never block on a missing source.
