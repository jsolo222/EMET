-- EMET Migration 002: information_record
-- The fundamental unit. Every piece of data entering the system.

CREATE TABLE IF NOT EXISTS information_record (
    -- IDENTITY
    id                          UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at                  TIMESTAMPTZ     NOT NULL DEFAULT now(),
    updated_at                  TIMESTAMPTZ     NOT NULL DEFAULT now(),
    ingested_at                 TIMESTAMPTZ     NOT NULL DEFAULT now(),

    -- CONTENT
    raw_content                 TEXT            NOT NULL,
    normalized_content          TEXT,
    summary                     TEXT,
    language                    VARCHAR(10),
    translated_content          TEXT,

    -- SOURCE
    source_id                   UUID            REFERENCES source_record(id),
    source_url                  TEXT,
    source_domain               VARCHAR(100),
    publication_time            TIMESTAMPTZ,
    retrieval_method            retrieval_method_enum,

    -- CLASSIFICATION
    data_type                   data_type_enum  NOT NULL,
    previous_type               data_type_enum,
    type_changed_at             TIMESTAMPTZ,
    type_change_reason          TEXT,

    -- DOMAIN TAGS
    domains                     TEXT[],

    -- GEOGRAPHIC
    geo_entities                TEXT[],
    geo_coordinates             POINT[],
    geo_confidence              FLOAT,

    -- ENTITY EXTRACTION
    entities                    JSONB,

    -- CONFIDENCE & DECAY
    confidence_value            FLOAT           NOT NULL DEFAULT 0.5,
    confidence_floor            FLOAT           NOT NULL DEFAULT 0.1,
    decay_rate                  FLOAT           NOT NULL DEFAULT 0.01,
    last_confirmed_at           TIMESTAMPTZ,
    confirmation_count          INTEGER         NOT NULL DEFAULT 0,

    -- PROVENANCE CHAIN
    source_tier                 INTEGER,
    propaganda_risk             FLOAT           NOT NULL DEFAULT 0.0,
    state_affiliated            BOOLEAN         NOT NULL DEFAULT false,
    affiliated_state            VARCHAR(100),
    coordination_flag           BOOLEAN         NOT NULL DEFAULT false,
    coordination_notes          TEXT,

    -- CROSS-REFERENCES
    related_records             UUID[],
    confirms_records            UUID[],
    contradicts_records         UUID[],
    spawned_query               UUID,

    -- CONTEXT
    displaced_by                UUID,
    displacement_notes          TEXT,

    -- INTERNAL
    classified_by               VARCHAR(50),
    classification_confidence   FLOAT,
    embedding_id                VARCHAR(100),
    raw_hash                    VARCHAR(64)
);

CREATE INDEX IF NOT EXISTS idx_information_record_data_type ON information_record(data_type);
CREATE INDEX IF NOT EXISTS idx_information_record_source_id ON information_record(source_id);
CREATE INDEX IF NOT EXISTS idx_information_record_created_at ON information_record(created_at);
CREATE INDEX IF NOT EXISTS idx_information_record_domains ON information_record USING GIN(domains);
CREATE UNIQUE INDEX IF NOT EXISTS idx_information_record_raw_hash ON information_record(raw_hash);
CREATE INDEX IF NOT EXISTS idx_information_record_confidence ON information_record(confidence_value);
CREATE INDEX IF NOT EXISTS idx_information_record_last_confirmed ON information_record(last_confirmed_at);

CREATE OR REPLACE TRIGGER trg_information_record_updated_at
    BEFORE UPDATE ON information_record
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

INSERT INTO schema_migrations (version, name)
VALUES ('002', 'information_record')
ON CONFLICT (version) DO NOTHING;
