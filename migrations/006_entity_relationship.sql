-- EMET Migration 006: entity_relationship
-- Typed edges between entities. Evidence-backed, confidence-scored.

CREATE TYPE relationship_type_enum AS ENUM (
    'CONTROLS', 'FUNDS', 'COORDINATES_WITH',
    'PUBLICLY_OPPOSES', 'MEMBER_OF', 'REPORTS_TO',
    'OWNS', 'OTHER'
);

CREATE TABLE entity_relationship (
    id                      UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at              TIMESTAMPTZ     NOT NULL DEFAULT now(),
    last_updated            TIMESTAMPTZ,

    entity_a                UUID            NOT NULL REFERENCES entity_record(id),
    entity_b                UUID            NOT NULL REFERENCES entity_record(id),
    relationship_type       relationship_type_enum NOT NULL,
    relationship_notes      TEXT,

    -- EVIDENCE
    confirmed_by            UUID[],
    confidence              FLOAT           NOT NULL DEFAULT 0.0,
    data_type               data_type_enum,

    -- TEMPORAL
    relationship_start      TIMESTAMPTZ,
    relationship_end        TIMESTAMPTZ,
    active                  BOOLEAN         NOT NULL DEFAULT true
);

CREATE INDEX idx_entity_rel_a ON entity_relationship(entity_a);
CREATE INDEX idx_entity_rel_b ON entity_relationship(entity_b);
CREATE INDEX idx_entity_rel_type ON entity_relationship(relationship_type);
