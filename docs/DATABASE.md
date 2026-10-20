# WorkGeo Database Schema

## Entity relationship

```text
State 1 ── N City 1 ── N Business
User 1 ── N Business
Category 1 ── N Business
Business 1 ── N BusinessImage
Business 1 ── N BusinessHour
```

## Enums

### Role
- `USER`
- `ADMIN`

### BusinessStatus
- `PENDING` — awaiting admin approval (default on create)
- `ACTIVE` — publicly visible
- `REJECTED` — rejected by admin
- `SUSPENDED` — temporarily hidden

### DayOfWeek
- `MONDAY` … `SUNDAY`

## Tables

### User
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| name | String | Display name |
| email | String | Unique |
| passwordHash | String | Never exposed in API |
| role | Role | Default USER |
| isActive | Boolean | Account status |
| createdAt | DateTime | |
| updatedAt | DateTime | |

### State
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| name | String | Unique |
| slug | String | Unique, optional URL segment |
| createdAt | DateTime | |
| updatedAt | DateTime | |

### City
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| name | String | Unique within state |
| slug | String | |
| stateId | UUID | FK → State |
| createdAt | DateTime | |
| updatedAt | DateTime | |

Unique constraint: `(stateId, name)`

### Category
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| name | String | Unique |
| slug | String | Unique |
| description | String? | |
| isActive | Boolean | Default true |
| createdAt | DateTime | |
| updatedAt | DateTime | |

### Business
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| ownerId | UUID | FK → User |
| categoryId | UUID | FK → Category |
| cityId | UUID | FK → City |
| name | String | |
| slug | String | Unique |
| description | String? | |
| address | String | |
| phone | String? | |
| website | String? | |
| latitude | Decimal(10,7) | |
| longitude | Decimal(10,7) | |
| status | BusinessStatus | Default PENDING |
| createdAt | DateTime | |
| updatedAt | DateTime | |

Indexes: `status`, `categoryId`, `cityId`, `ownerId`, `name`, `averageRating`.

### PostGIS (v2.0 Phase 1)

| Column | Type | Notes |
|--------|------|-------|
| location | geography(POINT, 4326) | Synced from lat/lng via DB trigger; GIST index |

Prisma schema retains `latitude`/`longitude` only. `location` is managed by migration + trigger. See `docs/POSTGIS.md`.

### BusinessImage
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| businessId | UUID | FK → Business |
| url | String | Storage path/URL |
| altText | String? | |
| sortOrder | Int | Default 0 |
| isCover | Boolean | Default false |
| createdAt | DateTime | |

### BusinessHour
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| businessId | UUID | FK → Business |
| dayOfWeek | DayOfWeek | |
| isClosed | Boolean | Default false |
| openTime | String? | HH:mm format |
| closeTime | String? | HH:mm format |

Unique constraint: `(businessId, dayOfWeek)`

## Cascade behavior

- Delete Business → cascade delete BusinessImage, BusinessHour
- Delete State → restrict if cities exist
- Delete City → restrict if businesses exist

## Seed data

Algeria-focused: states (wilayas), cities (Algiers, Constantine, Oran), categories, sample businesses with hours and placeholder images.
