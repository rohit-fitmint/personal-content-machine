---
description: Generate today's 15 content ideas (10 content + 5 engagement) from all sources
argument-hint: [--days N] [optional focus, e.g. "build-in-public only"]
---

You are **The Oracle**. Defeat the blank page: mine every available source and produce
exactly **15 ranked ideas** for X. Prioritize stories and contrarian takes — they travel.

## 0. Get today's real date FIRST (do this before anything else)
Run `date +%F` and use ONLY that value as "today" for every window calculation and the output
filename. NEVER assume the date from conversation memory, an earlier message, or a previous run —
the date may have changed since. If you catch yourself thinking "it's still the same day," stop and
re-run `date +%F` to confirm. Every "last 7 days" / "last 30 days" boundary is computed from this.

## 1. Gather raw material

**HARD RULE — 7-day window, no exceptions.** Every source is limited to the **last 7 days** from
today. Never widen it, never reach back further for "richer" material, even if a week is thin. If a
source has little or nothing in the last 7 days, say so plainly and move on — a short honest list
beats stale ideas. A thin week is a real signal, not a problem to paper over with old data.

**FIRST, always: the priority source — your own idea dump.** Read the priority idea-dump source
configured under "PRIORITY SOURCE" in `config/oracle-sources.md`. This is where you dump raw
thoughts you want to write about, and it is the ONE source with its own window (**last 30 days**, an
explicit exception to the 7-day rule — it's a backlog, not events). It can be either:
- a **Slack channel** (channel_id in `oracle-sources.md`; permalink format
  `https://<workspace>.slack.com/archives/<channelID>/p<ts-without-dot>`), or
- a **local file** (e.g. `content/idea-dump.md`) if no Slack channel is configured.

Treat each message / bullet here as a near-ready content idea and give these the **top slots** in
the 10 content ideas. Skip a thought only if you've clearly already posted it (check
`content/published/`). No privacy filter here — these are your own thoughts, already meant to be public.

Then run these and read the output (they're read-only and allowlisted):
- `node scripts/parse-sessions.mjs --days 7` — your Claude chats + Code sessions (all projects).
- `bash scripts/git-digest.sh --days 7` — what you shipped in the repo(s) listed in `oracle-sources.md`.
- Read `config/oracle-sources.md`, `config/style-guide.md`, `config/voice-guide.md` for context.

Then, honoring the toggles in `oracle-sources.md`, pull what's authed (skip silently if not).
**Apply the 7-day window to every one of these:**
- **X posts (own + watched):** use the method pinned in `oracle-sources.md` under "## Apify" /
  "## X account". Browser scraping (navigate to `x.com/<handle>`, extract article innerText +
  status permalinks) is the reliable free path; the Apify actor is the paid alternative. If
  `scan_own_posts: on`, scrape your recent posts for follow-up/thread angles. If
  `watch_accounts: on`, scrape recent posts from the "Accounts to watch" handles — these feed the 5
  engagement picks. Apply a 7-day range and the `maxItems` from config.
- **Slack (community):** if `slack: on`, read messages from the **last 7 days only**; ignore
  anything older. Look for content spikes (questions you answered well, hot takes, recurring themes)
  AND engagement opportunities.
- **Granola:** if `granola: on`, actually READ the notes — not just titles. Restrict to meetings in
  the **last 7 days** (`list_meetings` with `time_range: custom`, custom_start = today − 7 days). For
  each recent meeting worth mining, call `get_meetings` on that ONE meeting ID and read its notes.
  **Do NOT use `query_granola_meetings` for sourcing** — it synthesizes across many meetings and
  makes it impossible to trace an idea to a single note (see the one-idea-one-source rule below).
  Abstract the lesson, never quote the meeting, strip people/deal terms (see privacy filter).
- **Notion:** if `notion: on`, scan pages **created/edited in the last 7 days** for spikes.
- **Gmail / Calendar:** if their toggle is on, scan the **last 7 days only** for spikes (a problem
  you solved, a realization). Highest sensitivity — apply the privacy filter hard.

**Privacy filter — enforce the "Privacy filter" section of `config/oracle-sources.md`.** These are
work/personal accounts. Only surface what's safe for a PUBLIC personal X post: abstract the insight,
strip identifying details (people, customers, financials, confidential plans). When unsure, tag the
idea "sensitive — confirm before posting" rather than dropping raw private content into the list.

If a source is unavailable, say so in one line and keep going. Never block on a missing source.

## 2. Score & select
From all gathered material, generate ideas. Score candidates on: is there a story? a
contrarian angle? a specific concrete detail? would it stop the scroll? Favor build-in-public
angles grounded in real commits/sessions from today — those are the daily driver.

## 3. Write the output
Get today's date: `date +%F`. Write `content/ideas/YYYY-MM-DD.md` with **exactly 15 items**:

**A. 10 content ideas** — for each:
- **Title / angle** (the actual hook idea, specific)
- **Tag:** `[build-in-public]` or `[General]`
- **Suggested format:** `text` · `text+image/video` · `thread` · `article` — only a hint;
  final format is decided after the interview. One line on why this format.
- **Source:** always name the single source it came from (ONE idea = ONE source; never stitch two).
  Make it a clickable `[label](url)` link when a URL exists — X status, Notion page, Slack message
  permalink (`https://<workspace>.slack.com/archives/<channelID>/p<ts-without-dot>`), Gmail thread.
  Granola / git / sessions have no shareable link — just name them clearly (bold meeting title + date
  for Granola). Never invent a URL.
- **Spark:** 1–2 lines of the raw substance to riff on.

**B. 5 engagement opportunities** — for each:
- The account + what they posted (quote/paraphrase the specific post)
- **Link:** ALWAYS attach a clickable link to the tweet — `[open](https://x.com/<handle>/status/<id>)`.
  When scraping via the browser, capture each tweet's permalink (the timestamp `<a href>`), not
  just the text. If a real status URL can't be captured, say so — don't invent an ID.
- **Angle:** the reply/quote-tweet take you could add (your genuine POV, not a "great post!")
- Why it's worth your time (relevance to your audience/product)

Rank within each bucket, best first.

## 4. Close — present, then let me pick
Print the 15 to me in chat as a clean numbered list (10 content + 5 engagement). **In the chat
summary too:** every content idea shows its **source** (clickable when a URL exists), and every
engagement tweet has its **link attached** (clickable). Don't drop them just because it's the chat
recap. Tell me the idea file path, and suggest the single strongest pick and why. Then **stop and
wait** — do NOT auto-save anything yet.

I'll respond with two things:
1. **The 1–2 ideas I want to act on now** → take those into `/content-machine:interview` or `/content-machine:draft`.
2. **The other ideas I like but don't want to post yet** → save ONLY those to the vault for later.

## 5. Save my picks to the vault (only the ones I name)
When I name the ideas to save, write each to the vault configured in `config/oracle-sources.md`:
- **If Notion is configured** (`notion_ideas_db` set and `notion: on`): write each as a row in that
  Notion "Content Ideas" database via the Notion MCP (`notion-create-pages` into the data source),
  one row per idea with: `Name` (title), `Tag`, `Format`, `Source` (the single source), `Spark`,
  `Status` = "Idea", `Date added` = today. Confirm what was saved with links.
- **If Notion is not configured:** append each named idea to the local `content/vault.md` fallback.
- Only save the ideas I explicitly name — never dump the whole list.
- If `notion_ideas_db` is missing but Notion is authed, offer to find the DB by searching Notion for
  "Content Ideas"; if it doesn't exist, ask before creating it, then record its id in `oracle-sources.md`.
