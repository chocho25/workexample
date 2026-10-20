#!/usr/bin/env bash
set -euo pipefail

echo "==> WorkGeo setup script"

if ! command -v docker &>/dev/null; then
  echo "WARNING: Docker not found. Ensure PostgreSQL is running at DATABASE_URL."
else
  echo "==> Starting PostgreSQL..."
  docker compose -f infra/docker-compose.yml up -d
  echo "Waiting for PostgreSQL..."
  sleep 5
fi

if [ ! -f .env ]; then
  cp .env.example .env
  echo "Created .env from .env.example — update JWT_SECRET before production."
fi

echo "==> Installing dependencies..."
npm install

echo "==> Generating Prisma client..."
npm run db:generate

echo "==> Running migrations..."
npm run db:migrate

echo "==> Seeding database..."
npm run db:seed

echo ""
echo "Setup complete! Run: npm run dev"
echo "  Web:    http://localhost:3000"
echo "  API:    http://localhost:3001"
echo "  Swagger: http://localhost:3001/api/docs"
