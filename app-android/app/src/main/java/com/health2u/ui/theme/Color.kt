package com.health2u.ui.theme

import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.ui.graphics.Color

/**
 * Health2U Color Palette
 *
 * Colors extracted from Stitch Design System and adapted for Material Design 3.
 * This color scheme supports both light and dark themes.
 *
 * Primary: Medical Blue - Professional, trustworthy
 * Secondary: Teal - Health, wellness
 * Tertiary: Purple - Innovation, technology
 * Error: Red - Critical alerts
 * Surface variants: Neutral grays for backgrounds and surfaces
 */

// Brand Colors
private val MedicalBlue = Color(0xFF1976D2)  // Primary - Professional healthcare blue
private val MedicalBlueDark = Color(0xFF0D47A1)  // Darker shade for dark theme
private val MedicalBlueLight = Color(0xFF42A5F5)  // Lighter shade for surfaces

private val HealthTeal = Color(0xFF00897B)  // Secondary - Wellness and vitality
private val HealthTealDark = Color(0xFF00695C)
private val HealthTealLight = Color(0xFF4DB6AC)

private val TechPurple = Color(0xFF7B1FA2)  // Tertiary - Innovation
private val TechPurpleDark = Color(0xFF4A148C)
private val TechPurpleLight = Color(0xFF9C27B0)

// Functional Colors
private val ErrorRed = Color(0xFFD32F2F)  // Error states
private val ErrorRedDark = Color(0xFFB71C1C)

private val SuccessGreen = Color(0xFF388E3C)  // Success states
private val WarningOrange = Color(0xFFF57C00)  // Warning states

// Neutral Colors
private val NeutralGray50 = Color(0xFFFAFAFA)
private val NeutralGray100 = Color(0xFFF5F5F5)
private val NeutralGray200 = Color(0xFFEEEEEE)
private val NeutralGray300 = Color(0xFFE0E0E0)
private val NeutralGray400 = Color(0xFFBDBDBD)
private val NeutralGray500 = Color(0xFF9E9E9E)
private val NeutralGray600 = Color(0xFF757575)
private val NeutralGray700 = Color(0xFF616161)
private val NeutralGray800 = Color(0xFF424242)
private val NeutralGray900 = Color(0xFF212121)

// Text Colors
private val TextPrimary = Color(0xFF212121)
private val TextSecondary = Color(0xFF757575)
private val TextPrimaryDark = Color(0xFFFFFFFF)
private val TextSecondaryDark = Color(0xFFB0B0B0)

/**
 * Light Color Scheme
 *
 * Used for the default light theme.
 * Follows Material Design 3 color roles.
 */
val lightColorScheme = lightColorScheme(
    // Primary colors - Main brand color used for key components
    primary = MedicalBlue,
    onPrimary = Color.White,
    primaryContainer = MedicalBlueLight,
    onPrimaryContainer = Color(0xFF001D36),

    // Secondary colors - Supporting brand color for less prominent components
    secondary = HealthTeal,
    onSecondary = Color.White,
    secondaryContainer = HealthTealLight,
    onSecondaryContainer = Color(0xFF002114),

    // Tertiary colors - Accent color for contrast and highlighting
    tertiary = TechPurple,
    onTertiary = Color.White,
    tertiaryContainer = TechPurpleLight,
    onTertiaryContainer = Color(0xFF2A0044),

    // Error colors - Used for error states and destructive actions
    error = ErrorRed,
    onError = Color.White,
    errorContainer = Color(0xFFFFDAD6),
    onErrorContainer = Color(0xFF410002),

    // Background colors - Main screen background
    background = NeutralGray50,
    onBackground = TextPrimary,

    // Surface colors - Component backgrounds (cards, sheets, etc.)
    surface = Color.White,
    onSurface = TextPrimary,
    surfaceVariant = NeutralGray100,
    onSurfaceVariant = TextSecondary,

    // Outline colors - Borders and dividers
    outline = NeutralGray300,
    outlineVariant = NeutralGray200,

    // Inverse colors - For high-emphasis surfaces in light theme
    inverseSurface = NeutralGray900,
    inverseOnSurface = Color.White,
    inversePrimary = MedicalBlueLight,

    // Scrim - Semi-transparent overlay
    scrim = Color.Black.copy(alpha = 0.32f),

    // Surface tint - Tint color for elevated surfaces
    surfaceTint = MedicalBlue
)

/**
 * Dark Color Scheme
 *
 * Used when dark theme is enabled.
 * Adjusted for better contrast and reduced eye strain in low-light conditions.
 */
val darkColorScheme = darkColorScheme(
    // Primary colors
    primary = MedicalBlueLight,
    onPrimary = Color(0xFF003258),
    primaryContainer = MedicalBlueDark,
    onPrimaryContainer = Color(0xFFADD6FF),

    // Secondary colors
    secondary = HealthTealLight,
    onSecondary = Color(0xFF003730),
    secondaryContainer = HealthTealDark,
    onSecondaryContainer = Color(0xFF7EF8E4),

    // Tertiary colors
    tertiary = TechPurpleLight,
    onTertiary = Color(0xFF4A0072),
    tertiaryContainer = TechPurpleDark,
    onTertiaryContainer = Color(0xFFE6B3FF),

    // Error colors
    error = Color(0xFFFFB4AB),
    onError = Color(0xFF690005),
    errorContainer = ErrorRedDark,
    onErrorContainer = Color(0xFFFFDAD6),

    // Background colors
    background = NeutralGray900,
    onBackground = TextPrimaryDark,

    // Surface colors
    surface = Color(0xFF1A1C1E),
    onSurface = TextPrimaryDark,
    surfaceVariant = NeutralGray800,
    onSurfaceVariant = TextSecondaryDark,

    // Outline colors
    outline = NeutralGray600,
    outlineVariant = NeutralGray700,

    // Inverse colors
    inverseSurface = NeutralGray100,
    inverseOnSurface = NeutralGray900,
    inversePrimary = MedicalBlue,

    // Scrim
    scrim = Color.Black.copy(alpha = 0.64f),

    // Surface tint
    surfaceTint = MedicalBlueLight
)

/**
 * Extended Color Palette
 *
 * Additional semantic colors not covered by Material3 color roles.
 * Use these for specific UI needs beyond the standard color scheme.
 */
object ExtendedColors {
    // Success states
    val success = SuccessGreen
    val onSuccess = Color.White
    val successContainer = Color(0xFFC8E6C9)
    val onSuccessContainer = Color(0xFF1B5E20)

    // Warning states
    val warning = WarningOrange
    val onWarning = Color.White
    val warningContainer = Color(0xFFFFE0B2)
    val onWarningContainer = Color(0xFFE65100)

    // Info states
    val info = Color(0xFF0288D1)
    val onInfo = Color.White
    val infoContainer = Color(0xFFB3E5FC)
    val onInfoContainer = Color(0xFF01579B)

    // Chart colors (for health insights/graphs)
    val chart1 = MedicalBlue
    val chart2 = HealthTeal
    val chart3 = TechPurple
    val chart4 = Color(0xFFFF6F00)  // Orange
    val chart5 = Color(0xFFD32F2F)  // Red
    val chart6 = Color(0xFF388E3C)  // Green

    // Health metric specific colors
    val bloodPressure = Color(0xFFE91E63)  // Pink
    val heartRate = ErrorRed
    val bloodSugar = TechPurple
    val weight = HealthTeal
    val temperature = WarningOrange
    val oxygen = Color(0xFF2196F3)  // Blue
}
