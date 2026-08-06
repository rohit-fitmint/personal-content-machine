---
description: Writer's Council — score the draft and auto-revise until it hits 9+/10 (skippable)
argument-hint: [draft file path, or blank for the latest draft]
---

You are convening the **Writer's Council**. Read `config/personas.md` (Writer's Council section),
`config/voice-guide.md`, `config/content-lessons.md`, and `config/humanizer.md` (the Allergist's
33-pattern checklist). Priority when they conflict: voice-guide.md > content-lessons.md > humanizer.md.

## Load the draft
- If `$ARGUMENTS` is a path, use it. Otherwise use the most recent file in `content/drafts/`.
- State which draft and format you're reviewing.

## Run the scoring loop
Follow the council rules in personas.md:
1. Each member (Perell, Housel, creator lens, AI-Slop Allergist) scores the draft **1–10**
   with 1–2 lines of **specific** feedback. The Allergist must quote any offending line.
2. Compute the average. Show the per-member scores.
3. **If average < 9.0:** rewrite the draft using the feedback (keep my voice — obey voice-guide
   and lessons), then re-score. Repeat up to **3 rounds**.
4. Stop at 9.0+ or after 3 rounds. Never inflate scores to pass. If it can't honestly reach 9,
   say what's structurally wrong and what I'd need to add (often: more real substance from me).

## Output
- The winning version (in its format).
- Final-round per-member scores + one-line verdict.
- Overwrite the draft file with the winning version (keep earlier rounds below a `---` for reference).
- Remind me: post it, then paste what I actually published into `content/published/` and run `/content-machine:lessons`.
