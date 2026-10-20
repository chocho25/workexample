# WorkGeo Architecture

## Overview

WorkGeo is a **modular monolith** with a clean API boundary between the Next.js frontend and the NestJS backend.

```text
Client (Browser)
      ↓
Next.js Web App (apps/web)
      ↓  REST /api/v1
NestJS API (apps/api)
      ↓
Prisma ORM
      ↓
PostgreSQL
```

## Backend modules

| Module | Responsibility |
|--------|----------------|
| `auth` | Registration, login, JWT, `/auth/me` |
| `users` | User management (admin) |
| `categories` | Business categories |
| `states` | Geographic states/wilayas |
| `cities` | Cities within states |
| `businesses` | Core business CRUD + search |
| `business-images` | Image upload and management |
| `business-hours` | Weekly schedule per business |
| `home` | Home page aggregated data |
| `search` | Search/filter (via businesses module) |
| `admin` | Admin moderation endpoints |
| `health` | Health check |

Shared: `prisma`, `config`, `common`, `logging`, `security`.

## API versioning

All endpoints are prefixed with `/api/v1`.

## Response envelope

```json
{
  "data": { ... },
  "meta": { "page": 1, "limit": 20, "total": 100 }
}
```

Errors:

```json
{
  "statusCode": 400,
  "message": "Validation failed",
  "error": "Bad Request",
  "errors": [{ "field": "email", "message": "Invalid email" }]
}
```

## Authentication

- JWT bearer tokens in `Authorization` header
- Access token TTL: 15 minutes (configurable)
- Passwords hashed with Argon2id

## Authorization

| Role | Capabilities |
|------|-------------|
| `USER` | Read public businesses, CRUD own businesses |
| `ADMIN` | Full platform management and moderation |

Object-level checks enforce business ownership on mutations.

## Frontend routes

| Route | Purpose |
|-------|---------|
| `/` | Home |
| `/search` | Search + filters |
| `/map` | Map discovery |
| `/business/[id]` | Business details |
| `/login`, `/register` | Authentication |
| `/dashboard/*` | Owner dashboard |
| `/admin/*` | Admin panel |

## File storage

Business images stored on local filesystem under `uploads/` in development. Served via API static route. Production should use object storage (v2.0).

## Security layers

1. Input validation (class-validator DTOs)
2. Authentication guards (JWT)
3. Role guards (ADMIN)
4. Ownership guards (business owner)
5. Rate limiting (auth endpoints)
6. Security headers (Helmet)
7. CORS restriction

See `docs/SECURITY.md` for OWASP mapping.
