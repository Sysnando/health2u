package com.health2u.ui.theme

import androidx.compose.ui.unit.dp

/**
 * Health2U Dimensions System
 *
 * Centralized spacing, sizing, and layout constants following Material Design 3 guidelines.
 * All dimensions are defined in dp (density-independent pixels) for consistent sizing
 * across different screen densities.
 *
 * Usage: Use these constants instead of hardcoded values throughout the app.
 * Example: padding(Dimensions.SpaceM) instead of padding(16.dp)
 */
object Dimensions {

    // ============================================================
    // SPACING
    // ============================================================

    /**
     * Spacing scale following 8dp grid system
     */
    val SpaceXXS = 2.dp    // Minimal spacing (rare use)
    val SpaceXS = 4.dp     // Very tight spacing
    val SpaceS = 8.dp      // Small spacing (list item internal padding)
    val SpaceM = 16.dp     // Medium spacing (default padding, most common)
    val SpaceL = 24.dp     // Large spacing (section padding)
    val SpaceXL = 32.dp    // Extra large spacing (screen edges, major sections)
    val SpaceXXL = 48.dp   // Maximum spacing (rare use, very large gaps)

    /**
     * Screen edge padding
     * Consistent padding from screen edges for main content
     */
    val ScreenPaddingHorizontal = SpaceM  // 16.dp - Left/right screen padding
    val ScreenPaddingVertical = SpaceL    // 24.dp - Top/bottom screen padding
    val ScreenPaddingTop = SpaceXL        // 32.dp - Top padding with status bar

    /**
     * Section spacing
     * Vertical spacing between major sections
     */
    val SectionSpacingS = SpaceL          // 24.dp - Small section gap
    val SectionSpacingM = SpaceXL         // 32.dp - Medium section gap
    val SectionSpacingL = SpaceXXL        // 48.dp - Large section gap

    /**
     * Content spacing
     * Spacing within components and between related items
     */
    val ContentSpacingXS = SpaceXS        // 4.dp - Very tight items
    val ContentSpacingS = SpaceS          // 8.dp - Tight items
    val ContentSpacingM = SpaceM          // 16.dp - Standard items
    val ContentSpacingL = SpaceL          // 24.dp - Loose items

    // ============================================================
    // CORNER RADIUS
    // ============================================================

    /**
     * Corner radius scale for rounded corners
     */
    val CornerRadiusXS = 2.dp     // Minimal rounding
    val CornerRadiusS = 4.dp      // Small rounding (chips, small buttons)
    val CornerRadiusM = 8.dp      // Medium rounding (buttons, text fields)
    val CornerRadiusL = 12.dp     // Large rounding (cards)
    val CornerRadiusXL = 16.dp    // Extra large rounding (large cards, dialogs)
    val CornerRadiusXXL = 24.dp   // Maximum rounding (special components)
    val CornerRadiusFull = 999.dp // Fully rounded (pills, FAB)

    /**
     * Component-specific corner radii
     */
    val ButtonCornerRadius = CornerRadiusM        // 8.dp
    val CardCornerRadius = CornerRadiusL          // 12.dp
    val DialogCornerRadius = CornerRadiusXL       // 16.dp
    val TextFieldCornerRadius = CornerRadiusS     // 4.dp
    val BottomSheetCornerRadius = CornerRadiusXL  // 16.dp

    // ============================================================
    // ELEVATION
    // ============================================================

    /**
     * Elevation scale for shadows and depth
     */
    val ElevationNone = 0.dp      // No elevation (flat surface)
    val ElevationXS = 1.dp        // Minimal elevation
    val ElevationS = 2.dp         // Small elevation (raised surface)
    val ElevationM = 4.dp         // Medium elevation (cards at rest)
    val ElevationL = 8.dp         // Large elevation (cards on hover/press)
    val ElevationXL = 16.dp       // Extra large elevation (modals, dialogs)
    val ElevationXXL = 24.dp      // Maximum elevation (top-level overlays)

    /**
     * Component-specific elevations
     */
    val CardElevation = ElevationM            // 4.dp - Default card elevation
    val CardElevationHover = ElevationL       // 8.dp - Card on hover
    val DialogElevation = ElevationXL         // 16.dp - Dialog/modal elevation
    val AppBarElevation = ElevationS          // 2.dp - App bar elevation
    val BottomNavElevation = ElevationM       // 4.dp - Bottom navigation elevation
    val FABElevation = ElevationL             // 8.dp - FAB elevation

    // ============================================================
    // COMPONENT SIZES
    // ============================================================

    /**
     * Button dimensions
     * Minimum touch target: 48.dp per Material Design accessibility guidelines
     */
    val ButtonHeight = 48.dp              // Standard button height
    val ButtonHeightSmall = 36.dp         // Small button (use sparingly)
    val ButtonHeightLarge = 56.dp         // Large button (primary actions)
    val ButtonMinWidth = 88.dp            // Minimum button width
    val ButtonPaddingHorizontal = SpaceM  // 16.dp - Button text padding

    /**
     * Icon sizes
     */
    val IconSizeXS = 16.dp    // Tiny icon (inline with text)
    val IconSizeS = 20.dp     // Small icon
    val IconSize = 24.dp      // Standard icon (most common)
    val IconSizeL = 32.dp     // Large icon
    val IconSizeXL = 40.dp    // Extra large icon
    val IconSizeXXL = 48.dp   // Maximum icon (feature icons)

