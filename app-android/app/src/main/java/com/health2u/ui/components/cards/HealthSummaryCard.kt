package com.health2u.ui.components.cards

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.style.TextOverflow
import com.health2u.ui.theme.CustomTypography
import com.health2u.ui.theme.Dimensions

/**
 * Health Summary Card Component
 *
 * Card for displaying health metrics on the dashboard.
 * Shows metric name, value, unit, and optional trend icon.
 *
 * Features:
 * - Large metric value display
 * - Icon support
 * - Trend indicator support
 * - Minimum height for consistent layout
 * - Uses theme colors (no hardcoded colors)
 *
 * Usage:
 * ```
 * HealthSummaryCard(
 *     title = "Heart Rate",
 *     value = "72",
 *     unit = "bpm",
 *     icon = Icons.Filled.Favorite,
 *     onClick = { /* navigate to detail */ }
 * )
 * ```
 *
 * @param title Metric name/title
 * @param value Metric value (as string for formatting control)
 * @param unit Measurement unit
 * @param modifier Modifier for styling
 * @param icon Optional leading icon
 * @param subtitle Optional subtitle text
 * @param trendText Optional trend text (e.g., "+5% from last week")
 * @param onClick Optional click handler
 * @param contentDescription Accessibility description
 */
@Composable
fun HealthSummaryCard(
    title: String,
    value: String,
    unit: String,
    modifier: Modifier = Modifier,
    icon: ImageVector? = null,
    subtitle: String? = null,
    trendText: String? = null,
    onClick: (() -> Unit)? = null,
    contentDescription: String? = null
) {
    Card(
        onClick = onClick ?: {},
        modifier = modifier
            .fillMaxWidth()
            .semantics {
                contentDescription?.let { this.contentDescription = it }
            },
        enabled = onClick != null,
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant,
            contentColor = MaterialTheme.colorScheme.onSurface
        ),
        shape = MaterialTheme.shapes.medium,
        elevation = CardDefaults.cardElevation(
            defaultElevation = Dimensions.CardElevation
        )
    ) {
        Column(
            modifier = Modifier
                .padding(Dimensions.CardPadding)
                .fillMaxWidth(),
            verticalArrangement = Arrangement.spacedBy(Dimensions.ContentSpacingS)
        ) {
            // Header: Icon + Title
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(Dimensions.ContentSpacingS)
            ) {
                if (icon != null) {
                    Icon(
                        imageVector = icon,
                        contentDescription = null,
                        modifier = Modifier.size(Dimensions.HealthCardIconSize),
                        tint = MaterialTheme.colorScheme.primary
                    )
                }

                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = title,
                        style = MaterialTheme.typography.titleMedium,
                        color = MaterialTheme.colorScheme.onSurface,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis
                    )

                    if (subtitle != null) {
                        Text(
                            text = subtitle,
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                            maxLines = 1,
                            overflow = TextOverflow.Ellipsis
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(Dimensions.SpaceXS))

            // Metric Value
            Row(
                verticalAlignment = Alignment.Bottom,
                horizontalArrangement = Arrangement.spacedBy(Dimensions.SpaceXS)
            ) {
                Text(
                    text = value,
                    style = CustomTypography.healthMetricMedium,
                    color = MaterialTheme.colorScheme.primary,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )

                Text(
                    text = unit,
                    style = MaterialTheme.typography.titleMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.padding(bottom = Dimensions.SpaceXS)
                )
            }

            // Trend text (if provided)
            if (trendText != null) {
                Text(
                    text = trendText,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )
            }
        }
    }
}
