package com.health2u.presentation.dashboard

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Bedtime
import androidx.compose.material.icons.outlined.Bloodtype
import androidx.compose.material.icons.filled.Event
import androidx.compose.material.icons.filled.Favorite
import androidx.compose.material.icons.filled.MonitorHeart
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Science
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Snackbar
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import coil.compose.AsyncImage
import com.health2u.domain.model.Appointment
import com.health2u.domain.model.Exam
import com.health2u.ui.components.cards.AppointmentCard
import com.health2u.ui.components.cards.ExamCard
import com.health2u.ui.components.cards.HealthSummaryCard
import com.health2u.ui.components.empty.CompactEmptyState
import com.health2u.ui.components.loading.FullScreenLoading
import com.health2u.ui.theme.CustomTypography
import com.health2u.ui.theme.Dimensions
import com.health2u.ui.theme.ExtendedColors

/**
 * Dashboard Screen
 *
 * The main landing screen of the Health2U app, displaying a summary of the
 * user's health data including health score, vitals, recent lab results,
 * AI-powered insights, and upcoming appointments.
 *
 * Layout (top to bottom):
 * 1. Top bar with user avatar, app title, and notification bell
 * 2. Health Score hero section with score, change description, and sync badge
 * 3. Bento grid of 4 vital sign cards (2x2)
 * 4. Recent Lab Results section with exam cards
 * 5. AI Prediction card with dark background
 * 6. Upcoming Checkups section with horizontal scrolling appointment cards
 *
 * @param onNavigateToProfile Callback when user taps their avatar
 * @param onNavigateToExamDetail Callback when user taps an exam card, receives exam ID
 * @param viewModel Dashboard ViewModel, injected via Hilt
 */
