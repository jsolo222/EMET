-- EMET Migration 001: information_record
-- The fundamental unit. Every piece of data entering the system.

CREATE TYPE data_type_enum AS ENUM ('VERIFIED', 'CONTESTED', 'SPECULATIVE', 'QUERY');
CREATE TYPE retrieval_method_enum AS ENUM ('RSS', 'API', 'SCRAPE', 'MANUAL', 'INTERNAL');

CREATE TABLE information_record (
    -- IDENTITY
    id                          UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at                  TIMESTAMPTZ     NOT NULL DEFAULT now(),
    ingested_at                 TIMESTAMPTZ     NOT NULL,

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
    propaganda_risk             FLOAT           DEFAULT 0.0,
    state_affiliated            BOOLEAN         DEFAULT false,
    affiliated_state            VARCHAR(100),
    coordination_flag           BOOLEAN         DEFAULT false,
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

CREATE INDEX idx_information_record_data_type ON information_record(data_type);
CREATE INDEX idx_information_record_source_id ON information_record(source_id);
CREATE INDEX idx_information_record_created_at ON information_record(created_at);
CREATE INDEX idx_information_record_domains ON information_record USING GIN(domains);
CREATE UNIQUE INDEX idx_information_record_raw_hash ON information_record(raw_hash);
