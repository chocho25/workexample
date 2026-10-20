# WorkGeo Deployment

## Development

```bash
docker compose -f infra/docker-compose.yml up -d
cp .env.example .env
npm install
npm run db:migrate
npm run db:seed
npm run dev
```

## Production checklist

- [ ] Set strong `JWT_SECRET` (64+ random chars)
- [ ] Set `NODE_ENV=production`
- [ ] Configure production `DATABASE_URL`
- [ ] Enable HTTPS (reverse proxy: nginx/Caddy)
- [ ] Set restrictive `CORS_ORIGIN`
- [ ] Disable or protect Swagger
- [ ] Configure object storage for uploads (recommended)
- [ ] Set up database backups
- [ ] Configure log aggregation
- [ ] Run `npm audit` and resolve critical issues

## Docker production (future)

Multi-stage builds for API and Web containers. PostgreSQL as managed service.

## Environment variables

| Variable | Required | Description |
|----------|----------|-------------|
| DATABASE_URL | Yes | PostgreSQL connection string |
| JWT_SECRET | Yes | JWT signing secret |
| JWT_EXPIRES_IN | No | Token TTL (default 15m) |
| API_PORT | No | API port (default 3001) |
| CORS_ORIGIN | Yes | Allowed frontend origin |
| NEXT_PUBLIC_API_URL | Yes | API URL for frontend |
| UPLOAD_DIR | No | Image upload directory |
| MAX_UPLOAD_SIZE_MB | No | Max upload size |

## Database migrations

```bash
npm run db:migrate
```

Always run migrations before deploying new API versions.

## Build

```bash
npm run build
npm run start -w @workgeo/api
npm run start -w @workgeo/web
```
