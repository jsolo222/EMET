-- EMET Migration 008: monitoring_gap_record
-- Downtime logged as data. Gaps are not nothing — they are potential silence data.

CREATE TYPE gap_cause_enum AS ENUM ('CRASH', 'SHUTDOWN', 'UNKNOWN');

CREATE TABLE monitoring_gap_record (
    id                          UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    gap_start                   TIMESTAMPTZ     NOT NULL,
    gap_end                     TIMESTAMPTZ     NOT NULL,
    gap_duration                INTERVAL        GENERATED ALWAYS AS (gap_end - gap_start) STORED,

    cause                       gap_cause_enum  DEFAULT 'UNKNOWN',
    last_checkpoint_id          UUID            REFERENCES checkpoint_record(id),

    -- SIGNIFICANCE
    active_queries_at_gap       UUID[],
    gap_treated_as_silence      BOOLEAN         DEFAULT false,
    notes                       TEXT
);
