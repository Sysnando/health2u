package com.health2u.ui.components.loading

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.size
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.style.TextAlign
import com.health2u.ui.theme.Dimensions

/**
 * Loading Indicator Component
 *
 * Displays a loading spinner with optional message.
 * Used for full-screen loading states or inline loading.
 *
 * Features:
 * - Centered spinner
 * - Optional loading message
 * - Customizable size
 * - Uses theme colors (no hardcoded colors)
 * - Proper accessibility semantics
 *
 * Usage:
 * ```
 * // Full screen loading
 * LoadingIndicator(
 *     message = "Loading your health data...",
 *     modifier = Modifier.fillMaxSize()
 * )
 *
 * // Inline loading
 * LoadingIndicator(
 *     size = LoadingSize.Small
 * )
 * ```
 *
 * @param modifier Modifier for styling
 * @param message Optional loading message
 * @param size Loading indicator size
 * @param contentDescription Accessibility description
 */
@Composable
fun LoadingIndicator(
    modifier: Modifier = Modifier,
    message: String? = null,
    size: LoadingSize = LoadingSize.Medium,
    contentDescription: String? = null
) {
    Box(
        modifier = modifier.semantics {
            this.contentDescription = contentDescription ?: "Loading"
        },
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            CircularProgressIndicator(
                modifier = Modifier.size(size.dimension),
                color = MaterialTheme.colorScheme.primary,
                strokeWidth = size.strokeWidth
            )

            if (message != null) {
                Spacer(modifier = Modifier.height(Dimensions.SpaceL))

                Text(
                    text = message,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurface,
                    textAlign = TextAlign.Center
                )
            }
        }
    }
}

/**
 * Loading size variants
 */
enum class LoadingSize(
    val dimension: androidx.compose.ui.unit.Dp,
    val strokeWidth: androidx.compose.ui.unit.Dp
) {
    Small(
        dimension = Dimensions.ProgressIndicatorSizeS,
        strokeWidth = 2.dp
    ),
    Medium(
        dimension = Dimensions.ProgressIndicatorSizeM,
        strokeWidth = 3.dp
    ),
    Large(
        dimension = Dimensions.ProgressIndicatorSizeL,
        strokeWidth = 4.dp
    )
}

/**
 * Full Screen Loading Component
 *
 * Convenience wrapper for full-screen loading states.
 * Fills the entire screen with centered loading indicator.
 *
 * Usage:
 * ```
 * FullScreenLoading(
 *     message = "Syncing your data..."
 * )
 * ```
 *
 * @param message Optional loading message
 * @param contentDescription Accessibility description
 */
@Composable
fun FullScreenLoading(
    message: String? = null,
    contentDescription: String? = null
) {
    LoadingIndicator(
        modifier = Modifier.fillMaxSize(),
        message = message,
        size = LoadingSize.Large,
        contentDescription = contentDescription
    )
}

/**
 * Inline Loading Component
 *
 * Small loading indicator for inline use (e.g., in lists, buttons).
 *
 * Usage:
 * ```
 * InlineLoading()
 * ```
 *
 * @param modifier Modifier for styling
 * @param contentDescription Accessibility description
 */
@Composable
fun InlineLoading(
    modifier: Modifier = Modifier,
    contentDescription: String? = null
) {
    CircularProgressIndicator(
        modifier = modifier
            .size(Dimensions.ProgressIndicatorSizeS)
            .semantics {
                this.contentDescription = contentDescription ?: "Loading"
            },
        color = MaterialTheme.colorScheme.primary,
        strokeWidth = 2.dp
    )
}
