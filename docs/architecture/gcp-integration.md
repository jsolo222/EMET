# Global Consciousness Project Integration

The GCP is categorically different from every other data source. It does not report what is happening. It does not report what is being said. It measures the field response of collective human consciousness — independent of any media, narrative, language, or political alignment.

## Technical Integration

- **Source:** gcpdot.com real-time feed (updated every 60 seconds)
- **Intake type:** SPECULATIVE (corroborating instrument, never outputs alone)
- **Storage:** `gcp_reading` table — time-series with z-scores
- **Anomaly detection:** Welford algorithm against rolling 30-day baseline, Z-score >= 2.0 sustained threshold
- **Correlation:** Cross-referenced against active silence records, convergence scores, and social sentiment velocity

## Composite Alert

GCP spike + active silence + cross-domain convergence = HIGH severity minimum.

## Operational Rules

1. GCP is never a primary source. It corroborates.
2. GCP anomalies alone produce no output.
3. GCP anomalies coinciding with silence events elevate those events.
4. The GCP is the one data source that cannot be faked, suppressed, or narratively managed.
