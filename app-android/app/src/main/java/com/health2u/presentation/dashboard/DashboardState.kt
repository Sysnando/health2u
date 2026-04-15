package com.health2u.presentation.dashboard

import com.health2u.domain.model.Appointment
import com.health2u.domain.model.Exam

/**
 * Dashboard UI State
 *
 * Represents the complete state of the Dashboard screen.
 * Managed by [DashboardViewModel] and collected by [DashboardScreen].
 */
data class DashboardState(
    val userName: String = "",
    val profilePictureUrl: String? = null,
    val healthScore: Int = 0,
    val healthScoreChange: String = "",
    val isSyncing: Boolean = false,
    val vitals: List<VitalItem> = emptyList(),
    val recentExams: List<Exam> = emptyList(),
    val upcomingAppointments: List<Appointment> = emptyList(),
    val aiInsight: AiInsight? = null,
    val isLoading: Boolean = true,
    val error: String? = null
)

/**
 * Represents a single vital sign metric displayed in the bento grid.
 *
 * @param title Display name of the vital (e.g., "Heart Rate")
 * @param value Formatted value string (e.g., "72")
 * @param unit Measurement unit (e.g., "BPM")
 * @param iconName Icon identifier used to resolve the correct icon in the UI
 */
data class VitalItem(
    val title: String,
    val value: String,
    val unit: String,
    val iconName: String
)

/**
 * Represents an AI-generated health insight shown on the dashboard.
 *
 * @param title Insight headline (e.g., "Focus on Vitamin D")
 * @param description Detailed explanation of the insight
 * @param actionLabel Text for the call-to-action button (e.g., "Review Plan")
 */
data class AiInsight(
    val title: String,
    val description: String,
    val actionLabel: String
)
