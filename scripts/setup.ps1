# WorkGeo Windows setup script
$ErrorActionPreference = "Stop"

Write-Host "==> WorkGeo setup (Windows)" -ForegroundColor Green

if (Get-Command docker -ErrorAction SilentlyContinue) {
    Write-Host "==> Starting PostgreSQL via Docker..."
    docker compose -f infra/docker-compose.yml up -d
    Start-Sleep -Seconds 5
} else {
    Write-Host "WARNING: Docker not found. Ensure PostgreSQL is running at DATABASE_URL." -ForegroundColor Yellow
}

if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Write-Host "Created .env from .env.example"
}

if (-not (Test-Path "apps/api/.env")) {
    Copy-Item ".env" "apps/api/.env"
}

Write-Host "==> Installing dependencies..."
npm install

Write-Host "==> Generating Prisma client..."
npm run db:generate -w @workgeo/api

Write-Host "==> Running migrations..."
npm run db:migrate -w @workgeo/api

Write-Host "==> Seeding database..."
npm run db:seed -w @workgeo/api

Write-Host ""
Write-Host "Setup complete! Run: npm run dev" -ForegroundColor Green
Write-Host "  Web:     http://localhost:3000"
Write-Host "  API:     http://localhost:3001"
Write-Host "  Swagger: http://localhost:3001/api/docs"
