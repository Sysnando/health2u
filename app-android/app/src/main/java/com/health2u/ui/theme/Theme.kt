package com.health2u.ui.theme

import android.app.Activity
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalView
import androidx.core.view.WindowCompat

/**
 * Health2U Material3 Theme
 *
 * Main theme composable that applies the Health2U design system.
 * Supports both light and dark themes with proper system bar styling.
 *
 * @param darkTheme Whether to use dark theme. Defaults to system setting.
 * @param dynamicColor Whether to use dynamic theming (Material You). Currently disabled.
 * @param content The content to be themed.
 *
 * Usage:
 * ```
 * Health2uTheme {
 *     // Your app content
 * }
 * ```
 */
@Composable
fun Health2uTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    // Dynamic color is available on Android 12+ but disabled for brand consistency
    dynamicColor: Boolean = false,
    content: @Composable () -> Unit
) {
    // Select color scheme based on theme
    val colorScheme = when {
        // Note: Dynamic theming (Material You) is commented out to maintain
        // consistent brand colors across all devices
        // dynamicColor && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
        //     val context = LocalContext.current
        //     if (darkTheme) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
        // }
        darkTheme -> darkColorScheme
        else -> lightColorScheme
    }

    // Update system bars (status bar and navigation bar) to match theme
    val view = LocalView.current
    if (!view.isInEditMode) {
        SideEffect {
            val window = (view.context as Activity).window

            // Set status bar color
            window.statusBarColor = colorScheme.primary.toArgb()

            // Set navigation bar color
            window.navigationBarColor = colorScheme.surface.toArgb()

            // Configure system bar appearance (light or dark icons)
            WindowCompat.getInsetsController(window, view).apply {
                // Status bar icons should be light when using dark primary color
                isAppearanceLightStatusBars = false

                // Navigation bar icons should match theme
                isAppearanceLightNavigationBars = !darkTheme
            }
        }
    }

    // Apply Material3 theme
    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}

/**
 * Preview variants for different theme configurations
 */
@Composable
fun Health2uThemeLightPreview(
    content: @Composable () -> Unit
) {
    Health2uTheme(
        darkTheme = false,
        content = content
    )
}

@Composable
fun Health2uThemeDarkPreview(
    content: @Composable () -> Unit
) {
    Health2uTheme(
        darkTheme = true,
        content = content
    )
}
