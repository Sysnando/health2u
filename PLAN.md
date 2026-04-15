# Plan: Restructure into Monorepo + Node.js Backend

## Context

Health2U currently contains a complete Android app at the repo root (Gradle project + `app/` module). The Android app makes HTTP calls to `https://dev-api.health2u.com/` (see `app/src/main/java/com/health2u/data/remote/api/HealthApiService.kt`) but that backend doesn't exist, causing the SSL/network errors the user saw.

The user wants to:
1. **Restructure the repo as a monorepo** with three top-level packages: `admin-service/` (Node.js backend), `app-android/` (existing Android app moved here), `app-ios/` (empty, deferred).
2. **Implement the Node.js backend** (`admin-service/`) with all endpoints the Android app needs.
3. Leave `app-ios/` empty (no implementation yet).

The Android app already has a working `ErrorMapper` (`app/src/main/java/com/health2u/util/ErrorMapper.kt`) and offline-first repositories, so once the backend is reachable the errors disappear.

---

## Target Directory Layout

```
health2u/
├── admin-service/              # NEW — Node.js backend
│   ├── package.json
│   ├── .env.example
│   ├── README.md
│   └── src/
│       ├── server.js           # Entry point (Express)
│       ├── config.js           # PORT, JWT_SECRET, etc.
│       ├── db.js               # In-memory store (Map-based) with seed data
│       ├── middleware/
│       │   ├── auth.js         # JWT verification middleware
│       │   └── errorHandler.js # Centralized error handler
│       ├── routes/
│       │   ├── auth.js         # POST /auth/login, /refresh, /logout
│       │   ├── user.js         # GET/PUT /user/profile
│       │   ├── exams.js        # CRUD + /exams/upload (multer)
│       │   ├── appointments.js # CRUD /appointments
│       │   ├── insights.js     # GET /insights
│       │   └── emergencyContacts.js  # CRUD /emergency-contacts
│       └── data/
│           └── seed.js         # Sample users, exams, appointments, insights
├── app-android/                # MOVED from repo root
│   ├── app/                    # Gradle module (unchanged contents)
│   ├── build.gradle.kts
│   ├── settings.gradle.kts
│   ├── gradle.properties
│   ├── gradle/
│   ├── gradlew, gradlew.bat
│   └── local.properties
├── app-ios/                    # NEW, empty except README
│   └── README.md               # "iOS app — not yet implemented"
├── design-assets/              # Stays at root (shared across platforms)
├── docs/                       # NEW — move existing *.md docs here
│   ├── CLAUDE.md
│   ├── CONTRACTS.md
│   ├── IMPLEMENTATION_PLAN.md
│   ├── DATA_LAYER_ARCHITECTURE.md
│   └── ... (others)
├── .gitignore                  # Updated to cover new subdirs
└── README.md                   # NEW — monorepo overview + quickstart
```

---

## Phase 1: Move Android App to `app-android/`

