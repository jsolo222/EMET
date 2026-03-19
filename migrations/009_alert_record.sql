-- EMET Migration 009: alert_record
-- Alerts surface immediately. Everything else queues.

CREATE TABLE IF NOT EXISTS alert_record (
    id                      UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at              TIMESTAMPTZ     NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ     NOT NULL DEFAULT now(),
    fired_at                TIMESTAMPTZ     NOT NULL DEFAULT now(),

    -- CONTENT
    alert_type              alert_type_enum NOT NULL,
    severity                severity_enum   NOT NULL,
    summary                 TEXT            NOT NULL,
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

CREATE INDEX IF NOT EXISTS idx_alert_record_severity ON alert_record(severity);
CREATE INDEX IF NOT EXISTS idx_alert_record_type ON alert_record(alert_type);
CREATE INDEX IF NOT EXISTS idx_alert_record_acknowledged ON alert_record(acknowledged);
CREATE INDEX IF NOT EXISTS idx_alert_record_fired_at ON alert_record(fired_at);

CREATE OR REPLACE TRIGGER trg_alert_record_updated_at
    BEFORE UPDATE ON alert_record
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

INSERT INTO schema_migrations (version, name)
VALUES ('009', 'alert_record')
ON CONFLICT (version) DO NOTHING;
