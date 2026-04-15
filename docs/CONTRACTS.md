# Phase 1 Integration Contracts

This document defines the exact interfaces and conventions that all agents must follow to ensure seamless integration.

## 1. Package Naming Convention

**ALL agents must use this exact package structure:**

```
com.health2u
├── di/                    # DI modules (Infrastructure Agent)
├── data/                  # Data layer (Data Agent)
│   ├── local/
│   │   ├── dao/
│   │   ├── entity/
│   │   └── HealthDatabase.kt
│   ├── remote/
│   │   ├── api/
│   │   └── dto/
│   ├── repository/
│   └── mapper/
├── domain/                # Domain layer (Data Agent)
│   ├── model/
│   ├── repository/        # Interfaces only
│   └── usecase/
├── presentation/          # Presentation layer (Foundation Agent)
│   ├── MainActivity.kt
│   └── navigation/
├── ui/                    # UI components (Design Agent)
│   ├── theme/
│   └── components/
└── util/                  # Utilities (Foundation Agent)
```

## 2. Data Layer → Domain Layer Contract

### 2.1 Repository Interface Location
**Owner:** Data Agent
**Location:** `domain/repository/`
**Convention:** Interfaces in domain, implementations in data

**Repository Interface Template:**
```kotlin
package com.health2u.domain.repository

import com.health2u.domain.model.*
import kotlinx.coroutines.flow.Flow

interface ExamRepository {
    suspend fun getExams(filter: String?): Result<List<Exam>>
    suspend fun getExamById(id: String): Result<Exam>
    suspend fun uploadExam(exam: Exam, file: ByteArray): Result<Exam>
    suspend fun deleteExam(id: String): Result<Unit>
    fun observeExams(): Flow<List<Exam>>
}
```

**All repositories return `Result<T>` for error handling**

### 2.2 Domain Models
**Owner:** Data Agent
**Location:** `domain/model/`

**Required Domain Models for Phase 1:**
```kotlin
// domain/model/User.kt
data class User(
    val id: String,
    val email: String,
    val name: String,
    val profilePictureUrl: String?,
    val dateOfBirth: Long?,
    val phone: String?
)

// domain/model/Exam.kt
data class Exam(
    val id: String,
    val userId: String,
    val title: String,
    val type: String,
    val date: Long,
    val fileUrl: String?,
    val notes: String?,
    val createdAt: Long,
    val updatedAt: Long
)

// domain/model/Appointment.kt
data class Appointment(
    val id: String,
    val userId: String,
    val title: String,
    val description: String?,
    val doctorName: String?,
    val location: String?,
    val dateTime: Long,
    val reminderMinutes: Int?,
    val status: AppointmentStatus,
    val createdAt: Long
)

enum class AppointmentStatus {
    UPCOMING, COMPLETED, CANCELLED
}

// domain/model/EmergencyContact.kt
data class EmergencyContact(
    val id: String,
    val userId: String,
    val name: String,
    val relationship: String,
    val phone: String,
    val email: String?,
    val isPrimary: Boolean,
    val order: Int
)

// domain/model/HealthInsight.kt
data class HealthInsight(
    val id: String,
    val userId: String,
    val type: String,
    val title: String,
    val description: String,
    val metricValue: Double?,
    val timestamp: Long,
    val createdAt: Long
)
```

### 2.3 Database Entities
**Owner:** Data Agent
**Location:** `data/local/entity/`
**Convention:** Must have mapper to/from domain models

**Entity Template:**
```kotlin
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
```

**Mapper Convention:**
```kotlin
// data/mapper/ExamMapper.kt
fun ExamEntity.toDomain(): Exam = Exam(...)
fun Exam.toEntity(): ExamEntity = ExamEntity(...)
```

### 2.4 Room Database
**Owner:** Data Agent
**Location:** `data/local/HealthDatabase.kt`

**Exact Database Configuration:**
```kotlin
@Database(
    entities = [
        UserEntity::class,
        ExamEntity::class,
        AppointmentEntity::class,
        EmergencyContactEntity::class,
        HealthInsightEntity::class
    ],
    version = 1,
    exportSchema = false
)
abstract class HealthDatabase : RoomDatabase() {
    abstract fun userDao(): UserDao
    abstract fun examDao(): ExamDao
    abstract fun appointmentDao(): AppointmentDao
    abstract fun emergencyContactDao(): EmergencyContactDao
    abstract fun healthInsightDao(): HealthInsightDao
}
```

