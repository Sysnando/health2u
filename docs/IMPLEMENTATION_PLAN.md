# Health2U - Android Native Implementation Plan

## Project Overview

**Project Name:** My Health Hub (Health2U)
**Platform:** Android Native
**Minimum SDK:** Android 13 (API Level 33)
**Target SDK:** Android 15 (API Level 35)
**Design Source:** Stitch Project ID: 4316282056652774057

## Executive Summary

Health2U is a comprehensive health management Android application that enables users to track their health records, organize medical exams, manage appointments, and gain insights into their health data. The application emphasizes security, privacy, and user-friendly design.

---

## 1. Technology Stack

### 1.1 Core Technologies

**Language:** Kotlin (100%)
- Modern, concise, and null-safe
- Full Android official support
- Excellent coroutine support for async operations

**UI Framework:** Jetpack Compose
- Modern declarative UI framework
- Best performance for Android 13+
- Easier state management
- Faster development and testing
- Material Design 3 support

### 1.2 Architecture Pattern

**Clean Architecture + MVVM**
- Separation of concerns
- Testability
- Maintainability
- Scalability

**Layers:**
- **Presentation Layer:** Compose UI + ViewModels
- **Domain Layer:** Use Cases + Business Logic
- **Data Layer:** Repositories + Data Sources

### 1.3 Key Libraries & Dependencies

#### Core Android Jetpack
```kotlin
// Compose
androidx.compose.ui
androidx.compose.material3
androidx.compose.foundation
androidx.navigation:navigation-compose

// Lifecycle & ViewModel
androidx.lifecycle:lifecycle-viewmodel-compose
androidx.lifecycle:lifecycle-runtime-compose

// Kotlin Coroutines & Flow
org.jetbrains.kotlinx:kotlinx-coroutines-android
org.jetbrains.kotlinx:kotlinx-coroutines-core
```

#### Dependency Injection
```kotlin
// Hilt (Google's recommended DI)
com.google.dagger:hilt-android
androidx.hilt:hilt-navigation-compose
```

#### Networking
```kotlin
// Retrofit + OkHttp
com.squareup.retrofit2:retrofit
com.squareup.retrofit2:converter-gson
com.squareup.okhttp3:logging-interceptor
```

#### Database
```kotlin
// Room (Local SQLite)
androidx.room:room-runtime
androidx.room:room-ktx

// DataStore (Preferences)
androidx.datastore:datastore-preferences
```

#### Security
```kotlin
// Encrypted SharedPreferences
androidx.security:security-crypto

// Biometric Authentication
androidx.biometric:biometric
```

#### Image Processing & Display
```kotlin
// Coil (Compose-first image loading)
io.coil-kt:coil-compose

// CameraX
androidx.camera:camera-core
androidx.camera:camera-camera2
androidx.camera:camera-lifecycle
androidx.camera:camera-view
```

#### Testing
```kotlin
// Unit Testing
junit:junit
org.mockito.kotlin:mockito-kotlin
org.jetbrains.kotlinx:kotlinx-coroutines-test
app.cash.turbine:turbine // Flow testing

// Android Instrumentation Testing
androidx.test.ext:junit
androidx.test.espresso:espresso-core
androidx.compose.ui:ui-test-junit4

// End-to-End Testing
androidx.test:runner
androidx.test:rules
```

#### Additional Libraries
```kotlin
// Date/Time
org.jetbrains.kotlinx:kotlinx-datetime

// PDF Generation/Viewing
com.github.barteksc:android-pdf-viewer

// Charts/Graphs
com.github.PhilJay:MPAndroidChart

// Splash Screen
androidx.core:core-splashscreen
```

---

## 2. Application Screens & Implementation Plan

### 2.1 Design System (Screen 1)
**Stitch ID:** `asset-stub-assets-e59fec01f99a454b809ebd6013fd7a6e-1774120825936`

**Implementation:**
- Extract color palette -> `ui/theme/Color.kt`
- Extract typography system -> `ui/theme/Type.kt`
- Extract spacing/dimensions -> `ui/theme/Dimensions.kt`
- Create custom Material3 theme -> `ui/theme/Theme.kt`
- Build reusable component library -> `ui/components/`

**Components to Create:**
- Custom buttons (primary, secondary, text)
- Input fields with validation
- Cards (health record, exam, appointment)
- Navigation bar
- Loading indicators
- Error states
- Empty states
- Dialogs/modals

