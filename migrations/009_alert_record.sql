-- EMET Migration 009: alert_record
-- Alerts surface immediately. Everything else queues.

CREATE TYPE alert_type_enum AS ENUM (
    'CONVERGENCE', 'SILENCE_ESCALATION', 'ANOMALY',
    'QUERY_ESCALATION', 'SOURCE_ANOMALY', 'ENTITY_SURGE',
    'DISPLACEMENT_EVENT', 'OTHER'
);

CREATE TYPE severity_enum AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL');
CREATE TYPE delivery_enum AS ENUM ('TAURI_NOTIFICATION', 'QUEUE');

CREATE TABLE alert_record (
    id                      UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at              TIMESTAMPTZ     NOT NULL DEFAULT now(),
    fired_at                TIMESTAMPTZ,

    -- CONTENT
    alert_type              alert_type_enum NOT NULL,
    severity                severity_enum   NOT NULL,
    summary                 TEXT,
    detail                  TEXT,
    related_records         UUID[],
    related_queries         UUID[],
    related_entities        UUID[],

    -- DELIVERY
    delivered_via           delivery_enum,
    acknowledged            BOOLEAN         NOT NULL DEFAULT false,
    acknowledged_at         TIMESTAMPTZ,
    dismissed               BOOLEAN         NOT NULL DEFAULT false,
    notes                   TEXT
);

CREATE INDEX idx_alert_record_severity ON alert_record(severity);
CREATE INDEX idx_alert_record_type ON alert_record(alert_type);
CREATE INDEX idx_alert_record_acknowledged ON alert_record(acknowledged);
