package com.health2u.presentation.upload

import android.net.Uri
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.slideOutVertically
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.BookmarkBorder
import androidx.compose.material.icons.filled.CameraAlt
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Description
import androidx.compose.material.icons.filled.Photo
import androidx.compose.material.icons.filled.Share
import androidx.compose.material.icons.filled.UploadFile
import androidx.compose.material.icons.outlined.DataObject
import androidx.compose.material.icons.outlined.Security
import androidx.compose.material.icons.automirrored.outlined.TrendingUp
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.graphics.PathEffect
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.health2u.ui.theme.Dimensions
import com.health2u.ui.theme.ExtendedColors

@Composable
fun UploadScreen(
    onNavigateBack: () -> Unit,
    viewModel: UploadViewModel = hiltViewModel()
) {
    val state by viewModel.state.collectAsStateWithLifecycle()

    val filePickerLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.GetContent()
    ) { uri: Uri? ->
        uri?.let {
            viewModel.onFileSelected(
                uri = it,
                fileName = "PDF_${System.currentTimeMillis()}.pdf"
            )
        }
    }

    val cameraLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.TakePicturePreview()
    ) { bitmap ->
        bitmap?.let {
            viewModel.onFileSelected(
                uri = Uri.EMPTY,
                fileName = "CAMERA_${System.currentTimeMillis()}.jpg"
            )
        }
    }

    Scaffold { paddingValues ->
        AnimatedContent(
            targetState = state.uploadProgress != UploadProgress.Idle,
            transitionSpec = {
                (fadeIn(tween(300)) + slideInVertically { it / 4 })
                    .togetherWith(fadeOut(tween(200)) + slideOutVertically { -it / 4 })
            },
            label = "upload_state_transition"
        ) { isProcessing ->
            if (isProcessing) {
                ProcessingContent(
                    state = state,
                    onClose = {
                        viewModel.onDismiss()
                        onNavigateBack()
                    },
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(paddingValues)
                )
            } else {
                IdleContent(
                    onCameraClick = { cameraLauncher.launch(null) },
                    onGalleryClick = { filePickerLauncher.launch("application/pdf") },
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(paddingValues)
                )
            }
        }
    }
}

// ─────────────────────────────────────────────────────────────
// Idle State: Upload zone with camera / gallery buttons
// ─────────────────────────────────────────────────────────────

@Composable
private fun IdleContent(
    onCameraClick: () -> Unit,
    onGalleryClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier
            .padding(horizontal = Dimensions.ScreenPaddingHorizontal)
            .verticalScroll(rememberScrollState()),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Spacer(modifier = Modifier.weight(1f))

        // Dashed border upload zone
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(280.dp)
                .border(
                    border = BorderStroke(
                        width = Dimensions.BorderWidthMedium,
                        color = MaterialTheme.colorScheme.outline
                    ),
                    shape = RoundedCornerShape(Dimensions.CornerRadiusXL)
                )
                .clip(RoundedCornerShape(Dimensions.CornerRadiusXL))
                .background(MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.3f)),
            contentAlignment = Alignment.Center
        ) {
            // Dashed overlay drawn via Canvas
            androidx.compose.foundation.Canvas(
                modifier = Modifier.fillMaxSize()
            ) {
                val dashEffect = PathEffect.dashPathEffect(
                    floatArrayOf(20f, 12f), 0f
                )
                drawRoundRect(
                    color = androidx.compose.ui.graphics.Color.Gray.copy(alpha = 0.5f),
                    style = Stroke(
                        width = 3f,
                        pathEffect = dashEffect
                    ),
                    cornerRadius = androidx.compose.ui.geometry.CornerRadius(
                        Dimensions.CornerRadiusXL.toPx()
                    )
                )
            }

            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(Dimensions.ContentSpacingM)
            ) {
                Icon(
                    imageVector = Icons.Filled.UploadFile,
                    contentDescription = "Upload file",
                    modifier = Modifier.size(Dimensions.IconSizeXXL),
                    tint = MaterialTheme.colorScheme.primary
                )
                Text(
                    text = "Upload Medical Document",
                    style = MaterialTheme.typography.headlineSmall,
                    fontWeight = FontWeight.Bold,
                    textAlign = TextAlign.Center,
                    color = MaterialTheme.colorScheme.onSurface
                )
                Text(
                    text = "Supported formats: PDF, JPG, PNG",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }

        Spacer(modifier = Modifier.height(Dimensions.SectionSpacingM))

        // Action buttons
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(Dimensions.ContentSpacingM)
        ) {
            OutlinedButton(
                onClick = onCameraClick,
                modifier = Modifier
                    .weight(1f)
                    .height(Dimensions.ButtonHeightLarge),
                shape = RoundedCornerShape(Dimensions.ButtonCornerRadius)
            ) {
                Icon(
                    imageVector = Icons.Filled.CameraAlt,
                    contentDescription = null,
                    modifier = Modifier.size(Dimensions.IconSize)
                )
                Spacer(modifier = Modifier.width(Dimensions.ContentSpacingS))
                Text(text = "Camera")
            }

            OutlinedButton(
                onClick = onGalleryClick,
                modifier = Modifier
                    .weight(1f)
                    .height(Dimensions.ButtonHeightLarge),
                shape = RoundedCornerShape(Dimensions.ButtonCornerRadius)
            ) {
                Icon(
                    imageVector = Icons.Filled.Photo,
                    contentDescription = null,
                    modifier = Modifier.size(Dimensions.IconSize)
                )
                Spacer(modifier = Modifier.width(Dimensions.ContentSpacingS))
                Text(text = "Gallery")
            }
        }

        Spacer(modifier = Modifier.weight(1f))
    }
}