---

### 2.2 Authentication Flow

#### Welcome Screen (Screen 6)
**Stitch ID:** `a681a6276a0d44838c77c74188f6d5e0`

**Module:** `presentation/auth/welcome/`

**Features:**
- Brand introduction
- Navigate to login
- Navigate to onboarding
- App version display

**Components:**
- `WelcomeScreen.kt` (Composable)
- `WelcomeViewModel.kt`
- `WelcomeState.kt`

---

#### Login Screen (Screen 7)
**Stitch ID:** `e6dfd2760ed34e46996944be7ff26da2`

**Module:** `presentation/auth/login/`

**Features:**
- Email/password authentication
- Biometric authentication option
- Password visibility toggle
- Form validation
- "Forgot password" flow
- "Sign up" navigation

**Security:**
- Input sanitization
- Rate limiting on failed attempts
- Secure password storage using Android Keystore
- SSL pinning for API calls

**Components:**
- `LoginScreen.kt`
- `LoginViewModel.kt`
- `LoginUseCase.kt` (domain)
- `AuthRepository.kt` (data)

---

### 2.3 Onboarding Flow

#### Onboarding: Track Health (Screen 8)
**Stitch ID:** `b110dc8b16f1469ba325c0788242420f`

#### Onboarding: Stay Organized (Screen 9)
**Stitch ID:** `6ceabde3d11943c58be6802e62136256`

#### Onboarding: Secure & Private (Screen 10)
**Stitch ID:** `3353b894431549ea9c732f2321c9e741`

**Module:** `presentation/onboarding/`

**Features:**
- Horizontal pager with 3 screens
- Skip button
- Progress indicators
- "Get Started" on final screen
- Store onboarding completion status

**Components:**
- `OnboardingScreen.kt`
- `OnboardingViewModel.kt`
- `OnboardingPage.kt` (single page composable)

---

### 2.4 Main Application Screens

#### Dashboard (Screen 3)
**Stitch ID:** `8daf7fa7ee8245f9ac14e897ae4f9914`

**Module:** `presentation/dashboard/`

**Features:**
- Health overview cards
- Recent exams summary
- Upcoming appointments
- Quick actions (upload, view insights)
- Bottom navigation bar
- Search functionality
- Notifications

**Data Requirements:**
- User health summary
- Recent exam results
- Appointment list
- Health metrics (if available)

**Components:**
- `DashboardScreen.kt`
- `DashboardViewModel.kt`
- `HealthSummaryCard.kt`
- `RecentExamsSection.kt`
- `UpcomingAppointmentsSection.kt`
- `GetDashboardDataUseCase.kt`

---

#### Exams Screen (Screen 4)
**Stitch ID:** `a953f4d1d29e4083960125c0b4384177`

**Module:** `presentation/exams/`

**Features:**
- List of all medical exams
- Filter by date, type, category
- Search functionality
- Sort options
- View exam details
- Upload new exam
- Share exam (PDF export)
- Delete exam (with confirmation)

**Data Requirements:**
- Exam list with metadata
- Categories/types
- Date ranges
- PDF/image files

**Components:**
- `ExamsScreen.kt`
- `ExamsViewModel.kt`
- `ExamListItem.kt`
- `ExamDetailsBottomSheet.kt`
- `ExamFilterDialog.kt`
- `GetExamsUseCase.kt`
- `UploadExamUseCase.kt`

---

#### Insights Screen (Screen 5)
**Stitch ID:** `e06d2a0feccc4b81ac13d05a628763a0`

**Module:** `presentation/insights/`

**Features:**
- Health trends visualization
- Charts and graphs
- AI-powered insights
- Health score/metrics
- Recommendations
- Export reports

**Data Requirements:**
- Time-series health data
- Analyzed metrics
- AI-generated insights

**Components:**
- `InsightsScreen.kt`
- `InsightsViewModel.kt`
- `HealthTrendChart.kt`
- `InsightCard.kt`
- `GetHealthInsightsUseCase.kt`

---

#### AI Upload Processing (Screen 2)
**Stitch ID:** `753b673616774feaafd6fa855bacaf99`

**Module:** `presentation/upload/`

**Features:**
- Document upload (camera/gallery)
- OCR processing
- AI data extraction
- Progress indicators
- Error handling
- Preview before saving

**Technology:**
- CameraX for camera capture
- ML Kit for OCR (on-device)
- Optional: Cloud Vision API for advanced OCR

