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
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Description
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
import com.health2u.ui.theme.Dimensions
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Exam Card Component
 *
 * Card for displaying medical exam records in a list.
 * Shows exam title, type, date, and optional thumbnail/icon.
 *
 * Features:
 * - Exam metadata display
 * - Date formatting
 * - Icon/thumbnail support
 * - Minimum height for consistent layout
 * - Clickable for navigation to detail
 * - Uses theme colors (no hardcoded colors)
 *
 * Usage:
 * ```
 * ExamCard(
 *     title = "Blood Test Results",
 *     examType = "Laboratory",
 *     dateMillis = System.currentTimeMillis(),
 *     onClick = { /* navigate to exam detail */ }
 * )
 * ```
 *
 * @param title Exam title
 * @param examType Type of exam (e.g., "Blood Test", "X-Ray")
 * @param dateMillis Exam date in milliseconds
 * @param modifier Modifier for styling
 * @param icon Optional exam type icon
 * @param notes Optional preview of exam notes
 * @param onClick Click handler to view exam details
 * @param contentDescription Accessibility description
 */
@Composable
fun ExamCard(
    title: String,
    examType: String,
    dateMillis: Long,
    modifier: Modifier = Modifier,
    icon: ImageVector = Icons.Filled.Description,
    notes: String? = null,
    onClick: () -> Unit,
    contentDescription: String? = null
) {
    // Format date
    val dateFormatter = remember {
        SimpleDateFormat("MMM dd, yyyy", Locale.getDefault())
    }
    val formattedDate = dateFormatter.format(Date(dateMillis))

    Card(
        onClick = onClick,
        modifier = modifier
            .fillMaxWidth()
            .height(Dimensions.ExamCardMinHeight)
            .semantics {
                contentDescription?.let { this.contentDescription = it }
            },
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surface,
            contentColor = MaterialTheme.colorScheme.onSurface
        ),
        shape = MaterialTheme.shapes.medium,
        elevation = CardDefaults.cardElevation(
            defaultElevation = Dimensions.CardElevation
        )
    ) {
        Row(
            modifier = Modifier
                .padding(Dimensions.CardPadding)
                .fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(Dimensions.ContentSpacingM)
        ) {
            // Exam icon/thumbnail
            Icon(
                imageVector = icon,
                contentDescription = null,
                modifier = Modifier.size(Dimensions.ExamCardThumbnailSize),
                tint = MaterialTheme.colorScheme.primary
            )

            // Exam details
            Column(
                modifier = Modifier.weight(1f),
                verticalArrangement = Arrangement.spacedBy(Dimensions.ContentSpacingXS)
            ) {
                Text(
                    text = title,
                    style = MaterialTheme.typography.titleMedium,
                    color = MaterialTheme.colorScheme.onSurface,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )

                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(Dimensions.SpaceS)
                ) {
                    Text(
                        text = examType,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.primary
                    )

                    Text(
                        text = "•",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )

                    Text(
                        text = formattedDate,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }

                if (notes != null) {
                    Text(
                        text = notes,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis
                    )
                }
            }
        }
    }
}

/**
 * Remember date formatter to avoid recreation
 */
@Composable
private fun remember(block: () -> SimpleDateFormat): SimpleDateFormat {
    return androidx.compose.runtime.remember { block() }
}
