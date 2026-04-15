package com.health2u.presentation.settings

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.Help
import androidx.compose.material.icons.automirrored.filled.Logout
import androidx.compose.material.icons.filled.ChevronRight
import androidx.compose.material.icons.filled.DarkMode
import androidx.compose.material.icons.filled.Description
import androidx.compose.material.icons.filled.Language
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.PrivacyTip
import androidx.compose.material.icons.filled.Shield
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.health2u.ui.components.buttons.PrimaryButton
import com.health2u.ui.theme.Dimensions

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SettingsScreen(
    onNavigateBack: () -> Unit,
    onLogout: () -> Unit,
    viewModel: SettingsViewModel = hiltViewModel()
) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    val snackbarHostState = remember { SnackbarHostState() }

    LaunchedEffect(state.error) {
        state.error?.let { error ->
            snackbarHostState.showSnackbar(error)
            viewModel.dismissError()
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Column {
                        Text(
                            text = "Settings",
                            style = MaterialTheme.typography.titleLarge
                        )
                        Text(
                            text = "MyHealthHub",
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Back"
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.surface
                )
            )
        },
        snackbarHost = { SnackbarHost(snackbarHostState) }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .verticalScroll(rememberScrollState())
                .padding(
                    horizontal = Dimensions.ScreenPaddingHorizontal,
                    vertical = Dimensions.ScreenPaddingVertical
                )
        ) {
            // App Configuration Header
            Text(
                text = "App Configuration",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.SemiBold
            )

            Spacer(modifier = Modifier.height(Dimensions.SpaceS))

            Text(
                text = "Manage your account settings and preferences",
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )

            Spacer(modifier = Modifier.height(Dimensions.SectionSpacingM))

            // ACCOUNT Section
            SectionHeader(title = "ACCOUNT")

            Spacer(modifier = Modifier.height(Dimensions.ContentSpacingS))

            SettingsRow(
                icon = Icons.Default.Person,
                title = "Profile",
                subtitle = "View and edit your profile",
                onClick = { /* Navigate to profile */ }
            )

            HorizontalDivider(modifier = Modifier.padding(vertical = Dimensions.SpaceS))

            SettingsRow(
                icon = Icons.Default.Lock,
                title = "Change Password",
                subtitle = "Update your password",
                onClick = { /* Navigate to change password */ }
            )

            HorizontalDivider(modifier = Modifier.padding(vertical = Dimensions.SpaceS))

            SettingsRow(
                icon = Icons.Default.Shield,
                title = "Privacy",
                subtitle = "Manage privacy settings",
                onClick = { /* Navigate to privacy */ }
            )

            Spacer(modifier = Modifier.height(Dimensions.SectionSpacingM))

            // PREFERENCES Section
            SectionHeader(title = "PREFERENCES")

            Spacer(modifier = Modifier.height(Dimensions.ContentSpacingS))

            SettingsRowWithValue(
                icon = Icons.Default.Language,
                title = "Language",
                value = "English"
            )

            HorizontalDivider(modifier = Modifier.padding(vertical = Dimensions.SpaceS))

            SettingsToggleRow(
                icon = Icons.Default.Notifications,
                title = "Notifications",
                checked = state.notificationsEnabled,
                onCheckedChange = viewModel::onToggleNotifications
            )

            HorizontalDivider(modifier = Modifier.padding(vertical = Dimensions.SpaceS))

            SettingsToggleRow(
                icon = Icons.Default.DarkMode,
                title = "Dark Mode",
                checked = state.darkModeEnabled,
                onCheckedChange = viewModel::onToggleDarkMode
            )

            Spacer(modifier = Modifier.height(Dimensions.SectionSpacingM))

            // DATA & PRIVACY Section
            SectionHeader(title = "DATA & PRIVACY")

            Spacer(modifier = Modifier.height(Dimensions.ContentSpacingS))

            PrimaryButton(
                text = "Export Data",
                onClick = { /* TODO: Export data */ },
                modifier = Modifier.fillMaxWidth()
            )

            Spacer(modifier = Modifier.height(Dimensions.SpaceM))

            Text(
                text = "Delete Account",
                style = MaterialTheme.typography.labelLarge,
                color = MaterialTheme.colorScheme.error,
                modifier = Modifier
                    .clickable { /* TODO: Delete account flow */ }
                    .padding(vertical = Dimensions.SpaceS)
            )

            Spacer(modifier = Modifier.height(Dimensions.SectionSpacingM))

            // ABOUT Section
            SectionHeader(title = "ABOUT")

            Spacer(modifier = Modifier.height(Dimensions.ContentSpacingS))

            SettingsRowWithValue(
                icon = null,
                title = "Version",
                value = "v${state.appVersion}"
            )

            HorizontalDivider(modifier = Modifier.padding(vertical = Dimensions.SpaceS))

            SettingsRow(
                icon = Icons.Default.Description,
                title = "Terms of Service",
                onClick = { /* Navigate to terms */ }
            )

            HorizontalDivider(modifier = Modifier.padding(vertical = Dimensions.SpaceS))

            SettingsRow(
                icon = Icons.Default.PrivacyTip,
                title = "Privacy Policy",
                onClick = { /* Navigate to privacy policy */ }
            )

            HorizontalDivider(modifier = Modifier.padding(vertical = Dimensions.SpaceS))

            SettingsRow(
                icon = Icons.AutoMirrored.Filled.Help,
                title = "Help & Support",
                onClick = { /* Navigate to help */ }
            )

            Spacer(modifier = Modifier.height(Dimensions.SectionSpacingM))

            // Logout Button
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable(enabled = !state.isLoggingOut) {
                        viewModel.onLogout(onLogout)
                    }
                    .padding(vertical = Dimensions.SpaceM),
                horizontalArrangement = Arrangement.Center,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = Icons.AutoMirrored.Filled.Logout,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.error,
                    modifier = Modifier.size(Dimensions.IconSize)
                )
                Spacer(modifier = Modifier.width(Dimensions.SpaceS))
                Text(
                    text = if (state.isLoggingOut) "Logging out..." else "Logout",
                    style = MaterialTheme.typography.labelLarge,
                    color = MaterialTheme.colorScheme.error
                )
            }

            Spacer(modifier = Modifier.height(Dimensions.SpaceL))
        }
    }
}

