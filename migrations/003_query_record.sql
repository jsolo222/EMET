-- EMET Migration 003: query_record
-- Internally generated investigation threads.
-- OPEN -> ESCALATED -> RESOLVED or CLOSED.
-- A QUERY closed without findings is itself a finding.

CREATE TABLE IF NOT EXISTS query_record (
    id                      UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at              TIMESTAMPTZ     NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ     NOT NULL DEFAULT now(),

    -- ORIGIN
    spawned_by              spawned_by_enum NOT NULL,
    parent_query_id         UUID            REFERENCES query_record(id),
    depth                   INTEGER         NOT NULL DEFAULT 0,
    max_depth               INTEGER         NOT NULL DEFAULT 5,

    -- CONTENT
    question                TEXT            NOT NULL,
    context                 TEXT,
    triggering_record       UUID            REFERENCES information_record(id),

    -- STATE
    status                  query_status_enum NOT NULL DEFAULT 'OPEN',
    status_changed_at       TIMESTAMPTZ,
    escalated_at            TIMESTAMPTZ,
    escalation_reason       TEXT,

    -- INVESTIGATION
    search_attempts         INTEGER         NOT NULL DEFAULT 0,
    sources_consulted       UUID[],
    records_generated       UUID[],
    sub_queries             UUID[],
    findings_summary        TEXT,
    finding_tier            data_type_enum,

    -- SILENCE TRACKING
    silence_confirmed       BOOLEAN         NOT NULL DEFAULT false,
    silence_scope           TEXT,
    silence_record_id       UUID,

    -- RESOLUTION
    resolved_at             TIMESTAMPTZ,
    resolution_notes        TEXT,
    resolved_by             resolved_by_enum
);

CREATE INDEX IF NOT EXISTS idx_query_record_status ON query_record(status);
CREATE INDEX IF NOT EXISTS idx_query_record_parent ON query_record(parent_query_id);
CREATE INDEX IF NOT EXISTS idx_query_record_spawned_by ON query_record(spawned_by);
CREATE INDEX IF NOT EXISTS idx_query_record_created_at ON query_record(created_at);

CREATE OR REPLACE TRIGGER trg_query_record_updated_at
    BEFORE UPDATE ON query_record
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

INSERT INTO schema_migrations (version, name)
VALUES ('003', 'query_record')
ON CONFLICT (version) DO NOTHING;
