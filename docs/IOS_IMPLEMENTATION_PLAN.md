# iOS Implementation Plan

## 1. Overview

Native iOS client for health2u, at feature parity with `app-android`, consuming the same `admin-service` backend and matching the same design system. Clean Architecture + MVVM with an offline-first repository pattern, mirroring the Android implementation layer-for-layer so work can be cross-referenced directly.

Reference sources (authoritative):
- `app-android/app/src/main/java/com/health2u/**` — parallel implementation.
- `admin-service/src/routes/*.js` — backend contract.
- `admin-service/src/data/seed.js` — authoritative field names (snake_case).
- `docs/CONTRACTS.md`, `docs/DATA_LAYER_ARCHITECTURE.md`, `docs/IMPLEMENTATION_PLAN.md`, `docs/DESIGN_SYSTEM_COMPLETE.md`.

Target: iOS 16+. SwiftUI with `NavigationStack`. Swift 5.10+. No Objective-C.

---

## 2. Technology stack

| Concern | Android (reference) | iOS |
|---|---|---|
| Language | Kotlin 2.0 | Swift 5.10+ |
| UI | Jetpack Compose | SwiftUI |
| Nav | Navigation-Compose | `NavigationStack` |
| Async | Coroutines + `Flow` | `async/await` + `AsyncStream` |
| DI | Hilt | Manual `AppContainer` (factory) |
| Local store | Room | SwiftData (fallback: Core Data on <17) |
| Networking | Retrofit + OkHttp + Gson | `URLSession` + `Codable` |
| Images | Coil | `AsyncImage` |
| Secure storage | EncryptedSharedPreferences (planned) | Keychain Services |
| Tests | JUnit + MockK | XCTest |

Project generation: **XcodeGen** (`project.yml`) — declarative, reproducible, no binary `pbxproj` to maintain by hand. Regenerate with `xcodegen generate`.

---

## 3. Project structure

```
app-ios/
├── project.yml                   # XcodeGen spec (generates Health2u.xcodeproj)
├── Package.swift                 # Optional: SPM wrapper for CI builds
├── Health2u/
│   ├── App/
│   │   ├── Health2uApp.swift     # @main
│   │   └── AppContainer.swift    # Manual DI
│   ├── Data/
│   │   ├── Local/                # SwiftData @Model + stores
│   │   ├── Remote/               # APIClient, Endpoints, DTOs
│   │   ├── Repository/           # 5 repo implementations
│   │   └── Mapper/               # Entity ↔ Domain ↔ DTO
│   ├── Domain/
│   │   ├── Model/                # 5 structs
│   │   └── Repository/           # 5 protocols
│   ├── Presentation/
│   │   ├── Welcome/ Login/ Dashboard/ Exams/ Insights/
│   │   ├── Upload/ Appointments/ Profile/ EditProfile/
│   │   ├── EmergencyContacts/ Settings/
│   │   └── Navigation/           # Route enum + root NavigationStack
│   ├── UI/
│   │   ├── Theme/                # Color, Typography, Dimensions
│   │   └── Components/           # Buttons, Cards, Inputs, Empty, Loading
│   ├── Util/
│   │   └── Result+API.swift
│   └── Resources/
│       └── Assets.xcassets
├── Health2uTests/
└── Health2uUITests/
```

Each feature directory contains a triplet: `{Feature}View.swift`, `{Feature}ViewModel.swift`, `{Feature}State.swift`.

---

## 4. Domain models (Swift)

Five value-type structs, `Identifiable`, `Equatable`, `Sendable`. Fields mirror `app-android/.../domain/model/`:

