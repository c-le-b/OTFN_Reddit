# OTFN Reddit Bot

An automated bot that posts multi-perspective story summaries to
[r/OverTheFenceNews](https://www.reddit.com/r/OverTheFenceNews/) on behalf of
[Over The Fence News](https://overthefencenews.com), a news aggregation site.

## What it does

Over The Fence News generates news coverage of the same story written from
several points along the political spectrum (left, center, right). When a
story is promoted to the site's "Top Stories" list, this bot:

1. Polls a private application database on a fixed interval for stories that
   are ready to be shared.
2. Formats a single Reddit self-post containing a link to the full story on
   the site, plus a short excerpt from the left, center, and right versions
   of the coverage.
3. Submits that post to a single subreddit (r/OverTheFenceNews) that we own
   and moderate, via Reddit's API using `snoowrap`.
4. Records the result (success/failure, Reddit post ID) so each story is
   only ever posted once.

This is a standard server-side bot posting outbound to one subreddit we
control, not an interactive on-platform experience, game, or moderation
tool. It runs continuously on our own infrastructure and needs to read from
our own private database on a timer, which is why it's implemented as a
traditional external API client rather than a Devvit app (Devvit backends
run per-request, triggered by Reddit-side events, and don't support holding
a persistent connection to poll an external private data source).

## Rate limiting

The bot enforces a minimum spacing of 15 minutes between posts regardless of
how many stories are queued, to stay well under Reddit's API limits and
avoid tripping subreddit-level anti-spam heuristics.

## Setup

```bash
npm install
cp .env.example .env   # fill in real credentials
```

Run the migration in `migrations/001_reddit_bot.sql` against your Postgres
database, then:

```bash
npm start
```

## Configuration

All configuration is via environment variables — see `.env.example`.

| Variable | Description |
|---|---|
| `DATABASE_URL` | Postgres connection string |
| `REDDIT_CLIENT_ID` / `REDDIT_CLIENT_SECRET` | Script-app OAuth2 credentials |
| `REDDIT_USERNAME` / `REDDIT_PASSWORD` | Dedicated bot account credentials |
| `REDDIT_USER_AGENT` | Descriptive user agent per Reddit API guidelines |
| `REDDIT_SUBREDDIT` | Target subreddit (no `r/` prefix) |
| `SITE_BASE_URL` | Base URL used to build links back to full stories |

## License

MIT