// ─────────────────────────────────────────────────────────────
// Processing State: AI analysis progress
// ─────────────────────────────────────────────────────────────

@Composable
private fun ProcessingContent(
    state: UploadState,
    onClose: () -> Unit,
    modifier: Modifier = Modifier
) {
    val animatedProgress by animateFloatAsState(
        targetValue = state.overallProgress,
        animationSpec = tween(durationMillis = 600),
        label = "progress_animation"
    )

    Column(
        modifier = modifier.verticalScroll(rememberScrollState())
    ) {
        // ── Top bar ────────────────────────────────────────
        ProcessingTopBar(onClose = onClose)

        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = Dimensions.ScreenPaddingHorizontal)
        ) {
            Spacer(modifier = Modifier.height(Dimensions.ContentSpacingM))

            // ── Detected type badge + step indicator ───────
            if (state.detectedType != null) {
                DetectedTypeBadge(label = state.detectedType)
                Spacer(modifier = Modifier.height(Dimensions.ContentSpacingS))
            }

            // Step indicator text
            Text(
                text = "Mapping Biomarkers...",
                style = MaterialTheme.typography.labelMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
            Spacer(modifier = Modifier.height(Dimensions.ContentSpacingS))

            // Overall progress bar
            LinearProgressIndicator(
                progress = { animatedProgress },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(6.dp)
                    .clip(RoundedCornerShape(3.dp)),
                color = MaterialTheme.colorScheme.primary,
                trackColor = MaterialTheme.colorScheme.surfaceVariant
            )

            Spacer(modifier = Modifier.height(Dimensions.SectionSpacingS))

            // ── Main title ─────────────────────────────────
            Text(
                text = "Analyzing Blood Panel...",
                style = MaterialTheme.typography.headlineMedium,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.onSurface
            )
            Spacer(modifier = Modifier.height(Dimensions.ContentSpacingS))

            Text(
                text = "Our Clinical AI is extracting 42 biomarkers and cross-referencing with your historical health data.",
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )

            Spacer(modifier = Modifier.height(Dimensions.SectionSpacingS))

            // ── Processing steps ───────────────────────────
            state.processingSteps.forEachIndexed { index, step ->
                ProcessingStepRow(step = step)
                if (index < state.processingSteps.lastIndex) {
                    Spacer(modifier = Modifier.height(Dimensions.ContentSpacingM))
                }
            }

            Spacer(modifier = Modifier.height(Dimensions.SectionSpacingM))

            // ── Process log section ────────────────────────
            ProcessLogSection(logs = state.processLogs)

            Spacer(modifier = Modifier.height(Dimensions.SectionSpacingM))
        }
    }
}