## 3. Network Layer Contract

### 3.1 API Service Interface
**Owner:** Data Agent
**Location:** `data/remote/api/HealthApiService.kt`

**Exact API Endpoints (no deviations):**
```kotlin
interface HealthApiService {
    // Authentication
    @POST("auth/login")
    suspend fun login(@Body request: LoginRequest): Response<AuthResponse>

    @POST("auth/refresh")
    suspend fun refreshToken(@Body request: RefreshTokenRequest): Response<AuthResponse>

    @POST("auth/logout")
    suspend fun logout(): Response<Unit>

    // User Profile
    @GET("user/profile")
    suspend fun getProfile(): Response<UserProfileDto>

    @PUT("user/profile")
    suspend fun updateProfile(@Body profile: UserProfileDto): Response<UserProfileDto>

    // Exams
    @GET("exams")
    suspend fun getExams(@Query("filter") filter: String?): Response<List<ExamDto>>

    @GET("exams/{id}")
    suspend fun getExamById(@Path("id") id: String): Response<ExamDto>

    @Multipart
    @POST("exams/upload")
    suspend fun uploadExam(
        @Part file: MultipartBody.Part,
        @Part("metadata") metadata: RequestBody
    ): Response<ExamDto>

    @DELETE("exams/{id}")
    suspend fun deleteExam(@Path("id") id: String): Response<Unit>

    // Appointments
    @GET("appointments")
    suspend fun getAppointments(): Response<List<AppointmentDto>>

    @POST("appointments")
    suspend fun createAppointment(@Body appointment: AppointmentDto): Response<AppointmentDto>

    @PUT("appointments/{id}")
    suspend fun updateAppointment(
        @Path("id") id: String,
        @Body appointment: AppointmentDto
    ): Response<AppointmentDto>

    @DELETE("appointments/{id}")
    suspend fun deleteAppointment(@Path("id") id: String): Response<Unit>

    // Insights
    @GET("insights")
    suspend fun getHealthInsights(): Response<HealthInsightsDto>

    // Emergency Contacts
    @GET("emergency-contacts")
    suspend fun getEmergencyContacts(): Response<List<EmergencyContactDto>>

    @POST("emergency-contacts")
    suspend fun addEmergencyContact(@Body contact: EmergencyContactDto): Response<EmergencyContactDto>

    @PUT("emergency-contacts/{id}")
    suspend fun updateEmergencyContact(
        @Path("id") id: String,
        @Body contact: EmergencyContactDto
    ): Response<EmergencyContactDto>

    @DELETE("emergency-contacts/{id}")
    suspend fun deleteEmergencyContact(@Path("id") id: String): Response<Unit>
}
```

**DTOs must have mapper to/from domain models in `data/mapper/`**

## 4. Design System Contract

### 4.1 Theme Structure
**Owner:** Design Agent
**Location:** `ui/theme/`

**Required Theme Files:**
```
ui/theme/
├── Color.kt          # Material3 color scheme
├── Type.kt           # Typography scale
├── Dimensions.kt     # Spacing, corner radii, elevation
└── Theme.kt          # Theme composition
```

**Theme Usage Convention:**
```kotlin
@Composable
fun Health2uTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = if (darkTheme) darkColorScheme else lightColorScheme,
        typography = Typography,
        content = content
    )
}
```

**ALL UI code must use theme colors - NO hardcoded colors:**
```kotlin
// ✅ Correct
Text(
    text = "Hello",
    color = MaterialTheme.colorScheme.primary
)

// ❌ Wrong - will be rejected
Text(
    text = "Hello",
    color = Color(0xFF6200EE)
)
```

### 4.2 Dimensions
**Owner:** Design Agent
**Location:** `ui/theme/Dimensions.kt`

