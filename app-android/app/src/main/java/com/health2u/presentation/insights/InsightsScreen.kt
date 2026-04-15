package com.health2u.presentation.insights

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowDropDown
import androidx.compose.material.icons.filled.Description
import androidx.compose.material.icons.filled.Insights
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.health2u.ui.components.empty.EmptyState
import com.health2u.ui.components.loading.FullScreenLoading
import com.health2u.ui.theme.CustomTypography
import com.health2u.ui.theme.Dimensions
import com.health2u.ui.theme.ExtendedColors

/**
 * Health Insights Screen
 *
 * Displays comprehensive health analytics including metabolic stability score,
 * predictive longevity score, trend charts, activity indicators, and recent reports.
 *
 * Layout (LazyColumn):
 * 1. Header with app name and settings icon
 * 2. "Health Insights" title with date range selector
 * 3. Metabolic Stability section with bar chart
 * 4. Change indicator chips
 * 5. Predictive Longevity Score card (dark background)
 * 6. Score display with activity indicators
 * 7. Weekly bar chart
 * 8. Recent Reports section
 *
 * @param viewModel ViewModel providing [InsightsState]
 */
@Composable
fun InsightsScreen(
    viewModel: InsightsViewModel = hiltViewModel()
) {
    val state by viewModel.state.collectAsStateWithLifecycle()

    when {
        state.isLoading -> {
            FullScreenLoading(
                message = "Loading health insights...",
                contentDescription = "Loading health insights"
            )
        }
        state.error != null -> {
            EmptyState(
                icon = Icons.Filled.Insights,
                title = "Unable to load insights",
                description = state.error ?: "An unexpected error occurred",
                actionText = "Retry",
                onActionClick = { viewModel.loadInsights() }
            )
        }
        state.insights.isEmpty() -> {
            EmptyState(
                icon = Icons.Filled.Insights,
                title = "No insights yet",
                description = "Upload your health data to receive personalized insights"
            )
        }
        else -> {
            InsightsContent(state = state)
        }
    }
}

@Composable
private fun InsightsContent(state: InsightsState) {
    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .padding(horizontal = Dimensions.ScreenPaddingHorizontal),
        verticalArrangement = Arrangement.spacedBy(Dimensions.ContentSpacingM)
    ) {
        // Header
        item(key = "header") {
            InsightsHeader()
        }

        // Health Insights title with date range
        item(key = "title") {
            InsightsTitle()
        }

        // Metabolic Stability section
        item(key = "metabolic") {
            MetabolicStabilitySection(
                score = state.metabolicScore,
                trendData = state.trendData
            )
        }

        // Change indicator chips
        item(key = "changes") {
            if (state.changeIndicators.isNotEmpty()) {
                ChangeIndicatorsRow(indicators = state.changeIndicators)
            }
        }

        // Predictive Longevity Score card
        item(key = "longevity") {
            PredictiveLongevityCard(score = state.longevityScore)
        }

        // Activity indicators
        item(key = "activity") {
            if (state.activityIndicators.isNotEmpty()) {
                ActivityIndicatorsRow(indicators = state.activityIndicators)
            }
        }

        // Weekly bar chart
        item(key = "weekly_chart") {
            if (state.weeklyData.isNotEmpty()) {
                WeeklyBarChart(data = state.weeklyData)
            }
        }

        // Recent Reports header
        item(key = "reports_header") {
            if (state.recentReports.isNotEmpty()) {
                Spacer(modifier = Modifier.height(Dimensions.SpaceS))
                Text(
                    text = "Recent Reports",
                    style = MaterialTheme.typography.titleLarge,
                    color = MaterialTheme.colorScheme.onBackground
                )
            }
        }

        // Recent Reports list
        items(
            items = state.recentReports,
            key = { it.id }
        ) { report ->
            RecentReportItem(report = report)
        }

        // Bottom spacing for navigation bar clearance
        item(key = "bottom_spacer") {
            Spacer(modifier = Modifier.height(Dimensions.BottomNavHeight))
        }
    }
}

// ============================================================
// HEADER
// ============================================================

