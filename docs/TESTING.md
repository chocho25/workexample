# WorkGeo Testing Strategy

## Test layers

### Unit tests (Jest)
- Services: business logic, authorization helpers
- Validation: DTO validation edge cases
- Business hours logic: closed days, time formatting
- Password hashing utilities

Location: `apps/api/src/**/*.spec.ts`

### Integration tests (Jest + Supertest)
- Auth flow: register, login, me
- Business CRUD with ownership
- Search filters
- Admin moderation
- Prisma database operations (test database)

Location: `apps/api/test/**/*.e2e-spec.ts`

### Security tests
Explicit scenarios:
- Unauthenticated access to protected routes → 401
- User A cannot PATCH/DELETE User B's business → 403
- USER cannot access `/admin/*` → 403
- Cannot self-assign ADMIN role via register
- Invalid/expired JWT → 401
- Oversized payload → 413/400
- Invalid coordinates → 400
- Rate limit on login → 429

### Frontend
- TypeScript strict mode (compile-time)
- ESLint
- Manual E2E for v1.0 (Playwright optional future)

## Running tests

```bash
# Unit + integration
npm run test -w @workgeo/api

# With coverage
npm run test:cov -w @workgeo/api

# E2E
npm run test:e2e -w @workgeo/api
```

## CI pipeline

1. Install dependencies
2. Lint
3. Typecheck
4. Unit tests
5. Integration tests (requires PostgreSQL service)
6. Build API + Web
7. npm audit (warn on high/critical)

## Test database

Integration tests use a separate database or transaction rollback strategy.
Environment variable: `DATABASE_URL` pointing to test instance.
