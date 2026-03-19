#!/usr/bin/env bash
# Run PostgreSQL migrations in order
set -euo pipefail

DB_URL="${DATABASE_URL:-postgresql://emet:emet@localhost:6432/emet}"

for f in migrations/*.sql; do
    echo "Applying $f..."
    psql "$DB_URL" -f "$f"
done

echo "All migrations applied."