```swift
struct User: Identifiable, Equatable, Sendable {
    let id: String
    let email: String
    let name: String
    let profilePictureUrl: String?
    let dateOfBirth: Date?
    let phone: String?
}

struct Exam: Identifiable, Equatable, Sendable {
    let id, userId, title, type: String
    let date: Date
    let fileUrl: String?
    let notes: String?
    let createdAt, updatedAt: Date
}

struct Appointment: Identifiable, Equatable, Sendable {
    let id, userId, title: String
    let description: String?
    let doctorName: String?
    let location: String?
    let dateTime: Date
    let reminderMinutes: Int?
    let status: AppointmentStatus
    let createdAt: Date
}

enum AppointmentStatus: String, Codable, Sendable {
    case upcoming = "UPCOMING"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
}

struct EmergencyContact: Identifiable, Equatable, Sendable {
    let id, userId, name, relationship, phone: String
    let email: String?
    let isPrimary: Bool
    let order: Int
}

struct HealthInsight: Identifiable, Equatable, Sendable {
    let id, userId, type, title, description: String
    let metricValue: Double?
    let timestamp: Date
    let createdAt: Date
}
```

**⚠️ Critical:** backend uses **epoch millis** (`number`) for dates. Swift `Date` uses seconds. Conversion happens in mappers: `Date(timeIntervalSince1970: millis / 1000)`.

---

## 5. Networking contract (authoritative)

**Base URL:**
- Debug (simulator): `http://localhost:3000/`
- Debug (device on LAN): `http://<dev-host>:3000/`
- Release: `https://api.health2u.com/`

**Auth:** JWT bearer. Obtain via `POST /auth/login`; refresh via `POST /auth/refresh`. Tokens stored in Keychain (`kSecClassGenericPassword`, `.whenUnlockedThisDeviceOnly`).

**Request headers:** `Content-Type: application/json`, `Authorization: Bearer <token>` on all non-auth endpoints.

### 5.1 Endpoints

All request/response bodies use **snake_case** JSON. Decoder: `JSONDecoder` with `keyDecodingStrategy = .convertFromSnakeCase`, `dateDecodingStrategy = .millisecondsSince1970`.

| # | Method | Path | Request body | Response body |
|---|--------|------|--------------|---------------|
| 1 | POST | `/auth/login` | `{"email","password"}` | `{"access_token","refresh_token","user":{UserDTO}}` |
| 2 | POST | `/auth/refresh` | `{"refresh_token"}` | `{"access_token","refresh_token","user":{UserDTO}}` |
| 3 | POST | `/auth/logout` | — | `204` |
| 4 | GET | `/user/profile` | — | `UserDTO` |
| 5 | PUT | `/user/profile` | Partial `UserDTO` | `UserDTO` |
| 6 | GET | `/exams?filter={type}` | — | `[ExamDTO]` |
| 7 | GET | `/exams/:id` | — | `ExamDTO` |
| 8 | POST | `/exams/upload` | multipart: `file`, `metadata` (JSON string) | `ExamDTO` |
| 9 | GET | `/exams/:id/file` | — | `{"url": "..."}` |
| 10 | DELETE | `/exams/:id` | — | `204` |
| 11 | GET | `/appointments` | — | `[AppointmentDTO]` |
| 12 | POST | `/appointments` | `AppointmentDTO` | `AppointmentDTO` |
| 13 | PUT | `/appointments/:id` | Partial `AppointmentDTO` | `AppointmentDTO` |
| 14 | DELETE | `/appointments/:id` | — | `204` |
| 15 | GET | `/insights` | — | `{"insights":[HealthInsightDTO]}` |
| 16 | GET | `/emergency-contacts` | — | `[EmergencyContactDTO]` |
| 17 | POST | `/emergency-contacts` | `EmergencyContactDTO` | `EmergencyContactDTO` |
| 18 | PUT | `/emergency-contacts/:id` | Partial | `EmergencyContactDTO` |
| 19 | DELETE | `/emergency-contacts/:id` | — | `204` |

### 5.2 DTO shapes (Codable)

- `UserDTO`: `id, email, name, profile_picture_url?, date_of_birth?, phone?`
- `ExamDTO`: `id, user_id, title, type, date, file_url?, notes?, created_at, updated_at`
- `AppointmentDTO`: `id, user_id, title, description?, doctor_name?, location?, date_time, reminder_minutes?, status, created_at`
- `EmergencyContactDTO`: `id, user_id, name, relationship, phone, email?, is_primary, order`
- `HealthInsightDTO`: `id, user_id, type, title, description, metric_value?, timestamp, created_at`
- `AuthResponseDTO`: `access_token, refresh_token, user: UserDTO`

