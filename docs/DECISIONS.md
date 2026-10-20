# WorkGeo — Architecture Decision Log

## ADR-001: Monorepo with npm workspaces

**Date:** 2026-08-09  
**Context:** Need shared TypeScript types potential and unified scripts.  
**Decision:** npm workspaces with `apps/api` and `apps/web`.  
**Why:** Built into npm 7+, no extra tooling, sufficient for two apps.  
**Consequences:** Simpler setup; no Turborepo caching (acceptable for v1.0).

## ADR-002: Modular monolith (NestJS)

**Date:** 2026-08-09  
**Context:** Spec requires modular monolith, not microservices.  
**Decision:** Single NestJS application with domain modules.  
**Why:** Matches spec, easier deployment and testing for MVP.

## ADR-003: REST over GraphQL

**Date:** 2026-08-09  
**Context:** Spec explicitly defers GraphQL.  
**Decision:** Versioned REST API at `/api/v1`.  
**Why:** Simpler contracts, Swagger documentation, spec compliance.

## ADR-004: JWT bearer tokens (no refresh token in v1.0)

**Date:** 2026-08-09  
**Context:** Auth mechanism needed; refresh adds complexity.  
**Decision:** Short-lived JWT access tokens only; re-login on expiry.  
**Why:** Smallest safe option for MVP; refresh can be added in v2.0.  
**Consequences:** Users re-authenticate after 15 minutes.

## ADR-005: Argon2id password hashing

**Date:** 2026-08-09  
**Context:** Spec requires modern password hashing.  
**Decision:** `@node-rs/argon2` for Argon2id.  
**Why:** OWASP recommended, faster native implementation.

## ADR-006: BusinessHour as separate entity

**Date:** 2026-08-09  
**Context:** Weekly schedules are structured domain data.  
**Decision:** One row per day per business in `BusinessHour` table.  
**Why:** Enables schedule display, closed days, future "open now" feature.

## ADR-007: Coordinates without PostGIS (v1.0)

**Date:** 2026-08-09  
**Context:** Map display needs lat/lng only.  
**Decision:** Decimal fields on Business; no PostGIS extension.  
**Why:** Spec defers advanced GIS to v2.0.

## ADR-008: Local filesystem image storage (v1.0)

**Date:** 2026-08-09  
**Context:** Business images need storage.  
**Decision:** Local `uploads/` directory with validated uploads.  
**Why:** Simplest for development; cloud storage planned for v2.0.

## ADR-009: Response envelope `{ data, meta }`

**Date:** 2026-08-09  
**Context:** Consistent API response shape needed.  
**Decision:** Wrap successful responses in `{ data }` with optional `{ meta }` for pagination.  
**Why:** Predictable client parsing, room for metadata.

## ADR-010: Business moderation status

**Date:** 2026-08-09  
**Context:** Admin moderation required.  
**Decision:** Status enum: `PENDING`, `ACTIVE`, `REJECTED`, `SUSPENDED`. New businesses default to `PENDING`; only `ACTIVE` shown publicly.  
**Why:** Enables approval workflow without v2.0 verification features.

## ADR-011: Green/teal brand accent

**Date:** 2026-08-09  
**Context:** UI mockups use forest green primary color.  
**Decision:** Tailwind custom color `--primary: #006837` (WorkGeo green).  
**Why:** Matches provided design reference.

## ADR-012: Leaflet for maps (v1.0)

**Date:** 2026-08-09  
**Context:** Map discovery required; need open-source map library.  
**Decision:** react-leaflet with OpenStreetMap tiles.  
**Why:** No API key required for development; sufficient for marker display.

## ADR-013: PostGIS geography column with lat/lng preservation (v2.0 Phase 1)

**Date:** 2026-08-09  
**Context:** v2.0 requires radius/nearby search; v1.0 uses decimal lat/lng.  
**Decision:** Add `location geography(POINT, 4326)` synced via DB trigger; keep `latitude`/`longitude` in Prisma/API.  
**Why:** Backward-compatible API; geodesic distance on geography type; GIST index for performance.  
**Consequences:** PostGIS required on PostgreSQL server; spatial queries use parameterized raw SQL.
