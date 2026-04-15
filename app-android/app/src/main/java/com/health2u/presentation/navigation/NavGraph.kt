package com.health2u.presentation.navigation

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import com.health2u.presentation.editprofile.EditProfileScreen
import com.health2u.presentation.login.LoginScreen
import com.health2u.presentation.main.MainScreen
import com.health2u.presentation.settings.SettingsScreen
import com.health2u.presentation.upload.UploadScreen
import com.health2u.presentation.welcome.WelcomeScreen

@Composable
fun Health2uNavGraph(
    navController: NavHostController,
    modifier: Modifier = Modifier,
    startDestination: String = Screen.Welcome.route
) {
    NavHost(
        navController = navController,
        startDestination = startDestination,
        modifier = modifier
    ) {
        // Auth flow
        composable(Screen.Welcome.route) {
            WelcomeScreen(
                onGetStarted = {
                    navController.navigate(Screen.Login.route) {
                        popUpTo(Screen.Welcome.route) { inclusive = true }
                    }
                }
            )
        }

        composable(Screen.Login.route) {
            LoginScreen(
                onLoginSuccess = {
                    navController.navigate(Screen.Main.route) {
                        popUpTo(Screen.Login.route) { inclusive = true }
                    }
                },
                onSignUpClick = {
                    navController.navigate(Screen.Onboarding.route)
                }
            )
        }

        composable(Screen.Onboarding.route) {
            // TODO: Implement onboarding
            WelcomeScreen(onGetStarted = {
                navController.navigate(Screen.Login.route)
            })
        }

        // Main app with bottom navigation
        composable(Screen.Main.route) {
            MainScreen(outerNavController = navController)
        }

        // Screens outside bottom nav (pushed on top)
        composable(Screen.Upload.route) {
            UploadScreen(
                onNavigateBack = { navController.popBackStack() }
            )
        }

        composable(Screen.EditProfile.route) {
            EditProfileScreen(
                onNavigateBack = { navController.popBackStack() }
            )
        }

        composable(Screen.Settings.route) {
            SettingsScreen(
                onNavigateBack = { navController.popBackStack() },
                onLogout = {
                    navController.navigate(Screen.Welcome.route) {
                        popUpTo(0) { inclusive = true }
                    }
                }
            )
        }

        composable(Screen.EmergencyContacts.route) {
            PlaceholderScreen("Emergency Contacts - Coming Soon")
        }

        // Detail screens with arguments
        composable(Screen.ExamDetail.route) { backStackEntry ->
            val examId = backStackEntry.arguments?.getString("examId") ?: ""
            PlaceholderScreen("Exam Detail: $examId")
        }

        composable(Screen.AppointmentDetail.route) { backStackEntry ->
            val appointmentId = backStackEntry.arguments?.getString("appointmentId") ?: ""
            PlaceholderScreen("Appointment Detail: $appointmentId")
        }
    }
}

@Composable
private fun PlaceholderScreen(title: String) {
    Box(
        modifier = Modifier.fillMaxSize(),
        contentAlignment = Alignment.Center
    ) {
        Text(
            text = title,
            style = MaterialTheme.typography.headlineMedium,
            color = MaterialTheme.colorScheme.onBackground
        )
    }
}
