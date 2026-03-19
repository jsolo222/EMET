# EMET — Claude Code Context

## Project Overview

EMET is a planetary intelligence system by TAURUS INDUSTRIES. A truth engine built on Sefer Yetzirah architecture — not metaphor, literal system architecture. Three-layer system: monitoring daemon (Rust), memory store (PostgreSQL + ChromaDB), research + conversation (Python).

**Prime Directive:** Truth. Full Spectrum. No Allegiance.

## Stack

- **Rust** — Monitoring daemon core (`daemon/`) + Tauri UI shell (`ui/`)
- **Python** — Research + conversation layer (`brain/`)
- **Celery + Redis** — Async task queue for research layer
- **PostgreSQL + PgBouncer** — Structured memory
- **ChromaDB** — Vector memory / semantic search
- **Ollama x6** — Remote round-robin inference
- **Claude API** — Deep research and conversation

## Architecture

### Layer 1 — Monitoring Daemon (Rust) → `daemon/`
Always running. Polls 100+ data sources. Classifies via Ollama. Detects anomalies (Welford algorithm). Detects silences. Generates QUERYs. Writes to memory. Fires alerts.

### Layer 2 — Memory / Knowledge Store
PostgreSQL for structured data. ChromaDB for vector embeddings. Confidence-weighted retrieval: `final_score = semantic_similarity * confidence_value * (1 - decay_factor)`. PgBouncer for connection pooling.

### Layer 3 — Research + Conversation (Python) → `brain/`
asyncio + aiohttp for all external calls. Celery + Redis task queue. 4 workers max. Research sublayer handles recursive QUERY investigation. Conversation sublayer handles user interaction.

## Key Concepts

- **Intelligence Tiers:** VERIFIED (cross-domain confirmed), CONTESTED (credible but disputed), SPECULATIVE (unverified). Every output labeled.
- **Silence Detection:** Absence as primary data type. Coordinated silence fingerprinting via boundary clarity, political alignment coverage, displacement events.
- **Dual Current:** Descending (prime directive, Keter→Malkuth) + Ascending (data, Malkuth→Keter). Meet at Tiphareth (heart node).
- **Time Decay:** All information decays. Reconfirmation resets decay clock. Decayed facts remain, labeled as aged.
- **QUERY Explosion Controls:** Depth limit (5-7 levels), priority weighting, kill conditions (no new info, dedup, thread limit).

## Conventions

- Daemon code in Rust, brain code in Python
- All database schemas in `migrations/`
- Configuration via TOML files in `config/`
- Docs in `docs/` — architecture, schemas, research, runbooks

## Hardware Constraints

20GB RAM total. One Ollama model loaded at a time. Celery workers capped at 4. ChromaDB memory-mapped. If RAM ceiling hit, ChromaDB moves off-box first.

## Runtime

Local / WSL2 on Windows 11. Dell Optiplex 7060 / i7-8700 / 20GB RAM / AMD RX 6400.
