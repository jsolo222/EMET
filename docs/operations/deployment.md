# Deployment

## Runtime Environment

- Local / WSL2 on Windows 11
- Dell Optiplex 7060 / i7-8700 / 20GB RAM / AMD RX 6400

## Services

Start infrastructure:
```bash
docker-compose up -d
```

This starts: PostgreSQL (5432), PgBouncer (6432), Redis (6379), ChromaDB (8000).

## RAM Budget

| Component | Allocation |
|-----------|-----------|
| PostgreSQL | 2-4 GB |
| ChromaDB | 1-2 GB (memory-mapped) |
| Rust daemon | ~200 MB |
| Celery workers x4 | ~500 MB each = 2 GB |
| Redis | ~200 MB |
| Tauri UI | ~300 MB |
| Ollama (one model) | 4-6 GB (remote, one at a time) |
| OS overhead | 2-3 GB |
| **Total** | **~12-18 GB** |
| **Headroom** | **2-8 GB** |

If ceiling hit: ChromaDB moves off-box first. Everything else stays local.