// ─────────────────────────────────────────────────────────────
// Top bar with close, title, bookmark, share
// ─────────────────────────────────────────────────────────────

@Composable
private fun ProcessingTopBar(
    onClose: () -> Unit,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .padding(
                horizontal = Dimensions.ContentSpacingS,
                vertical = Dimensions.ContentSpacingS
            ),
        verticalAlignment = Alignment.CenterVertically
    ) {
        IconButton(onClick = onClose) {
            Icon(
                imageVector = Icons.Filled.Close,
                contentDescription = "Close",
                tint = MaterialTheme.colorScheme.onSurface
            )
        }

        Text(
            text = "MYHEALTHHUB",
            style = MaterialTheme.typography.titleSmall,
            fontWeight = FontWeight.Bold,
            color = MaterialTheme.colorScheme.onSurface,
            modifier = Modifier.weight(1f),
            textAlign = TextAlign.Center
        )

        IconButton(onClick = { /* bookmark action */ }) {
            Icon(
                imageVector = Icons.Filled.BookmarkBorder,
                contentDescription = "Bookmark",
                tint = MaterialTheme.colorScheme.onSurface
            )
        }
        IconButton(onClick = { /* share action */ }) {
            Icon(
                imageVector = Icons.Filled.Share,
                contentDescription = "Share",
                tint = MaterialTheme.colorScheme.onSurface
            )
        }
    }
}

// ─────────────────────────────────────────────────────────────
// Detected type badge (e.g. "HDL DETECTED")
// ─────────────────────────────────────────────────────────────

@Composable
private fun DetectedTypeBadge(
    label: String,
    modifier: Modifier = Modifier
) {
    Surface(
        modifier = modifier,
        shape = RoundedCornerShape(Dimensions.CornerRadiusS),
        color = ExtendedColors.successContainer,
        contentColor = ExtendedColors.onSuccessContainer
    ) {
        Text(
            text = label,
            style = MaterialTheme.typography.labelSmall,
            fontWeight = FontWeight.Bold,
            modifier = Modifier.padding(
                horizontal = Dimensions.ContentSpacingS,
                vertical = Dimensions.ContentSpacingXS
            )
        )
    }
}

// ─────────────────────────────────────────────────────────────
// Single processing step row
// ─────────────────────────────────────────────────────────────

@Composable
private fun ProcessingStepRow(
    step: ProcessingStep,
    modifier: Modifier = Modifier
) {
    val stepIcon: ImageVector = when (step.title) {
        "OCR Extraction" -> Icons.Outlined.DataObject
        "Updating Trends" -> Icons.AutoMirrored.Outlined.TrendingUp
        "Validation" -> Icons.Outlined.Security
        else -> Icons.Filled.Description
    }

    Card(
        modifier = modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = when (step.status) {
                StepStatus.Active -> MaterialTheme.colorScheme.primaryContainer.copy(alpha = 0.3f)
                StepStatus.Complete -> ExtendedColors.successContainer.copy(alpha = 0.3f)
                StepStatus.Pending -> MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f)
            }
        ),
        shape = RoundedCornerShape(Dimensions.CornerRadiusL)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(Dimensions.CardPadding),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(Dimensions.ContentSpacingM)
        ) {
            // Status icon
            StepStatusIcon(status = step.status, icon = stepIcon)

            // Text content
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = step.title,
                    style = MaterialTheme.typography.titleSmall,
                    fontWeight = FontWeight.SemiBold,
                    color = MaterialTheme.colorScheme.onSurface
                )
                Text(
                    text = step.description,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                if (step.detail != null) {
                    Spacer(modifier = Modifier.height(Dimensions.ContentSpacingXS))
                    Text(
                        text = step.detail,
                        style = MaterialTheme.typography.labelSmall,
                        fontWeight = FontWeight.Medium,
                        color = ExtendedColors.info
                    )
                }
            }
        }
    }
}

