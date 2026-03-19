#!/usr/bin/env bash
# EMET — Run PostgreSQL migrations in order.
# Idempotent: tracks applied migrations in schema_migrations table.
# Usage: ./scripts/migrate.sh [--status]
set -euo pipefail

DB_URL="${DATABASE_URL:-postgresql://emet:emet_dev@localhost:6432/emet}"

# Direct connection for migrations (bypass PgBouncer for DDL)
DB_DIRECT="${DATABASE_URL_DIRECT:-postgresql://emet:emet_dev@localhost:5432/emet}"

show_status() {
    echo "=== Applied Migrations ==="
    psql "$DB_DIRECT" -c "SELECT version, name, applied_at FROM schema_migrations ORDER BY version;" 2>/dev/null \
        || echo "(no migrations applied yet)"
}

if [[ "${1:-}" == "--status" ]]; then
    show_status
    exit 0
fi

echo "EMET — Applying migrations..."
echo "Target: $DB_DIRECT"
echo ""

APPLIED=0
SKIPPED=0

for f in migrations/*.sql; do
    VERSION=$(basename "$f" | cut -d'_' -f1)
    NAME=$(basename "$f" .sql)

    # Check if already applied
    ALREADY=$(psql "$DB_DIRECT" -tAc \
        "SELECT 1 FROM schema_migrations WHERE version = '$VERSION'" 2>/dev/null || echo "")

    if [[ "$ALREADY" == "1" ]]; then
        echo "  SKIP  $NAME (already applied)"
        SKIPPED=$((SKIPPED + 1))
    else
        echo "  APPLY $NAME..."
        psql "$DB_DIRECT" -f "$f" --set ON_ERROR_STOP=on -q
        APPLIED=$((APPLIED + 1))
    fi
done

echo ""
echo "Done. Applied: $APPLIED, Skipped: $SKIPPED"
