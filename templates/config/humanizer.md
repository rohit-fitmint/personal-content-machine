# Humanizer

Vendored, tuned adaptation of the **humanizer** skill (blader/humanizer, MIT) — 33 patterns of
AI-writing tells, based on Wikipedia's "Signs of AI writing." `/draft` runs this as a final pass
before saving; `/council`'s AI-Slop Allergist uses it as its checklist.

> **Refresh:** the canonical, always-updated version is the Claude Code plugin
> (`/plugin marketplace add blader/humanizer`, run `/humanizer` for ad-hoc use). To update this
> vendored copy, re-copy the upstream SKILL.md and re-apply the "Voice overrides" header below.

---

## ⚠️ Voice overrides — THESE WIN over the 33 patterns
`config/voice-guide.md` and `config/content-lessons.md` outrank everything below. The humanizer is a
net for AI slop, NOT a style flattener. Where a pattern would erase Rohit's actual voice, DO NOT apply
it. Specifically, KEEP these even though generic humanizing would remove them:
- **Aphoristic / philosophical closing lines** — his best posts end on them ("the world isn't running
  anywhere…"). Pattern 32 (aphorism formulas) does NOT apply to an earned closing line.
- **"Honestly," and casual conversational openers** — he deliberately uses these (his own /lessons
  added "Honestly,"). Pattern 33 (fake-candid openers) does NOT apply to his genuine ones.
- **Short punchy lines, fragments, one-idea-per-line rhythm, single-word emphasis ("ZERO")** — this is
  his cadence, not "staccato drama" (pattern 31). Keep it.
- **Intentional example lists** ("paediatricians, classes, toys, tuition") — not forced Rule-of-Three.
Everything else below applies fully — most of it already matches his voice (em-dashes, corporate
verbs, hype, hollow CTAs, emoji). When a humanizer pattern and the voice guide agree, apply hard.

---

## The three-step loop (how to run the pass)
1. **Rewrite** — fix every pattern below that isn't voice-protected. Preserve the information, flex the shape.
2. **Audit** — reread and ask "would this read as obviously AI-generated?" Catch anything left, and any
   fabricated fact/number/name (see the hard rule).
3. **Finalize** — last sweep to guarantee ZERO em/en dashes remain.

## Hard rule — no fabrication
Never invent facts, names, dates, numbers, or citations to satisfy a rewrite. If a real detail isn't
in the source (interview transcript / digest), write plainly or ask. This matches the machine's
existing "never invent metrics" stance.

---

## The 33 patterns

### Content (1–6)
1. **Significance inflation** — "marks a turning point", "cemented its legacy". Cut the grandeur.
2. **Notability name-dropping** — citing coverage/prestige to prove importance. Drop it.
3. **Superficial "-ing" analysis** — "symbolizing", "reflecting", "highlighting" tacked on to sound deep. Cut.
4. **Promotional language** — "nestled in the breathtaking", "a must-have", "seamless". Say the plain thing.
5. **Vague attribution** — "experts say", "many believe", "studies show" with no source. Name it or cut it.
6. **Formulaic challenge/triumph** — a tidy "Challenges" or struggle-then-win arc. Only if it actually happened.

### Language (7–13)
7. **AI vocabulary** — pivot, tapestry, landscape, realm, testament, delve, boasts, robust, leverage. Replace.
8. **Copula avoidance** — "serves as / functions as / stands as" → just "is".
9. **Negative parallelism** — "it's not just X, it's Y" / "not only… but also". Rewrite as a direct claim.
10. **Forced Rule of Three** — triads for rhythm ("fast, simple, and powerful"). Keep one, or vary the count.
11. **Synonym cycling** — swapping words for the same thing to avoid repetition. Repeat the plain word.
12. **False ranges** — "from X to Y" joining unrelated things ("from startups to spirituality"). Cut.
13. **Passive voice hiding the actor** — "mistakes were made" → say who did it.

### Style / formatting (14–19)
14. **Em/en dash overuse** — HARD BAN on em/en dashes (—, –); use periods or commas. (Matches Rohit's #1 rule.) BUT a plain spaced hyphen ( - ) is a connector he uses naturally — do NOT flag or remove it.
15. **Excessive boldface** — stop bolding for emphasis mid-sentence.
16. **Inline-header lists** — "**Speed:** it's fast. **Cost:** it's cheap." Turn into real sentences.
17. **Title-Case Headings** — use lowercase/sentence case.
18. **Decorative emojis** — remove. (Matches his minimal-emoji rule.)
19. **Curly quotes** — use straight quotes ' and ".

### Communication (20–22)
20. **Chatbot artifacts** — "I hope this helps!", "Great question!", "Sure!". Delete.
21. **Cutoff disclaimers / gap-filling** — "as of my last update", speculating to fill a hole. Cut or ask.
22. **Sycophancy** — "That's a brilliant point". Drop the flattery.

### Filler / hedging / structure (23–33)
23. **Bloated phrases** — "in order to" → "to", "due to the fact that" → "because".
24. **Over-qualification** — "could potentially possibly help". Commit or cut.
25. **Generic upbeat endings** — "the possibilities are endless", "the future is bright". Cut.
26. **Inconsistent hyphenation / forced hyphen pairs** — "cross-functional", "data-driven" as filler. Simplify.
27. **Authority-hedging tropes** — "the real question is", "at its core", "make no mistake". Cut.
28. **Signposting / meta-announcements** — "let's dive in", "in this post", "let's break it down". Cut.
29. **Fragmented headers** — one-word or sentence-fragment headings that add nothing. Cut or merge.
30. **Diff-anchored writing** — explaining what it's NOT before what it is. Just state what it is.
31. **Manufactured staccato drama** — fake tension via clipped lines. (NOTE: his genuine short-line rhythm is protected — see overrides.)
32. **Aphorism formulas** — pat "wisdom" bolted on. (NOTE: his earned closing aphorisms are protected — see overrides.)
33. **Fake-candid rhetorical openers** — "Let me be honest.", "Here's the thing." (NOTE: his genuine "Honestly," is protected — see overrides.)

---

## What human writing actually clusters (aim for these)
Mixed feelings, specific era-bound references, genuine asides, real sentence-length variety, and hard
specifics (real numbers, names, moments). AI can't easily fake these — Rohit's voice already has them.
