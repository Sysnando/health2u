package com.health2u.presentation.insights

import com.health2u.domain.model.HealthInsight

/**
 * Insights UI State
 *
 * Represents the complete state of the Health Insights screen.
 * Managed by [InsightsViewModel] and collected by [InsightsScreen].
 */
data class InsightsState(
    val insights: List<HealthInsight> = emptyList(),
    val metabolicScore: Int = 0,
    val longevityScore: Int = 0,
    val trendData: List<Float> = emptyList(),
    val changeIndicators: List<ChangeIndicator> = emptyList(),
    val activityIndicators: List<ActivityIndicator> = emptyList(),
    val weeklyData: List<Float> = emptyList(),
    val recentReports: List<RecentReport> = emptyList(),
    val isLoading: Boolean = true,
    val error: String? = null
)

/**
 * Represents a percentage change indicator displayed in the metabolic section.
 *
 * @param label Display label (e.g., "Glucose")
 * @param changePercent Percentage change value (positive or negative)
 */
data class ChangeIndicator(
    val label: String,
    val changePercent: Float
)

/**
 * Represents an activity metric with a colored indicator dot.
 *
 * @param label Display label (e.g., "Cardio", "Sleep")
 * @param value Display value (e.g., "85", "13h")
 * @param colorIndex Index into ExtendedColors.chart1..chart6 palette
 */
data class ActivityIndicator(
    val label: String,
    val value: String,
    val colorIndex: Int
)

/**
 * Represents a report item in the Recent Reports section.
 *
 * @param id Unique identifier
 * @param title Report title (e.g., "Annual Physical Summary")
 * @param date Formatted date string
 * @param type Report type identifier
 */
data class RecentReport(
    val id: String,
    val title: String,
    val date: String,
    val type: String
)