    /**
     * Avatar sizes
     */
    val AvatarSizeXS = 24.dp  // Tiny avatar (inline)
    val AvatarSizeS = 32.dp   // Small avatar (list items)
    val AvatarSizeM = 48.dp   // Medium avatar (standard)
    val AvatarSizeL = 64.dp   // Large avatar (profile)
    val AvatarSizeXL = 96.dp  // Extra large avatar (profile header)
    val AvatarSizeXXL = 128.dp // Maximum avatar (onboarding)

    /**
     * Input field dimensions
     */
    val TextFieldHeight = 56.dp               // Standard text field height
    val TextFieldHeightSmall = 48.dp          // Compact text field
    val TextFieldPaddingHorizontal = SpaceM   // 16.dp - Text field padding
    val TextFieldPaddingVertical = SpaceS     // 8.dp - Text field padding

    /**
     * Divider thickness
     */
    val DividerThickness = 1.dp       // Standard divider
    val DividerThicknessBold = 2.dp   // Bold divider (emphasis)

    /**
     * Progress indicator sizes
     */
    val ProgressIndicatorSizeS = 16.dp    // Small (inline)
    val ProgressIndicatorSizeM = 24.dp    // Medium (default)
    val ProgressIndicatorSizeL = 48.dp    // Large (loading screen)

    /**
     * Badge sizes
     */
    val BadgeSizeS = 16.dp    // Small badge (notification dot)
    val BadgeSizeM = 20.dp    // Medium badge (counter)

    // ============================================================
    // CARD DIMENSIONS
    // ============================================================

    /**
     * Card sizes and padding
     */
    val CardPadding = SpaceM              // 16.dp - Internal card padding
    val CardPaddingL = SpaceL             // 24.dp - Large card padding
    val CardMinHeight = 80.dp             // Minimum card height
    val CardImageHeight = 180.dp          // Standard card image height
    val CardImageHeightLarge = 240.dp     // Large card image height

    /**
     * Health summary card specific
     */
    val HealthCardMinHeight = 120.dp      // Health metric card minimum height
    val HealthCardIconSize = IconSizeXL   // 40.dp - Health card icon

    /**
     * Exam card specific
     */
    val ExamCardMinHeight = 96.dp         // Exam list item minimum height
    val ExamCardThumbnailSize = 64.dp     // Exam thumbnail size

    /**
     * Appointment card specific
     */
    val AppointmentCardMinHeight = 104.dp // Appointment list item minimum height

    // ============================================================
    // BOTTOM NAVIGATION
    // ============================================================

    /**
     * Bottom navigation bar dimensions
     */
    val BottomNavHeight = 80.dp           // Bottom nav bar height
    val BottomNavIconSize = IconSize      // 24.dp - Bottom nav icon
    val BottomNavLabelPadding = SpaceXS   // 4.dp - Label top padding

    // ============================================================
    // APP BAR
    // ============================================================

    /**
     * App bar dimensions
     */
    val AppBarHeight = 64.dp              // Standard app bar height
    val AppBarHeightLarge = 112.dp        // Large app bar (collapsing)
    val AppBarIconSize = IconSize         // 24.dp - App bar icon

    // ============================================================
    // DIALOG
    // ============================================================

    /**
     * Dialog dimensions
     */
    val DialogMinWidth = 280.dp           // Minimum dialog width
    val DialogMaxWidth = 560.dp           // Maximum dialog width
    val DialogPadding = SpaceL            // 24.dp - Dialog padding
    val DialogButtonHeight = ButtonHeight // 48.dp - Dialog button height

    // ============================================================
    // BOTTOM SHEET
    // ============================================================

    /**
     * Bottom sheet dimensions
     */
    val BottomSheetPeekHeight = 96.dp     // Collapsed bottom sheet height
    val BottomSheetHandleWidth = 32.dp    // Drag handle width
    val BottomSheetHandleHeight = 4.dp    // Drag handle height
    val BottomSheetPadding = SpaceM       // 16.dp - Bottom sheet padding

    // ============================================================
    // LIST ITEMS
    // ============================================================

    /**
     * List item dimensions
     */
    val ListItemHeight = 56.dp            // Single-line list item
    val ListItemHeightTwoLine = 72.dp     // Two-line list item
    val ListItemHeightThreeLine = 88.dp   // Three-line list item
    val ListItemPadding = SpaceM          // 16.dp - List item padding
    val ListItemIconSize = IconSize       // 24.dp - List item icon

    // ============================================================
    // TOUCH TARGETS
    // ============================================================

    /**
     * Minimum touch target sizes for accessibility
     * Per Material Design and WCAG guidelines
     */
    val MinTouchTarget = 48.dp            // Minimum interactive element size
    val MinTouchTargetSmall = 40.dp       // Small interactive element (use with caution)

    // ============================================================
    // BORDER WIDTHS
    // ============================================================

    /**
     * Border/stroke widths
     */
    val BorderWidthThin = 1.dp            // Thin border
    val BorderWidthMedium = 2.dp          // Medium border (default)
    val BorderWidthThick = 4.dp           // Thick border (emphasis)

    // ============================================================
    // MAX WIDTHS (for responsive layouts)
    // ============================================================

    /**
     * Maximum widths for content containers
     * Prevents text from being too wide on large screens
     */
    val ContentMaxWidth = 600.dp          // Maximum width for main content
    val CardMaxWidth = 400.dp             // Maximum width for cards
    val DialogContentMaxWidth = 480.dp    // Maximum width for dialog content
}
