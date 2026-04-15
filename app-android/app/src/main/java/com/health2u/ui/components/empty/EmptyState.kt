package com.health2u.ui.components.empty

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.style.TextAlign
import com.health2u.ui.components.buttons.PrimaryButton
import com.health2u.ui.theme.Dimensions

/**
 * Empty State Component
 *
 * Displays an empty state with icon, title, description, and optional action button.
 * Used when there's no data to display (e.g., no exams, no appointments).
 *
 * Features:
 * - Large icon
 * - Title and description
 * - Optional action button
 * - Centered layout
 * - Uses theme colors (no hardcoded colors)
 * - Proper accessibility semantics
 *
 * Usage:
 * ```
 * EmptyState(
 *     icon = Icons.Filled.Description,
 *     title = "No exams yet",
 *     description = "Upload your first medical exam to get started",
 *     actionText = "Upload Exam",
 *     onActionClick = { /* navigate to upload */ }
 * )
 * ```
 *
 * @param icon Icon to display
 * @param title Empty state title
 * @param description Empty state description
 * @param modifier Modifier for styling
 * @param actionText Optional action button text
 * @param onActionClick Optional action button click handler
 * @param contentDescription Accessibility description
 */
@Composable
fun EmptyState(
    icon: ImageVector,
    title: String,
    description: String,
    modifier: Modifier = Modifier,
    actionText: String? = null,
    onActionClick: (() -> Unit)? = null,
    contentDescription: String? = null
) {
    Box(
        modifier = modifier
            .fillMaxSize()
            .semantics {
                this.contentDescription = contentDescription ?: "Empty state: $title"
            },
        contentAlignment = Alignment.Center
    ) {
        Column(
            modifier = Modifier
                .padding(Dimensions.ScreenPaddingHorizontal),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            // Icon
            Icon(
                imageVector = icon,
                contentDescription = null,
                modifier = Modifier.size(Dimensions.IconSizeXXL * 2),
                tint = MaterialTheme.colorScheme.surfaceVariant
            )

            Spacer(modifier = Modifier.height(Dimensions.SpaceL))

            // Title
            Text(
                text = title,
                style = MaterialTheme.typography.titleLarge,
                color = MaterialTheme.colorScheme.onSurface,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(Dimensions.SpaceS))

            // Description
            Text(
                text = description,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                textAlign = TextAlign.Center
            )

            // Action button (if provided)
            if (actionText != null && onActionClick != null) {
                Spacer(modifier = Modifier.height(Dimensions.SpaceXL))

                PrimaryButton(
                    text = actionText,
                    onClick = onActionClick
                )
            }
        }
    }
}

/**
 * Compact Empty State Component
 *
 * Smaller variant for inline empty states (e.g., empty sections within a screen).
 *
 * Usage:
 * ```
 * CompactEmptyState(
 *     icon = Icons.Filled.Event,
 *     message = "No upcoming appointments"
 * )
 * ```
 *
 * @param icon Icon to display
 * @param message Empty state message
 * @param modifier Modifier for styling
 * @param contentDescription Accessibility description
 */
@Composable
fun CompactEmptyState(
    icon: ImageVector,
    message: String,
    modifier: Modifier = Modifier,
    contentDescription: String? = null
) {
    Column(
        modifier = modifier
            .padding(Dimensions.SpaceL)
            .semantics {
                this.contentDescription = contentDescription ?: "Empty: $message"
            },
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Icon(
            imageVector = icon,
            contentDescription = null,
            modifier = Modifier.size(Dimensions.IconSizeXL),
            tint = MaterialTheme.colorScheme.surfaceVariant
        )

        Spacer(modifier = Modifier.height(Dimensions.SpaceM))

        Text(
            text = message,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            textAlign = TextAlign.Center
        )
    }
}