@Composable
private fun SectionHeader(title: String) {
    Text(
        text = title,
        style = MaterialTheme.typography.labelMedium,
        color = MaterialTheme.colorScheme.onSurfaceVariant,
        fontWeight = FontWeight.SemiBold,
        letterSpacing = MaterialTheme.typography.labelMedium.letterSpacing
    )
}

@Composable
private fun SettingsRow(
    icon: ImageVector?,
    title: String,
    subtitle: String? = null,
    onClick: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick)
            .padding(vertical = Dimensions.SpaceS),
        verticalAlignment = Alignment.CenterVertically
    ) {
        if (icon != null) {
            Icon(
                imageVector = icon,
                contentDescription = null,
                modifier = Modifier.size(Dimensions.IconSize),
                tint = MaterialTheme.colorScheme.onSurfaceVariant
            )
            Spacer(modifier = Modifier.width(Dimensions.SpaceM))
        }
        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = title,
                style = MaterialTheme.typography.bodyLarge
            )
            if (subtitle != null) {
                Text(
                    text = subtitle,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
        Icon(
            imageVector = Icons.Default.ChevronRight,
            contentDescription = null,
            tint = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

@Composable
private fun SettingsRowWithValue(
    icon: ImageVector?,
    title: String,
    value: String
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = Dimensions.SpaceS),
        verticalAlignment = Alignment.CenterVertically
    ) {
        if (icon != null) {
            Icon(
                imageVector = icon,
                contentDescription = null,
                modifier = Modifier.size(Dimensions.IconSize),
                tint = MaterialTheme.colorScheme.onSurfaceVariant
            )
            Spacer(modifier = Modifier.width(Dimensions.SpaceM))
        }
        Text(
            text = title,
            style = MaterialTheme.typography.bodyLarge,
            modifier = Modifier.weight(1f)
        )
        Text(
            text = value,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

@Composable
private fun SettingsToggleRow(
    icon: ImageVector,
    title: String,
    checked: Boolean,
    onCheckedChange: (Boolean) -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = Dimensions.SpaceS),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(
            imageVector = icon,
            contentDescription = null,
            modifier = Modifier.size(Dimensions.IconSize),
            tint = MaterialTheme.colorScheme.onSurfaceVariant
        )
        Spacer(modifier = Modifier.width(Dimensions.SpaceM))
        Text(
            text = title,
            style = MaterialTheme.typography.bodyLarge,
            modifier = Modifier.weight(1f)
        )
        Switch(
            checked = checked,
            onCheckedChange = onCheckedChange
        )
    }
}
