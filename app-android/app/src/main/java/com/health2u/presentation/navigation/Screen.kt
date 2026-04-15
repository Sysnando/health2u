package com.health2u.presentation.navigation

sealed class Screen(val route: String) {
    // Auth Flow
    object Welcome : Screen("welcome")
    object Login : Screen("login")
    object Onboarding : Screen("onboarding")

    // Main App (container with bottom nav)
    object Main : Screen("main")
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
