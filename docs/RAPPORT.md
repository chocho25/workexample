# WorkGeo — Rapport de livraison

**Date :** 9 août 2026  
**Projet :** WorkGeo v1.0 + début v2.0  
**Base de données :** PostgreSQL `workgeo_vi` sur `localhost:5432`

---

## 1. Résumé exécutif

WorkGeo est une plateforme de découverte d'entreprises locales (Algérie). Le monorepo comprend :

| Composant | Technologie | Port |
|-----------|-------------|------|
| Backend API | NestJS + Prisma | 3001 |
| Frontend Web | Next.js 15 + Tailwind | 3000 |
| Base de données | PostgreSQL 16 | 5432 |

**État actuel :** v1.0 fonctionnel + fonctionnalités v2.0 de base (avis, favoris, analytics, vérification).

---

## 2. Configuration `.env` (corrigée)

### Racine — `.env`
Contient toutes les variables partagées, y compris `DATABASE_URL` et `NEXT_PUBLIC_API_URL`.

### Backend — `apps/api/.env`
```env
DATABASE_URL="postgresql://postgres:chouchou2027@localhost:5432/workgeo_vi?schema=public"
API_PORT=3001
JWT_SECRET=workgeo-dev-jwt-secret-change-in-production-32chars
JWT_EXPIRES_IN=15m
CORS_ORIGIN=http://localhost:3000
UPLOAD_DIR=./uploads
NODE_ENV=development
```

### Frontend — `apps/web/.env.local`
```env
NEXT_PUBLIC_API_URL=http://localhost:3001/api/v1
```

> **Important :** Prisma lit `apps/api/.env`. Next.js lit `apps/web/.env.local`. Les deux fichiers sont dans `.gitignore` (secrets non commités).

---

## 3. Base de données

### Connexion
```
postgresql://postgres:chouchou2027@localhost:5432/workgeo_vi?schema=public
```

### Migrations appliquées
| Migration | Contenu |
|-----------|---------|
| `20260809000000_init` | 7 modèles v1.0 (User, State, City, Category, Business, BusinessImage, BusinessHour) |
| `20260809120000_v2` | Review, Favorite, AnalyticsEvent + champs isVerified, averageRating, reviewCount |

### Seed (données de test)
| Rôle | Email | Mot de passe |
|------|-------|--------------|
| Admin | admin@workgeo.local | Admin123!@# |
| Utilisateur | user@workgeo.local | User123!@# |

**Données incluses :** 4 wilayas, 5 villes, 6 catégories, 6 entreprises, horaires, images placeholder, avis approuvés sur « Le Gourmet » (vérifié).

---

## 4. WorkGeo v1.0 — Fonctionnalités livrées

### Public (visiteur)
- Page d'accueil avec catégories, villes, entreprises featured
- Recherche texte + filtres (catégorie, wilaya, ville)
- Tri : pertinence, nom, date, **note** (v2)
- Carte interactive (Leaflet + OpenStreetMap)
- Fiche entreprise : contact, horaires, carte, appel

### Authentification
- Inscription / Connexion (JWT 15 min, Argon2id)
- Rôles : `USER`, `ADMIN`

### Propriétaire (dashboard)
- Tableau de bord avec statistiques
- CRUD entreprises (statut PENDING → approbation admin)
- Liste `/dashboard/businesses`

### Admin
- Gestion utilisateurs, entreprises, catégories, wilayas, villes
- Modération statut entreprise (PENDING / ACTIVE / REJECTED / SUSPENDED)
- **Vérification badge** (v2)

### Sécurité
- Guards JWT + rôles + propriété objet
- Rate limiting (auth, avis)
- Helmet, CORS, validation DTO
- Pas de mots de passe en clair

---

## 5. WorkGeo v2.0 — Fonctionnalités livrées

| Fonctionnalité | Backend | Frontend | Statut |
|----------------|---------|----------|--------|
| **Avis & notes** | POST/GET reviews, modération admin | Section avis sur fiche entreprise | ✅ |
| **Favoris** | CRUD favorites | Bouton Save + page `/favorites` | ✅ |
| **Analytics** | Tracking événements + dashboard owner | Stats sur dashboard | ✅ |
| **Badge vérifié** | `isVerified` + admin verify | Badge sur fiche entreprise | ✅ |
| **Tri par note** | `sort=rating_desc` | Dropdown recherche | ✅ |
| **Modération avis** | Admin approve/reject | Page `/admin/reviews` | ✅ |

### Endpoints v2.0 ajoutés
```
GET    /api/v1/businesses/:id/reviews
POST   /api/v1/businesses/:id/reviews
PATCH  /api/v1/reviews/:id
DELETE /api/v1/reviews/:id
GET    /api/v1/favorites
POST   /api/v1/favorites/:businessId
DELETE /api/v1/favorites/:businessId
POST   /api/v1/analytics/businesses/:id/track
GET    /api/v1/analytics/dashboard
PATCH  /api/v1/admin/businesses/:id/verify
GET    /api/v1/admin/reviews
PATCH  /api/v1/admin/reviews/:id/status
```

### v2.0 — Non implémenté (roadmap)
- PostGIS / recherche par rayon
- « Open now »
- Notifications, PWA
- Multilingue (AR/FR/EN)
- SEO, stockage cloud images

---

## 6. Structure du projet

```
work-geo-vibe/
├── apps/
│   ├── api/          NestJS (modules: auth, businesses, reviews, favorites, analytics, admin…)
│   └── web/          Next.js (19 routes)
├── docs/             Documentation architecture, API, sécurité, checklist
├── infra/            docker-compose.yml (PostgreSQL)
├── scripts/          setup.sh, setup.ps1
├── .env                Config racine
├── apps/api/.env       Config backend
└── apps/web/.env.local Config frontend
```

---

## 7. Qualité & tests

| Vérification | Résultat |
|--------------|----------|
| Build API | ✅ Succès |
| Build Web | ✅ Succès (19 pages) |
| Tests unitaires | ✅ 9/9 passés |
| Migrations DB | ✅ 2 migrations appliquées |
| Seed | ✅ Exécuté avec succès |

---

## 8. Démarrage rapide

```powershell
# 1. Vérifier PostgreSQL (workgeo_vi doit exister)
# 2. Depuis la racine du projet :
npm install
npm run db:migrate    # si pas déjà fait
npm run db:seed       # si pas déjà fait
npm run dev           # Lance API (3001) + Web (3000)
```

**URLs :**
- Web : http://localhost:3000
- API : http://localhost:3001
- Swagger : http://localhost:3001/api/docs

---

## 9. Prochaines étapes recommandées

1. **Production :** Changer `JWT_SECRET`, activer HTTPS, protéger Swagger
2. **v2.0 suite :** Notifications, recherche « Open now », i18n
3. **Tests E2E :** Lancer `npm run test:e2e -w @workgeo/api` (nécessite PostgreSQL)
4. **Images :** Remplacer placeholders par uploads réels ou stockage cloud

---

## 10. Décisions techniques clés

| Décision | Choix |
|----------|-------|
| Monorepo | npm workspaces |
| Auth | JWT bearer (15 min), pas de refresh token v1 |
| Maps | Leaflet + OSM (pas de clé API) |
| Images | Filesystem local `uploads/` |
| Avis | Modération admin avant publication |
| Analytics | Événements agrégés par type (pas de PII dans les logs) |

---

*Rapport généré après validation build + migrations + seed sur la base `workgeo_vi`.*