@Composable
fun DashboardScreen(
    onNavigateToProfile: () -> Unit,
    onNavigateToExamDetail: (String) -> Unit,
    viewModel: DashboardViewModel = hiltViewModel()
) {
    val state by viewModel.state.collectAsStateWithLifecycle()

    if (state.isLoading && state.vitals.isEmpty()) {
        FullScreenLoading(message = "Loading your health data...")
        return
    }

    Box(modifier = Modifier.fillMaxSize()) {
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .background(MaterialTheme.colorScheme.background),
            contentPadding = PaddingValues(bottom = Dimensions.SpaceXXL)
        ) {
            // Top Bar
            item(key = "top_bar") {
                DashboardTopBar(
                    userName = state.userName,
                    profilePictureUrl = state.profilePictureUrl,
                    onAvatarClick = onNavigateToProfile,
                    onNotificationClick = { /* TODO: navigate to notifications */ }
                )
            }

            // Health Score Hero
            item(key = "health_score") {
                HealthScoreHero(
                    score = state.healthScore,
                    changeDescription = state.healthScoreChange,
                    isSyncing = state.isSyncing
                )
            }

            // Vitals Bento Grid
            item(key = "vitals_header") {
                SectionHeader(
                    title = "Vitals",
                    modifier = Modifier.padding(
                        start = Dimensions.ScreenPaddingHorizontal,
                        end = Dimensions.ScreenPaddingHorizontal,
                        top = Dimensions.SectionSpacingM,
                        bottom = Dimensions.ContentSpacingS
                    )
                )
            }

            item(key = "vitals_grid") {
                VitalsBentoGrid(
                    vitals = state.vitals,
                    modifier = Modifier.padding(horizontal = Dimensions.ScreenPaddingHorizontal)
                )
            }

            // Recent Lab Results
            item(key = "lab_results_header") {
                SectionHeader(
                    title = "Recent Lab Results",
                    modifier = Modifier.padding(
                        start = Dimensions.ScreenPaddingHorizontal,
                        end = Dimensions.ScreenPaddingHorizontal,
                        top = Dimensions.SectionSpacingM,
                        bottom = Dimensions.ContentSpacingS
                    )
                )
            }

            if (state.recentExams.isEmpty()) {
                item(key = "lab_results_empty") {
                    CompactEmptyState(
                        icon = Icons.Filled.Science,
                        message = "No lab results yet",
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = Dimensions.ScreenPaddingHorizontal)
                    )
                }
            } else {
                items(
                    items = state.recentExams,
                    key = { exam -> exam.id }
                ) { exam ->
                    ExamCard(
                        title = exam.title,
                        examType = exam.type,
                        dateMillis = exam.date,
                        notes = exam.notes,
                        onClick = { onNavigateToExamDetail(exam.id) },
                        contentDescription = "${exam.title} exam from ${exam.type}",
                        modifier = Modifier.padding(
                            horizontal = Dimensions.ScreenPaddingHorizontal,
                            vertical = Dimensions.ContentSpacingXS
                        )
                    )
                }
            }

            // AI Prediction Card
            if (state.aiInsight != null) {
                item(key = "ai_prediction") {
                    AiPredictionCard(
                        insight = state.aiInsight!!,
                        onActionClick = { /* TODO: navigate to AI plan */ },
                        modifier = Modifier.padding(
                            start = Dimensions.ScreenPaddingHorizontal,
                            end = Dimensions.ScreenPaddingHorizontal,
                            top = Dimensions.SectionSpacingM
                        )
                    )
                }
            }

            // Upcoming Checkups
            item(key = "checkups_header") {
                SectionHeader(
                    title = "Upcoming Checkups",
                    modifier = Modifier.padding(
                        start = Dimensions.ScreenPaddingHorizontal,
                        end = Dimensions.ScreenPaddingHorizontal,
                        top = Dimensions.SectionSpacingM,
                        bottom = Dimensions.ContentSpacingS
                    )
                )
            }

            item(key = "checkups_list") {
                if (state.upcomingAppointments.isEmpty()) {
                    CompactEmptyState(
                        icon = Icons.Filled.Event,
                        message = "No upcoming checkups",
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = Dimensions.ScreenPaddingHorizontal)
                    )
                } else {
                    UpcomingCheckupsRow(
                        appointments = state.upcomingAppointments,
                        onAppointmentClick = { /* TODO: navigate to appointment detail */ }
                    )
                }
            }
        }

        // Error Snackbar
        if (state.error != null) {
            Snackbar(
                modifier = Modifier
                    .align(Alignment.BottomCenter)
                    .padding(Dimensions.ScreenPaddingHorizontal),
                action = {
                    Text(
                        text = "Dismiss",
                        modifier = Modifier.clickable { viewModel.dismissError() },
                        color = MaterialTheme.colorScheme.inversePrimary
                    )
                }
            ) {
                Text(text = state.error ?: "")
            }
        }
    }
}

// ============================================================
// Top Bar
// ============================================================

/**
 * Dashboard top bar with user avatar, app title, and notification icon.
 */
@Composable
private fun DashboardTopBar(
    userName: String,
    profilePictureUrl: String?,
    onAvatarClick: () -> Unit,
    onNotificationClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .padding(
                horizontal = Dimensions.ScreenPaddingHorizontal,
                vertical = Dimensions.SpaceM
            ),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(Dimensions.ContentSpacingS)
        ) {
            // User avatar
            Box(
                modifier = Modifier
                    .size(Dimensions.AvatarSizeM)
                    .clip(CircleShape)
                    .border(
                        width = Dimensions.BorderWidthMedium,
                        color = MaterialTheme.colorScheme.primary,
                        shape = CircleShape
                    )
                    .clickable(onClick = onAvatarClick)
                    .semantics { contentDescription = "Profile picture for $userName" },
                contentAlignment = Alignment.Center
            ) {
                if (profilePictureUrl != null) {
                    AsyncImage(
                        model = profilePictureUrl,
                        contentDescription = null,
                        modifier = Modifier
                            .size(Dimensions.AvatarSizeM)
                            .clip(CircleShape),
                        contentScale = ContentScale.Crop
                    )
                } else {
                    Icon(
                        imageVector = Icons.Filled.Person,
                        contentDescription = null,
                        modifier = Modifier.size(Dimensions.IconSizeL),
                        tint = MaterialTheme.colorScheme.primary
                    )
                }
            }

            // App title
            Text(
                text = "MYHEALTHHUB",
                style = MaterialTheme.typography.titleMedium.copy(
                    fontWeight = FontWeight.Bold,
                    letterSpacing = 1.5.sp
                ),
                color = MaterialTheme.colorScheme.onBackground
            )
        }

        // Notification bell
        IconButton(
            onClick = onNotificationClick,
            modifier = Modifier.semantics { contentDescription = "Notifications" }
        ) {
            Icon(
                imageVector = Icons.Filled.Notifications,
                contentDescription = null,
                tint = MaterialTheme.colorScheme.onBackground,
                modifier = Modifier.size(Dimensions.IconSize)
            )
        }
    }
}