**Exact Structure:**
```kotlin
object Dimensions {
    // Spacing
    val SpaceXS = 4.dp
    val SpaceS = 8.dp
    val SpaceM = 16.dp
    val SpaceL = 24.dp
    val SpaceXL = 32.dp

    // Corner Radius
    val CornerRadiusS = 4.dp
    val CornerRadiusM = 8.dp
    val CornerRadiusL = 16.dp

    // Elevation
    val ElevationS = 2.dp
    val ElevationM = 4.dp
    val ElevationL = 8.dp

    // Component Sizes
    val ButtonHeight = 48.dp
    val IconSize = 24.dp
    val AvatarSizeS = 32.dp
    val AvatarSizeM = 48.dp
    val AvatarSizeL = 64.dp
}
```

### 4.3 Component Library
**Owner:** Design Agent
**Location:** `ui/components/`

**Required Components for Phase 1:**
```
ui/components/
├── buttons/
│   ├── PrimaryButton.kt
│   ├── SecondaryButton.kt
│   └── TextButton.kt
├── inputs/
│   ├── H2UTextField.kt
│   └── H2UPasswordField.kt
├── cards/
│   ├── HealthSummaryCard.kt
│   ├── ExamCard.kt
│   └── AppointmentCard.kt
├── loading/
│   └── LoadingIndicator.kt
└── empty/
    └── EmptyState.kt
```

**Component API Convention:**
```kotlin
@Composable
fun PrimaryButton(
    text: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    loading: Boolean = false
) {
    // Implementation
}
```

## 5. Navigation Contract

### 5.1 Navigation Routes
**Owner:** Foundation Agent
**Location:** `presentation/navigation/Screen.kt`

**Exact Route Definitions:**
```kotlin
sealed class Screen(val route: String) {
    // Auth Flow
    object Welcome : Screen("welcome")
    object Login : Screen("login")
    object Onboarding : Screen("onboarding")

    // Main App
    object Dashboard : Screen("dashboard")
    object Exams : Screen("exams")
    object Insights : Screen("insights")
    object Upload : Screen("upload")
    object Appointments : Screen("appointments")

    // User Management
    object Profile : Screen("profile")
    object EditProfile : Screen("profile/edit")
    object EmergencyContacts : Screen("emergency-contacts")
    object Settings : Screen("settings")

    // Detail screens with arguments
    object ExamDetail : Screen("exams/{examId}") {
        fun createRoute(examId: String) = "exams/$examId"
    }

    object AppointmentDetail : Screen("appointments/{appointmentId}") {
        fun createRoute(appointmentId: String) = "appointments/$appointmentId"
    }
}
```

### 5.2 Navigation Graph
**Owner:** Foundation Agent
**Location:** `presentation/navigation/NavGraph.kt`

**Structure:**
```kotlin
@Composable
fun Health2uNavGraph(
    navController: NavHostController,
    startDestination: String = Screen.Welcome.route
) {
    NavHost(
        navController = navController,
        startDestination = startDestination
    ) {
        // Auth flow
        composable(Screen.Welcome.route) { /* WelcomeScreen */ }
        composable(Screen.Login.route) { /* LoginScreen */ }
        composable(Screen.Onboarding.route) { /* OnboardingScreen */ }

        // Main app
        composable(Screen.Dashboard.route) { /* DashboardScreen */ }
        // ... etc
    }
}
```

## 6. Dependency Injection Contract

### 6.1 Module Structure
**Owner:** Infrastructure Agent
**Location:** `di/`

**Required Modules:**
```
di/
├── AppModule.kt         # Application-level dependencies
├── DatabaseModule.kt    # Room database
├── NetworkModule.kt     # Retrofit, OkHttp
└── RepositoryModule.kt  # Repository bindings
```

### 6.2 Database Module
**Exact Configuration:**
```kotlin
@Module
@InstallIn(SingletonComponent::class)
object DatabaseModule {

    @Provides
    @Singleton
    fun provideHealthDatabase(
        @ApplicationContext context: Context
    ): HealthDatabase {
        return Room.databaseBuilder(
            context,
            HealthDatabase::class.java,
            "health2u_database"
        )
        .fallbackToDestructiveMigration()
        .build()
    }

    @Provides
    fun provideUserDao(database: HealthDatabase) = database.userDao()

    @Provides
    fun provideExamDao(database: HealthDatabase) = database.examDao()

    @Provides
    fun provideAppointmentDao(database: HealthDatabase) = database.appointmentDao()

    @Provides
    fun provideEmergencyContactDao(database: HealthDatabase) = database.emergencyContactDao()

    @Provides
    fun provideHealthInsightDao(database: HealthDatabase) = database.healthInsightDao()
}
```

