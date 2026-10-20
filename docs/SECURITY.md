# WorkGeo Security Baseline

## Standards referenced

- OWASP Top 10:2025
- OWASP API Security Top 10:2023
- OWASP ASVS (Level 2 target for v1.0)

## Control mapping

### Broken Access Control (A01 / API1)
- JWT authentication guard on protected routes
- Role-based `@Roles('ADMIN')` decorator
- Business ownership verification on mutations
- Admin routes isolated under `/admin`
- Public business list filtered to `ACTIVE` status only

### Security Misconfiguration (A02)
- Helmet security headers
- CORS restricted to configured origin
- Swagger disabled in production (or protected)
- No secrets in repository (`.env.example` only)
- `NODE_ENV=production` disables debug output

### Software Supply Chain (A03)
- npm lockfile committed
- `npm audit` in CI
- Minimal dependency footprint

### Cryptographic Failures (A04)
- Argon2id password hashing
- JWT signed with strong secret (min 32 chars)
- HTTPS required in production

### Injection (A05 / API8)
- Prisma parameterized queries only
- class-validator DTO whitelisting
- Search input length limits

### Insecure Design (A06)
- Explicit authorization model documented
- Business moderation workflow
- Rate limiting on auth endpoints

### Authentication Failures (A07 / API2)
- Password policy: min 8 chars, upper, lower, digit, special
- Login rate limit: 5 attempts per minute per IP
- Generic "Invalid credentials" message
- JWT expiration (15m default)

### Resource Consumption (A09 / API4)
- Pagination max 100
- Request body size limit
- Upload max 5MB
- Image dimension limits

### File Upload
- Allowlist: JPEG, PNG, WebP
- Magic byte validation
- Safe filename generation (UUID)
- Storage outside web root

### Logging
- Failed login attempts
- Admin actions
- No passwords or tokens in logs

## Security headers (Helmet)

- Content-Security-Policy (configured per app)
- X-Content-Type-Options: nosniff
- Referrer-Policy: strict-origin-when-cross-origin
- X-Frame-Options: DENY

## Frontend security

- Token stored in memory (React context), not localStorage
- Route guards are UX-only; API enforces authorization
- No secrets in `NEXT_PUBLIC_*`

## Security tests

See `docs/TESTING.md` — security test suite covers IDOR, role escalation, invalid JWT, rate limiting.

## Version record

| Standard | Version used |
|----------|-------------|
| OWASP Top 10 | 2025 |
| OWASP API Top 10 | 2023 |
| Node.js | 24.x |
| NestJS | 11.x |
| Next.js | 15.x |
