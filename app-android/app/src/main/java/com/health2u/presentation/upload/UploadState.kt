package com.health2u.presentation.upload

import android.net.Uri

data class UploadState(
    val selectedFileUri: Uri? = null,
    val fileName: String? = null,
    val uploadProgress: UploadProgress = UploadProgress.Idle,
    val processingSteps: List<ProcessingStep> = emptyList(),
    val processLogs: List<ProcessLog> = emptyList(),
    val detectedType: String? = null,
    val overallProgress: Float = 0f,
    val error: String? = null
)

enum class UploadProgress {
    Idle, Uploading, Processing, Complete, Error
}

data class ProcessingStep(
    val title: String,
    val description: String,
    val status: StepStatus,
    val detail: String? = null
)

enum class StepStatus {
    Pending, Active, Complete
}

data class ProcessLog(
    val message: String,
    val isComplete: Boolean
)