1. Create `app-android/` directory.
2. Move into it: `app/`, `build.gradle.kts`, `settings.gradle.kts`, `gradle.properties`, `gradle/`, `gradlew`, `gradlew.bat`, `local.properties`, `.idea/` (optional), `build/`, `.gradle/`, `.kotlin/`.
3. Verify build still works: `cd app-android && ./gradlew assembleDebug`.
4. Update Android `NetworkModule.kt` BASE_URL (currently `https://dev-api.health2u.com/`) to point to the local backend:
   - Debug: `http://10.0.2.2:3000/` (Android emulator loopback to host's localhost).
   - Release: keep `https://api.health2u.com/` placeholder.
   - Allow cleartext for debug flavor via `network_security_config.xml` (check if it already permits 10.0.2.2).

Files touched:
- `app-android/app/src/main/java/com/health2u/di/NetworkModule.kt` — BASE_URL per build type.
- `app-android/app/src/main/res/xml/network_security_config.xml` — cleartext for 10.0.2.2 in debug.
- `app-android/app/src/main/AndroidManifest.xml` — ensure `networkSecurityConfig` is referenced.

---

## Phase 2: Create `app-ios/` Placeholder

- `app-ios/README.md` explaining the iOS package is a placeholder; no source yet.

---

## Phase 3: Build `admin-service/` (Node.js Backend)

### 3.1 Setup
- `package.json` with dependencies: `express`, `cors`, `morgan`, `jsonwebtoken`, `bcryptjs`, `multer`, `uuid`, `dotenv`. Dev deps: `nodemon`.
- Scripts: `"dev": "nodemon src/server.js"`, `"start": "node src/server.js"`.
- Node 18+ (ESM or CommonJS — pick CommonJS for simpler tooling, matches Node conventions).
- `.env.example` with `PORT=3000`, `JWT_SECRET=dev-secret-change-me`.

### 3.2 Endpoints (match `HealthApiService.kt` exactly)

All JSON; snake_case field names (matching existing Kotlin `@SerializedName` in DTOs).

**Auth** (`src/routes/auth.js`)
- `POST /auth/login` → `{ access_token, refresh_token, expires_in, user: {...} }`
- `POST /auth/refresh` → new access token
- `POST /auth/logout` → 204

**User** (`src/routes/user.js`, JWT required)
- `GET /user/profile` → `UserProfileDto` shape
- `PUT /user/profile` → updated profile

**Exams** (`src/routes/exams.js`, JWT required)
- `GET /exams?filter=...` → `ExamDto[]`
- `GET /exams/:id` → `ExamDto`
- `POST /exams/upload` (multipart: `file`, `metadata`) → `ExamDto`; save file to `admin-service/uploads/`
- `DELETE /exams/:id` → 204

**Appointments** (`src/routes/appointments.js`, JWT required)
- `GET /appointments` → `AppointmentDto[]`
- `POST /appointments` → `AppointmentDto`
- `PUT /appointments/:id` → `AppointmentDto`
- `DELETE /appointments/:id` → 204

**Insights** (`src/routes/insights.js`, JWT required)
- `GET /insights` → `{ insights: [...] }` (matches `HealthInsightsDto`)

**Emergency Contacts** (`src/routes/emergencyContacts.js`, JWT required)
- `GET /emergency-contacts` → `EmergencyContactDto[]`
- `POST /emergency-contacts` → `EmergencyContactDto`
- `PUT /emergency-contacts/:id` → `EmergencyContactDto`
- `DELETE /emergency-contacts/:id` → 204

### 3.3 Data Model
- In-memory `Map` stores keyed by id, seeded at startup from `src/data/seed.js`.
- Seeded user: `sarah@example.com` / `password123`, plus ~3 exams, 2 appointments, 5 insights (heart_rate, blood_pressure, sleep, glucose, ai_prediction), 2 emergency contacts.
- DTO shapes must match existing Kotlin DTOs in `app-android/app/src/main/java/com/health2u/data/remote/dto/` (verify by reading each DTO's `@SerializedName` fields).

### 3.4 Auth Flow
- `POST /auth/login` checks email/password against seed, signs JWT with 1h expiry, returns refresh token (simple opaque string).
- Middleware `auth.js` reads `Authorization: Bearer <token>`, verifies, attaches `req.user`.
- All non-auth routes require JWT.

### 3.5 Error Handling
- `errorHandler.js` catches thrown errors, returns `{ error: { code, message } }` with appropriate HTTP status.
- 404 for unknown routes.

### 3.6 README
- `admin-service/README.md` documents: install (`npm install`), run (`npm run dev`), endpoints list, default credentials, how Android emulator connects (`http://10.0.2.2:3000/`).

---

## Phase 4: Root-level Housekeeping

- Move project-level docs (`CLAUDE.md`, `CONTRACTS.md`, `IMPLEMENTATION_PLAN.md`, `DATA_LAYER_*.md`, `DESIGN_*.md`, `PHASE_1_COMPLETE.md`, `QUICK_START_DESIGN.md`, `DATA_AGENT_VALIDATION_REPORT.md`) into `docs/`.
- Write new root `README.md` with monorepo overview:
  - Quickstart: start backend, run Android app pointing at it.
  - Link to each package's README.
- Update root `.gitignore` to cover `admin-service/node_modules/`, `admin-service/uploads/`, `app-android/build/`, `app-android/.gradle/`, `app-ios/` artifacts.

---

## Critical Files Reference

**Read before modifying:**
- `app/src/main/java/com/health2u/data/remote/api/HealthApiService.kt` — source of truth for all endpoints.
- `app/src/main/java/com/health2u/data/remote/dto/*.kt` — exact JSON field names (snake_case) the backend must return.
- `app/src/main/java/com/health2u/di/NetworkModule.kt` — BASE_URL currently hardcoded.

**Reuse:**
- Existing `ErrorMapper` in `util/ErrorMapper.kt` already gives friendly messages once the backend is reachable.
- Existing offline-first repositories in `data/repository/` keep Room as cache — no change needed.

---

## Agent Team (5 Agents, Parallel)

### Agent 1: `restructure`
**Owns:** filesystem moves, Android network config.
- Create `app-android/` dir, move into it: `app/`, `build.gradle.kts`, `settings.gradle.kts`, `gradle.properties`, `gradle/`, `gradlew`, `gradlew.bat`, `local.properties`, `.idea/`, `build/`, `.gradle/`, `.kotlin/`.
- Create `app-ios/README.md` placeholder.
- Edit `app-android/app/src/main/java/com/health2u/di/NetworkModule.kt` → `BASE_URL = if (BuildConfig.DEBUG) "http://10.0.2.2:3000/" else "https://api.health2u.com/"`.
- Edit/create `app-android/app/src/main/res/xml/network_security_config.xml` to allow cleartext for `10.0.2.2` + `localhost` in debug.
- Reference `networkSecurityConfig` in `AndroidManifest.xml`.
- Does NOT touch: `admin-service/`, `design-assets/`, docs.
- Validate: `cd app-android && ./gradlew assembleDebug`.

### Agent 2: `backend-scaffold`
**Owns:** `admin-service/package.json`, `.env.example`, `src/server.js`, `src/config.js`, `src/db.js`, `src/middleware/auth.js`, `src/middleware/errorHandler.js`, `src/data/seed.js`.
- Produce the DB contract + Auth middleware contract (below).
- `server.js` mounts routes (delegated to other agents) with `app.use(...)`.
- Does NOT touch: `src/routes/*`, Android files.
- Validate: `npm install && node -e "require('./src/db')" && node -e "require('./src/middleware/auth')"`.

### Agent 3: `backend-auth-user`
**Owns:** `admin-service/src/routes/auth.js`, `admin-service/src/routes/user.js`.
- Consumes DB + auth middleware contracts.
- Implements endpoints per "API Contract" below.
- Does NOT touch: other routes, scaffold files.
- Validate: manual curl after `backend-scaffold` completes.

### Agent 4: `backend-health`
**Owns:** `admin-service/src/routes/exams.js`, `admin-service/src/routes/appointments.js`, `admin-service/src/routes/insights.js`, `admin-service/src/routes/emergencyContacts.js`.
- Uses `multer` for `/exams/upload`, saves to `admin-service/uploads/` (create dir on first use).
- Consumes DB + auth middleware contracts.
- Implements endpoints per "API Contract" below.
- Validate: manual curl after `backend-scaffold` completes.

### Agent 5: `docs`
**Owns:** root `README.md`, `admin-service/README.md`, `docs/` directory (moved *.md files), root `.gitignore`, `app-ios/README.md` content (coordinate with `restructure` — `restructure` creates empty, `docs` fills it).
- Move existing top-level `*.md` (`CLAUDE.md`, `CONTRACTS.md`, `IMPLEMENTATION_PLAN.md`, etc.) into `docs/`.
- Write monorepo overview + quickstart in root `README.md`.
- Update `.gitignore` for `admin-service/node_modules/`, `admin-service/uploads/`, `app-android/build/`.

---

## Contracts (defined by lead, shared by all agents)

### Contract A: DB module (`admin-service/src/db.js`)

```js
module.exports = {
  users: {
    findByEmail(email),            // => user | null
    findById(id),                  // => user | null
    update(id, patch),             // => user
    verifyPassword(user, plain),   // => boolean (bcrypt compare)
  },
  exams: {
    list(userId, filter),          // filter may be null/undefined or "Lab Results" etc.
    getById(id, userId),
    create(userId, { title, type, date, fileUrl, notes }),
    remove(id, userId),            // => boolean
  },
  appointments: {
    list(userId),
    getById(id, userId),
    create(userId, data),
    update(id, userId, patch),
    remove(id, userId),            // => boolean
  },
  insights: {
    list(userId),
  },
  emergencyContacts: {
    list(userId),
    create(userId, data),
    update(id, userId, patch),
    remove(id, userId),
  },
};
```

Users are not exposed in HTTP responses directly — route agents must only return the DTO shape. Password hash (bcryptjs) is stored but never returned.

### Contract B: Auth middleware (`admin-service/src/middleware/auth.js`)

```js
// Usage in server.js: app.use('/user', auth, require('./routes/user'));
// Reads header: Authorization: Bearer <jwt>
// On success: attaches req.user = { id, email } and calls next()
// On failure: responds 401 { error: { code: 'UNAUTHORIZED', message: '...' } }
module.exports = function auth(req, res, next) { ... };
```

JWT payload: `{ sub: userId, email }`, expires in 1h, signed with `process.env.JWT_SECRET`.

### Contract C: server.js mount order (owned by `backend-scaffold`)

```js
app.use('/auth', require('./routes/auth'));               // public
app.use('/user', auth, require('./routes/user'));         // protected
app.use('/exams', auth, require('./routes/exams'));
app.use('/appointments', auth, require('./routes/appointments'));
app.use('/insights', auth, require('./routes/insights'));
app.use('/emergency-contacts', auth, require('./routes/emergencyContacts'));
```

Each route module is a mounted router — it does NOT re-prefix its own routes. E.g. `routes/user.js` defines `router.get('/profile', ...)` (not `/user/profile`).

### Contract D: API JSON shapes (snake_case, matching Kotlin DTOs exactly)

**User profile:**
```json
{ "id": "u1", "email": "sarah@example.com", "name": "Sarah Mitchell",
  "profile_picture_url": null, "date_of_birth": 654307200000, "phone": "+1..." }
```

**Exam:**
```json
{ "id": "...", "user_id": "u1", "title": "...", "type": "Lab Results",
  "date": 1700000000000, "file_url": null, "notes": null,
  "created_at": 1700000000000, "updated_at": 1700000000000 }
```

**Appointment:**
```json
{ "id": "...", "user_id": "u1", "title": "...", "description": null,
  "doctor_name": "Dr. Sarah Jenkins", "location": "...", "date_time": 1700000000000,
  "reminder_minutes": 30, "status": "UPCOMING", "created_at": 1700000000000 }
```

**Insights envelope** (GET /insights):
```json
{ "insights": [ { "id": "...", "user_id": "u1", "type": "heart_rate",
  "title": "...", "description": "...", "metric_value": 72.0,
  "timestamp": 1700000000000, "created_at": 1700000000000 } ] }
```

**Emergency contact:**
```json
{ "id": "...", "user_id": "u1", "name": "...", "relationship": "...",
  "phone": "+1...", "email": null, "is_primary": true, "order": 0 }
```

**Auth responses:**
- `POST /auth/login` body: `{ "email", "password" }` → `{ "access_token", "refresh_token", "user": {UserProfileDto} }` (200).
- `POST /auth/refresh` body: `{ "refresh_token" }` → `{ "access_token", "refresh_token", "user": {...} }` (200).
- `POST /auth/logout` → 204 empty.

**Exams upload:** multipart/form-data with parts `file` (binary) and `metadata` (JSON string of `{ title, type, date, notes? }`). Response: `ExamDto` with `file_url` pointing to `/uploads/<filename>`. Static serving of `/uploads` is owned by `backend-scaffold` in server.js.

**Error envelope (all failures):** `{ "error": { "code": "...", "message": "..." } }` with HTTP status.

### Contract E: Seed data (owned by `backend-scaffold`)
- One user: id `u1`, email `sarah@example.com`, password `password123` (bcrypt hashed), name `Sarah Mitchell`.
- Three exams of varied types.
- Two upcoming appointments.
- Five insights (heart_rate, blood_pressure, sleep, glucose, ai_prediction).
- Two emergency contacts.

---

## Cross-Cutting Concerns

| Concern | Owner |
|---|---|
| JWT signing secret & expiry | `backend-scaffold` (defines), `backend-auth-user` (consumes) |
| `/uploads/` static serving + directory creation | `backend-scaffold` (wires `express.static` in server.js, creates dir on startup) |
| Date field semantics (all epoch ms) | Documented in Contract D — all agents must use `Date.now()` |
| Status string casing for appointments (`UPCOMING`/`COMPLETED`/`CANCELLED`) | `backend-health` seeds + returns exactly these; enforced by seed data from `backend-scaffold` |
| Root `.gitignore` | `docs` |
| Android cleartext policy for emulator | `restructure` |

---

## Verification

1. **Structure**: `ls` at repo root shows `admin-service/`, `app-android/`, `app-ios/`, `design-assets/`, `docs/`, `README.md`.
2. **Backend runs**: `cd admin-service && npm install && npm run dev` starts on port 3000.
3. **Smoke test backend**:
   - `curl -X POST http://localhost:3000/auth/login -H 'content-type: application/json' -d '{"email":"sarah@example.com","password":"password123"}'` → returns token.
   - With token: `curl http://localhost:3000/user/profile -H 'Authorization: Bearer <token>'` → returns profile JSON matching `UserProfileDto` shape.
   - Same pattern for `/exams`, `/appointments`, `/insights`, `/emergency-contacts`.
4. **Android builds**: `cd app-android && ./gradlew assembleDebug` succeeds.
5. **End-to-end**: start backend, run Android app on emulator, log in with seeded credentials, confirm Dashboard shows real data instead of mock defaults, no SSL errors.
6. **iOS placeholder**: `ls app-ios/` shows only `README.md`.