**Security:**
- Local processing when possible
- Encrypted file storage
- Secure transmission to server

**Components:**
- `UploadScreen.kt`
- `UploadViewModel.kt`
- `CameraCapture.kt`
- `DocumentPreview.kt`
- `ProcessDocumentUseCase.kt`
- `OcrProcessor.kt`

---

### 2.5 User Management

#### User Profile (Screen 11)
**Stitch ID:** `340ec2c957c64bc7a55d49b92ec861b2`

**Module:** `presentation/profile/`

**Features:**
- Display user information
- Profile picture
- Personal details
- Health information
- Navigate to edit profile
- Navigate to emergency contacts
- Navigate to settings
- Logout

**Components:**
- `ProfileScreen.kt`
- `ProfileViewModel.kt`
- `GetUserProfileUseCase.kt`

---

#### Edit Profile (Screen 12)
**Stitch ID:** `7536d063fa1944fa816d05ea36ad1805`

**Module:** `presentation/profile/edit/`

**Features:**
- Edit personal information
- Upload/change profile picture
- Form validation
- Save changes
- Cancel/discard changes

**Components:**
- `EditProfileScreen.kt`
- `EditProfileViewModel.kt`
- `UpdateProfileUseCase.kt`

---

### 2.6 Emergency Contacts

#### Emergency Contacts - Empty State (Screen 13)
**Stitch ID:** `47aba8be46a0422eb02407c68ebf3e74`

#### Emergency Contacts (Screen 14)
**Stitch ID:** `0ddda2d0705d4cf9af63d2e7e8ba3df8`

**Module:** `presentation/emergency/`

**Features:**
- List of emergency contacts
- Add new contact
- Edit contact
- Delete contact
- Quick call button
- Empty state handling

**Components:**
- `EmergencyContactsScreen.kt`
- `EmergencyContactsViewModel.kt`
- `AddContactDialog.kt`
- `ContactListItem.kt`
- `ManageEmergencyContactsUseCase.kt`

---

### 2.7 Settings & Configuration

#### Settings (Screen 15)
**Stitch ID:** `9595423fc1644b04a3b4f447f4dea1ca`

**Module:** `presentation/settings/`

**Features:**
- App preferences
- Notification settings
- Security settings (biometric, PIN)
- Privacy settings
- Data management (export/delete)
- About app
- Terms & privacy policy
- Logout

**Components:**
- `SettingsScreen.kt`
- `SettingsViewModel.kt`
- `SettingsRepository.kt`

---

#### Appointments (Screen 16)
**Stitch ID:** `0b4f255b798a49b586fcc817dccc2528`

**Module:** `presentation/appointments/`

**Features:**
- Calendar view
- List of appointments
- Add new appointment
- Edit appointment
- Delete appointment
- Reminders/notifications
- Filter by status (upcoming, past, cancelled)

**Components:**
- `AppointmentsScreen.kt`
- `AppointmentsViewModel.kt`
- `AppointmentCalendar.kt`
- `AppointmentListItem.kt`
- `AddAppointmentDialog.kt`
- `ManageAppointmentsUseCase.kt`

---

## 3. Project Structure