// ─────────────────────────────────────────────────────────────
// Step status icon (spinner / check / pending dot)
// ─────────────────────────────────────────────────────────────

@Composable
private fun StepStatusIcon(
    status: StepStatus,
    icon: ImageVector,
    modifier: Modifier = Modifier
) {
    val infiniteTransition = rememberInfiniteTransition(label = "spinner")
    val rotation by infiniteTransition.animateFloat(
        initialValue = 0f,
        targetValue = 360f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 1200, easing = LinearEasing),
            repeatMode = RepeatMode.Restart
        ),
        label = "spinner_rotation"
    )

    Box(
        modifier = modifier
            .size(Dimensions.IconSizeXL)
            .clip(CircleShape)
            .background(
                when (status) {
                    StepStatus.Active -> MaterialTheme.colorScheme.primary.copy(alpha = 0.15f)
                    StepStatus.Complete -> ExtendedColors.success.copy(alpha = 0.15f)
                    StepStatus.Pending -> MaterialTheme.colorScheme.outline.copy(alpha = 0.1f)
                }
            ),
        contentAlignment = Alignment.Center
    ) {
        when (status) {
            StepStatus.Active -> {
                CircularProgressIndicator(
                    modifier = Modifier.size(Dimensions.IconSizeS),
                    strokeWidth = 2.dp,
                    color = MaterialTheme.colorScheme.primary
                )
            }
            StepStatus.Complete -> {
                Icon(
                    imageVector = Icons.Filled.CheckCircle,
                    contentDescription = "Complete",
                    modifier = Modifier.size(Dimensions.IconSize),
                    tint = ExtendedColors.success
                )
            }
            StepStatus.Pending -> {
                Icon(
                    imageVector = icon,
                    contentDescription = null,
                    modifier = Modifier.size(Dimensions.IconSizeS),
                    tint = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
    }
}

// ─────────────────────────────────────────────────────────────
// Process log section
// ─────────────────────────────────────────────────────────────

@Composable
private fun ProcessLogSection(
    logs: List<ProcessLog>,
    modifier: Modifier = Modifier
) {
    Column(modifier = modifier.fillMaxWidth()) {
        // Header
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = "PROCESS LOG",
                style = MaterialTheme.typography.labelLarge,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.onSurface
            )
            Text(
                text = "Real-time sync",
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }

        Spacer(modifier = Modifier.height(Dimensions.ContentSpacingS))

        Card(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(
                containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f)
            ),
            shape = RoundedCornerShape(Dimensions.CornerRadiusL)
        ) {
            Column(
                modifier = Modifier.padding(Dimensions.CardPadding),
                verticalArrangement = Arrangement.spacedBy(Dimensions.ContentSpacingS)
            ) {
                logs.forEachIndexed { index, log ->
                    LogEntry(log = log)
                    if (index < logs.lastIndex) {
                        HorizontalDivider(
                            color = MaterialTheme.colorScheme.outlineVariant,
                            thickness = Dimensions.DividerThickness
                        )
                    }
                }

                if (logs.isEmpty()) {
                    Text(
                        text = "Waiting for upload...",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        }
    }
}

@Composable
private fun LogEntry(
    log: ProcessLog,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .padding(vertical = Dimensions.ContentSpacingXS),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(Dimensions.ContentSpacingS)
    ) {
        if (log.isComplete) {
            Icon(
                imageVector = Icons.Filled.CheckCircle,
                contentDescription = "Complete",
                modifier = Modifier.size(Dimensions.IconSizeS),
                tint = ExtendedColors.success
            )
        } else {
            CircularProgressIndicator(
                modifier = Modifier.size(Dimensions.IconSizeS),
                strokeWidth = 2.dp,
                color = MaterialTheme.colorScheme.primary
            )
        }

        Text(
            text = log.message,
            style = MaterialTheme.typography.bodySmall,
            color = if (log.isComplete) {
                MaterialTheme.colorScheme.onSurface
            } else {
                MaterialTheme.colorScheme.onSurfaceVariant
            },
            modifier = Modifier.weight(1f)
        )
    }
}
