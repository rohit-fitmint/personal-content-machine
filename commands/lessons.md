---
description: Learn from your edits — diff what you posted vs the draft, save the lesson
argument-hint: (paste your final published post, or pass its file path)
---

You are running the **Lessons Loop** — the flywheel that makes the machine sound more like me
over time. Read `config/content-lessons.md`.

## Get the versions
- **Published:** if `$ARGUMENTS` is a path, read it; else ask me to paste the EXACT text I posted,
  then save it to `content/published/YYYY-MM-DD-<slug>.md` (date via `date +%F`).
- **Baseline = the MACHINE ORIGINAL first draft (DEFAULT).** Find the matching file in
  `content/drafts/` (same idea/slug) and use the `## MACHINE ORIGINAL — first draft` block as the
  baseline, NOT the council-approved / edited copy. This measures the full gap between what the
  machine produces cold and what I actually post — which is exactly what future drafts should close.
  Diffing only the council-approved version hides every preference the council silently absorbed
  before I saw it, so those patterns never get codified and the first draft keeps repeating them.
  If the original block is missing (older drafts), fall back to whatever draft exists and say so.

## Diff and extract lessons
Compare the **machine-original first draft** to what I actually published. For each meaningful
change, ask: is this a **generalizable** pattern or a one-off? Look for:
- Words/phrases I consistently cut or swap (my anti-slop tells).
- Structural moves (I shorten hooks / drop the last line / merge tweets).
- Tone shifts (I make it drier / more direct / less hype).
- Formatting habits (punctuation, emoji, line breaks).

**When the draft drifted a lot, attribute each change (quick three-way read):** first draft →
council version → published. A change the **council** made that I **kept** is the highest-value
kind to bake into the drafter (the machine can learn to do it natively). A change **I** made after
the council is my purest taste signal. Both are worth a lesson; note which is which.

Ignore pure one-offs. Only surface rules that would improve future drafts.

## Confirm and save
- Show me the 1–3 candidate lessons, each as: `- [YYYY-MM-DD] <rule>. (evidence: <what changed>)`.
- Ask which to keep (I might reject or reword).
- Append the approved ones below the `<!-- new lessons go below this line -->` marker in
  `config/content-lessons.md`.
- Confirm they're saved. These now bind all future `/content-machine:draft` and `/content-machine:council` runs.
