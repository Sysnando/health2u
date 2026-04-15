# Data Layer Architecture

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                        │
│                    (Foundation Agent - Future)                   │
│                                                                   │
│  ViewModels inject Repository Interfaces via Hilt               │
└─────────────────────────────────────────────────────────────────┘
                              ▲
                              │ Uses
                              │
┌─────────────────────────────────────────────────────────────────┐
│                         DOMAIN LAYER                             │
│                       (Data Agent - DONE)                        │
│                                                                   │
│  ┌──────────────────────┐      ┌───────────────────────┐       │
│  │  Domain Models       │      │ Repository Interfaces │       │
│  │  - User              │      │ - UserRepository      │       │
│  │  - Exam              │      │ - ExamRepository      │       │
│  │  - Appointment       │      │ - AppointmentRepo     │       │
│  │  - EmergencyContact  │      │ - EmergencyContactRepo│       │
│  │  - HealthInsight     │      │ - HealthInsightRepo   │       │
│  └──────────────────────┘      └───────────────────────┘       │
│                                          ▲                        │
│                                          │ Implements            │
└──────────────────────────────────────────┼──────────────────────┘
                                           │
┌──────────────────────────────────────────┼──────────────────────┐
│                          DATA LAYER                              │
│                       (Data Agent - DONE)                        │
│                                          │                        │
│  ┌───────────────────────────────────────┴─────────────────┐   │
│  │           Repository Implementations                      │   │
│  │  - UserRepositoryImpl                                    │   │
│  │  - ExamRepositoryImpl                                    │   │
│  │  - AppointmentRepositoryImpl                             │   │
│  │  - EmergencyContactRepositoryImpl                        │   │
│  │  - HealthInsightRepositoryImpl                           │   │
│  │                                                           │   │
│  │  Offline-First Strategy:                                 │   │
│  │  1. Try API call                                         │   │
│  │  2. On success: Cache in Room → Return data             │   │
│  │  3. On error: Return cached data if available           │   │
│  │  4. Flow observers always read from Room                │   │
│  └───────────────────────────────────────────────────────────┘   │
│               ▲                              ▲                    │
│               │                              │                    │
│      Uses     │                              │ Uses               │
│               │                              │                    │
│  ┌────────────┴─────────────┐  ┌───────────┴──────────────┐    │
│  │  Local Data Source       │  │  Remote Data Source      │    │
│  │  (Room Database)         │  │  (Retrofit API)          │    │
│  │                          │  │                          │    │
│  │  ┌───────────────────┐  │  │  ┌───────────────────┐  │    │
│  │  │ HealthDatabase    │  │  │  │ HealthApiService  │  │    │
│  │  │ - Version 1       │  │  │  │ - Auth endpoints  │  │    │
│  │  │ - 5 entities      │  │  │  │ - User endpoints  │  │    │
│  │  │ - Encryption      │  │  │  │ - Exam endpoints  │  │    │
│  │  │   ready           │  │  │  │ - Appointment     │  │    │
│  │  └───────────────────┘  │  │  │   endpoints       │  │    │
│  │                          │  │  │ - Insight         │  │    │
│  │  5 DAOs:                 │  │  │   endpoints       │  │    │
│  │  - UserDao               │  │  │ - Emergency       │  │    │
│  │  - ExamDao               │  │  │   Contact         │  │    │
│  │  - AppointmentDao        │  │  │   endpoints       │  │    │
│  │  - EmergencyContactDao   │  │  └───────────────────┘  │    │
│  │  - HealthInsightDao      │  │                          │    │
│  │                          │  │  6 DTOs:                 │    │
│  │  5 Entities:             │  │  - UserProfileDto        │    │
│  │  - UserEntity            │  │  - ExamDto               │    │
│  │  - ExamEntity            │  │  - AppointmentDto        │    │
│  │  - AppointmentEntity     │  │  - EmergencyContactDto   │    │
│  │  - EmergencyContactEntity│  │  - HealthInsightsDto     │    │
│  │  - HealthInsightEntity   │  │  - AuthDto               │    │
│  └──────────────────────────┘  └──────────────────────────┘    │
│                                                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                    Mappers (Bidirectional)                 │  │
│  │  Entity ↔ Domain ↔ DTO                                    │  │
│  │  - UserMapper                                              │  │
│  │  - ExamMapper                                              │  │
│  │  - AppointmentMapper                                       │  │
│  │  - EmergencyContactMapper                                  │  │
│  │  - HealthInsightMapper                                     │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              ▲
                              │ Injected by
                              │
