package com.health2u.ui.components.buttons

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.size
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import com.health2u.ui.theme.Dimensions

/**
 * Secondary Button Component
 *
 * Medium-emphasis button for secondary actions.
 * Outlined style with transparent background.
 *
 * Features:
 * - Loading state with spinner
 * - Disabled state handling
 * - Minimum touch target size (48dp)
 * - Uses theme colors (no hardcoded colors)
 *
 * Usage:
 * ```
 * SecondaryButton(
 *     text = "Cancel",
 *     onClick = { /* action */ }
 * )
 * ```
 *
 * @param text Button label text
 * @param onClick Callback when button is clicked
 * @param modifier Modifier for styling
 * @param enabled Whether the button is enabled
 * @param loading Whether to show loading spinner
 * @param contentDescription Accessibility description (defaults to text)
 */
@Composable
fun SecondaryButton(
    text: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    loading: Boolean = false,
    contentDescription: String? = null
) {
    OutlinedButton(
        onClick = onClick,
        enabled = enabled && !loading,
        modifier = modifier
            .heightIn(min = Dimensions.ButtonHeight)
            .semantics {
                this.contentDescription = contentDescription ?: text
            },
        border = BorderStroke(
            width = Dimensions.BorderWidthMedium,
            color = if (enabled && !loading) {
                MaterialTheme.colorScheme.outline
            } else {
                MaterialTheme.colorScheme.surfaceVariant
            }
        ),
        shape = MaterialTheme.shapes.medium,
        contentPadding = PaddingValues(
            horizontal = Dimensions.ButtonPaddingHorizontal,
            vertical = Dimensions.ContentSpacingS
        )
    ) {
        Box(
            contentAlignment = Alignment.Center
        ) {
            if (loading) {
                CircularProgressIndicator(
                    modifier = Modifier.size(Dimensions.IconSize),
                    color = MaterialTheme.colorScheme.primary,
                    strokeWidth = 2.dp
                )
            } else {
                Text(
                    text = text,
                    style = MaterialTheme.typography.labelLarge,
                    color = if (enabled) {
                        MaterialTheme.colorScheme.primary
                    } else {
                        MaterialTheme.colorScheme.onSurfaceVariant
                    },
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )
            }
        }
    }
}
