package com.health2u.ui.components.buttons

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
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
 * Primary Button Component
 *
 * High-emphasis button for primary actions.
 * Uses the app's primary color and is the most prominent button style.
 *
 * Features:
 * - Loading state with spinner
 * - Disabled state handling
 * - Minimum touch target size (48dp) per accessibility guidelines
 * - Uses theme colors (no hardcoded colors)
 *
 * Usage:
 * ```
 * PrimaryButton(
 *     text = "Continue",
 *     onClick = { /* action */ },
 *     enabled = formIsValid,
 *     loading = isSubmitting
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
fun PrimaryButton(
    text: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    loading: Boolean = false,
    contentDescription: String? = null
) {
    Button(
        onClick = onClick,
        enabled = enabled && !loading,
        modifier = modifier
            .heightIn(min = Dimensions.ButtonHeight)
            .semantics {
                // Use custom description or default to button text
                this.contentDescription = contentDescription ?: text
            },
        colors = ButtonDefaults.buttonColors(
            containerColor = MaterialTheme.colorScheme.primary,
            contentColor = MaterialTheme.colorScheme.onPrimary,
            disabledContainerColor = MaterialTheme.colorScheme.surfaceVariant,
            disabledContentColor = MaterialTheme.colorScheme.onSurfaceVariant
        ),
        shape = MaterialTheme.shapes.medium,
        contentPadding = PaddingValues(
            horizontal = Dimensions.ButtonPaddingHorizontal,
            vertical = Dimensions.ContentSpacingS
        ),
        elevation = ButtonDefaults.buttonElevation(
            defaultElevation = 0.dp,
            pressedElevation = 0.dp,
            disabledElevation = 0.dp
        )
    ) {
        Box(
            contentAlignment = Alignment.Center
        ) {
            if (loading) {
                CircularProgressIndicator(
                    modifier = Modifier.size(Dimensions.IconSize),
                    color = MaterialTheme.colorScheme.onPrimary,
                    strokeWidth = 2.dp
                )
            } else {
                Text(
                    text = text,
                    style = MaterialTheme.typography.labelLarge,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )
            }
        }
    }
}