### 5.3 Errors

All non-2xx responses decode to:
```swift
struct APIErrorEnvelope: Decodable { let error: APIErrorBody }
struct APIErrorBody: Decodable { let code: String; let message: String }
```
Repositories surface failures as `Result<T, APIError>` where `APIError` is:
```swift
enum APIError: Error {
    case network(URLError)
    case decoding(DecodingError)
    case server(status: Int, code: String, message: String)
    case unauthorized
    case offline
}
```

**401 handling:** `AuthInterceptor` refreshes once via `/auth/refresh`, retries the original request once, logs out on second failure.

---

## 6. Local storage contract

SwiftData `@Model` classes (require iOS 17; for iOS 16 substitute Core Data entities with the same schema). One `@Model` per Android Room entity:

- `UserModel`, `ExamModel`, `AppointmentModel`, `EmergencyContactModel`, `HealthInsightModel`.

Each model has the same fields as the corresponding Android `Entity.kt`. Primary key = `id` (String). Timestamps stored as `Date`.

Single `ModelContainer` owned by `AppContainer`. Background writes on a detached task.

---

## 7. Repository contract

Five protocols in `Domain/Repository/`:

```swift
protocol UserRepository {
    func getProfile() async -> Result<User, APIError>
    func updateProfile(_ user: User) async -> Result<User, APIError>
    func observeProfile() -> AsyncStream<User?>
    func logout() async -> Result<Void, APIError>
}
// + ExamRepository, AppointmentRepository,
//   EmergencyContactRepository, HealthInsightRepository
```

**Offline-first behavior (all `get*` methods):**
1. Call API.
2. On success → persist to SwiftData → return `.success(data)`.
3. On failure → read from SwiftData → return `.success(cached)` if present, else `.failure(err)`.

Observable methods (`observe*`) return `AsyncStream` backed by SwiftData change notifications.

**Multipart upload** (`ExamRepository.uploadExam`): build `multipart/form-data` body with `file` (binary) and `metadata` (JSON-stringified metadata including `title`, `type`, `date`).

---

## 8. Presentation

- **ViewModel pattern**: `@MainActor final class FooViewModel: ObservableObject { @Published var state: FooState }`. Methods invoked from views via `Task { await vm.load() }`.
- **State**: one `struct FooState: Equatable` per screen.
- **Navigation**: single `enum Route: Hashable` covering all destinations, driven by one `NavigationStack` at app root.
- **Screens to build** (parity with Android): Welcome, Login, Dashboard, Exams (+ ExamDetail), Insights, Upload, Appointments (+ AppointmentDetail), Profile, EditProfile, EmergencyContacts, Settings.

### 8.1 Design system

Port `app-android/app/src/main/java/com/health2u/ui/theme/`:

- **Colors** (`Color+Health2u.swift`): Primary `#1976D2`, Secondary `#00897B`, Tertiary `#7B1FA2`, Error `#D32F2F`, plus health-metric extended palette. Register in `Assets.xcassets` with light/dark variants.
- **Typography** (`Typography+Health2u.swift`): Material3 scale → SwiftUI `Font` tokens (displayLarge … labelSmall).
- **Dimensions** (`Dimensions.swift`): 8pt grid — `spaceXS=4, S=8, M=16, L=24, XL=32, XXL=48`. Corner radii `xs=2 … full=999`. Elevations map to `.shadow(...)` presets.

### 8.2 Components

Ten reusable SwiftUI views matching Android component APIs:
`PrimaryButton`, `SecondaryButton`, `TextButton`, `H2UTextField`, `H2UPasswordField`, `HealthSummaryCard`, `ExamCard`, `AppointmentCard`, `LoadingIndicator`, `EmptyState`. Minimum touch target: **44pt** (iOS HIG).

---

## 9. Authentication flow

