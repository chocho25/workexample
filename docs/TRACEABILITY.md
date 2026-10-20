# WorkGeo Traceability Matrix

Maps v1.0 requirements to implementation.

| Requirement | Module | API | DB Entity | UI Route | Tests |
|-------------|--------|-----|-----------|----------|-------|
| Browse businesses | businesses | GET /businesses | Business | /search | ✓ |
| Search businesses | businesses | GET /businesses?search= | Business | /search | ✓ |
| Filter category/state/city | businesses | GET /businesses?filters | Business | /search | ✓ |
| Business details | businesses | GET /businesses/:id | Business | /business/[id] | ✓ |
| Business location/map | businesses | GET /businesses | Business | /map | ✓ |
| Business hours | business-hours | GET/PUT .../hours | BusinessHour | /business/[id] | ✓ |
| Register | auth | POST /auth/register | User | /register | ✓ |
| Login | auth | POST /auth/login | User | /login | ✓ |
| Create business | businesses | POST /businesses | Business | /dashboard/businesses/new | ✓ |
| Edit own business | businesses | PATCH /businesses/:id | Business | /dashboard/.../edit | ✓ |
| Delete own business | businesses | DELETE /businesses/:id | Business | /dashboard | ✓ |
| Dashboard | — | GET /businesses/mine | Business | /dashboard | ✓ |
| Home page | home | GET /home | Multiple | / | ✓ |
| Admin users | admin | GET/PATCH /admin/users | User | /admin/users | ✓ |
| Admin businesses | admin | PATCH .../status | Business | /admin/businesses | ✓ |
| Admin categories | admin | CRUD /admin/categories | Category | /admin/categories | ✓ |
| Admin states/cities | admin | CRUD /admin/states,cities | State, City | /admin/states, /admin/cities | ✓ |
| Image upload | business-images | POST .../images | BusinessImage | dashboard | ✓ |
| Health check | health | GET /health | — | — | ✓ |

## Security controls traceability

| Control | Implementation | Test |
|---------|---------------|------|
| Password hashing | Argon2id in auth service | unit |
| JWT auth | JwtAuthGuard | e2e |
| Role authorization | RolesGuard | e2e |
| Ownership check | BusinessOwnerGuard | e2e |
| Rate limiting | ThrottlerGuard on auth | e2e |
| Input validation | ValidationPipe + DTOs | unit |
| File upload validation | Multer + magic bytes | e2e |
| Security headers | Helmet middleware | manual |
