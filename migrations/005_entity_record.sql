-- EMET Migration 005: entity_record
-- People, organizations, institutions the system tracks.

CREATE TABLE IF NOT EXISTS entity_record (
    id                      UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at              TIMESTAMPTZ     NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ     NOT NULL DEFAULT now(),

    -- IDENTITY
    canonical_name          VARCHAR(200)    NOT NULL,
    aliases                 TEXT[],
    entity_type             entity_type_enum NOT NULL,

    -- CONTEXT
    description             TEXT,
    domains                 TEXT[],
    geo_entities            TEXT[],
    known_affiliations      UUID[],

    -- APPEARANCE TRACKING
    first_seen_at           TIMESTAMPTZ,
    last_seen_at            TIMESTAMPTZ,
    mention_count           INTEGER         NOT NULL DEFAULT 0,
    mention_velocity        FLOAT           NOT NULL DEFAULT 0.0,
    velocity_baseline       FLOAT           NOT NULL DEFAULT 0.0,
    velocity_anomaly        BOOLEAN         NOT NULL DEFAULT false,

    -- RELATIONSHIP GRAPH
    embedding_id            VARCHAR(100)
);

CREATE INDEX IF NOT EXISTS idx_entity_record_name ON entity_record(canonical_name);
CREATE INDEX IF NOT EXISTS idx_entity_record_type ON entity_record(entity_type);
CREATE INDEX IF NOT EXISTS idx_entity_record_aliases ON entity_record USING GIN(aliases);
CREATE INDEX IF NOT EXISTS idx_entity_record_last_seen ON entity_record(last_seen_at);

CREATE OR REPLACE TRIGGER trg_entity_record_updated_at
    BEFORE UPDATE ON entity_record
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

INSERT INTO schema_migrations (version, name)
VALUES ('005', 'entity_record')
ON CONFLICT (version) DO NOTHING;
