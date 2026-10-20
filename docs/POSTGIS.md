# PostGIS Geographic Search — WorkGeo Phase 1

## Overview

WorkGeo uses **PostgreSQL + PostGIS** for radius and nearest-neighbor business discovery.

Existing `latitude` and `longitude` decimal columns are **preserved** for backward-compatible API responses. A synced `location` geography column powers spatial queries.

## Architecture

```text
Business (API / Prisma)
  latitude   Decimal(10,7)   ← unchanged, validated on input
  longitude  Decimal(10,7)   ← unchanged, validated on input
  location   geography(POINT, 4326)   ← PostGIS, DB-managed via trigger
```

| Component | Role |
|-----------|------|
| `latitude` / `longitude` | Source of truth for API; Prisma CRUD |
| `location` | Derived geography column; spatial index |
| `sync_business_location()` | Trigger keeps `location` in sync on INSERT/UPDATE |
| `businesses_location_gist_idx` | GIST index for `ST_DWithin` / distance sorts |

**SRID:** 4326 (WGS84) — standard GPS coordinates.

## Development requirements

### PostgreSQL with PostGIS

PostGIS must be installed on your PostgreSQL server.

**Windows (Stack Builder / installer):**
1. Install PostgreSQL 16
2. Run Stack Builder → Spatial Extensions → PostGIS
3. Restart PostgreSQL service

**Verify:**
```sql
CREATE EXTENSION IF NOT EXISTS postgis;
SELECT PostGIS_Version();
```

**Health check:**
```http
GET /api/v1/health
```
Response includes:
```json
{
  "data": {
    "status": "ok",
    "postgis": { "enabled": true, "version": "3.x ..." }
  }
}
```

## Migration

Migration: `20260809140000_postgis_location`

Steps performed:
1. `CREATE EXTENSION IF NOT EXISTS postgis`
2. Add `location geography(POINT, 4326)` to `businesses`
3. Backfill from existing `latitude` / `longitude`
4. Create GIST spatial index
5. Create trigger `business_location_sync`

Apply:
```bash
npm run db:migrate -w @workgeo/api
npm run db:generate -w @workgeo/api
```

**Never run** `prisma migrate reset` on production data.

## API — Nearby search

```http
GET /api/v1/businesses/nearby
```

### Query parameters

| Param | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `latitude` | number | yes | — | WGS84, -90 to 90 |
| `longitude` | number | yes | — | WGS84, -180 to 180 |
| `radius` | number | no | 5 | Radius in **kilometers** (max 100) |
| `categoryId` | UUID | no | — | Filter by category |
| `cityId` | UUID | no | — | Filter by city |
| `page` | number | no | 1 | Pagination |
| `limit` | number | no | 20 | Max 100 |

### Example

```http
GET /api/v1/businesses/nearby?latitude=36.7538&longitude=3.0588&radius=10&limit=20
```

### Response

```json
{
  "data": [
    {
      "id": "...",
      "name": "Le Gourmet",
      "latitude": "36.7538000",
      "longitude": "3.0588000",
      "distanceKm": 0.3,
      "category": { ... },
      "city": { ... }
    }
  ],
  "meta": { "page": 1, "limit": 20, "total": 5, "totalPages": 1 },
  "query": { "latitude": 36.7538, "longitude": 3.0588, "radiusKm": 10 }
}
```

- Only **ACTIVE** businesses are returned
- Results sorted by distance (nearest first)
- `distanceKm` is additive; existing business fields unchanged

### Errors

| Code | When |
|------|------|
| 400 | Invalid coordinates or query params |
| 503 | PostGIS extension not enabled |

## Security

- All query parameters validated via `NearbyBusinessesDto` (class-validator)
- Spatial queries use **parameterized** Prisma `$queryRaw` tagged templates — no string interpolation
- Public endpoint; returns only ACTIVE businesses
- Coordinate range validation prevents invalid geometry

## Frontend

Map page (`/map`) includes **Near Me** button:
- Uses browser geolocation
- Calls `/businesses/nearby` with 10 km radius
- Shows distance badges on business cards

## Testing

```bash
npm run test -w @workgeo/api
```

Unit tests:
- `geo/coordinates.util.spec.ts` — validation & conversions
- `geo/geo.service.spec.ts` — service logic (mocked Prisma)

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `503 PostGIS is not enabled` | Install PostGIS, run migration |
| Migration fails on `CREATE EXTENSION` | PostGIS not installed on PostgreSQL server |
| Empty nearby results | Check businesses have valid lat/lng; increase radius |
| Distance seems wrong | Confirm WGS84 coords; PostGIS uses geodesic distance on geography type |
