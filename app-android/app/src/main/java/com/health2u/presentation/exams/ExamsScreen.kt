package com.health2u.presentation.exams

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Description
import androidx.compose.material.icons.filled.Science
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.FilterChip
import androidx.compose.material3.FilterChipDefaults
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.health2u.domain.model.Exam
import com.health2u.ui.components.empty.EmptyState
import com.health2u.ui.components.inputs.H2UTextField
import com.health2u.ui.components.loading.FullScreenLoading
import com.health2u.ui.theme.Dimensions
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

@Composable
fun ExamsScreen(
    onNavigateToExamDetail: (String) -> Unit,
    onNavigateToUpload: () -> Unit,
    viewModel: ExamsViewModel = hiltViewModel()
) {
    val state by viewModel.state.collectAsStateWithLifecycle()

    Scaffold(
        floatingActionButton = {
            FloatingActionButton(
                onClick = onNavigateToUpload,
                containerColor = MaterialTheme.colorScheme.primary,
                contentColor = MaterialTheme.colorScheme.onPrimary,
                modifier = Modifier.semantics {
                    contentDescription = "Upload new exam"
                }
            ) {
                Icon(
                    imageVector = Icons.Filled.Add,
                    contentDescription = null
                )
            }
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
        ) {
            // Header Section
            ExamsHeader()

            // Filter Chips
            ExamsFilterChips(
                filters = state.availableFilters,
                selectedFilter = state.selectedFilter,
                onFilterSelected = viewModel::onFilterSelected
            )

            Spacer(modifier = Modifier.height(Dimensions.ContentSpacingS))

            // Search Bar
            H2UTextField(
                value = state.searchQuery,
                onValueChange = viewModel::onSearchQueryChanged,
                label = "Search",
                placeholder = "Search exams...",
                leadingIcon = {
                    Icon(
                        imageVector = Icons.Filled.Search,
                        contentDescription = null,
                        tint = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = Dimensions.ScreenPaddingHorizontal)
            )

            Spacer(modifier = Modifier.height(Dimensions.ContentSpacingM))

            // Content
            when {
                state.isLoading -> {
                    FullScreenLoading(message = "Loading your exams...")
                }
                state.error != null -> {
                    EmptyState(
                        icon = Icons.Filled.Description,
                        title = "Something went wrong",
                        description = state.error ?: "An unexpected error occurred.",
                        actionText = "Retry",
                        onActionClick = viewModel::onRetry
                    )
                }
                state.filteredExams.isEmpty() -> {
                    EmptyState(
                        icon = Icons.Filled.Description,
                        title = "No exams found",
                        description = if (state.searchQuery.isNotBlank() || state.selectedFilter != "All Records") {
                            "Try adjusting your search or filter criteria."
                        } else {
                            "Upload your first medical exam to get started."
                        },
                        actionText = if (state.exams.isEmpty()) "Upload Exam" else null,
                        onActionClick = if (state.exams.isEmpty()) onNavigateToUpload else null
                    )
                }
                else -> {
                    ExamsList(
                        exams = state.filteredExams,
                        onExamClick = onNavigateToExamDetail
                    )
                }
            }
        }
    }
}

// ------------------------------------------------------------------
// Header
// ------------------------------------------------------------------

@Composable
private fun ExamsHeader() {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(
                start = Dimensions.ScreenPaddingHorizontal,
                end = Dimensions.ScreenPaddingHorizontal,
                top = Dimensions.ScreenPaddingTop,
                bottom = Dimensions.ContentSpacingS
            )
    ) {
        // "Clinical Records" label
        Text(
            text = "Clinical Records",
            style = MaterialTheme.typography.labelLarge,
            color = MaterialTheme.colorScheme.primary
        )

        Spacer(modifier = Modifier.height(Dimensions.SpaceXS))

        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            // "Exams" title
            Text(
                text = "Exams",
                style = MaterialTheme.typography.headlineLarge,
                color = MaterialTheme.colorScheme.onSurface
            )

            // Sync Status Indicator
            SyncStatusIndicator()
        }
    }
}

@Composable
private fun SyncStatusIndicator() {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        modifier = Modifier.semantics {
            contentDescription = "Sync status: Live"
        }
    ) {
        Box(
            modifier = Modifier
                .size(8.dp)
                .clip(CircleShape)
                .background(MaterialTheme.colorScheme.tertiary)
        )
        Spacer(modifier = Modifier.width(Dimensions.SpaceXS))
        Text(
            text = "Live",
            style = MaterialTheme.typography.labelSmall,
            color = MaterialTheme.colorScheme.tertiary
        )
    }
}

// ------------------------------------------------------------------
// Filter Chips
// ------------------------------------------------------------------

@Composable
private fun ExamsFilterChips(
    filters: List<String>,
    selectedFilter: String,
    onFilterSelected: (String) -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .horizontalScroll(rememberScrollState())
            .padding(horizontal = Dimensions.ScreenPaddingHorizontal),
        horizontalArrangement = Arrangement.spacedBy(Dimensions.SpaceS)
    ) {
        filters.forEach { filter ->
            val isSelected = filter == selectedFilter
            FilterChip(
                selected = isSelected,
                onClick = { onFilterSelected(filter) },
                label = {
                    Text(
                        text = filter,
                        style = MaterialTheme.typography.labelLarge
                    )
                },
                colors = FilterChipDefaults.filterChipColors(
                    selectedContainerColor = MaterialTheme.colorScheme.primary,
                    selectedLabelColor = MaterialTheme.colorScheme.onPrimary,
                    containerColor = MaterialTheme.colorScheme.surfaceVariant,
                    labelColor = MaterialTheme.colorScheme.onSurfaceVariant
                ),
                modifier = Modifier.semantics {
                    contentDescription = if (isSelected) {
                        "$filter filter, selected"
                    } else {
                        "$filter filter"
                    }
                }
            )
        }
    }
}

