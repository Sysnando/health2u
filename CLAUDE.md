# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Health2U** is a health management platform (monorepo) with a Deno/Hono backend on Supabase Edge Functions, native Android (Kotlin/Compose) and iOS (Swift/SwiftUI) apps, and a static marketing portal. Health data app — treat security and privacy as critical (HIPAA/GDPR context).

## Build & Development Commands

### admin-service (Deno + Supabase Edge Functions)
```bash
cd admin-service
supabase start                                          # Start local Postgres (requires Docker)
supabase functions serve admin --env-file .env --no-verify-jwt  # Serve functions locally
./scripts/deploy.sh                                     # Deploy (db push + secrets + functions)
```

### app-android (Kotlin + Jetpack Compose)
```bash
cd app-android
./gradlew assembleDevDebug                              # Debug build
./gradlew assembleProdRelease                           # Release build
./gradlew test                                          # All unit tests
./gradlew test --tests com.health2u.domain.usecase.auth.LoginUseCaseTest  # Single test
./gradlew connectedAndroidTest                          # Instrumentation tests
./gradlew testDevDebugUnitTestCoverage                  # Coverage report
./gradlew lintDevDebug                                  # Lint
```

### app-ios (Swift + SwiftUI)
```bash
cd app-ios
swift build                                             # CLI build
xcodegen generate                                       # Generate .xcodeproj from project.yml
xcodebuild -project Health2u.xcodeproj -scheme Health2u \
  -destination 'platform=iOS Simulator,name=iPhone 15' build
xcodebuild test -project Health2u.xcodeproj -scheme Health2u \
  -destination 'platform=iOS Simulator,name=iPhone 15'  # Run tests
```

### portal (Static HTML + Tailwind CDN)
```bash
cd portal
python3 -m http.server 8080                             # Local preview
./scripts/deploy.sh                                     # Deploy to Cloudflare Pages
```

## Architecture

### Monorepo Structure (no workspace manager — each service is independent)
- `admin-service/` — Deno/Hono backend on Supabase Edge Functions, Postgres DB, Cloudflare R2 for file storage
- `app-android/` — Kotlin + Jetpack Compose, Hilt DI, Room DB, Retrofit
- `app-ios/` — Swift 5.10 + SwiftUI, manual DI (AppContainer), SwiftData, URLSession
- `portal/` — Static HTML, Tailwind CDN, Cloudflare Pages, i18n (en/es/pt/pt-BR/fr)
- `docs/` — Detailed architecture docs (CONTRACTS.md, IMPLEMENTATION_PLAN.md, etc.)
- `design-assets/` — Stitch design system downloads

### Three-Layer Clean Architecture (Android & iOS mirror each other)
```
presentation/  →  Domain models, ViewModels, UI screens
domain/        →  Use cases (single responsibility), repository interfaces, models
data/          →  Repository implementations, local (Room/SwiftData), remote (Retrofit/URLSession), mappers
```

### Backend (admin-service/supabase/)
- Entry point: `functions/admin/index.ts` (Hono app)
- Routes: `functions/admin/routes/` — auth, user, exams, appointments, insights, contacts
- Shared: `functions/admin/_shared/` — db client, JWT middleware, R2 helpers, error handling
- Migrations: `migrations/` — SQL schema + seed data
- Custom JWT auth (not Supabase Auth) — 1hr access tokens, one-time-use refresh tokens

### Key Patterns
- **Offline-first mobile**: API call → cache in Room/SwiftData on success → Flow/AsyncStream observers read from local DB → return cached data on network error
- **File uploads (2-step)**: POST `/exams/upload-url` → get presigned R2 PUT URL → upload directly to R2 → POST `/exams` with metadata
- **API field naming**: snake_case on wire, mappers convert to camelCase domain models
- **Android DI modules** in `di/`: AppModule, NetworkModule, DatabaseModule, RepositoryModule
- **iOS DI**: Manual AppContainer factory pattern

### Android Feature Module Convention
```
presentation/<feature>/<Feature>Screen.kt, <Feature>ViewModel.kt, <Feature>State.kt
domain/usecase/<feature>/<Action>UseCase.kt
domain/repository/<Feature>Repository.kt  (interface)
data/repository/<Feature>RepositoryImpl.kt
```

## Testing

- **Android**: JUnit + MockK + Turbine (Flow testing) + Compose Test. Target 80%+ coverage.
- **iOS**: XCTest. Structure mirrors Android.
- **Test naming**: `` `methodName with condition should expected behavior`() ``
- **Coroutine tests**: Use `runTest`

## Design System

- Stitch Project ID: `4316282056652774057`
- Theme files: `ui/theme/` (Color, Type, Dimensions, Theme) in both Android and iOS
- Reusable components: `ui/components/` — buttons, cards, inputs, dialogs
- All components use theme colors — no hardcoded hex values
- 8dp spacing grid, 48dp minimum touch targets

## API Endpoints (admin-service)

```
POST /auth/login|refresh|logout
GET|PUT /user/profile
GET /exams, GET /exams/:id, GET /exams/:id/file, POST /exams/upload-url, POST /exams, DELETE /exams/:id
GET|POST /appointments, PUT|DELETE /appointments/:id
GET /insights
GET|POST /emergency-contacts, PUT|DELETE /emergency-contacts/:id
GET /health
```

## Default Dev Credentials
- Email: `sarah@example.com` / Password: `password123`
- Android emulator backend: `http://10.0.2.2:3000`

## Key Documentation
- `docs/CONTRACTS.md` — Phase 1 integration contracts (exact API, DI, navigation conventions)
- `docs/IMPLEMENTATION_PLAN.md` — 10-phase development roadmap with Stitch screen IDs
- `docs/IOS_IMPLEMENTATION_PLAN.md` — iOS-specific implementation plan
- `docs/DATA_LAYER_ARCHITECTURE.md` — Entity → Domain → DTO mapping flow
