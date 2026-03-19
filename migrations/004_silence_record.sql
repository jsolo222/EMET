-- EMET Migration 004: silence_record
-- Absence as a primary data type.

CREATE TYPE silence_type_enum AS ENUM ('ORGANIC', 'COORDINATED', 'UNKNOWN');

CREATE TABLE silence_record (
    id                              UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at                      TIMESTAMPTZ     NOT NULL DEFAULT now(),

    -- WHAT IS ABSENT
    expected_content                TEXT,
    detection_method                TEXT,
    related_query                   UUID            REFERENCES query_record(id),

    -- SCOPE OF SILENCE
    domains_checked                 TEXT[],
    sources_checked                 INTEGER,
    time_window                     INTERVAL,

    -- SILENCE TYPING
    silence_type                    silence_type_enum DEFAULT 'UNKNOWN',
    type_confidence                 FLOAT,
    type_reasoning                  TEXT,

    -- FINGERPRINT
    boundary_clarity                FLOAT,
    political_alignment_coverage    FLOAT,
    displacement_event              UUID            REFERENCES information_record(id),
    displacement_confirmed          BOOLEAN         DEFAULT false,

    -- PERSISTENCE
    investigation_rounds            INTEGER         NOT NULL DEFAULT 0,
    still_silent                    BOOLEAN         NOT NULL DEFAULT true,
    escalated                       BOOLEAN         NOT NULL DEFAULT false,
    escalated_at                    TIMESTAMPTZ,

    -- SIGNIFICANCE
    significance_score              FLOAT,
    significance_notes              TEXT
);

CREATE INDEX idx_silence_record_type ON silence_record(silence_type);
CREATE INDEX idx_silence_record_escalated ON silence_record(escalated);
