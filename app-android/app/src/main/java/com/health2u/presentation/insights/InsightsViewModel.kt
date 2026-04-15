package com.health2u.presentation.insights

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.health2u.data.Result
import com.health2u.domain.model.HealthInsight
import com.health2u.domain.repository.HealthInsightRepository
import com.health2u.util.ErrorMapper
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * Insights ViewModel
 *
 * Manages the state of the Health Insights screen.
 * Loads health insights from the repository and computes derived metrics
 * such as metabolic score, longevity score, trend data, and activity indicators.
 */
@HiltViewModel
class InsightsViewModel @Inject constructor(
    private val healthInsightRepository: HealthInsightRepository
) : ViewModel() {

    private val _state = MutableStateFlow(InsightsState())
    val state: StateFlow<InsightsState> = _state.asStateFlow()

    init {
        loadInsights()
        observeInsights()
    }

    /**
     * Loads health insights from the repository and computes all derived UI state.
     */
    fun loadInsights() {
        viewModelScope.launch {
            _state.update { it.copy(isLoading = true, error = null) }

            when (val result = healthInsightRepository.getHealthInsights()) {
                is Result.Success -> {
                    val insights = result.data
                    _state.update {
                        it.copy(
                            insights = insights,
                            metabolicScore = computeMetabolicScore(insights),
                            longevityScore = computeLongevityScore(insights),
                            trendData = computeTrendData(insights),
                            changeIndicators = computeChangeIndicators(insights),
                            activityIndicators = computeActivityIndicators(insights),
                            weeklyData = computeWeeklyData(insights),
                            recentReports = computeRecentReports(insights),
                            isLoading = false,
                            error = null
                        )
                    }
                }
                is Result.Error -> {
                    _state.update {
                        it.copy(
                            isLoading = false,
                            error = ErrorMapper.toUserMessage(result.exception)
                        )
                    }
                }
            }
        }
    }

    /**
     * Observes real-time insight updates from the local data source.
     */
    private fun observeInsights() {
        viewModelScope.launch {
            healthInsightRepository.observeHealthInsights().collect { insights ->
                _state.update {
                    it.copy(
                        insights = insights,
                        metabolicScore = computeMetabolicScore(insights),
                        longevityScore = computeLongevityScore(insights),
                        trendData = computeTrendData(insights),
                        changeIndicators = computeChangeIndicators(insights),
                        activityIndicators = computeActivityIndicators(insights),
                        weeklyData = computeWeeklyData(insights),
                        recentReports = computeRecentReports(insights)
                    )
                }
            }
        }
    }

    /**
     * Computes metabolic stability score from metabolic-type insights.
     * Score is clamped between 0 and 100.
     */
    private fun computeMetabolicScore(insights: List<HealthInsight>): Int {
        val metabolicInsights = insights.filter { it.type == "metabolic" }
        if (metabolicInsights.isEmpty()) return 0

        val avgValue = metabolicInsights
            .mapNotNull { it.metricValue }
            .average()

        return avgValue.toInt().coerceIn(0, 100)
    }

    /**
     * Computes predictive longevity score from longevity-type insights.
     * Score is clamped between 0 and 100.
     */
    private fun computeLongevityScore(insights: List<HealthInsight>): Int {
        val longevityInsights = insights.filter { it.type == "longevity" }
        if (longevityInsights.isEmpty()) return 0

        val avgValue = longevityInsights
            .mapNotNull { it.metricValue }
            .average()

        return avgValue.toInt().coerceIn(0, 100)
    }

    /**
     * Builds a list of float values representing the trend line for the bar chart.
     * Uses the most recent insights sorted by timestamp.
     */
    private fun computeTrendData(insights: List<HealthInsight>): List<Float> {
        return insights
            .filter { it.metricValue != null }
            .sortedBy { it.timestamp }
            .takeLast(TREND_DATA_POINTS)
            .map { it.metricValue?.toFloat() ?: 0f }
    }

    /**
     * Computes change indicator chips from insights grouped by type.
     * Shows the percentage change for key health categories.
     */
    private fun computeChangeIndicators(insights: List<HealthInsight>): List<ChangeIndicator> {
        val types = listOf("glucose" to "Glucose", "cholesterol" to "Cholesterol", "bp" to "Blood Pressure")

        return types.mapNotNull { (type, label) ->
            val typeInsights = insights
                .filter { it.type == type }
                .sortedBy { it.timestamp }

            if (typeInsights.size >= 2) {
                val previous = typeInsights[typeInsights.size - 2].metricValue ?: return@mapNotNull null
                val current = typeInsights.last().metricValue ?: return@mapNotNull null
                if (previous == 0.0) return@mapNotNull null

                val change = ((current - previous) / previous * 100).toFloat()
                ChangeIndicator(label = label, changePercent = change)
            } else {
                null
            }
        }
    }

    /**
     * Builds activity indicators from the latest insight of each activity type.
     */
    private fun computeActivityIndicators(insights: List<HealthInsight>): List<ActivityIndicator> {
        val activityTypes = listOf(
            Triple("cardio", "Cardio", 0),
            Triple("sleep", "Sleep", 1),
            Triple("recovery", "Recovery", 2),
            Triple("stress", "Stress", 3)
        )

        return activityTypes.mapNotNull { (type, label, colorIndex) ->
            val latest = insights
                .filter { it.type == type }
                .maxByOrNull { it.timestamp }

            latest?.let {
                val displayValue = when (type) {
                    "sleep" -> "${it.metricValue?.toInt() ?: 0}h"
                    else -> "${it.metricValue?.toInt() ?: 0}"
                }
                ActivityIndicator(label = label, value = displayValue, colorIndex = colorIndex)
            }
        }
    }

    /**
     * Computes weekly bar chart data from the 7 most recent data points.
     */
    private fun computeWeeklyData(insights: List<HealthInsight>): List<Float> {
        return insights
            .filter { it.metricValue != null }
            .sortedBy { it.timestamp }
            .takeLast(WEEKLY_DATA_POINTS)
            .map { it.metricValue?.toFloat() ?: 0f }
    }

    /**
     * Extracts recent report entries from report-type insights.
     */
    private fun computeRecentReports(insights: List<HealthInsight>): List<RecentReport> {
        return insights
            .filter { it.type == "report" }
            .sortedByDescending { it.createdAt }
            .take(MAX_RECENT_REPORTS)
            .map { insight ->
                RecentReport(
                    id = insight.id,
                    title = insight.title,
                    date = formatReportDate(insight.createdAt),
                    type = insight.type
                )
            }
    }

    /**
     * Formats a timestamp to a readable date string for report display.
     */
    private fun formatReportDate(timestamp: Long): String {
        val formatter = java.text.SimpleDateFormat("MMM dd, yyyy", java.util.Locale.getDefault())
        return formatter.format(java.util.Date(timestamp))
    }

    companion object {
        private const val TREND_DATA_POINTS = 12
        private const val WEEKLY_DATA_POINTS = 7
        private const val MAX_RECENT_REPORTS = 5
    }
}