@Composable
private fun InsightsHeader() {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(top = Dimensions.ScreenPaddingTop),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = "MYHEALTHHUB",
            style = MaterialTheme.typography.labelMedium.copy(
                fontWeight = FontWeight.Bold,
                letterSpacing = CustomTypography.overline.letterSpacing
            ),
            color = MaterialTheme.colorScheme.primary
        )

        IconButton(
            onClick = { /* Navigate to settings */ },
            modifier = Modifier.semantics {
                contentDescription = "Settings"
            }
        ) {
            Icon(
                imageVector = Icons.Filled.Settings,
                contentDescription = null,
                tint = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}

@Composable
private fun InsightsTitle() {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = "Health Insights",
            style = MaterialTheme.typography.headlineLarge,
            color = MaterialTheme.colorScheme.onBackground
        )

        TextButton(onClick = { /* Open date range picker */ }) {
            Text(
                text = "This Month",
                style = MaterialTheme.typography.labelLarge,
                color = MaterialTheme.colorScheme.primary
            )
            Icon(
                imageVector = Icons.Filled.ArrowDropDown,
                contentDescription = "Select date range",
                tint = MaterialTheme.colorScheme.primary
            )
        }
    }
}

// ============================================================
// METABOLIC STABILITY
// ============================================================

@Composable
private fun MetabolicStabilitySection(
    score: Int,
    trendData: List<Float>
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(Dimensions.CardCornerRadius),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surface
        ),
        elevation = CardDefaults.cardElevation(
            defaultElevation = Dimensions.CardElevation
        )
    ) {
        Column(
            modifier = Modifier.padding(Dimensions.CardPadding)
        ) {
            Text(
                text = "Metabolic Stability",
                style = MaterialTheme.typography.titleMedium,
                color = MaterialTheme.colorScheme.onSurface
            )

            Spacer(modifier = Modifier.height(Dimensions.SpaceS))

            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.Bottom
            ) {
                // Score display
                Column {
                    Text(
                        text = "$score",
                        style = CustomTypography.healthMetricLarge,
                        color = MaterialTheme.colorScheme.primary
                    )
                    Text(
                        text = "/100",
                        style = MaterialTheme.typography.titleMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }

                Spacer(modifier = Modifier.width(Dimensions.SpaceL))

                // Trend bar chart
                if (trendData.isNotEmpty()) {
                    TrendBarChart(
                        data = trendData,
                        modifier = Modifier
                            .weight(1f)
                            .height(80.dp)
                    )
                }
            }
        }
    }
}

/**
 * Draws a simple bar chart using Canvas for trend visualization.
 *
 * @param data List of float values to render as bars
 * @param modifier Modifier for sizing
 */
@Composable
private fun TrendBarChart(
    data: List<Float>,
    modifier: Modifier = Modifier
) {
    val barColor = MaterialTheme.colorScheme.primary
    val barColorLight = MaterialTheme.colorScheme.primaryContainer

    Canvas(
        modifier = modifier.semantics {
            contentDescription = "Metabolic trend chart with ${data.size} data points"
        }
    ) {
        if (data.isEmpty()) return@Canvas

        val maxValue = data.max().coerceAtLeast(1f)
        val barCount = data.size
        val totalSpacing = (barCount - 1) * 4.dp.toPx()
        val barWidth = (size.width - totalSpacing) / barCount
        val cornerRadiusPx = 4.dp.toPx()

        data.forEachIndexed { index, value ->
            val barHeight = (value / maxValue) * size.height
            val x = index * (barWidth + 4.dp.toPx())
            val y = size.height - barHeight

            val isHighlighted = index == data.lastIndex
            drawRoundRect(
                color = if (isHighlighted) barColor else barColorLight,
                topLeft = Offset(x, y),
                size = Size(barWidth, barHeight),
                cornerRadius = CornerRadius(cornerRadiusPx, cornerRadiusPx)
            )
        }
    }
}

// ============================================================
// CHANGE INDICATORS
// ============================================================

@Composable
private fun ChangeIndicatorsRow(indicators: List<ChangeIndicator>) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(Dimensions.ContentSpacingS)
    ) {
        indicators.forEach { indicator ->
            ChangeIndicatorChip(indicator = indicator)
        }
    }
}