```
health2u/
├── app/
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/health2u/
│   │   │   │   ├── di/                    # Dependency Injection
│   │   │   │   │   ├── AppModule.kt
│   │   │   │   │   ├── NetworkModule.kt
│   │   │   │   │   ├── DatabaseModule.kt
│   │   │   │   │   └── RepositoryModule.kt
│   │   │   │   │
│   │   │   │   ├── data/                  # Data Layer
│   │   │   │   │   ├── local/
│   │   │   │   │   │   ├── dao/
│   │   │   │   │   │   ├── entity/
│   │   │   │   │   │   └── HealthDatabase.kt
│   │   │   │   │   ├── remote/
│   │   │   │   │   │   ├── api/
│   │   │   │   │   │   └── dto/
│   │   │   │   │   ├── repository/
│   │   │   │   │   └── mapper/
│   │   │   │   │
│   │   │   │   ├── domain/                # Domain Layer
│   │   │   │   │   ├── model/
│   │   │   │   │   ├── repository/
│   │   │   │   │   └── usecase/
│   │   │   │   │       ├── auth/
│   │   │   │   │       ├── exams/
│   │   │   │   │       ├── appointments/
│   │   │   │   │       └── profile/
│   │   │   │   │
│   │   │   │   ├── presentation/          # Presentation Layer
│   │   │   │   │   ├── MainActivity.kt
│   │   │   │   │   ├── navigation/
│   │   │   │   │   │   ├── NavGraph.kt
│   │   │   │   │   │   └── Screen.kt
│   │   │   │   │   ├── auth/
│   │   │   │   │   │   ├── welcome/
│   │   │   │   │   │   ├── login/
│   │   │   │   │   │   └── onboarding/
│   │   │   │   │   ├── dashboard/
│   │   │   │   │   ├── exams/
│   │   │   │   │   ├── insights/
│   │   │   │   │   ├── upload/
│   │   │   │   │   ├── profile/
│   │   │   │   │   ├── emergency/
│   │   │   │   │   ├── settings/
│   │   │   │   │   └── appointments/
│   │   │   │   │
│   │   │   │   ├── ui/                    # UI Components
│   │   │   │   │   ├── theme/
│   │   │   │   │   │   ├── Color.kt
│   │   │   │   │   │   ├── Type.kt
│   │   │   │   │   │   ├── Theme.kt
│   │   │   │   │   │   └── Dimensions.kt
│   │   │   │   │   └── components/
│   │   │   │   │       ├── buttons/
│   │   │   │   │       ├── cards/
│   │   │   │   │       ├── inputs/
│   │   │   │   │       └── dialogs/
│   │   │   │   │
│   │   │   │   └── util/                  # Utilities
│   │   │   │       ├── Constants.kt
│   │   │   │       ├── Extensions.kt
│   │   │   │       ├── DateUtils.kt
│   │   │   │       └── SecurityUtils.kt
│   │   │   │
│   │   │   ├── res/                       # Resources
│   │   │   └── AndroidManifest.xml
│   │   │
│   │   ├── test/                          # Unit Tests
│   │   │   └── java/com/health2u/
│   │   │       ├── domain/usecase/
│   │   │       ├── data/repository/
│   │   │       └── presentation/viewmodel/
│   │   │
│   │   └── androidTest/                   # Instrumentation Tests
│   │       └── java/com/health2u/
│   │           ├── ui/
│   │           └── data/local/
│   │
│   └── build.gradle.kts
│
├── build.gradle.kts
├── settings.gradle.kts
├── gradle.properties
└── README.md
```

---

## 4. Security Implementation

### 4.1 Data Security

**Encryption at Rest:**
- Use Android Keystore System for cryptographic keys
- Encrypt sensitive data in Room database using SQLCipher
- Use EncryptedSharedPreferences for preferences
- Encrypt files stored locally

**Encryption in Transit:**
- TLS 1.3 for all network communications
- Certificate pinning to prevent MITM attacks
- Implement proper SSL/TLS validation

### 4.2 Authentication Security

**Implementation:**
- Biometric authentication (fingerprint/face)
- Optional PIN/password backup
- Secure token storage
- Token refresh mechanism
- Session timeout
- Account lockout after failed attempts

### 4.3 Input Validation

**Rules:**
- Sanitize all user inputs
- Validate email formats
- Strong password requirements
- SQL injection prevention
- XSS prevention

### 4.4 Code Security

**Best Practices:**
- ProGuard/R8 code obfuscation
- Remove logging in production
- Secure API key storage (not in code)
- Root/jailbreak detection
- Debug mode detection
- Certificate pinning

### 4.5 Privacy Compliance

**GDPR/HIPAA Considerations:**
- User data export functionality
- Right to deletion
- Consent management
- Data minimization
- Privacy policy display
- Audit logging

### 4.6 Network Security Configuration

```xml
<!-- res/xml/network_security_config.xml -->
<network-security-config>
    <base-config cleartextTrafficPermitted="false">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>
    <domain-config cleartextTrafficPermitted="false">
        <domain includeSubdomains="true">api.health2u.com</domain>
        <pin-set>
            <pin digest="SHA-256">base64==</pin>
            <pin digest="SHA-256">backup-base64==</pin>
        </pin-set>
    </domain-config>
</network-security-config>
```

---

## 5. Testing Strategy

### 5.1 Unit Tests (Target: 80% Coverage)

**Scope:**
- ViewModels
- Use Cases
- Repositories
- Mappers
- Utility functions
- Validation logic

**Tools:**
- JUnit 4/5
- Mockito/MockK
- Kotlinx-coroutines-test
- Turbine (Flow testing)

