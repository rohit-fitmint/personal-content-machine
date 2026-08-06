# Oracle Sources

Configuration for what `/content-machine:oracle` mines. Edit freely — the Oracle reads this file
every run. Anything unauthed or unavailable is skipped silently. Replace every `TODO`.

## ⭐ PRIORITY SOURCE — your own idea dump (read FIRST, weight HIGHEST)
Where you dump raw thoughts you want to write about. Every entry here is a near-ready idea and gets
the top slots in the 10. This is the ONE source with a **30-day window** (an exception to the hard
7-day rule — it's a backlog, not events). Choose ONE of the two options:

**Option A — a local file (default, zero setup):** keep raw ideas in `content/idea-dump.md`
(one idea per bullet). No connector needed.
- source: local
- file: content/idea-dump.md
- window_days: 30

**Option B — a private Slack channel** (uncomment and fill if you'd rather dump ideas in Slack):
# - source: slack
# - channel: TODO_channel_name
# - channel_id: TODO_channel_id        # e.g. C0XXXXXXXXX ; workspace: TODO_workspace
# - window_days: 30
# - privacy: none needed — these are your own thoughts, already meant to be public.

Skip a thought if you've clearly already posted it (check content/published/).

## Repos
Git repos to scan for build-in-public material (used by `git-digest.sh`).
- TODO_/path/to/your/repo        # the project you're building in public

## Claude sessions
Mined by `parse-sessions.mjs` across ALL projects (no config needed).
- window_days: 7

## Your X account
Your own recent posts are scanned for follow-up / thread-continuation angles.
- handle: TODO_your_handle

## Accounts to watch (engagement opportunities)
The Oracle picks 5 recent posts from these worth a genuine reply / quote-tweet.
- TODO_handle_1
- TODO_handle_2
- TODO_handle_3
# add as many as you like

## Keywords to watch (optional)
Topics worth reacting to when they trend among people you follow.
- TODO_keyword_1
- TODO_keyword_2

## Connector toggles
The Oracle skips any set to `off` or unauthed. Turn a source on only after you've connected it
(run `/mcp` in an interactive session). 7-DAY WINDOW IS A HARD RULE for all of these.
- notion: off         # a "Content Ideas" vault database, if you use one
# - notion_ideas_db: TODO_data_source_id        # data source id for your "Content Ideas" DB
# - notion_ideas_db_url: TODO_url
- slack: off          # a community workspace — spikes + engagement opportunities
- granola: off        # meeting transcripts — decisions, insights, hot takes
- gmail: off          # recent emails — scan for spikes only
- calendar: off       # recent/upcoming meetings for context
# If every connector is off, the Oracle still works from: Claude sessions + git + your own posts
# (via the browser). Connectors just add more sources.

## Privacy filter (IMPORTANT — these are work/personal accounts)
The Oracle must treat Slack / Granola / Gmail / Calendar / Notion as PRIVATE by default. When mining them:
- Only surface ideas that are safe and appropriate for a PUBLIC personal X post.
- NEVER expose: other people's names/DMs, customer or client identities, revenue/financials,
  unreleased plans marked confidential, credentials, or anything said in confidence.
- Abstract the insight, drop the identifying details. A meeting can inspire a post about a
  *lesson*; it should never quote the meeting.
- When in doubt, flag the idea as "sensitive — confirm before posting" rather than dropping it in raw.

## Apify / X scraping
How the Oracle pulls your posts + watched accounts.
- primary_method: browser              # navigate to x.com/<handle>, extract article innerText + status permalinks — REAL posts, free
- actor: apidojo/twitter-scraper-lite  # the paid Apify alternative; free tier returns demo/placeholder data only
- max_items_per_run: 200
- watch_accounts: on   # set off to skip the 5 engagement picks (saves scraping)
- scan_own_posts: on
# Actor input shape (twitter-scraper-lite): { twitterHandles: [...], start: "YYYY-MM-DD", end: "YYYY-MM-DD", maxItems: N, sort: "Latest" }
