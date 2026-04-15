# admin-service

Node.js + Express backend for Health2U. In-memory data store with seed data for development.

## Prerequisites

- Node 18+

## Setup

```bash
cd admin-service
cp .env.example .env
npm install
npm run dev
```

The server starts on `http://localhost:3000`.

## Endpoints

### Authentication

| Method | Path | Auth | Description |
|---|---|---|---|
| `POST` | `/auth/login` | public | `{ email, password }` returns `{ access_token, refresh_token, user }` |
| `POST` | `/auth/refresh` | public | `{ refresh_token }` returns a new token pair |
| `POST` | `/auth/logout` | public | Returns 204 |

### User

| Method | Path | Auth | Description |
|---|---|---|---|
| `GET` | `/user/profile` | Bearer | Returns user profile |
| `PUT` | `/user/profile` | Bearer | Updates profile |

### Exams

| Method | Path | Auth | Description |
|---|---|---|---|
| `GET` | `/exams?filter=` | Bearer | List exams (optional filter) |
| `GET` | `/exams/:id` | Bearer | Get exam by ID |
| `POST` | `/exams/upload` | Bearer | Upload exam (multipart: `file`, `metadata` JSON) |
| `DELETE` | `/exams/:id` | Bearer | Delete exam |

### Appointments

| Method | Path | Auth | Description |
|---|---|---|---|
| `GET` | `/appointments` | Bearer | List appointments |
| `POST` | `/appointments` | Bearer | Create appointment |
| `PUT` | `/appointments/:id` | Bearer | Update appointment |
| `DELETE` | `/appointments/:id` | Bearer | Delete appointment |

### Insights

| Method | Path | Auth | Description |
|---|---|---|---|
| `GET` | `/insights` | Bearer | Returns `{ insights: [...] }` |

### Emergency Contacts

| Method | Path | Auth | Description |
|---|---|---|---|
| `GET` | `/emergency-contacts` | Bearer | List contacts |
| `POST` | `/emergency-contacts` | Bearer | Create contact |
| `PUT` | `/emergency-contacts/:id` | Bearer | Update contact |
| `DELETE` | `/emergency-contacts/:id` | Bearer | Delete contact |

### Health Check

| Method | Path | Auth | Description |
|---|---|---|---|
| `GET` | `/health` | public | Returns `{ status: "ok" }` |

## Auth

All authenticated endpoints require a Bearer JWT in the `Authorization` header. Obtain a token via `POST /auth/login`.

## Default credentials

- Email: `sarah@example.com`
- Password: `password123` (seeded user)

## Connecting from Android emulator

Use `http://10.0.2.2:3000/` as the base URL. This is configured in `app-android/app/src/main/java/com/health2u/di/NetworkModule.kt` for debug builds.

## Data store

In-memory `Map`s, seeded from `src/data/seed.js` at startup. Data resets on restart.

## Example curl

```bash
TOKEN=$(curl -s -X POST http://localhost:3000/auth/login \
  -H 'content-type: application/json' \
  -d '{"email":"sarah@example.com","password":"password123"}' | jq -r .access_token)

curl http://localhost:3000/user/profile -H "Authorization: Bearer $TOKEN"
```