**Example Test Structure:**
```kotlin
class LoginViewModelTest {
    @Test
    fun `login with valid credentials should emit success`() = runTest {
        // Given
        val useCase = mockk<LoginUseCase>()
        coEvery { useCase(any()) } returns Result.success(User())
        val viewModel = LoginViewModel(useCase)

        // When
        viewModel.login("test@email.com", "password123")

        // Then
        viewModel.state.test {
            assertEquals(LoginState.Success, awaitItem())
        }
    }
}
```

### 5.2 Instrumentation Tests

**Scope:**
- Database operations (Room DAO)
- Compose UI components
- Navigation flows
- Data persistence

**Tools:**
- AndroidJUnit4
- Espresso
- Compose UI Test
- Room Testing

### 5.3 UI Tests

**Scope:**
- Screen rendering
- User interactions
- State changes
- Navigation

**Example:**
```kotlin
class LoginScreenTest {
    @get:Rule
    val composeTestRule = createComposeRule()

    @Test
    fun loginButton_isDisabled_whenFieldsEmpty() {
        composeTestRule.setContent {
            LoginScreen()
        }

        composeTestRule
            .onNodeWithText("Login")
            .assertIsNotEnabled()
    }
}
```

### 5.4 Security Tests

**Checks:**
- SQL injection attempts
- Invalid input handling
- Certificate pinning
- Encrypted storage verification
- Authentication bypass attempts

### 5.5 Performance Tests

**Metrics:**
- App startup time
- Screen rendering time
- Database query performance
- Memory usage
- Battery consumption

---

## 6. Development Phases

### Phase 1: Project Setup & Design System (Week 1-2)
- [ ] Initialize Android project with Kotlin
- [ ] Setup Gradle dependencies
- [ ] Configure Hilt DI
- [ ] Retrieve all design assets from Stitch
- [ ] Implement Design System (colors, typography, components)
- [ ] Setup navigation structure
- [ ] Configure Room database schema
- [ ] Setup Retrofit API client
- [ ] Implement base architecture layers

### Phase 2: Authentication & Onboarding (Week 2-3)
- [ ] Implement Welcome Screen
- [ ] Implement Login Screen
- [ ] Implement Onboarding flow (3 screens)
- [ ] Setup biometric authentication
- [ ] Implement token management
- [ ] Add authentication use cases
- [ ] Write unit tests for auth flow
- [ ] Security validation for authentication

### Phase 3: Core Screens - Part 1 (Week 3-5)
- [ ] Implement Dashboard Screen
- [ ] Implement Exams Screen
- [ ] Implement AI Upload Processing
- [ ] Setup CameraX integration
- [ ] Implement OCR processing
- [ ] Create database models for exams
- [ ] Write repository layer
- [ ] Unit tests for core features

### Phase 4: Core Screens - Part 2 (Week 5-6)
- [ ] Implement Insights Screen
- [ ] Add charts/graphs for health trends
- [ ] Implement Appointments Screen
- [ ] Add calendar functionality
- [ ] Setup notification system
- [ ] Unit tests for insights and appointments

### Phase 5: User Management (Week 6-7)
- [ ] Implement User Profile Screen
- [ ] Implement Edit Profile Screen
- [ ] Implement Emergency Contacts (empty & populated)
- [ ] Implement Settings Screen
- [ ] Add data export functionality
- [ ] Unit tests for user management

### Phase 6: Integration & Polish (Week 7-8)
- [ ] Integrate all screens with navigation
- [ ] Implement bottom navigation
- [ ] Add loading states
- [ ] Add error handling
- [ ] Implement offline support
- [ ] Add animations and transitions
- [ ] Optimize performance

### Phase 7: Security Hardening (Week 8-9)
- [ ] Implement certificate pinning
- [ ] Add ProGuard rules
- [ ] Implement root detection
- [ ] Add secure file storage
- [ ] Security audit
- [ ] Penetration testing

### Phase 8: Testing & QA (Week 9-10)
- [ ] Complete unit test suite (80%+ coverage)
- [ ] Complete instrumentation tests
- [ ] UI/UX testing
- [ ] Performance testing
- [ ] Security testing
- [ ] Bug fixes
- [ ] Accessibility testing

### Phase 9: Beta Release (Week 10-11)
- [ ] Internal testing
- [ ] Beta user feedback
- [ ] Bug fixes and refinements
- [ ] Documentation
- [ ] Play Store assets preparation

