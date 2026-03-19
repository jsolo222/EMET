-- EMET Migration 007: checkpoint_record
-- System state preservation.

CREATE TABLE IF NOT EXISTS checkpoint_record (
    id                      UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at              TIMESTAMPTZ     NOT NULL DEFAULT now(),
    checkpoint_trigger      checkpoint_trigger_enum NOT NULL,

    -- STATE SNAPSHOT
    open_queries            UUID[],
    daemon_state            JSONB,
    memory_sync_marker      TIMESTAMPTZ,
    ollama_pool_state       JSONB,

    -- INTEGRITY
    checksum                VARCHAR(64),
    valid                   BOOLEAN         NOT NULL DEFAULT true
);

CREATE INDEX IF NOT EXISTS idx_checkpoint_record_created_at ON checkpoint_record(created_at);

INSERT INTO schema_migrations (version, name)
VALUES ('007', 'checkpoint_record')
ON CONFLICT (version) DO NOTHING;