┌─────────────────────────────────────────────────────────────────┐
│                    DEPENDENCY INJECTION                          │
│                  (Infrastructure Agent - DONE)                   │
│                                                                   │
│  ┌────────────────┐  ┌────────────────┐  ┌──────────────────┐ │
│  │ DatabaseModule │  │ NetworkModule  │  │ RepositoryModule │ │
│  │                │  │                │  │                  │ │
│  │ Provides:      │  │ Provides:      │  │ Binds:           │ │
│  │ - Database     │  │ - ApiService   │  │ - Repositories   │ │
│  │ - All DAOs     │  │ - Retrofit     │  │   (interface →   │ │
│  │                │  │ - OkHttp       │  │    impl)         │ │
│  └────────────────┘  └────────────────┘  └──────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Data Flow

### Read Operation (e.g., Get Exams)

```
ViewModel
   │
   │ inject ExamRepository
   │
   ▼
ExamRepositoryImpl
   │
   ├──> Try API: apiService.getExams()
   │         │
   │         ├──> Success? Cache in examDao.insertExams()
   │         │         └──> Return Result.Success(exams)
   │         │
   │         └──> Error? Fallback to examDao.getAllExams()
   │                   └──> Return cached data or error
   │
   └──> observeExams(): Flow from examDao.observeExams()
             └──> Real-time updates from Room
```

### Write Operation (e.g., Create Appointment)

```
ViewModel
   │
   │ inject AppointmentRepository
   │
   ▼
AppointmentRepositoryImpl
   │
   └──> API: apiService.createAppointment(dto)
            │
            ├──> Success?
            │      │
            │      ├──> Cache: appointmentDao.insertAppointment()
            │      └──> Return Result.Success(appointment)
            │
            └──> Error?
                   └──> Return Result.Error(exception)
```

## Error Handling

All repository methods return `Result<T>`:

```kotlin
sealed class Result<out T> {
    data class Success<T>(val data: T) : Result<T>()
    data class Error(val exception: Throwable) : Result<Nothing>()
}
```

Usage in ViewModel (future):

```kotlin
viewModelScope.launch {
    when (val result = examRepository.getExams(filter)) {
        is Result.Success -> {
            _uiState.value = UiState.Success(result.data)
        }
        is Result.Error -> {
            _uiState.value = UiState.Error(result.exception.message)
        }
    }
}
```

## Reactive Updates

All repositories provide Flow-based observers:

```kotlin
// In Repository
fun observeExams(): Flow<List<Exam>> {
    return examDao.observeExams(userId).map { entities ->
        entities.map { it.toDomain() }
    }
}

// In ViewModel (future)
val exams: StateFlow<List<Exam>> = examRepository
    .observeExams()
    .stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = emptyList()
    )
```

## Security Considerations

### Already Implemented:
1. All API calls use HTTPS (enforced by NetworkModule)
2. Room entities ready for encryption (SQLCipher in future)
3. Tokens stored in EncryptedSharedPreferences (via Infrastructure Agent)

### Future Enhancements:
- Certificate pinning (NetworkModule)
- Request signing
- Biometric authentication for sensitive operations

## Performance Optimizations

### Room Database:
- Indices on frequently queried columns (userId, date, dateTime, timestamp, order)
- Suspend functions for async operations
- Flow for reactive updates (no polling)
- OnConflict strategies for upsert operations

### Network Layer:
- Response caching via OkHttp (configured in NetworkModule)
- Timeout configuration (30s connect, read, write)
- Future: Request deduplication, pagination

## Testing Strategy

### Unit Tests (Created):
- ExamRepositoryImplTest - Shows offline-first pattern
- UserRepositoryImplTest - Shows Flow testing pattern

### Test Coverage Includes:
- Successful API calls with caching
- API errors with fallback to cache
- Network exceptions with fallback to cache
- Flow-based reactive updates
- Delete operations

### Future Tests:
- AppointmentRepositoryImplTest
- EmergencyContactRepositoryImplTest
- HealthInsightRepositoryImplTest
- Integration tests with in-memory Room database

## Dependency Graph

```
ExamRepositoryImpl
    ├── @Inject ExamDao (provided by DatabaseModule)
    └── @Inject HealthApiService (provided by NetworkModule)

UserRepositoryImpl
    ├── @Inject UserDao (provided by DatabaseModule)
    └── @Inject HealthApiService (provided by NetworkModule)

AppointmentRepositoryImpl
    ├── @Inject AppointmentDao (provided by DatabaseModule)
    └── @Inject HealthApiService (provided by NetworkModule)

EmergencyContactRepositoryImpl
    ├── @Inject EmergencyContactDao (provided by DatabaseModule)
    └── @Inject HealthApiService (provided by NetworkModule)

HealthInsightRepositoryImpl
    ├── @Inject HealthInsightDao (provided by DatabaseModule)
    └── @Inject HealthApiService (provided by NetworkModule)
```

All dependencies are constructor-injected via Hilt `@Inject` annotation.

---

**Architecture Status:** Complete and Ready for Integration
