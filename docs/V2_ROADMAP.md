# WorkGeo v2.0 Roadmap

Evolve v1.0 through controlled migrations. Do not rewrite v1.0.

## Discovery
- Advanced multi-filter search
- Distance-based discovery ("nearby")
- "Open now" filter
- Sort by rating/popularity/distance

## GIS
- [x] PostGIS extension + geography column
- [x] Spatial GIST index
- [x] Radius / nearby search (`GET /businesses/nearby`)
- [x] Distance sorting (nearest first)
- [ ] Advanced polygon queries

## Trust
- Reviews and ratings
- Verification badge
- Enhanced moderation workflows

## Personalization
- Favorites
- Saved searches
- Notifications

## Business growth
- Analytics dashboard (views, searches, clicks)
- Profile performance metrics

## Media
- Cloud object storage (S3/R2)
- Image optimization pipeline
- Responsive variants

## Internationalization
- Arabic, French, English
- RTL support
- Localized content

## SEO
- Structured data (JSON-LD)
- Sitemap, canonical URLs
- Social previews

## Mobile
- PWA installability
- Push notifications
- Enhanced location UX

## Migration principle

```text
v1.0 stable core → DB migrations → new modules → new endpoints → new UI → security tests
```

Existing v1.0 functionality must remain stable unless a documented breaking change is approved.