### 6.3 Network Module
**Exact Configuration:**
```kotlin
@Module
@InstallIn(SingletonComponent::class)
object NetworkModule {

    private const val BASE_URL = "https://dev-api.health2u.com/"

    @Provides
    @Singleton
    fun provideOkHttpClient(): OkHttpClient {
        return OkHttpClient.Builder()
            .addInterceptor(
                HttpLoggingInterceptor().apply {
                    level = if (BuildConfig.DEBUG) {
                        HttpLoggingInterceptor.Level.BODY
                    } else {
                        HttpLoggingInterceptor.Level.NONE
                    }
                }
            )
            .connectTimeout(30, TimeUnit.SECONDS)
            .readTimeout(30, TimeUnit.SECONDS)
            .writeTimeout(30, TimeUnit.SECONDS)
            .build()
    }

    @Provides
    @Singleton
    fun provideRetrofit(okHttpClient: OkHttpClient): Retrofit {
        return Retrofit.Builder()
            .baseUrl(BASE_URL)
            .client(okHttpClient)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
    }

    @Provides
    @Singleton
    fun provideHealthApiService(retrofit: Retrofit): HealthApiService {
        return retrofit.create(HealthApiService::class.java)
    }
}
```

### 6.4 Repository Module
**Convention:**
```kotlin
@Module
@InstallIn(SingletonComponent::class)
abstract class RepositoryModule {

    @Binds
    @Singleton
    abstract fun bindExamRepository(
        impl: ExamRepositoryImpl
    ): ExamRepository

    // ... other repository bindings
}
```

## 7. Build Configuration Contract

### 7.1 Gradle Version Catalog
**Owner:** Infrastructure Agent
**Location:** `gradle/libs.versions.toml`

**Exact Versions:**
```toml
[versions]
agp = "8.5.0"
kotlin = "2.0.0"
compose = "1.6.8"
compose-material3 = "1.2.1"
hilt = "2.51.1"
room = "2.6.1"
retrofit = "2.11.0"
okhttp = "4.12.0"
coil = "2.6.0"

[libraries]
# Compose
androidx-compose-ui = { group = "androidx.compose.ui", name = "ui", version.ref = "compose" }
androidx-compose-material3 = { group = "androidx.compose.material3", name = "material3", version.ref = "compose-material3" }
androidx-compose-ui-tooling = { group = "androidx.compose.ui", name = "ui-tooling", version.ref = "compose" }

# Hilt
hilt-android = { group = "com.google.dagger", name = "hilt-android", version.ref = "hilt" }
hilt-compiler = { group = "com.google.dagger", name = "hilt-compiler", version.ref = "hilt" }

# Room
androidx-room-runtime = { group = "androidx.room", name = "room-runtime", version.ref = "room" }
androidx-room-ktx = { group = "androidx.room", name = "room-ktx", version.ref = "room" }
androidx-room-compiler = { group = "androidx.room", name = "room-compiler", version.ref = "room" }

# Retrofit
retrofit = { group = "com.squareup.retrofit2", name = "retrofit", version.ref = "retrofit" }
retrofit-gson = { group = "com.squareup.retrofit2", name = "converter-gson", version.ref = "retrofit" }
okhttp-logging = { group = "com.squareup.okhttp3", name = "logging-interceptor", version.ref = "okhttp" }

# Image Loading
coil-compose = { group = "io.coil-kt", name = "coil-compose", version.ref = "coil" }

[plugins]
android-application = { id = "com.android.application", version.ref = "agp" }
kotlin-android = { id = "org.jetbrains.kotlin.android", version.ref = "kotlin" }
hilt = { id = "com.google.dagger.hilt.android", version.ref = "hilt" }
kotlin-kapt = { id = "org.jetbrains.kotlin.kapt", version.ref = "kotlin" }
```

