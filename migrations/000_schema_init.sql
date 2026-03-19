-- EMET Migration 000: Schema initialization
-- Extensions, enum types, migration tracking, utility functions.
-- All types created here so tables can reference them in any order.

-- ============================================================
-- MIGRATION TRACKING
-- ============================================================

CREATE TABLE IF NOT EXISTS schema_migrations (
    version     VARCHAR(20)     PRIMARY KEY,
    name        VARCHAR(200)    NOT NULL,
    applied_at  TIMESTAMPTZ     NOT NULL DEFAULT now()
);

-- ============================================================
-- ENUM TYPES
-- ============================================================

-- Wrap each in DO block: CREATE TYPE ... IF NOT EXISTS isn't supported pre-PG14.

DO $$ BEGIN
    CREATE TYPE data_type_enum AS ENUM ('VERIFIED', 'CONTESTED', 'SPECULATIVE', 'QUERY');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
    CREATE TYPE retrieval_method_enum AS ENUM ('RSS', 'API', 'SCRAPE', 'MANUAL', 'INTERNAL');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
    CREATE TYPE source_type_enum AS ENUM ('RSS', 'API', 'SCRAPE', 'MANUAL');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
    CREATE TYPE query_status_enum AS ENUM ('OPEN', 'ESCALATED', 'RESOLVED', 'CLOSED');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
    CREATE TYPE spawned_by_enum AS ENUM ('DAEMON', 'USER', 'RESEARCH_LOOP');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
    CREATE TYPE resolved_by_enum AS ENUM ('DAEMON', 'USER', 'TIMEOUT');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
    CREATE TYPE silence_type_enum AS ENUM ('ORGANIC', 'COORDINATED', 'UNKNOWN');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
    CREATE TYPE entity_type_enum AS ENUM (
        'PERSON', 'ORGANIZATION', 'INSTITUTION',
        'GOVERNMENT', 'CORPORATION', 'OTHER'
    );
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
    CREATE TYPE relationship_type_enum AS ENUM (
        'CONTROLS', 'FUNDS', 'COORDINATES_WITH',
        'PUBLICLY_OPPOSES', 'MEMBER_OF', 'REPORTS_TO',
        'OWNS', 'OTHER'
    );
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
    CREATE TYPE checkpoint_trigger_enum AS ENUM (
        'USER_REQUEST', 'DATA_WRITE', 'ALERT_THRESHOLD', 'INTERVAL'
    );
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
    CREATE TYPE gap_cause_enum AS ENUM ('CRASH', 'SHUTDOWN', 'UNKNOWN');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
    CREATE TYPE alert_type_enum AS ENUM (
        'CONVERGENCE', 'SILENCE_ESCALATION', 'ANOMALY',
        'QUERY_ESCALATION', 'SOURCE_ANOMALY', 'ENTITY_SURGE',
        'DISPLACEMENT_EVENT', 'OTHER'
    );
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
    CREATE TYPE severity_enum AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
    CREATE TYPE delivery_enum AS ENUM ('TAURI_NOTIFICATION', 'QUEUE');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- ============================================================
-- UTILITY: updated_at trigger function
-- ============================================================

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Record this migration
INSERT INTO schema_migrations (version, name)
VALUES ('000', 'schema_init')
ON CONFLICT (version) DO NOTHING;
