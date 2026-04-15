package com.health2u.presentation.main

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AddAPhoto
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationBarItemDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavDestination.Companion.hierarchy
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.health2u.presentation.dashboard.DashboardScreen
import com.health2u.presentation.exams.ExamsScreen
import com.health2u.presentation.insights.InsightsScreen
import com.health2u.presentation.navigation.BottomNavItem
import com.health2u.presentation.navigation.Screen
import com.health2u.presentation.profile.ProfileScreen
import com.health2u.ui.theme.Dimensions

@Composable
fun MainScreen(
    outerNavController: NavHostController,
    modifier: Modifier = Modifier
) {
    val innerNavController = rememberNavController()
    val navBackStackEntry by innerNavController.currentBackStackEntryAsState()
    val currentDestination = navBackStackEntry?.destination

    Scaffold(
        modifier = modifier.fillMaxSize(),
        bottomBar = {
            NavigationBar(
                containerColor = MaterialTheme.colorScheme.surface.copy(alpha = 0.95f),
                tonalElevation = 0.dp
            ) {
                val items = listOf(
                    BottomNavItem.Home,
                    BottomNavItem.Exams,
                    null, // placeholder for FAB
                    BottomNavItem.Insights,
                    BottomNavItem.Records
                )

                items.forEach { item ->
                    if (item == null) {
                        // Center FAB spacer
                        NavigationBarItem(
                            selected = false,
                            onClick = { outerNavController.navigate(Screen.Upload.route) },
                            icon = {
                                FloatingActionButton(
                                    onClick = { outerNavController.navigate(Screen.Upload.route) },
                                    containerColor = MaterialTheme.colorScheme.primary,
                                    contentColor = MaterialTheme.colorScheme.onPrimary,
                                    shape = CircleShape,
                                    modifier = Modifier.size(56.dp)
                                ) {
                                    Icon(
                                        imageVector = Icons.Filled.AddAPhoto,
                                        contentDescription = "AI Upload",
                                        modifier = Modifier.size(28.dp)
                                    )
                                }
                            },
                            label = {
                                Text(
                                    text = "AI Upload",
                                    fontSize = 10.sp,
                                    style = MaterialTheme.typography.labelSmall
                                )
                            },
                            colors = NavigationBarItemDefaults.colors(
                                indicatorColor = MaterialTheme.colorScheme.surface
                            )
                        )
                    } else {
                        val selected = currentDestination?.hierarchy?.any { it.route == item.route } == true
                        NavigationBarItem(
                            selected = selected,
                            onClick = {
                                innerNavController.navigate(item.route) {
                                    popUpTo(innerNavController.graph.findStartDestination().id) {
                                        saveState = true
                                    }
                                    launchSingleTop = true
                                    restoreState = true
                                }
                            },
                            icon = {
                                Icon(
                                    imageVector = if (selected) item.selectedIcon else item.icon,
                                    contentDescription = item.title
                                )
                            },
                            label = {
                                Text(
                                    text = item.title,
                                    fontSize = 10.sp,
                                    style = MaterialTheme.typography.labelSmall
                                )
                            },
                            colors = NavigationBarItemDefaults.colors(
                                selectedIconColor = MaterialTheme.colorScheme.primary,
                                selectedTextColor = MaterialTheme.colorScheme.primary,
                                unselectedIconColor = MaterialTheme.colorScheme.onSurfaceVariant,
                                unselectedTextColor = MaterialTheme.colorScheme.onSurfaceVariant,
                                indicatorColor = MaterialTheme.colorScheme.primaryContainer.copy(alpha = 0.3f)
                            )
                        )
                    }
                }
            }
        }
    ) { innerPadding ->
        NavHost(
            navController = innerNavController,
            startDestination = Screen.Dashboard.route,
            modifier = Modifier.padding(innerPadding)
        ) {
            composable(Screen.Dashboard.route) {
                DashboardScreen(
                    onNavigateToProfile = {
                        outerNavController.navigate(Screen.Profile.route)
                    },
                    onNavigateToExamDetail = { examId ->
                        outerNavController.navigate(Screen.ExamDetail.createRoute(examId))
                    }
                )
            }
            composable(Screen.Exams.route) {
                ExamsScreen(
                    onNavigateToExamDetail = { examId ->
                        outerNavController.navigate(Screen.ExamDetail.createRoute(examId))
                    },
                    onNavigateToUpload = {
                        outerNavController.navigate(Screen.Upload.route)
                    }
                )
            }
            composable(Screen.Insights.route) {
                InsightsScreen()
            }
            composable(Screen.Profile.route) {
                ProfileScreen(
                    onNavigateToEditProfile = {
                        outerNavController.navigate(Screen.EditProfile.route)
                    },
                    onNavigateToSettings = {
                        outerNavController.navigate(Screen.Settings.route)
                    },
                    onNavigateToEmergencyContacts = {
                        outerNavController.navigate(Screen.EmergencyContacts.route)
                    },
                    onLogout = {
                        outerNavController.navigate(Screen.Welcome.route) {
                            popUpTo(0) { inclusive = true }
                        }
                    }
                )
            }
        }
    }
}
