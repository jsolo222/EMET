-- EMET Migration 008: monitoring_gap_record
-- Downtime logged as data. Gaps are not nothing — they are potential silence data.

CREATE TABLE IF NOT EXISTS monitoring_gap_record (
    id                          UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    gap_start                   TIMESTAMPTZ     NOT NULL,
    gap_end                     TIMESTAMPTZ     NOT NULL,
    gap_duration                INTERVAL        GENERATED ALWAYS AS (gap_end - gap_start) STORED,

    cause                       gap_cause_enum  NOT NULL DEFAULT 'UNKNOWN',
    last_checkpoint_id          UUID            REFERENCES checkpoint_record(id),

    -- SIGNIFICANCE
    active_queries_at_gap       UUID[],
    gap_treated_as_silence      BOOLEAN         NOT NULL DEFAULT false,
    notes                       TEXT
);

CREATE INDEX IF NOT EXISTS idx_monitoring_gap_start ON monitoring_gap_record(gap_start);

INSERT INTO schema_migrations (version, name)
VALUES ('008', 'monitoring_gap_record')
ON CONFLICT (version) DO NOTHING;