1. App launches → `AppContainer` reads tokens from Keychain → decides root route (Welcome vs Dashboard).
2. `WelcomeView` → button → `LoginView`.
3. `LoginView` submits → `AuthRepository.login(email, password)` → stores tokens in Keychain + decoded `userId` in a `SessionStore` (actor) → navigates to Dashboard.
4. `AuthInterceptor` attaches `Authorization` header and handles 401 refresh.
5. Logout: clear Keychain + SessionStore + SwiftData, route back to Welcome.

**Seed credentials for dev:** `sarah@example.com` / `password123`.

**Do not port the Android `user_id_placeholder` hack** — iOS reads `userId` from `AuthResponse.user.id` at login and from the SessionStore thereafter.

---

## 10. Dependency injection

Single `AppContainer` class, constructed once in `@main`:

```swift
@MainActor
final class AppContainer {
    let apiClient: APIClient
    let modelContainer: ModelContainer
    let sessionStore: SessionStore
    let userRepository: UserRepository
    let examRepository: ExamRepository
    let appointmentRepository: AppointmentRepository
    let emergencyContactRepository: EmergencyContactRepository
    let healthInsightRepository: HealthInsightRepository

    func makeDashboardViewModel() -> DashboardViewModel { ... }
    // factory methods per ViewModel
}
```

Injected into the view tree via `.environmentObject(container)`.

---

## 11. Testing

Target ≥80% coverage on `Data/` and `Domain/` (parity with Android per `docs/CLAUDE.md`).

- **Repository tests**: stub `APIClient` + in-memory model container, assert offline-first fallback, cache population.
- **ViewModel tests**: drive `@MainActor` inputs, assert published state transitions.
- **Mapper round-trips**: DTO → domain → entity → domain equality.

---

## 12. Phased roadmap

1. Project scaffold (XcodeGen spec, `@main` app, AppContainer stub, theme, components).
2. Domain models + `Result`/`APIError`.
3. Remote layer (APIClient, endpoints, DTOs).
4. Local store (SwiftData models, mappers).
5. Repository implementations (offline-first).
6. Auth flow (Welcome, Login, Keychain, SessionStore, AuthInterceptor).
7. Dashboard + feature screens.
8. Profile / EditProfile / EmergencyContacts / Settings.
9. Polish (errors, empties, skeletons, VoiceOver, Dynamic Type).
10. Hardening (cert pinning, biometric gate via `LAContext`, snapshot tests, TestFlight).

---

## 13. Known gaps / differences from Android

- Android hardcodes `userId = "user_id_placeholder"`. iOS must read real userId from JWT/AuthResponse.
- Dates: Android stores epoch millis; iOS converts to/from `Date` in mappers.
- Simulator base URL is `localhost:3000`, **not** `10.0.2.2`.
- Android has no certificate pinning yet — plan `URLSessionDelegate` pinning before iOS release.

---

## 14. Cross-references

- `docs/CONTRACTS.md` — exact package structure, endpoints, DI bindings.
- `docs/DATA_LAYER_ARCHITECTURE.md` — offline-first diagrams.
- `docs/IMPLEMENTATION_PLAN.md` — full phase-by-phase roadmap.
- `docs/DESIGN_SYSTEM_COMPLETE.md` — theme tokens + component specs.
- `docs/QUICK_START_DESIGN.md` — component usage examples.

---

## 15. Validation

### Build validation
```bash
cd app-ios
xcodegen generate              # produces Health2u.xcodeproj
xcodebuild -project Health2u.xcodeproj \
           -scheme Health2u \
           -destination 'platform=iOS Simulator,name=iPhone 15' \
           build
```

### Backend sanity (before running the app)
```bash
cd admin-service && npm install && npm start   # :3000
curl http://localhost:3000/health              # {"status":"ok"}
curl -X POST http://localhost:3000/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"sarah@example.com","password":"password123"}'
```

### Manual e2e
1. Launch app in simulator → Welcome.
2. Tap Sign In → enter `sarah@example.com` / `password123` → Dashboard renders.
3. Navigate to Exams → list populated from `/exams`.
4. Kill network → relaunch → cached data still shown.
5. Restore network → pull to refresh → fresh data overwrites cache.

### Tests
```bash
xcodebuild test -project Health2u.xcodeproj -scheme Health2u \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```
