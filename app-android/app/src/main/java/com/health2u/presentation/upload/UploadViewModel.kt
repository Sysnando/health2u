package com.health2u.presentation.upload

import android.net.Uri
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.health2u.domain.repository.ExamRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class UploadViewModel @Inject constructor(
    private val examRepository: ExamRepository
) : ViewModel() {

    private val _state = MutableStateFlow(UploadState())
    val state: StateFlow<UploadState> = _state.asStateFlow()

    fun onFileSelected(uri: Uri, fileName: String) {
        _state.update {
            it.copy(
                selectedFileUri = uri,
                fileName = fileName,
                uploadProgress = UploadProgress.Uploading,
                error = null
            )
        }
        simulateProcessing()
    }

    private fun simulateProcessing() {
        viewModelScope.launch {
            // Phase 1: Uploading - file integrity check
            _state.update {
                it.copy(
                    overallProgress = 0.05f,
                    processLogs = listOf(
                        ProcessLog(
                            message = "File integrity verified (${it.fileName ?: "document.pdf"})",
                            isComplete = true
                        )
                    )
                )
            }
            delay(800)

            // Phase 2: Transition to processing, detect type
            _state.update {
                it.copy(
                    uploadProgress = UploadProgress.Processing,
                    detectedType = "HDL DETECTED",
                    overallProgress = 0.15f,
                    processingSteps = listOf(
                        ProcessingStep(
                            title = "OCR Extraction",
                            description = "Converting image data to medical values...",
                            status = StepStatus.Active
                        ),
                        ProcessingStep(
                            title = "Updating Trends",
                            description = "Refining Cholesterol & Lipids charts.",
                            status = StepStatus.Pending,
                            detail = "\u2191 4.2% Posterior inference"
                        ),
                        ProcessingStep(
                            title = "Validation",
                            description = "Clinical integrity check: running...",
                            status = StepStatus.Pending
                        )
                    ),
                    processLogs = listOf(
                        ProcessLog(
                            message = "File integrity verified (${it.fileName ?: "document.pdf"})",
                            isComplete = true
                        ),
                        ProcessLog(
                            message = "Extracting Biomarkers...",
                            isComplete = false
                        )
                    )
                )
            }
            delay(1500)

            // Phase 3: OCR complete, trends active
            _state.update {
                it.copy(
                    overallProgress = 0.45f,
                    processingSteps = listOf(
                        ProcessingStep(
                            title = "OCR Extraction",
                            description = "Converting image data to medical values...",
                            status = StepStatus.Complete
                        ),
                        ProcessingStep(
                            title = "Updating Trends",
                            description = "Refining Cholesterol & Lipids charts.",
                            status = StepStatus.Active,
                            detail = "\u2191 4.2% Posterior inference"
                        ),
                        ProcessingStep(
                            title = "Validation",
                            description = "Clinical integrity check: running...",
                            status = StepStatus.Pending
                        )
                    ),
                    processLogs = listOf(
                        ProcessLog(
                            message = "File integrity verified (${it.fileName ?: "document.pdf"})",
                            isComplete = true
                        ),
                        ProcessLog(
                            message = "Extracting Biomarkers...",
                            isComplete = false
                        ),
                        ProcessLog(
                            message = "Analyzing Lipid Panel discrepancies",
                            isComplete = false
                        )
                    )
                )
            }
            delay(1500)

            // Phase 4: Trends complete, validation active
            _state.update {
                it.copy(
                    overallProgress = 0.75f,
                    processingSteps = listOf(
                        ProcessingStep(
                            title = "OCR Extraction",
                            description = "Converting image data to medical values...",
                            status = StepStatus.Complete
                        ),
                        ProcessingStep(
                            title = "Updating Trends",
                            description = "Refining Cholesterol & Lipids charts.",
                            status = StepStatus.Complete,
                            detail = "\u2191 4.2% Posterior inference"
                        ),
                        ProcessingStep(
                            title = "Validation",
                            description = "Clinical integrity check: running...",
                            status = StepStatus.Active
                        )
                    )
                )
            }
            delay(1200)

            // Phase 5: All complete
            _state.update {
                it.copy(
                    uploadProgress = UploadProgress.Complete,
                    overallProgress = 1f,
                    processingSteps = listOf(
                        ProcessingStep(
                            title = "OCR Extraction",
                            description = "Converting image data to medical values...",
                            status = StepStatus.Complete
                        ),
                        ProcessingStep(
                            title = "Updating Trends",
                            description = "Refining Cholesterol & Lipids charts.",
                            status = StepStatus.Complete,
                            detail = "\u2191 4.2% Posterior inference"
                        ),
                        ProcessingStep(
                            title = "Validation",
                            description = "Clinical integrity check: running...",
                            status = StepStatus.Complete
                        )
                    ),
                    processLogs = listOf(
                        ProcessLog(
                            message = "File integrity verified (${it.fileName ?: "document.pdf"})",
                            isComplete = true
                        ),
                        ProcessLog(
                            message = "Biomarkers extracted successfully",
                            isComplete = true
                        ),
                        ProcessLog(
                            message = "Lipid Panel analysis complete",
                            isComplete = true
                        )
                    )
                )
            }
        }
    }

    fun onDismiss() {
        _state.update { UploadState() }
    }
}
