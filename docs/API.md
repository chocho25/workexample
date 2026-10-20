# WorkGeo API Contract

Base URL: `/api/v1`

All successful responses use `{ "data": ... }` with optional `"meta"` for pagination.

## Authentication

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| POST | `/auth/register` | Public | Register new user |
| POST | `/auth/login` | Public | Login, returns JWT |
| GET | `/auth/me` | Bearer | Current user profile |

### POST /auth/register
Body: `{ "name", "email", "password" }`

### POST /auth/login
Body: `{ "email", "password" }`
Response: `{ "data": { "accessToken", "user" } }`

## Home

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/home` | Public | Featured categories, cities, businesses |

## Categories

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/categories` | Public | List active categories |
| GET | `/categories/:id` | Public | Category detail |

## States & Cities

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/states` | Public | List states |
| GET | `/states/:id` | Public | State detail |
| GET | `/states/:id/cities` | Public | Cities in state |
| GET | `/cities` | Public | List cities (optional `?stateId=`) |
| GET | `/cities/:id` | Public | City detail |

## Businesses

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/businesses` | Public | Search/list (see query params) |
| GET | `/businesses/nearby` | Public | Nearby search (PostGIS, see below) |
| GET | `/businesses/mine` | Bearer | Owner's businesses (all statuses) |
| GET | `/businesses/:id` | Public | Business detail (ACTIVE only for public) |
| POST | `/businesses` | Bearer | Create business |
| PATCH | `/businesses/:id` | Bearer | Update (owner or admin) |
| DELETE | `/businesses/:id` | Bearer | Delete (owner or admin) |

### GET /businesses query params
- `search` — text search (max 100 chars)
- `categoryId` — UUID filter
- `stateId` — UUID filter
- `cityId` — UUID filter
- `page` — default 1, max 100
- `limit` — default 20, max 100
- `sort` — `relevance` | `name_asc` | `name_desc` | `newest` | `rating_desc`

Public list returns only `ACTIVE` businesses.

### GET /businesses/nearby (PostGIS)

Find ACTIVE businesses within a radius, sorted by distance.

| Param | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `latitude` | number | yes | — | WGS84 (-90 to 90) |
| `longitude` | number | yes | — | WGS84 (-180 to 180) |
| `radius` | number | no | 5 | Kilometers (max 100) |
| `categoryId` | UUID | no | — | Filter |
| `cityId` | UUID | no | — | Filter |
| `page` | number | no | 1 | Pagination |
| `limit` | number | no | 20 | Max 100 |

Response adds `distanceKm` per business and `query` metadata. Requires PostGIS — see `docs/POSTGIS.md`.

## Business Hours

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/businesses/:id/hours` | Public | Weekly schedule |
| PUT | `/businesses/:id/hours` | Bearer | Replace schedule (owner/admin) |

## Reviews (v2.0)

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/businesses/:businessId/reviews` | Public | Approved reviews |
| POST | `/businesses/:businessId/reviews` | Bearer | Create review |
| PATCH | `/reviews/:id` | Bearer | Update own review |
| DELETE | `/reviews/:id` | Bearer | Delete own review |

## Favorites (v2.0)

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/favorites` | Bearer | List favorites |
| POST | `/favorites/:businessId` | Bearer | Add favorite |
| DELETE | `/favorites/:businessId` | Bearer | Remove favorite |

## Analytics (v2.0)

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| POST | `/analytics/businesses/:id/track` | Public | Track event |
| GET | `/analytics/dashboard` | Bearer | Owner analytics |

## Business Images

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/businesses/:id/images` | Public | List images |
| POST | `/businesses/:id/images` | Bearer | Upload image (multipart) |
| DELETE | `/businesses/:id/images/:imageId` | Bearer | Delete image |

## Admin

All require `ADMIN` role.

| Method | Path | Description |
|--------|------|-------------|
| GET | `/admin/users` | List users |
| PATCH | `/admin/users/:id` | Update user (role, isActive) |
| GET | `/admin/businesses` | List all businesses |
| PATCH | `/admin/businesses/:id/status` | Moderate business status |
| POST | `/admin/categories` | Create category |
| PATCH | `/admin/categories/:id` | Update category |
| DELETE | `/admin/categories/:id` | Delete category |
| POST | `/admin/states` | Create state |
| PATCH | `/admin/states/:id` | Update state |
| POST | `/admin/cities` | Create city |
| PATCH | `/admin/cities/:id` | Update city |

## Health

| Method | Path | Description |
|--------|------|-------------|
| GET | `/health` | Service health check |

## Error codes

| Code | Meaning |
|------|---------|
| 400 | Validation error |
| 401 | Unauthenticated |
| 403 | Forbidden |
| 404 | Not found |
| 409 | Conflict |
| 429 | Rate limited |
| 503 | Service unavailable (e.g. PostGIS not enabled) |
| 500 | Internal error |
