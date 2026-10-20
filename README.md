# WorkGeo

Location-aware business discovery platform for finding and managing local businesses.

## Stack

| Layer | Technology |
|-------|------------|
| Frontend | Next.js 15 (App Router), TypeScript, Tailwind CSS, shadcn/ui, TanStack Query |
| Backend | NestJS, TypeScript, Prisma ORM |
| Database | PostgreSQL 16 |
| Auth | JWT (access tokens), Argon2id password hashing |

## Monorepo structure

```text
apps/
  api/    NestJS REST API (/api/v1)
  web/    Next.js web application
docs/     Architecture, API, security, and decision records
infra/    Docker Compose for local PostgreSQL
scripts/  Utility scripts
```

Package manager: **npm workspaces** (documented in `docs/DECISIONS.md`).

## Quick start

### Prerequisites

- Node.js 20+
- Docker (for PostgreSQL)

### 1. Install dependencies

```bash
npm install
```

### 2. Start PostgreSQL

**With Docker:**

```bash
docker compose -f infra/docker-compose.yml up -d
```

**Windows (PowerShell setup script):**

```powershell
.\scripts\setup.ps1
```

**Without Docker:** Install PostgreSQL locally and set `DATABASE_URL` in `.env`.

### 3. Configure environment

```bash
cp .env.example .env
```

Edit `.env` and set a strong `JWT_SECRET`.

### 4. Database setup

```bash
npm run db:migrate
npm run db:seed
```

### 5. Run development servers

```bash
npm run dev
```

- Web: http://localhost:3000
- API: http://localhost:3001
- Swagger: http://localhost:3001/api/docs

## Seed accounts

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@workgeo.local | Admin123!@# |
| User | user@workgeo.local | User123!@# |

> Development-only credentials. Never use in production.

## Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start API + web in development |
| `npm run build` | Production build |
| `npm run lint` | Lint all packages |
| `npm run test` | Run API tests |
| `npm run db:migrate` | Apply Prisma migrations |
| `npm run db:seed` | Seed development data |

## Documentation

See the [`docs/`](./docs/) directory for architecture, API contract, database schema, security baseline, and release checklist.

## License

Private — WorkGeo project.
