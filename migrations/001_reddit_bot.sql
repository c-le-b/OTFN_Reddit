-- Schema needed for the Reddit posting bot.
-- Adapt table/column names to match your own application if integrating
-- into an existing schema rather than running standalone.

CREATE TABLE IF NOT EXISTS story_queue (
  id BIGSERIAL PRIMARY KEY,
  headline TEXT NOT NULL,
  slug TEXT NOT NULL,

  title_left TEXT,
  story_left TEXT,
  title_center TEXT,
  story_center TEXT,
  title_right TEXT,
  story_right TEXT,

  priority_rank INTEGER,
  ready_to_post BOOLEAN DEFAULT FALSE,
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  posted_to_reddit BOOLEAN DEFAULT FALSE,
  reddit_post_id TEXT,
  reddit_posted_at TIMESTAMPTZ,
  reddit_post_attempts INTEGER DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_story_queue_ready
  ON story_queue (ready_to_post) WHERE ready_to_post = true;

CREATE TABLE IF NOT EXISTS reddit_post_log (
  id BIGSERIAL PRIMARY KEY,
  story_id BIGINT REFERENCES story_queue(id),
  attempted_at TIMESTAMPTZ DEFAULT NOW(),
  success BOOLEAN NOT NULL,
  reddit_post_id TEXT,
  error_msg TEXT
);

CREATE INDEX IF NOT EXISTS idx_reddit_post_log_story ON reddit_post_log(story_id);