### Phase 10: Production Release (Week 11-12)
- [ ] Final QA
- [ ] Play Store submission
- [ ] Release notes
- [ ] Monitoring setup
- [ ] Post-launch support plan

---

## 7. API Integration

### 7.1 Expected Endpoints

```kotlin
interface HealthApiService {
    // Authentication
    @POST("auth/login")
    suspend fun login(@Body request: LoginRequest): Response<AuthResponse>

    @POST("auth/refresh")
    suspend fun refreshToken(@Body token: String): Response<AuthResponse>

    @POST("auth/logout")
    suspend fun logout(): Response<Unit>

    // User Profile
    @GET("user/profile")
    suspend fun getProfile(): Response<UserProfile>

    @PUT("user/profile")
    suspend fun updateProfile(@Body profile: UserProfile): Response<UserProfile>

    // Exams
    @GET("exams")
    suspend fun getExams(@Query("filter") filter: String?): Response<List<Exam>>

    @GET("exams/{id}")
    suspend fun getExamById(@Path("id") id: String): Response<Exam>

    @Multipart
    @POST("exams/upload")
    suspend fun uploadExam(
        @Part file: MultipartBody.Part,
        @Part("metadata") metadata: RequestBody
    ): Response<Exam>

    @DELETE("exams/{id}")
    suspend fun deleteExam(@Path("id") id: String): Response<Unit>

    // Appointments
    @GET("appointments")
    suspend fun getAppointments(): Response<List<Appointment>>

    @POST("appointments")
    suspend fun createAppointment(@Body appointment: Appointment): Response<Appointment>

    @PUT("appointments/{id}")
    suspend fun updateAppointment(
        @Path("id") id: String,
        @Body appointment: Appointment
    ): Response<Appointment>

    @DELETE("appointments/{id}")
    suspend fun deleteAppointment(@Path("id") id: String): Response<Unit>

    // Insights
    @GET("insights")
    suspend fun getHealthInsights(): Response<HealthInsights>

    // Emergency Contacts
    @GET("emergency-contacts")
    suspend fun getEmergencyContacts(): Response<List<EmergencyContact>>

    @POST("emergency-contacts")
    suspend fun addEmergencyContact(@Body contact: EmergencyContact): Response<EmergencyContact>

    @PUT("emergency-contacts/{id}")
    suspend fun updateEmergencyContact(
        @Path("id") id: String,
        @Body contact: EmergencyContact
    ): Response<EmergencyContact>

    @DELETE("emergency-contacts/{id}")
    suspend fun deleteEmergencyContact(@Path("id") id: String): Response<Unit>
}
```

---

## 8. Database Schema

### 8.1 Room Entities

```kotlin
@Entity(tableName = "users")
data class UserEntity(
    @PrimaryKey val id: String,
    val email: String,
    val name: String,
    val profilePictureUrl: String?,
    val dateOfBirth: Long?,
    val phone: String?,
    val lastSyncTimestamp: Long
)

@Entity(tableName = "exams")
data class ExamEntity(
    @PrimaryKey val id: String,
    val userId: String,
    val title: String,
    val type: String,
    val date: Long,
    val fileUrl: String?,
    val localFilePath: String?,
    val notes: String?,
    val createdAt: Long,
    val updatedAt: Long
)

@Entity(tableName = "appointments")
data class AppointmentEntity(
    @PrimaryKey val id: String,
    val userId: String,
    val title: String,
    val description: String?,
    val doctorName: String?,
    val location: String?,
    val dateTime: Long,
    val reminderMinutes: Int?,
    val status: String, // UPCOMING, COMPLETED, CANCELLED
    val createdAt: Long
)

@Entity(tableName = "emergency_contacts")
data class EmergencyContactEntity(
    @PrimaryKey val id: String,
    val userId: String,
    val name: String,
    val relationship: String,
    val phone: String,
    val email: String?,
    val isPrimary: Boolean,
    val order: Int
)

@Entity(tableName = "health_insights")
data class HealthInsightEntity(
    @PrimaryKey val id: String,
    val userId: String,
    val type: String,
    val title: String,
    val description: String,
    val metricValue: Double?,
    val timestamp: Long,
    val createdAt: Long
)
```

---

## 9. Performance Optimization

### 9.1 Image Loading
- Use Coil with proper caching
- Lazy loading for lists
- Image compression before upload
- Thumbnail generation

