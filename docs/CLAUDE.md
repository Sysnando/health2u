# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Health2U (My Health Hub)** is an Android native health management application built with Kotlin and Jetpack Compose. The app follows Clean Architecture + MVVM pattern with strict security and privacy requirements.

**Target Platform:** Android 13+ (API Level 33+)
**Design Source:** Stitch Project (ID: 4316282056652774057)

## Architecture

### Three-Layer Clean Architecture

1. **Presentation Layer** (`presentation/`)
   - Jetpack Compose UI with Material Design 3
   - ViewModels using Kotlin Coroutines and StateFlow/SharedFlow
   - Navigation via Compose Navigation
   - Each feature module contains: `Screen.kt`, `ViewModel.kt`, `State.kt`

2. **Domain Layer** (`domain/`)
   - Pure Kotlin business logic
   - Use Cases (single responsibility per use case)
   - Domain models
   - Repository interfaces (no implementations)

3. **Data Layer** (`data/`)
   - Repository implementations
   - Data sources: `local/` (Room + DataStore) and `remote/` (Retrofit)
   - DTOs and Entities with Mappers
   - Offline-first approach with sync strategy

### Dependency Injection

- **Hilt** is used throughout for DI
- Modules in `di/`: `AppModule`, `NetworkModule`, `DatabaseModule`, `RepositoryModule`
- ViewModels injected with `@HiltViewModel`
- All repositories, use cases, and data sources constructor-inject dependencies

## Key Technologies

- **UI:** Jetpack Compose + Material3
- **Async:** Kotlin Coroutines + Flow
- **DI:** Hilt
- **Database:** Room + EncryptedSharedPreferences + DataStore
- **Network:** Retrofit + OkHttp with certificate pinning
- **Security:** Android Keystore, Biometric Auth, SQLCipher
- **Image:** Coil, CameraX
- **Testing:** JUnit, MockK, Turbine, Compose Test

## Feature Modules

All features follow the same structure:

```
presentation/<feature>/
  ├── <Feature>Screen.kt       # Composable UI
  ├── <Feature>ViewModel.kt    # State management
  ├── <Feature>State.kt        # UI state data class
  └── components/              # Feature-specific composables

domain/usecase/<feature>/
  └── <Action>UseCase.kt       # Single business action

data/repository/<feature>/
  ├── <Feature>Repository.kt   # Interface (in domain/)
  └── <Feature>RepositoryImpl.kt
```

### Main Features

- **Auth:** `welcome/`, `login/`, `onboarding/` (3-screen horizontal pager)
- **Core:** `dashboard/`, `exams/`, `insights/`, `upload/` (OCR + AI), `appointments/`
- **User:** `profile/`, `emergency/`, `settings/`

Each screen has a corresponding Stitch design ID (see `IMPLEMENTATION_PLAN.md` Appendix A).

## Design System

Located in `ui/theme/`:
- `Color.kt` - Material3 color scheme extracted from Stitch Design System
- `Type.kt` - Typography scale
- `Dimensions.kt` - Spacing, corner radii, elevation
- `Theme.kt` - Material3 theme composition

Reusable components in `ui/components/`:
- `buttons/` - Primary, secondary, text buttons
- `cards/` - Health record, exam, appointment cards
- `inputs/` - Text fields with validation
- `dialogs/` - Modals, bottom sheets

## Testing Requirements

**Target: 80%+ code coverage**

### Unit Tests (`test/`)
- ViewModels: Test state emissions with `Turbine`
- Use Cases: Mock repositories with `MockK`
- Repositories: Mock data sources
- Utilities: Standard JUnit tests
- Use `runTest` for coroutines

### Instrumentation Tests (`androidTest/`)
- Room DAOs with in-memory database
- Compose UI with `createComposeRule()`
- Navigation flows
- End-to-end user flows

### Test Naming Convention
```kotlin
fun `methodName with condition should expected behavior`()
```

Example:
```kotlin
@Test
fun `login with valid credentials should emit success state`() = runTest { ... }
```

## Security Guidelines

**CRITICAL:** This is a health data app subject to HIPAA/GDPR requirements.

### Mandatory Security Practices

1. **Data at Rest:**
   - Use `EncryptedSharedPreferences` for tokens/keys
   - Encrypt Room DB with SQLCipher
   - Store files in encrypted internal storage

