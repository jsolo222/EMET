-- EMET Migration 010: gcp_reading
-- Global Consciousness Project time-series data.
-- GCP is a corroborating instrument, never a primary source.

CREATE TABLE gcp_reading (
    id                      UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    recorded_at             TIMESTAMPTZ     NOT NULL,
    ingested_at             TIMESTAMPTZ     NOT NULL DEFAULT now(),

    -- RAW DATA
    dot_value               FLOAT           NOT NULL,
    raw_variance            FLOAT,

    -- ANALYSIS
    z_score                 FLOAT,
    baseline_mean           FLOAT,
    baseline_stddev         FLOAT,
    anomalous               BOOLEAN         DEFAULT false,

    -- CORRELATION
    correlated_silence      UUID            REFERENCES silence_record(id),
    correlated_alert        UUID            REFERENCES alert_record(id),
    correlation_notes       TEXT
);

CREATE INDEX idx_gcp_reading_recorded ON gcp_reading(recorded_at);
CREATE INDEX idx_gcp_reading_anomalous ON gcp_reading(anomalous);