### 7.2 App build.gradle.kts
**Owner:** Infrastructure Agent
**Exact Configuration:**
```kotlin
plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.kotlin.kapt)
    alias(libs.plugins.hilt)
}

android {
    namespace = "com.health2u"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.health2u"
        minSdk = 33
        targetSdk = 35
        versionCode = 1
        versionName = "1.0.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        debug {
            applicationIdSuffix = ".debug"
            isDebuggable = true
            isMinifyEnabled = false
        }
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildFeatures {
        compose = true
        buildConfig = true
    }

    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.14"
    }
}

dependencies {
    // Compose
    implementation(libs.androidx.compose.ui)
    implementation(libs.androidx.compose.material3)
    debugImplementation(libs.androidx.compose.ui.tooling)

    // Hilt
    implementation(libs.hilt.android)
    kapt(libs.hilt.compiler)

    // Room
    implementation(libs.androidx.room.runtime)
    implementation(libs.androidx.room.ktx)
    kapt(libs.androidx.room.compiler)

    // Retrofit
    implementation(libs.retrofit)
    implementation(libs.retrofit.gson)
    implementation(libs.okhttp.logging)

    // Coil
    implementation(libs.coil.compose)
}
```

## 8. Cross-Cutting Concerns

### 8.1 Package Naming
**Owner:** ALL AGENTS
**Rule:** MUST use `com.health2u` as base package. No exceptions.

### 8.2 Dependency Versions
**Owner:** Infrastructure Agent
**Rule:** All version numbers live in `gradle/libs.versions.toml`. No hardcoded versions in build.gradle files.

### 8.3 Security Configuration
**Owner:** Infrastructure Agent
**Location:** `app/src/main/res/xml/network_security_config.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="false">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>
    <domain-config cleartextTrafficPermitted="false">
        <domain includeSubdomains="true">dev-api.health2u.com</domain>
        <domain includeSubdomains="true">staging-api.health2u.com</domain>
        <domain includeSubdomains="true">api.health2u.com</domain>
    </domain-config>
</network-security-config>
```

### 8.4 Error Handling
**Owner:** Data Agent defines, ALL agents follow
**Convention:** Use `Result<T>` for all operations that can fail

```kotlin
sealed class Result<out T> {
    data class Success<T>(val data: T) : Result<T>()
    data class Error(val exception: Throwable) : Result<Nothing>()
    data class Loading<T>(val data: T? = null) : Result<T>()
}
```

### 8.5 Coroutine Scopes
**Owner:** Foundation Agent defines, ALL ViewModels follow

```kotlin
// In ViewModels
viewModelScope.launch {
    // Coroutine code
}

// In repositories
withContext(Dispatchers.IO) {
    // IO operations
}
```

## 9. File Ownership

To prevent conflicts, each agent owns specific directories:

**Infrastructure Agent:**
- `/gradle/`
- `/build.gradle.kts`
- `/settings.gradle.kts`
- `/app/build.gradle.kts`
- `/app/src/main/java/com/health2u/di/`
- `/app/src/main/AndroidManifest.xml`
- `/app/src/main/res/xml/`

**Design Agent:**
- `/app/src/main/java/com/health2u/ui/theme/`
- `/app/src/main/java/com/health2u/ui/components/`
- `/design-assets/` (Stitch downloads)

**Data Agent:**
- `/app/src/main/java/com/health2u/data/`
- `/app/src/main/java/com/health2u/domain/model/`
- `/app/src/main/java/com/health2u/domain/repository/` (interfaces)

**Foundation Agent:**
- `/app/src/main/java/com/health2u/presentation/MainActivity.kt`
- `/app/src/main/java/com/health2u/presentation/navigation/`
- `/app/src/main/java/com/health2u/util/`
- `/app/proguard-rules.pro`

## 10. Validation Requirements

Each agent must validate their work before reporting done:

**Infrastructure Agent:**
- Run `./gradlew tasks` and verify it completes without errors
- Verify all plugins are applied correctly
- Check that version catalog resolves

**Design Agent:**
- Verify theme files compile
- Verify Stitch assets are downloaded
- Check that components use theme colors (no hardcoded colors)

**Data Agent:**
- Verify Room schema generates without errors
- Verify Retrofit interfaces compile
- Verify all repositories have tests

**Foundation Agent:**
- Verify navigation graph compiles
- Verify MainActivity compiles
- Verify utility functions have unit tests

---

**Contract Version:** 1.0
**Last Updated:** 2026-04-07
**Status:** Active - All agents must follow these contracts exactly
