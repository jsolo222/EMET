# Architecture Overview

## Three-Layer System

### Layer 1 — Monitoring Daemon (Rust)

Always running. Always watching. Does not care if the user is present.

**Responsibilities:**
- Poll all data sources on defined intervals
- Parse and normalize incoming data into standard record format
- Run lightweight classification via Ollama round-robin
- Detect anomalies against learned baselines (Welford algorithm)
- Detect silences — what didn't arrive that should have
- Generate QUERY threads when patterns trigger thresholds
- Write all findings to memory store with full provenance
- Write checkpoints on defined triggers
- Fire alerts when escalation thresholds are crossed
- Log all downtime gaps as monitoring gap records

**Does not:** Talk to the user. Make conclusions. Run deep LLM reasoning.

### Layer 2 — Memory / Knowledge Store

The substrate. Everything reads from it. Everything writes to it.

**PostgreSQL** — Structured memory. Facts, timestamps, provenance chains, tier assignments, source records, QUERY threads, alert history, checkpoint state, monitoring gap log, entity registry, relationship edges, silence records, decay tracking. Connection pooling via PgBouncer.

**ChromaDB** — Vector memory. Semantic embeddings of all confirmed facts. Pattern library. Semantic search. Relationship proximity mapping. Memory-mapped files — does not load full index into RAM.

**Sync Problem:** A fact decays in Postgres but its embedding still ranks highly in ChromaDB.

**Solution:**
- Stage 1: Confidence-weighted retrieval at query time: `final_score = semantic_similarity * confidence_value * (1 - decay_factor)`
- Stage 2: Scheduled embedding refresh with metadata filtering (post-stable)

### Layer 3 — Research + Conversation (Python)

**Concurrency:** asyncio + aiohttp for all external calls. Celery + Redis task queue. 4 workers max.

**Research sublayer:** Recursive QUERY investigation with depth limits, priority weighting, kill conditions, deduplication. Uses Claude API for complex reasoning, Ollama for routine tasks.

**Conversation sublayer:** Plain language interface. Semantic search across memory. Tier-labeled output with provenance. Cannot invent citations.

## The Dual Current

- **Descending** — Prime directive emanating downward. Keter to Malkuth.
- **Ascending** — Physical universe feeding upward. Malkuth to Keter.
- **Meeting point** — Tiphareth. Where raw data and prime directive complete the circuit.