// ============================================================
// Health Score Hero
// ============================================================

/**
 * Hero section displaying the overall health score prominently.
 * Shows score, description of changes, and a "Live Syncing" badge.
 */
@Composable
private fun HealthScoreHero(
    score: Int,
    changeDescription: String,
    isSyncing: Boolean,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = Dimensions.ScreenPaddingHorizontal),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.primaryContainer
        ),
        shape = RoundedCornerShape(Dimensions.CornerRadiusXL),
        elevation = CardDefaults.cardElevation(defaultElevation = Dimensions.ElevationS)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(Dimensions.CardPaddingL),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = "Your Health Score",
                style = MaterialTheme.typography.titleMedium,
                color = MaterialTheme.colorScheme.onPrimaryContainer
            )

            Spacer(modifier = Modifier.height(Dimensions.SpaceS))

            // Large score display
            Text(
                text = "$score/100",
                style = CustomTypography.healthMetricLarge,
                color = MaterialTheme.colorScheme.primary,
                modifier = Modifier.semantics {
                    contentDescription = "Health score: $score out of 100"
                }
            )

            Spacer(modifier = Modifier.height(Dimensions.SpaceS))

            // Change description
            Text(
                text = changeDescription,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onPrimaryContainer.copy(alpha = 0.8f),
                textAlign = TextAlign.Center,
                modifier = Modifier.padding(horizontal = Dimensions.SpaceM)
            )

            // Live Syncing badge
            if (isSyncing) {
                Spacer(modifier = Modifier.height(Dimensions.SpaceM))

                Box(
                    modifier = Modifier
                        .background(
                            color = ExtendedColors.success.copy(alpha = 0.15f),
                            shape = RoundedCornerShape(Dimensions.CornerRadiusFull)
                        )
                        .padding(
                            horizontal = Dimensions.SpaceM,
                            vertical = Dimensions.SpaceXS
                        )
                ) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(Dimensions.SpaceXS)
                    ) {
                        Box(
                            modifier = Modifier
                                .size(8.dp)
                                .background(
                                    color = ExtendedColors.success,
                                    shape = CircleShape
                                )
                        )
                        Text(
                            text = "Live Syncing",
                            style = MaterialTheme.typography.labelSmall,
                            color = ExtendedColors.success
                        )
                    }
                }
            }
        }
    }
}

// ============================================================
// Vitals Bento Grid
// ============================================================

/**
 * 2x2 grid of vital sign cards using [HealthSummaryCard].
 */
@Composable
private fun VitalsBentoGrid(
    vitals: List<VitalItem>,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier.fillMaxWidth(),
        verticalArrangement = Arrangement.spacedBy(Dimensions.ContentSpacingS)
    ) {
        vitals.chunked(2).forEach { rowVitals ->
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(Dimensions.ContentSpacingS)
            ) {
                rowVitals.forEach { vital ->
                    HealthSummaryCard(
                        title = vital.title,
                        value = vital.value,
                        unit = vital.unit,
                        icon = resolveVitalIcon(vital.iconName),
                        modifier = Modifier.weight(1f),
                        contentDescription = "${vital.title}: ${vital.value} ${vital.unit}"
                    )
                }
                // Fill remaining space if odd number of items in last row
                if (rowVitals.size == 1) {
                    Spacer(modifier = Modifier.weight(1f))
                }
            }
        }
    }
}

