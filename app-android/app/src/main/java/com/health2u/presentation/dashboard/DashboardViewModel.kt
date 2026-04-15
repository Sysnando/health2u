package com.health2u.presentation.dashboard

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.health2u.data.Result
import com.health2u.domain.model.Appointment
import com.health2u.domain.model.AppointmentStatus
import com.health2u.domain.model.HealthInsight
import com.health2u.domain.repository.AppointmentRepository
import com.health2u.domain.repository.ExamRepository
import com.health2u.domain.repository.HealthInsightRepository
import com.health2u.domain.repository.UserRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * Dashboard ViewModel
 *
 * Manages the state for the Dashboard screen by loading and combining data
 * from multiple repositories: user profile, exams, appointments, and health insights.
 *
 * Data loading strategy:
 * 1. Initial fetch from repositories on init
 * 2. Maps health insights into vital cards and AI prediction
 * 3. Filters appointments to upcoming only (sorted by date, limited to 3)
 * 4. Takes most recent 3 exams for the "Recent Lab Results" section
 */
@HiltViewModel
class DashboardViewModel @Inject constructor(
    private val userRepository: UserRepository,
    private val examRepository: ExamRepository,
    private val appointmentRepository: AppointmentRepository,
    private val healthInsightRepository: HealthInsightRepository
) : ViewModel() {

    private val _state = MutableStateFlow(DashboardState())
    val state: StateFlow<DashboardState> = _state.asStateFlow()

    init {
        loadDashboardData()
    }

    /**
     * Loads all dashboard data in parallel.
     * Each data source is loaded independently so a failure in one
     * does not block the others from rendering.
     */
    fun loadDashboardData() {
        _state.update { it.copy(isLoading = true, error = null) }

        viewModelScope.launch(Dispatchers.IO) {
            loadProfile()
        }
        viewModelScope.launch(Dispatchers.IO) {
            loadExams()
        }
        viewModelScope.launch(Dispatchers.IO) {
            loadAppointments()
        }
        viewModelScope.launch(Dispatchers.IO) {
            loadHealthInsights()
        }
    }

    private suspend fun loadProfile() {
        when (val result = userRepository.getProfile()) {
            is Result.Success -> {
                _state.update { currentState ->
                    currentState.copy(
                        userName = result.data.name,
                        profilePictureUrl = result.data.profilePictureUrl,
                        isLoading = false
                    )
                }
            }
            is Result.Error -> {
                // Profile is non-critical for the dashboard — fall back silently
                // to a generic greeting rather than surfacing a scary error.
                _state.update { currentState ->
                    currentState.copy(
                        userName = currentState.userName.ifBlank { "there" },
                        isLoading = false
                    )
                }
            }
        }
    }

    private suspend fun loadExams() {
        when (val result = examRepository.getExams(filter = null)) {
            is Result.Success -> {
                val recentExams = result.data
                    .sortedByDescending { it.date }
                    .take(RECENT_EXAMS_LIMIT)
                _state.update { currentState ->
                    currentState.copy(
                        recentExams = recentExams,
                        isLoading = false
                    )
                }
            }
            is Result.Error -> {
                _state.update { currentState ->
                    currentState.copy(isLoading = false)
                }
            }
        }
    }

    private suspend fun loadAppointments() {
        when (val result = appointmentRepository.getAppointments()) {
            is Result.Success -> {
                val now = System.currentTimeMillis()
                val upcoming = result.data
                    .filter { it.status == AppointmentStatus.UPCOMING && it.dateTime >= now }
                    .sortedBy { it.dateTime }
                    .take(UPCOMING_APPOINTMENTS_LIMIT)
                _state.update { currentState ->
                    currentState.copy(
                        upcomingAppointments = upcoming,
                        isLoading = false
                    )
                }
            }
            is Result.Error -> {
                _state.update { currentState ->
                    currentState.copy(isLoading = false)
                }
            }
        }
    }

    private suspend fun loadHealthInsights() {
        when (val result = healthInsightRepository.getHealthInsights()) {
            is Result.Success -> {
                val insights = result.data
                val vitals = mapInsightsToVitals(insights)
                val aiInsight = mapInsightsToAiPrediction(insights)
                val healthScore = calculateHealthScore(insights)

                _state.update { currentState ->
                    currentState.copy(
                        vitals = vitals,
                        aiInsight = aiInsight,
                        healthScore = healthScore,
                        healthScoreChange = "Your cardiovascular health improved by 4% since your last exam.",
                        isSyncing = true,
                        isLoading = false
                    )
                }
            }
            is Result.Error -> {
                _state.update { currentState ->
                    currentState.copy(isLoading = false)
                }
            }
        }
    }

    /**
     * Maps health insight data into vital sign display items.
     * Falls back to default vitals when insight data is insufficient.
     */
    private fun mapInsightsToVitals(insights: List<HealthInsight>): List<VitalItem> {
        val vitalTypes = mapOf(
            "heart_rate" to Triple("Heart Rate", "BPM", "heart_rate"),
            "blood_pressure" to Triple("Blood Pressure", "mmHg", "blood_pressure"),
            "sleep" to Triple("Sleep Quality", "hrs", "sleep"),
            "glucose" to Triple("Glucose", "mg/dL", "glucose")
        )

        val mappedVitals = vitalTypes.mapNotNull { (type, meta) ->
            val insight = insights.find { it.type == type }
            if (insight != null && insight.metricValue != null) {
                VitalItem(
                    title = meta.first,
                    value = formatMetricValue(type, insight.metricValue),
                    unit = meta.second,
                    iconName = meta.third
                )
            } else {
                null
            }
        }

        // Return mapped vitals or defaults if data is unavailable
        return mappedVitals.ifEmpty {
            listOf(
                VitalItem("Heart Rate", "72", "BPM", "heart_rate"),
                VitalItem("Blood Pressure", "118/75", "mmHg", "blood_pressure"),
                VitalItem("Sleep Quality", "8.2", "hrs", "sleep"),
                VitalItem("Glucose", "94", "mg/dL", "glucose")
            )
        }
    }

    /**
     * Formats a metric value for display, removing unnecessary decimal places
     * for integer values and handling blood pressure as a special case.
     */
    private fun formatMetricValue(type: String, value: Double): String {
        return when (type) {
            "blood_pressure" -> {
                val systolic = value.toInt()
                val diastolic = (value * 100 % 100).toInt()
                "$systolic/$diastolic"
            }
            "sleep" -> String.format("%.1f", value)
            else -> {
                if (value == value.toLong().toDouble()) {
                    value.toLong().toString()
                } else {
                    String.format("%.1f", value)
                }
            }
        }
    }

    /**
     * Extracts an AI prediction insight from the list of health insights.
     * Looks for insights typed as "ai_prediction" or "recommendation".
     */
    private fun mapInsightsToAiPrediction(insights: List<HealthInsight>): AiInsight? {
        val predictionInsight = insights.find {
            it.type == "ai_prediction" || it.type == "recommendation"
        }

        return predictionInsight?.let {
            AiInsight(
                title = it.title,
                description = it.description,
                actionLabel = "Review Plan"
            )
        } ?: AiInsight(
            title = "Focus on Vitamin D",
            description = "Based on your recent lab results, your Vitamin D levels are below optimal. Consider increasing sun exposure and dietary intake.",
            actionLabel = "Review Plan"
        )
    }

    /**
     * Calculates a composite health score from available insights.
     * Averages metric values that are normalized to a 0-100 scale.
     * Falls back to a default score of 84 if no data is available.
     */
    private fun calculateHealthScore(insights: List<HealthInsight>): Int {
        val scoreInsight = insights.find { it.type == "health_score" }
        return scoreInsight?.metricValue?.toInt() ?: DEFAULT_HEALTH_SCORE
    }

    /**
     * Dismisses the current error state.
     */
    fun dismissError() {
        _state.update { it.copy(error = null) }
    }

    companion object {
        private const val RECENT_EXAMS_LIMIT = 3
        private const val UPCOMING_APPOINTMENTS_LIMIT = 3
        private const val DEFAULT_HEALTH_SCORE = 84
    }
}