2. **Data in Transit:**
   - Enforce TLS 1.3 via `network_security_config.xml`
   - Implement certificate pinning in `NetworkModule`
   - Never allow cleartext traffic

3. **Authentication:**
   - Store tokens in Android Keystore
   - Implement biometric + PIN fallback
   - Session timeout after inactivity
   - Rate limit failed auth attempts

4. **Input Validation:**
   - Sanitize ALL user inputs before use
   - Validate on both client and server
   - Use parameterized queries (Room handles this)

5. **Code Obfuscation:**
   - ProGuard/R8 enabled in release builds
   - Strip all logging in production
   - No API keys or secrets in code (use BuildConfig)

## Database Schema

Room entities in `data/local/entity/`:
- `UserEntity` - User profile
- `ExamEntity` - Medical exam records
- `AppointmentEntity` - Calendar appointments
- `EmergencyContactEntity` - Emergency contacts
- `HealthInsightEntity` - AI-generated insights

All entities have `@Entity` with `tableName` and use `String` IDs from backend.

### Database Migrations

Always provide migration paths:
```kotlin
val MIGRATION_1_2 = object : Migration(1, 2) {
    override fun migrate(database: SupportSQLiteDatabase) { ... }
}
```

## API Integration

Interface: `data/remote/api/HealthApiService.kt`
- All endpoints return `Response<T>` for error handling
- Use `@Multipart` for file uploads
- Retrofit instance configured in `NetworkModule` with:
  - Auth token interceptor
  - Logging (debug only)
  - Certificate pinning
  - Timeout configuration

### Offline Support

Repositories implement cache-first strategy:
1. Try local data source first
2. If stale or missing, fetch from remote
3. Update local cache
4. Queue write operations when offline
5. Sync when connectivity restored

## Stitch Design Asset Retrieval

**DO NOT implement yet** - only when explicitly requested.

To download design assets from Stitch:
1. Install `@google/stitch-sdk` via npm
2. Set `STITCH_API_KEY` environment variable
3. Use project ID: `4316282056652774057`
4. Screen IDs are listed in `IMPLEMENTATION_PLAN.md` Appendix A

## Build Variants

Three environments with flavor dimensions:
- **dev** - `dev-api.health2u.com` (local development)
- **staging** - `staging-api.health2u.com` (QA testing)
- **prod** - `api.health2u.com` (production)

### Development Commands

Since this is a greenfield Android project (not yet initialized):

**When project is initialized:**
```bash
# Build
./gradlew assembleDevDebug
./gradlew assembleProdRelease

# Run tests
./gradlew test              # Unit tests
./gradlew connectedAndroidTest  # Instrumentation tests

# Single test class
./gradlew test --tests com.health2u.domain.usecase.auth.LoginUseCaseTest

# Code coverage
./gradlew testDevDebugUnitTestCoverage
./gradlew createDevDebugCoverageReport

# Lint
./gradlew lintDevDebug

# Clean
./gradlew clean
```

## Compose Best Practices

1. **State Management:**
   - ViewModel exposes `StateFlow<UiState>` for screen state
   - Use `collectAsStateWithLifecycle()` in composables
   - Hoist state; keep composables stateless when possible

2. **Performance:**
   - Use `remember` for expensive calculations
   - Use `LazyColumn/LazyRow` for lists (never `Column` with many items)
   - Provide stable keys for list items: `key = { item.id }`
   - Avoid lambda recreation: extract to `remember { }`

3. **Navigation:**
   - Define routes in `navigation/Screen.kt` sealed class
   - NavGraph in `navigation/NavGraph.kt`
   - Pass IDs, not complex objects, between screens

4. **Accessibility:**
   - All interactive elements need `contentDescription`
   - Minimum touch target: 48dp
   - Support font scaling

## Development Phases

Refer to `IMPLEMENTATION_PLAN.md` Section 6 for the 10-phase development plan (12 weeks).

**Current Phase:** Planning/Design Asset Retrieval
**Next Phase:** Project Setup & Design System Implementation

## Important Notes

- This project is **NOT YET INITIALIZED** - only planning documents exist
- When creating code, strictly follow the architecture patterns described
- Always write tests alongside feature code (TDD encouraged)
- Never commit secrets, API keys, or credentials
- All new features require security review
- Follow Kotlin coding conventions and Android best practices
- Prioritize user privacy and data security in all decisions