### 9.2 Database
- Proper indexing on frequently queried columns
- Use transactions for bulk operations
- Implement pagination for large datasets
- Background database operations

### 9.3 Network
- Request/response caching
- Implement retry logic with exponential backoff
- Batch API calls when possible
- Optimize payload sizes

### 9.4 UI Performance
- Avoid unnecessary recompositions
- Use `remember` and `derivedStateOf` appropriately
- Lazy layouts for lists
- Proper key management in lists

---

## 10. Offline Support

### 10.1 Strategy
- Cache-first approach for read operations
- Queue write operations when offline
- Sync when connection restored
- Conflict resolution strategy

### 10.2 Implementation
```kotlin
class SyncManager @Inject constructor(
    private val localDataSource: LocalDataSource,
    private val remoteDataSource: RemoteDataSource,
    private val connectivityObserver: ConnectivityObserver
) {
    fun observeAndSync() {
        connectivityObserver.observe().collect { isConnected ->
            if (isConnected) {
                syncPendingChanges()
            }
        }
    }

    private suspend fun syncPendingChanges() {
        // Implement sync logic
    }
}
```

---

## 11. Accessibility

### 11.1 Requirements
- Content descriptions for all interactive elements
- Proper heading hierarchy
- Minimum touch target size (48dp)
- Color contrast ratios (WCAG AA)
- Screen reader support
- Font scaling support

### 11.2 Implementation
```kotlin
@Composable
fun AccessibleButton(
    text: String,
    onClick: () -> Unit,
    contentDescription: String? = null
) {
    Button(
        onClick = onClick,
        modifier = Modifier
            .semantics {
                contentDescription?.let { this.contentDescription = it }
            }
            .sizeIn(minWidth = 48.dp, minHeight = 48.dp)
    ) {
        Text(text)
    }
}
```

---

## 12. Monitoring & Analytics

### 12.1 Crash Reporting
- Firebase Crashlytics integration
- Custom crash reporting
- ANR detection

### 12.2 Analytics
- User flow tracking
- Feature usage metrics
- Performance metrics
- Error tracking

### 12.3 Implementation
```kotlin
// Optional: Firebase or custom analytics
interface AnalyticsTracker {
    fun logEvent(eventName: String, params: Map<String, Any>)
    fun logScreenView(screenName: String)
    fun setUserId(userId: String)
}
```

---

## 13. Build Configuration

### 13.1 Build Variants

```kotlin
android {
    buildTypes {
        debug {
            applicationIdSuffix = ".debug"
            isDebuggable = true
            isMinifyEnabled = false
        }
        release {
            isDebuggable = false
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            buildConfigField("String", "API_BASE_URL", "\"https://dev-api.health2u.com/\"")
        }
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            buildConfigField("String", "API_BASE_URL", "\"https://staging-api.health2u.com/\"")
        }
        create("prod") {
            dimension = "environment"
            buildConfigField("String", "API_BASE_URL", "\"https://api.health2u.com/\"")
        }
    }
}
```

---

## 14. Risk Assessment & Mitigation

### 14.1 Technical Risks

| Risk | Impact | Likelihood | Mitigation |
|------|--------|-----------|------------|
| OCR accuracy issues | High | Medium | Implement manual correction UI, use multiple OCR engines |
| API downtime | High | Low | Robust offline support, local caching |
| Security vulnerabilities | Critical | Medium | Security audits, penetration testing, code reviews |
| Performance issues on older devices | Medium | Medium | Performance testing, optimization, minimum SDK 33 |
| Third-party library bugs | Medium | Medium | Careful library selection, version pinning |

### 14.2 Schedule Risks

| Risk | Impact | Likelihood | Mitigation |
|------|--------|-----------|------------|
| Design changes | High | Medium | Buffer time in schedule, agile approach |
| API delays | High | Low | Mock API for development, parallel work |
| Testing takes longer | Medium | Medium | Start testing early, automated tests |

---

## 15. Documentation Requirements

### 15.1 Code Documentation
- KDoc comments for public APIs
- README files for each module
- Architecture decision records (ADRs)

### 15.2 User Documentation
- In-app help/tutorials
- FAQ section
- Privacy policy
- Terms of service

### 15.3 Developer Documentation
- Setup guide
- Build instructions
- API documentation
- Testing guide
- Contribution guidelines

---

## 16. Deployment

