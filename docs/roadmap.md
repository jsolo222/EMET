# Roadmap

## Phase 1 — Foundation
- Repository skeleton and configuration
- PostgreSQL schemas and migrations
- Docker infrastructure (Postgres, Redis, ChromaDB, PgBouncer)
- Daemon scaffold with source polling framework

## Phase 2 — The Daemon
- RSS polling + normalization
- Ollama pool with round-robin and health checks
- Welford anomaly detection baselines
- Silence detection framework
- QUERY thread generation
- Checkpoint system
- Memory writes (Postgres + ChromaDB)

## Phase 3 — The Brain
- Celery worker infrastructure
- Research sublayer: recursive investigation loop
- QUERY explosion controls (depth, priority, kill conditions)
- Conversation sublayer: semantic search, tier labeling
- Claude API integration with Ollama fallback routing
- Confidence-weighted retrieval

## Phase 4 — The Eye
- Tauri UI shell
- Dashboard + live monitoring state
- Investigation viewer
- Entity graph visualization
- Conversation interface
- System tray integration
- Alert delivery

## Phase 5 — Integration
- GCP polling + silence correlation
- Schumann Resonance pairing
- Cross-domain convergence scoring
- Composite alert system
- Full end-to-end flow testing
