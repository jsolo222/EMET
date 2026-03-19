#!/usr/bin/env bash
# EMET development environment setup
set -euo pipefail

echo "=== EMET Development Setup ==="

# Start Docker services
echo "Starting infrastructure services..."
docker-compose up -d

# Wait for Postgres
echo "Waiting for PostgreSQL..."
until docker-compose exec -T postgres pg_isready -U emet > /dev/null 2>&1; do
    sleep 1
done
echo "PostgreSQL ready."

# Run migrations
echo "Running migrations..."
for f in migrations/*.sql; do
    echo "  Applying $f..."
    docker-compose exec -T postgres psql -U emet -d emet -f "/docker-entrypoint-initdb.d/$(basename "$f")"
done

echo "=== Setup complete ==="
