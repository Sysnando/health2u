package com.health2u.presentation.exams

import com.health2u.domain.model.Exam

data class ExamsState(
    val exams: List<Exam> = emptyList(),
    val filteredExams: List<Exam> = emptyList(),
    val searchQuery: String = "",
    val selectedFilter: String = "All Records",
    val availableFilters: List<String> = listOf("All Records", "Lab Results", "Radiology", "Prescriptions"),
    val isLoading: Boolean = true,
    val error: String? = null
)