### 16.1 Pre-release Checklist
- [ ] All unit tests passing
- [ ] All instrumentation tests passing
- [ ] Security audit completed
- [ ] Performance benchmarks met
- [ ] Accessibility audit passed
- [ ] Privacy policy updated
- [ ] Play Store assets ready
- [ ] Release notes prepared

### 16.2 Play Store Requirements
- App icon (512x512)
- Feature graphic (1024x500)
- Screenshots (phone & tablet)
- Short description (80 chars)
- Full description (4000 chars)
- Privacy policy URL
- Content rating questionnaire

---

## 17. Post-Launch

### 17.1 Monitoring
- Crash rate < 1%
- ANR rate < 0.5%
- App startup time < 2s
- User retention tracking

### 17.2 Maintenance Plan
- Weekly bug fix releases (if needed)
- Monthly feature updates
- Quarterly security audits
- Annual major version

---

## 18. Success Metrics

### 18.1 Technical KPIs
- Test coverage > 80%
- Crash-free rate > 99%
- App size < 50MB
- Startup time < 2 seconds
- API response time < 500ms

### 18.2 User KPIs
- User retention (Day 7) > 40%
- Daily active users growth
- Feature adoption rates
- User satisfaction score > 4.5/5

---

## 19. Resources & Tools

### 19.1 Development Tools
- Android Studio Ladybug or later
- Gradle 8.x
- Kotlin 2.0+
- Git for version control

### 19.2 Design Tools
- Stitch for design specs
- Figma (if needed for reference)

### 19.3 Project Management
- Jira/Linear for task tracking
- Confluence/Notion for documentation
- Slack for communication

---

## 20. Next Steps

### Immediate Actions:
1. **Retrieve Stitch Design Assets**
   - Download all 16 screen designs
   - Extract design system specifications
   - Export assets (icons, images)

2. **Setup Development Environment**
   - Install Android Studio
   - Configure Kotlin
   - Setup emulator/device for testing

3. **Project Initialization**
   - Create Android project with Compose
   - Setup Gradle dependencies
   - Configure Hilt DI
   - Setup Git repository

4. **Review & Approval**
   - Review this plan with stakeholders
   - Confirm API specifications
   - Finalize timeline
   - Allocate resources

---

## Appendix A: Stitch Screen Reference

| # | Screen Name | Stitch ID |
|---|-------------|-----------|
| 1 | Design System | asset-stub-assets-e59fec01f99a454b809ebd6013fd7a6e-1774120825936 |
| 2 | AI Upload Processing | 753b673616774feaafd6fa855bacaf99 |
| 3 | MyHealthHub Dashboard | 8daf7fa7ee8245f9ac14e897ae4f9914 |
| 4 | MyHealthHub Exams | a953f4d1d29e4083960125c0b4384177 |
| 5 | MyHealthHub Insights | e06d2a0feccc4b81ac13d05a628763a0 |
| 6 | Welcome to MyHealthHub | a681a6276a0d44838c77c74188f6d5e0 |
| 7 | MyHealthHub Login | e6dfd2760ed34e46996944be7ff26da2 |
| 8 | Onboarding: Track Health | b110dc8b16f1469ba325c0788242420f |
| 9 | Onboarding: Stay Organized | 6ceabde3d11943c58be6802e62136256 |
| 10 | Onboarding: Secure & Private | 3353b894431549ea9c732f2321c9e741 |
| 11 | User Profile | 340ec2c957c64bc7a55d49b92ec861b2 |
| 12 | Edit Profile | 7536d063fa1944fa816d05ea36ad1805 |
| 13 | Emergency Contacts (Empty) | 47aba8be46a0422eb02407c68ebf3e74 |
| 14 | Emergency Contacts | 0ddda2d0705d4cf9af63d2e7e8ba3df8 |
| 15 | Settings | 9595423fc1644b04a3b4f447f4dea1ca |
| 16 | Appointments | 0b4f255b798a49b586fcc817dccc2528 |

---

## Appendix B: Recommended Team Structure

- **1 Senior Android Developer** (Architecture, complex features)
- **1-2 Mid-level Android Developers** (Feature implementation)
- **1 QA Engineer** (Testing, automation)
- **1 Designer** (Design review, asset preparation)
- **1 Backend Developer** (API development)
- **1 Project Manager** (Coordination, timeline management)

---

**Document Version:** 1.0
**Last Updated:** 2026-04-07
**Status:** Draft - Awaiting Review & Design Asset Retrieval
