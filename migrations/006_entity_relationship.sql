-- EMET Migration 006: entity_relationship
-- Typed edges between entities. Evidence-backed, confidence-scored.

CREATE TABLE IF NOT EXISTS entity_relationship (
    id                      UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at              TIMESTAMPTZ     NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ     NOT NULL DEFAULT now(),

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
    active                  BOOLEAN         NOT NULL DEFAULT true,

    -- Prevent duplicate edges of same type between same entities
    CONSTRAINT uq_entity_relationship UNIQUE (entity_a, entity_b, relationship_type)
);

CREATE INDEX IF NOT EXISTS idx_entity_rel_a ON entity_relationship(entity_a);
CREATE INDEX IF NOT EXISTS idx_entity_rel_b ON entity_relationship(entity_b);
CREATE INDEX IF NOT EXISTS idx_entity_rel_type ON entity_relationship(relationship_type);
CREATE INDEX IF NOT EXISTS idx_entity_rel_active ON entity_relationship(active);

CREATE OR REPLACE TRIGGER trg_entity_relationship_updated_at
    BEFORE UPDATE ON entity_relationship
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

INSERT INTO schema_migrations (version, name)
VALUES ('006', 'entity_relationship')
ON CONFLICT (version) DO NOTHING;
