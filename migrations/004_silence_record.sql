-- EMET Migration 004: silence_record
-- Absence as a primary data type.
-- Silence is measurable, classifiable, and often more significant than noise.

CREATE TABLE IF NOT EXISTS silence_record (
    id                              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at                      TIMESTAMPTZ     NOT NULL DEFAULT now(),
    updated_at                      TIMESTAMPTZ     NOT NULL DEFAULT now(),

    -- WHAT IS ABSENT
    expected_content                TEXT,
    detection_method                TEXT,
    related_query                   UUID            REFERENCES query_record(id),

    -- SCOPE OF SILENCE
    domains_checked                 TEXT[],
    sources_checked                 INTEGER,
    time_window                     INTERVAL,

    -- SILENCE TYPING
    silence_type                    silence_type_enum NOT NULL DEFAULT 'UNKNOWN',
    type_confidence                 FLOAT,
    type_reasoning                  TEXT,

    -- FINGERPRINT
    boundary_clarity                FLOAT,          -- 0.0 = ragged/organic, 1.0 = clean/coordinated
    political_alignment_coverage    FLOAT,          -- 0.0 = partial, 1.0 = universal silence
    displacement_event              UUID            REFERENCES information_record(id),
    displacement_confirmed          BOOLEAN         NOT NULL DEFAULT false,

    -- PERSISTENCE
    investigation_rounds            INTEGER         NOT NULL DEFAULT 0,
    still_silent                    BOOLEAN         NOT NULL DEFAULT true,
    escalated                       BOOLEAN         NOT NULL DEFAULT false,
    escalated_at                    TIMESTAMPTZ,

    -- SIGNIFICANCE
    significance_score              FLOAT,
    significance_notes              TEXT
);

CREATE INDEX IF NOT EXISTS idx_silence_record_type ON silence_record(silence_type);
CREATE INDEX IF NOT EXISTS idx_silence_record_escalated ON silence_record(escalated);
CREATE INDEX IF NOT EXISTS idx_silence_record_still_silent ON silence_record(still_silent);
CREATE INDEX IF NOT EXISTS idx_silence_record_created_at ON silence_record(created_at);

CREATE OR REPLACE TRIGGER trg_silence_record_updated_at
    BEFORE UPDATE ON silence_record
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

INSERT INTO schema_migrations (version, name)
VALUES ('004', 'silence_record')
ON CONFLICT (version) DO NOTHING;
