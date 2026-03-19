-- EMET Migration 001: source_record
-- Every source the system knows about. Trust is computed, never assigned.
-- Must be created BEFORE information_record (FK dependency).

CREATE TABLE IF NOT EXISTS source_record (
    id                      UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at              TIMESTAMPTZ     NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ     NOT NULL DEFAULT now(),

    -- IDENTITY
    name                    VARCHAR(200)    NOT NULL,
    url                     TEXT,
    feed_url                TEXT,
    source_type             source_type_enum,

    -- TRUST MODEL (all computed from track record, never manually assigned)
    trust_score             FLOAT           NOT NULL DEFAULT 0.0,
    trust_history           JSONB           NOT NULL DEFAULT '[]'::jsonb,
    tier                    INTEGER         DEFAULT 4,
    propaganda_risk         FLOAT           NOT NULL DEFAULT 0.0,
    state_affiliated        BOOLEAN         NOT NULL DEFAULT false,
    affiliated_state        VARCHAR(100),

    -- TRACK RECORD
    total_records           INTEGER         NOT NULL DEFAULT 0,
    verified_count          INTEGER         NOT NULL DEFAULT 0,
    contested_count         INTEGER         NOT NULL DEFAULT 0,
    speculative_count       INTEGER         NOT NULL DEFAULT 0,
    contradiction_count     INTEGER         NOT NULL DEFAULT 0,
    coordination_flags      INTEGER         NOT NULL DEFAULT 0,

    -- OPERATIONAL
    active                  BOOLEAN         NOT NULL DEFAULT true,
    poll_interval           INTEGER,
    last_polled_at          TIMESTAMPTZ,
    last_successful_at      TIMESTAMPTZ,
    circuit_breaker         BOOLEAN         NOT NULL DEFAULT false,
    cooldown_until          TIMESTAMPTZ,
    error_count             INTEGER         NOT NULL DEFAULT 0,
    consecutive_errors      INTEGER         NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_source_record_active ON source_record(active);
CREATE INDEX IF NOT EXISTS idx_source_record_trust ON source_record(trust_score);
CREATE INDEX IF NOT EXISTS idx_source_record_name ON source_record(name);

CREATE OR REPLACE TRIGGER trg_source_record_updated_at
    BEFORE UPDATE ON source_record
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

INSERT INTO schema_migrations (version, name)
VALUES ('001', 'source_record')
ON CONFLICT (version) DO NOTHING;
