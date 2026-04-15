# Quick Start Guide - Health2U Design System

**For:** Infrastructure and Foundation Agents
**Status:** Ready to Use

---

## Import Statements

### Theme
```kotlin
import com.health2u.ui.theme.Health2uTheme
import com.health2u.ui.theme.Dimensions
```

### Buttons
```kotlin
import com.health2u.ui.components.buttons.PrimaryButton
import com.health2u.ui.components.buttons.SecondaryButton
import com.health2u.ui.components.buttons.H2UTextButton
```

### Inputs
```kotlin
import com.health2u.ui.components.inputs.H2UTextField
import com.health2u.ui.components.inputs.H2UPasswordField
```

### Cards
```kotlin
import com.health2u.ui.components.cards.HealthSummaryCard
import com.health2u.ui.components.cards.ExamCard
import com.health2u.ui.components.cards.AppointmentCard
```

### Loading & Empty States
```kotlin
import com.health2u.ui.components.loading.LoadingIndicator
import com.health2u.ui.components.loading.FullScreenLoading
import com.health2u.ui.components.empty.EmptyState
```

---

## Basic Usage

### 1. Wrap Your App with Theme
```kotlin
@Composable
fun MainActivity() {
    Health2uTheme {
        // Your app content
        Surface(
            modifier = Modifier.fillMaxSize(),
            color = MaterialTheme.colorScheme.background
        ) {
            NavGraph()
        }
    }
}
```

### 2. Use Theme Colors
```kotlin
Text(
    text = "Hello",
    color = MaterialTheme.colorScheme.primary  // ✅ Correct
    // color = Color(0xFF6200EE)  // ❌ Never do this
)
```

### 3. Use Dimensions
```kotlin
Column(
    modifier = Modifier.padding(Dimensions.SpaceM),
    verticalArrangement = Arrangement.spacedBy(Dimensions.SpaceS)
) {
    // Content
}
```

---

## Common Patterns

### Login Screen
```kotlin
@Composable
fun LoginScreen() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(Dimensions.ScreenPaddingHorizontal)
    ) {
        H2UTextField(
            value = email,
            onValueChange = { email = it },
            label = "Email",
            keyboardType = KeyboardType.Email
        )

        Spacer(modifier = Modifier.height(Dimensions.SpaceM))

        H2UPasswordField(
            value = password,
            onValueChange = { password = it },
            label = "Password"
        )

        Spacer(modifier = Modifier.height(Dimensions.SpaceL))

        PrimaryButton(
            text = "Log In",
            onClick = { viewModel.login() },
            enabled = email.isNotEmpty() && password.isNotEmpty(),
            loading = uiState.isLoading
        )
    }
}
```

### Dashboard with Cards
```kotlin
@Composable
fun DashboardScreen() {
    LazyColumn(
        modifier = Modifier.fillMaxSize(),
        contentPadding = PaddingValues(Dimensions.SpaceM),
        verticalArrangement = Arrangement.spacedBy(Dimensions.SpaceM)
    ) {
        item {
            HealthSummaryCard(
                title = "Heart Rate",
                value = "72",
                unit = "bpm",
                icon = Icons.Filled.Favorite,
                onClick = { /* navigate */ }
            )
        }

        items(exams) { exam ->
            ExamCard(
                title = exam.title,
                examType = exam.type,
                dateMillis = exam.date,
                onClick = { /* navigate */ }
            )
        }
    }
}
```

### Loading State
```kotlin
@Composable
fun MyScreen() {
    when (uiState) {
        is Loading -> FullScreenLoading(message = "Loading...")
        is Success -> ContentView(uiState.data)
        is Empty -> EmptyState(
            icon = Icons.Filled.Description,
            title = "No data yet",
            description = "Add your first item",
            actionText = "Add Item",
            onActionClick = { /* action */ }
        )
    }
}
```

---

## Required Gradle Dependencies

Add to `app/build.gradle.kts`:

```kotlin
dependencies {
    // Compose Material3
    implementation("androidx.compose.material3:material3:1.2.1")
    implementation("androidx.compose.ui:ui:1.6.8")
    implementation("androidx.compose.ui:ui-tooling:1.6.8")

    // Core
    implementation("androidx.core:core-ktx:1.12.0")

    // Icons
    implementation("androidx.compose.material:material-icons-extended:1.6.8")
}
```

---

## Color Reference

Access via `MaterialTheme.colorScheme.*`:

- `primary` - Medical Blue
- `secondary` - Health Teal
- `tertiary` - Tech Purple
- `error` - Error Red
- `background` - Screen background
- `surface` - Card background
- `onPrimary` - Text on primary color
- `onSurface` - Text on surface

Extended colors in `ExtendedColors` object:
- `success` / `onSuccess`
- `warning` / `onWarning`
- `info` / `onInfo`

---

## Typography Reference

Access via `MaterialTheme.typography.*`:

- `displayLarge` / `displayMedium` / `displaySmall` - Largest text
- `headlineLarge` / `headlineMedium` / `headlineSmall` - Section headers
- `titleLarge` / `titleMedium` / `titleSmall` - Titles
- `bodyLarge` / `bodyMedium` / `bodySmall` - Body text
- `labelLarge` / `labelMedium` / `labelSmall` - UI labels

Custom: `CustomTypography.healthMetricLarge` for large numbers

---

## Dimensions Reference

Common spacing:
- `SpaceXS` = 4.dp
- `SpaceS` = 8.dp
- `SpaceM` = 16.dp (most common)
- `SpaceL` = 24.dp
- `SpaceXL` = 32.dp

Component sizes:
- `ButtonHeight` = 48.dp
- `IconSize` = 24.dp
- `CardPadding` = 16.dp
- `MinTouchTarget` = 48.dp

---

## Validation Rules

1. **No Hardcoded Colors** - Always use `MaterialTheme.colorScheme.*`
2. **Minimum Touch Targets** - Interactive elements >= 48.dp
3. **Use Dimensions** - Reference `Dimensions.*` instead of raw dp values
4. **Accessibility** - Add `contentDescription` to icons and images
5. **Consistent APIs** - Follow component parameter patterns

---

## Need Help?

- See `DESIGN_AGENT_REPORT.md` for complete details
- See `DESIGN_SYSTEM_COMPLETE.md` for validation results
- Check individual component files for KDoc documentation
