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
import androidx.compose.material.icons.filled.AccessTime
import androidx.compose.material.icons.filled.CalendarToday
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Person
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.style.TextOverflow
import com.health2u.ui.theme.Dimensions
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Appointment Card Component
 *
 * Card for displaying medical appointments in a list.
 * Shows appointment title, doctor, date/time, and location.
 *
 * Features:
 * - Appointment details display
 * - Date and time formatting
 * - Doctor name and location
 * - Status indicator
 * - Minimum height for consistent layout
 * - Clickable for navigation to detail
 * - Uses theme colors (no hardcoded colors)
 *
 * Usage:
 * ```
 * AppointmentCard(
 *     title = "Annual Checkup",
 *     doctorName = "Dr. Smith",
 *     dateTimeMillis = System.currentTimeMillis(),
 *     location = "Main Clinic, Room 305",
 *     status = "Upcoming",
 *     onClick = { /* navigate to appointment detail */ }
 * )
 * ```
 *
 * @param title Appointment title
 * @param doctorName Doctor's name
 * @param dateTimeMillis Appointment date/time in milliseconds
 * @param modifier Modifier for styling
 * @param location Appointment location
 * @param status Appointment status ("Upcoming", "Completed", "Cancelled")
 * @param description Optional appointment description
 * @param onClick Click handler to view appointment details
 * @param contentDescription Accessibility description
 */
@Composable
fun AppointmentCard(
    title: String,
    doctorName: String,
    dateTimeMillis: Long,
    modifier: Modifier = Modifier,
    location: String? = null,
    status: String = "Upcoming",
    description: String? = null,
    onClick: () -> Unit,
    contentDescription: String? = null
) {
    // Format date and time
    val dateFormatter = remember {
        SimpleDateFormat("MMM dd, yyyy", Locale.getDefault())
    }
    val timeFormatter = remember {
        SimpleDateFormat("hh:mm a", Locale.getDefault())
    }
    val date = Date(dateTimeMillis)
    val formattedDate = dateFormatter.format(date)
    val formattedTime = timeFormatter.format(date)

    // Status color
    val statusColor = when (status.lowercase()) {
        "upcoming" -> MaterialTheme.colorScheme.primary
        "completed" -> MaterialTheme.colorScheme.tertiary
        "cancelled" -> MaterialTheme.colorScheme.error
        else -> MaterialTheme.colorScheme.onSurfaceVariant
    }

    Card(
        onClick = onClick,
        modifier = modifier
            .fillMaxWidth()
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
        Column(
            modifier = Modifier
                .padding(Dimensions.CardPadding)
                .fillMaxWidth(),
            verticalArrangement = Arrangement.spacedBy(Dimensions.ContentSpacingS)
        ) {
            // Header: Title + Status
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = title,
                    style = MaterialTheme.typography.titleMedium,
                    color = MaterialTheme.colorScheme.onSurface,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                    modifier = Modifier.weight(1f)
                )

                Spacer(modifier = Modifier.width(Dimensions.SpaceS))

                Text(
                    text = status,
                    style = MaterialTheme.typography.labelSmall,
                    color = statusColor
                )
            }

            // Doctor
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(Dimensions.SpaceS)
            ) {
                Icon(
                    imageVector = Icons.Filled.Person,
                    contentDescription = null,
                    modifier = Modifier.size(Dimensions.IconSizeS),
                    tint = MaterialTheme.colorScheme.onSurfaceVariant
                )

                Text(
                    text = doctorName,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurface
                )
            }

            // Date & Time
            Row(
                horizontalArrangement = Arrangement.spacedBy(Dimensions.SpaceL)
            ) {
                // Date
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(Dimensions.SpaceS)
                ) {
                    Icon(
                        imageVector = Icons.Filled.CalendarToday,
                        contentDescription = null,
                        modifier = Modifier.size(Dimensions.IconSizeS),
                        tint = MaterialTheme.colorScheme.onSurfaceVariant
                    )

                    Text(
                        text = formattedDate,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }

                // Time
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(Dimensions.SpaceS)
                ) {
                    Icon(
                        imageVector = Icons.Filled.AccessTime,
                        contentDescription = null,
                        modifier = Modifier.size(Dimensions.IconSizeS),
                        tint = MaterialTheme.colorScheme.onSurfaceVariant
                    )

                    Text(
                        text = formattedTime,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }

            // Location (if provided)
            if (location != null) {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(Dimensions.SpaceS)
                ) {
                    Icon(
                        imageVector = Icons.Filled.LocationOn,
                        contentDescription = null,
                        modifier = Modifier.size(Dimensions.IconSizeS),
                        tint = MaterialTheme.colorScheme.onSurfaceVariant
                    )

                    Text(
                        text = location,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis
                    )
                }
            }

            // Description (if provided)
            if (description != null) {
                Text(
                    text = description,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    maxLines = 2,
                    overflow = TextOverflow.Ellipsis
                )
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