@Composable
private fun ChangeIndicatorChip(indicator: ChangeIndicator) {
    val isPositive = indicator.changePercent >= 0
    val chipColor = if (isPositive) {
        ExtendedColors.successContainer
    } else {
        MaterialTheme.colorScheme.errorContainer
    }
    val textColor = if (isPositive) {
        ExtendedColors.onSuccessContainer
    } else {
        MaterialTheme.colorScheme.onErrorContainer
    }

    val sign = if (isPositive) "+" else ""
    val formattedChange = "$sign%.1f%%".format(indicator.changePercent)

    Card(
        shape = RoundedCornerShape(Dimensions.CornerRadiusFull),
        colors = CardDefaults.cardColors(containerColor = chipColor),
        elevation = CardDefaults.cardElevation(defaultElevation = Dimensions.ElevationNone)
    ) {
        Column(
            modifier = Modifier.padding(
                horizontal = Dimensions.SpaceM,
                vertical = Dimensions.SpaceS
            ),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = formattedChange,
                style = MaterialTheme.typography.labelLarge.copy(fontWeight = FontWeight.Bold),
                color = textColor
            )
            Text(
                text = indicator.label,
                style = MaterialTheme.typography.labelSmall,
                color = textColor.copy(alpha = 0.8f)
            )
        }
    }
}

// ============================================================
// PREDICTIVE LONGEVITY SCORE
// ============================================================

@Composable
private fun PredictiveLongevityCard(score: Int) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(Dimensions.CardCornerRadius),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.inverseSurface
        ),
        elevation = CardDefaults.cardElevation(
            defaultElevation = Dimensions.CardElevation
        )
    ) {
        Column(
            modifier = Modifier.padding(Dimensions.CardPaddingL)
        ) {
            Text(
                text = "Predictive Longevity Score",
                style = MaterialTheme.typography.titleMedium,
                color = MaterialTheme.colorScheme.inverseOnSurface
            )

            Spacer(modifier = Modifier.height(Dimensions.SpaceS))

            Text(
                text = "Based on your current health metrics and lifestyle patterns, " +
                    "your longevity indicators show positive trends.",
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.inverseOnSurface.copy(alpha = 0.7f)
            )

            Spacer(modifier = Modifier.height(Dimensions.SpaceM))

            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Column {
                    Text(
                        text = "$score",
                        style = CustomTypography.healthMetricLarge,
                        color = MaterialTheme.colorScheme.inversePrimary
                    )
                    Text(
                        text = "Cardio",
                        style = MaterialTheme.typography.labelMedium,
                        color = MaterialTheme.colorScheme.inverseOnSurface.copy(alpha = 0.7f)
                    )
                }

                Column(horizontalAlignment = Alignment.End) {
                    Text(
                        text = "6.2 percentile improvement",
                        style = MaterialTheme.typography.labelLarge,
                        color = ExtendedColors.success
                    )

                    Spacer(modifier = Modifier.height(Dimensions.SpaceS))

                    TextButton(onClick = { /* Navigate to longevity details */ }) {
                        Text(
                            text = "Explore Details",
                            style = MaterialTheme.typography.labelLarge.copy(
                                fontWeight = FontWeight.Bold
                            ),
                            color = MaterialTheme.colorScheme.inversePrimary
                        )
                    }
                }
            }
        }
    }
}

// ============================================================
// ACTIVITY INDICATORS
// ============================================================

@Composable
private fun ActivityIndicatorsRow(indicators: List<ActivityIndicator>) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceEvenly
    ) {
        indicators.forEach { indicator ->
            ActivityIndicatorItem(indicator = indicator)
        }
    }
}