/**
 * Resolves a vital icon name to an [ImageVector].
 */
private fun resolveVitalIcon(iconName: String): ImageVector {
    return when (iconName) {
        "heart_rate" -> Icons.Filled.Favorite
        "blood_pressure" -> Icons.Filled.MonitorHeart
        "sleep" -> Icons.Filled.Bedtime
        "glucose" -> Icons.Outlined.Bloodtype
        else -> Icons.Filled.Favorite
    }
}

// ============================================================
// AI Prediction Card
// ============================================================

/**
 * Dark-themed card displaying an AI-generated health prediction
 * with a call-to-action button.
 */
@Composable
private fun AiPredictionCard(
    insight: AiInsight,
    onActionClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Card(
        modifier = modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.inverseSurface
        ),
        shape = RoundedCornerShape(Dimensions.CornerRadiusXL),
        elevation = CardDefaults.cardElevation(defaultElevation = Dimensions.ElevationM)
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(Dimensions.CardPaddingL)
        ) {
            Text(
                text = "AI Prediction",
                style = MaterialTheme.typography.labelMedium,
                color = MaterialTheme.colorScheme.inverseOnSurface.copy(alpha = 0.7f)
            )

            Spacer(modifier = Modifier.height(Dimensions.SpaceS))

            Text(
                text = insight.title,
                style = MaterialTheme.typography.titleLarge,
                color = MaterialTheme.colorScheme.inverseOnSurface
            )

            Spacer(modifier = Modifier.height(Dimensions.SpaceS))

            Text(
                text = insight.description,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.inverseOnSurface.copy(alpha = 0.8f),
                maxLines = 3,
                overflow = TextOverflow.Ellipsis
            )

            Spacer(modifier = Modifier.height(Dimensions.SpaceM))

            Button(
                onClick = onActionClick,
                colors = ButtonDefaults.buttonColors(
                    containerColor = MaterialTheme.colorScheme.inversePrimary,
                    contentColor = MaterialTheme.colorScheme.onPrimaryContainer
                ),
                shape = RoundedCornerShape(Dimensions.ButtonCornerRadius),
                modifier = Modifier.semantics {
                    contentDescription = insight.actionLabel
                }
            ) {
                Text(
                    text = insight.actionLabel,
                    style = MaterialTheme.typography.labelLarge
                )
            }
        }
    }
}

// ============================================================
// Upcoming Checkups
// ============================================================

/**
 * Horizontally scrollable row of upcoming appointment cards.
 */
@Composable
private fun UpcomingCheckupsRow(
    appointments: List<Appointment>,
    onAppointmentClick: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    LazyRow(
        modifier = modifier.fillMaxWidth(),
        contentPadding = PaddingValues(horizontal = Dimensions.ScreenPaddingHorizontal),
        horizontalArrangement = Arrangement.spacedBy(Dimensions.ContentSpacingS)
    ) {
        items(
            items = appointments,
            key = { it.id }
        ) { appointment ->
            AppointmentCard(
                title = appointment.title,
                doctorName = appointment.doctorName ?: "Doctor",
                dateTimeMillis = appointment.dateTime,
                location = appointment.location,
                status = appointment.status.name.lowercase()
                    .replaceFirstChar { it.uppercase() },
                description = appointment.description,
                onClick = { onAppointmentClick(appointment.id) },
                contentDescription = "Appointment: ${appointment.title} with ${appointment.doctorName}",
                modifier = Modifier.width(280.dp)
            )
        }
    }
}

// ============================================================
// Section Header
// ============================================================

/**
 * Reusable section header with title text.
 */
@Composable
private fun SectionHeader(
    title: String,
    modifier: Modifier = Modifier
) {
    Text(
        text = title,
        style = MaterialTheme.typography.titleLarge,
        color = MaterialTheme.colorScheme.onBackground,
        modifier = modifier
    )
}
