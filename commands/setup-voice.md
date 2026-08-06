---
description: One-time setup — build voice-guide.md and style-guide.md from your real posts
argument-hint: (paste your best X posts when prompted, or pass a file path)
---

You are setting up the content machine's voice. This is the highest-leverage step —
without a real voice guide, every draft is slop. Do it carefully.

## Steps

1. **Get the raw material.**
   - If `$ARGUMENTS` is a file path, read it. Otherwise ask me to paste **10–20 of my
     best / most "me" X posts** (a mix of top performers and ones that just sound like me).
   - Also ask for 1–2 posts that **flopped** or felt off — negative signal is gold.

2. **Analyze the posts as evidence** (don't invent — quote and pattern-match):
   - Hook shapes I actually use (first lines). Extract 4–6 reusable formulas from real examples.
   - Sentence rhythm, length, line breaks, white space habits.
   - Vocabulary: favorite words, contractions, slang, technical register.
   - Punctuation & emoji habits (do I use em-dashes? emoji? ALL CAPS for emphasis?).
   - Tone (e.g. self-deprecating confidence, dry, earnest, punchy).
   - What structurally correlates with my better vs worse posts.

3. **Rewrite `config/voice-guide.md`** from that evidence. Replace every TODO with
   real, specific, quoted patterns. Keep "the one rule" but make the rest concrete to me.

4. **Interview me briefly for `config/style-guide.md`** — ask, one at a time:
   - handle + one-line bio, what I want to be known for, my background/credibility
   - the SaaS in one plain sentence, who it's for, the wedge, current stage
   - my 1–2 content goals, any assets to promote, my hard-nos
   Then fill in `config/style-guide.md`, replacing the TODOs.

5. **Also update `config/oracle-sources.md`**: set my X handle, and ask which accounts
   I want to watch for engagement — write them into the "Accounts to watch" section.

6. Show me both finished files and confirm they sound right before we're done.

Be rigorous about step 3 — this file is what beats AI slop.