@Composable
private fun ActivityIndicatorItem(indicator: ActivityIndicator) {
    val dotColor = getChartColor(indicator.colorIndex)

    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = Modifier.semantics {
            contentDescription = "${indicator.label}: ${indicator.value}"
        }
    ) {
        Box(
            modifier = Modifier
                .size(Dimensions.BadgeSizeS)
                .clip(CircleShape)
                .background(dotColor)
        )

        Spacer(modifier = Modifier.height(Dimensions.SpaceXS))

        Text(
            text = indicator.value,
            style = CustomTypography.healthMetricMedium,
            color = MaterialTheme.colorScheme.onBackground
        )

        Text(
            text = indicator.label,
            style = MaterialTheme.typography.labelSmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

/**
 * Maps a color index to one of the extended chart colors.
 */
private fun getChartColor(index: Int): Color {
    return when (index % 6) {
        0 -> ExtendedColors.chart1
        1 -> ExtendedColors.chart2
        2 -> ExtendedColors.chart3
        3 -> ExtendedColors.chart4
        4 -> ExtendedColors.chart5
        5 -> ExtendedColors.chart6
        else -> ExtendedColors.chart1
    }
}

// ============================================================
// WEEKLY BAR CHART
// ============================================================

@Composable
private fun WeeklyBarChart(data: List<Float>) {
    val dayLabels = listOf("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")

    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(Dimensions.CardCornerRadius),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surface
        ),
        elevation = CardDefaults.cardElevation(
            defaultElevation = Dimensions.CardElevation
        )
    ) {
        Column(
            modifier = Modifier.padding(Dimensions.CardPadding)
        ) {
            Text(
                text = "Weekly Overview",
                style = MaterialTheme.typography.titleMedium,
                color = MaterialTheme.colorScheme.onSurface
            )

            Spacer(modifier = Modifier.height(Dimensions.SpaceM))

            // Bar chart drawn with Canvas
            val primaryColor = MaterialTheme.colorScheme.primary
            val secondaryColor = MaterialTheme.colorScheme.secondaryContainer

            Canvas(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(120.dp)
                    .semantics {
                        contentDescription = "Weekly health data chart with ${data.size} days"
                    }
            ) {
                if (data.isEmpty()) return@Canvas

                val maxValue = data.max().coerceAtLeast(1f)
                val barCount = data.size.coerceAtMost(7)
                val spacing = 12.dp.toPx()
                val totalSpacing = (barCount - 1) * spacing
                val barWidth = (size.width - totalSpacing) / barCount
                val cornerRadiusPx = 6.dp.toPx()

                for (i in 0 until barCount) {
                    val value = data[i]
                    val barHeight = (value / maxValue) * size.height * 0.9f
                    val x = i * (barWidth + spacing)
                    val y = size.height - barHeight

                    val isToday = i == barCount - 1
                    drawRoundRect(
                        color = if (isToday) primaryColor else secondaryColor,
                        topLeft = Offset(x, y),
                        size = Size(barWidth, barHeight),
                        cornerRadius = CornerRadius(cornerRadiusPx, cornerRadiusPx)
                    )
                }
            }

            Spacer(modifier = Modifier.height(Dimensions.SpaceS))

            // Day labels
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceEvenly
            ) {
                val displayCount = data.size.coerceAtMost(7)
                for (i in 0 until displayCount) {
                    Text(
                        text = dayLabels[i % dayLabels.size],
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        textAlign = TextAlign.Center,
                        modifier = Modifier.weight(1f)
                    )
                }
            }
        }
    }
}

// ============================================================
// RECENT REPORTS
// ============================================================

@Composable
private fun RecentReportItem(report: RecentReport) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(Dimensions.CardCornerRadius),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surface
        ),
        elevation = CardDefaults.cardElevation(
            defaultElevation = Dimensions.ElevationS
        )
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(Dimensions.CardPadding),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Report icon
            Box(
                modifier = Modifier
                    .size(Dimensions.IconSizeXL)
                    .clip(RoundedCornerShape(Dimensions.CornerRadiusM))
                    .background(MaterialTheme.colorScheme.primaryContainer),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Filled.Description,
                    contentDescription = null,
                    modifier = Modifier.size(Dimensions.IconSize),
                    tint = MaterialTheme.colorScheme.primary
                )
            }

            Spacer(modifier = Modifier.width(Dimensions.SpaceM))

            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = report.title,
                    style = MaterialTheme.typography.titleSmall,
                    color = MaterialTheme.colorScheme.onSurface
                )

                Spacer(modifier = Modifier.height(Dimensions.SpaceXXS))

                Text(
                    text = report.date,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
    }
}
