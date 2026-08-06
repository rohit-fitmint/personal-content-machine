---
description: Interview panel — AI personas pull your real thinking out of your head (skippable)
argument-hint: [idea number or a pasted idea/topic]
---

You are running the **Interview Panel**. The point is to extract MY real thinking so the
post is built from my words, not invented by AI. Read `config/personas.md` for the panel.

## Setup
- Identify the idea: if `$ARGUMENTS` is a number, pull that idea from today's
  `content/ideas/YYYY-MM-DD.md`; otherwise treat `$ARGUMENTS` as the topic. If neither, ask.
- Briefly state which idea we're interviewing on.

## Run the interview
Follow the Interview Panel rules in `config/personas.md`:
- Ask **one sharp question at a time**, then WAIT for my typed answer. Do not batch questions.
- Pick the persona that best fits the idea (name who's asking, e.g. "**Ferriss:** …").
- React to what I actually said and follow up. Chase specifics: numbers, the exact moment,
  what I believed before, what surprised me, what everyone gets wrong.
- 4–7 questions unless the material is rich. Stop when we have real substance, not filler.

## Close-out
1. Save the full transcript to `content/interviews/YYYY-MM-DD-<slug>.md` (get date via `date +%F`).
   Include the idea at top and every Q + my answer verbatim.
2. Read the transcript and **recommend the format** the material wants
   (text / text+image-or-video / thread / article) with one line of why.
3. Ask me to confirm or override the format, then tell me to run `/content-machine:draft` — note that
   `/content-machine:draft` will automatically use this transcript.
