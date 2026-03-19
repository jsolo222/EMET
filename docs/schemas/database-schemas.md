# Database Schemas

All schema definitions are implemented as numbered SQL migrations in `migrations/`.

## Overview

| Schema | Migration | Purpose |
|--------|-----------|---------|
| `information_record` | 001 | The fundamental unit. Every piece of data entering the system. |
| `source_record` | 002 | Every source the system knows. Trust computed, never assigned. |
| `query_record` | 003 | Internally generated investigation threads. |
| `silence_record` | 004 | Absence as primary data type. Coordinated silence fingerprinting. |
| `entity_record` | 005 | People, organizations, institutions tracked. |
| `entity_relationship` | 006 | Typed weighted edges between entities. |
| `checkpoint_record` | 007 | System state preservation. |
| `monitoring_gap_record` | 008 | Downtime logged as data. |
| `alert_record` | 009 | Escalation events. |
| `gcp_reading` | 010 | Global Consciousness Project time-series data. |

## Custom Enums

- `data_type_enum`: VERIFIED, CONTESTED, SPECULATIVE, QUERY
- `retrieval_method_enum`: RSS, API, SCRAPE, MANUAL, INTERNAL
- `source_type_enum`: RSS, API, SCRAPE, MANUAL
- `query_status_enum`: OPEN, ESCALATED, RESOLVED, CLOSED
- `spawned_by_enum`: DAEMON, USER, RESEARCH_LOOP
- `resolved_by_enum`: DAEMON, USER, TIMEOUT
- `silence_type_enum`: ORGANIC, COORDINATED, UNKNOWN
- `entity_type_enum`: PERSON, ORGANIZATION, INSTITUTION, GOVERNMENT, CORPORATION, OTHER
- `relationship_type_enum`: CONTROLS, FUNDS, COORDINATES_WITH, PUBLICLY_OPPOSES, MEMBER_OF, REPORTS_TO, OWNS, OTHER
- `checkpoint_trigger_enum`: USER_REQUEST, DATA_WRITE, ALERT_THRESHOLD, INTERVAL
- `gap_cause_enum`: CRASH, SHUTDOWN, UNKNOWN
- `alert_type_enum`: CONVERGENCE, SILENCE_ESCALATION, ANOMALY, QUERY_ESCALATION, SOURCE_ANOMALY, ENTITY_SURGE, DISPLACEMENT_EVENT, OTHER
- `severity_enum`: LOW, MEDIUM, HIGH, CRITICAL
- `delivery_enum`: TAURI_NOTIFICATION, QUEUE

## Key Design Decisions

1. **All sources start at zero trust.** Trust is computed from track record, never manually assigned.
2. **Time decay is universal.** All information decays. Reconfirmation resets the decay clock. Decayed facts remain, labeled as aged.
3. **Silence is data.** The `silence_record` table treats absence as a first-class measurable phenomenon.
4. **Monitoring gaps are data.** Downtime is logged and can feed silence detection.
5. **Provenance is mandatory.** Every fact traces to a source. No orphan assertions.