// ------------------------------------------------------------------
// Exams List
// ------------------------------------------------------------------

@Composable
private fun ExamsList(
    exams: List<Exam>,
    onExamClick: (String) -> Unit
) {
    LazyColumn(
        contentPadding = PaddingValues(
            horizontal = Dimensions.ScreenPaddingHorizontal,
            vertical = Dimensions.ContentSpacingS
        ),
        verticalArrangement = Arrangement.spacedBy(Dimensions.ContentSpacingM),
        modifier = Modifier.fillMaxSize()
    ) {
        items(
            items = exams,
            key = { exam -> exam.id }
        ) { exam ->
            ExamCard(
                exam = exam,
                onClick = { onExamClick(exam.id) }
            )
        }
    }
}

// ------------------------------------------------------------------
// Exam Card
// ------------------------------------------------------------------

@Composable
private fun ExamCard(
    exam: Exam,
    onClick: () -> Unit
) {
    val dateFormatter = remember {
        SimpleDateFormat("MMM dd, yyyy", Locale.getDefault())
    }
    val timeFormatter = remember {
        SimpleDateFormat("hh:mm a", Locale.getDefault())
    }

    val formattedDate = remember(exam.date) {
        dateFormatter.format(Date(exam.date))
    }
    val formattedTime = remember(exam.date) {
        timeFormatter.format(Date(exam.date))
    }

    val examIcon = remember(exam.type) { iconForExamType(exam.type) }
    val iconBackgroundColor = when (exam.type.lowercase()) {
        "lab results" -> MaterialTheme.colorScheme.primaryContainer
        "radiology" -> MaterialTheme.colorScheme.secondaryContainer
        "prescriptions" -> MaterialTheme.colorScheme.tertiaryContainer
        else -> MaterialTheme.colorScheme.surfaceVariant
    }
    val iconTint = when (exam.type.lowercase()) {
        "lab results" -> MaterialTheme.colorScheme.onPrimaryContainer
        "radiology" -> MaterialTheme.colorScheme.onSecondaryContainer
        "prescriptions" -> MaterialTheme.colorScheme.onTertiaryContainer
        else -> MaterialTheme.colorScheme.onSurfaceVariant
    }

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick)
            .semantics { contentDescription = "Exam: ${exam.title}, ${exam.type}, $formattedDate" },
        shape = RoundedCornerShape(Dimensions.CornerRadiusL),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surface
        ),
        elevation = CardDefaults.cardElevation(
            defaultElevation = Dimensions.ElevationS
        )
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(Dimensions.CardPadding)
        ) {
            // Top row: icon + title + type badge
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Icon with colored background
                Box(
                    modifier = Modifier
                        .size(Dimensions.IconSizeXL)
                        .clip(RoundedCornerShape(Dimensions.CornerRadiusM))
                        .background(iconBackgroundColor),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = examIcon,
                        contentDescription = null,
                        tint = iconTint,
                        modifier = Modifier.size(Dimensions.IconSize)
                    )
                }

                Spacer(modifier = Modifier.width(Dimensions.ContentSpacingS))

                // Title and type
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = exam.title,
                        style = MaterialTheme.typography.titleMedium,
                        color = MaterialTheme.colorScheme.onSurface,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis
                    )
                    Text(
                        text = exam.type,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }

                // Type badge
                Box(
                    modifier = Modifier
                        .clip(RoundedCornerShape(Dimensions.CornerRadiusS))
                        .background(MaterialTheme.colorScheme.secondaryContainer)
                        .padding(
                            horizontal = Dimensions.SpaceS,
                            vertical = Dimensions.SpaceXS
                        )
                ) {
                    Text(
                        text = exam.type,
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSecondaryContainer
                    )
                }
            }

            Spacer(modifier = Modifier.height(Dimensions.ContentSpacingS))

            // Date and time row
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = formattedDate,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Text(
                    text = formattedTime,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }

            // Notes section (if available)
            if (!exam.notes.isNullOrBlank()) {
                Spacer(modifier = Modifier.height(Dimensions.ContentSpacingS))

                Text(
                    text = exam.notes,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    maxLines = 2,
                    overflow = TextOverflow.Ellipsis
                )
            }

            Spacer(modifier = Modifier.height(Dimensions.ContentSpacingS))

            // "View Report" link
            Text(
                text = "View Report",
                style = MaterialTheme.typography.labelLarge,
                color = MaterialTheme.colorScheme.primary,
                modifier = Modifier
                    .align(Alignment.End)
                    .clickable(onClick = onClick)
                    .padding(vertical = Dimensions.SpaceXS)
            )
        }
    }
}

// ------------------------------------------------------------------
// Helpers
// ------------------------------------------------------------------

private fun iconForExamType(type: String): ImageVector {
    return when (type.lowercase()) {
        "lab results" -> Icons.Filled.Science
        "radiology" -> Icons.Filled.Description
        "prescriptions" -> Icons.Filled.Description
        else -> Icons.Filled.Description
    }
}
