package com.health2u.presentation.settings

data class SettingsState(
    val notificationsEnabled: Boolean = true,
    val darkModeEnabled: Boolean = false,
    val appVersion: String = "1.0.0",
    val isLoading: Boolean = false,
    val isLoggingOut: Boolean = false,
    val error: String? = null
)
