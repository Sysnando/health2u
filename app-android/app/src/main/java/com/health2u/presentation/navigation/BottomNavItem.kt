package com.health2u.presentation.navigation

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Description
import androidx.compose.material.icons.filled.FolderShared
import androidx.compose.material.icons.filled.Insights
import androidx.compose.material.icons.filled.SpaceDashboard
import androidx.compose.material.icons.outlined.Description
import androidx.compose.material.icons.outlined.FolderShared
import androidx.compose.material.icons.outlined.Insights
import androidx.compose.material.icons.outlined.SpaceDashboard
import androidx.compose.ui.graphics.vector.ImageVector

sealed class BottomNavItem(
    val route: String,
    val title: String,
    val icon: ImageVector,
    val selectedIcon: ImageVector
) {
    object Home : BottomNavItem(
        route = Screen.Dashboard.route,
        title = "Home",
        icon = Icons.Outlined.SpaceDashboard,
        selectedIcon = Icons.Filled.SpaceDashboard
    )

    object Exams : BottomNavItem(
        route = Screen.Exams.route,
        title = "Exams",
        icon = Icons.Outlined.Description,
        selectedIcon = Icons.Filled.Description
    )

    object Insights : BottomNavItem(
        route = Screen.Insights.route,
        title = "Insights",
        icon = Icons.Outlined.Insights,
        selectedIcon = Icons.Filled.Insights
    )

    object Records : BottomNavItem(
        route = Screen.Profile.route,
        title = "Records",
        icon = Icons.Outlined.FolderShared,
        selectedIcon = Icons.Filled.FolderShared
    )

    companion object {
        val items = listOf(Home, Exams, Insights, Records)
    }
}
