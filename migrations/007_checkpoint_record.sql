-- EMET Migration 007: checkpoint_record
-- System state preservation.

CREATE TYPE checkpoint_trigger_enum AS ENUM (
    'USER_REQUEST', 'DATA_WRITE', 'ALERT_THRESHOLD', 'INTERVAL'
);

CREATE TABLE checkpoint_record (
    id                      UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at              TIMESTAMPTZ     NOT NULL DEFAULT now(),
    trigger                 checkpoint_trigger_enum NOT NULL,

    -- STATE SNAPSHOT
    open_queries            UUID[],
    daemon_state            JSONB,
    memory_sync_marker      TIMESTAMPTZ,
    ollama_pool_state       JSONB,

    -- INTEGRITY
    checksum                VARCHAR(64),
    valid                   BOOLEAN         NOT NULL DEFAULT true
);
