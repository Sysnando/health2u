package com.health2u.presentation.exams

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.health2u.data.Result
import com.health2u.domain.model.Exam
import com.health2u.domain.repository.ExamRepository
import com.health2u.util.ErrorMapper
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class ExamsViewModel @Inject constructor(
    private val examRepository: ExamRepository
) : ViewModel() {

    private val _state = MutableStateFlow(ExamsState())
    val state: StateFlow<ExamsState> = _state.asStateFlow()

    init {
        loadExams()
        observeExams()
    }

    fun onSearchQueryChanged(query: String) {
        _state.update { it.copy(searchQuery = query) }
        applyFilters()
    }

    fun onFilterSelected(filter: String) {
        _state.update { it.copy(selectedFilter = filter) }
        applyFilters()
    }

    fun onRetry() {
        loadExams()
    }

    private fun loadExams() {
        viewModelScope.launch {
            _state.update { it.copy(isLoading = true, error = null) }

            when (val result = examRepository.getExams(filter = null)) {
                is Result.Success -> {
                    _state.update {
                        it.copy(
                            exams = result.data,
                            isLoading = false,
                            error = null
                        )
                    }
                    applyFilters()
                }
                is Result.Error -> {
                    _state.update {
                        it.copy(
                            isLoading = false,
                            error = ErrorMapper.toUserMessage(result.exception)
                        )
                    }
                }
            }
        }
    }

    private fun observeExams() {
        viewModelScope.launch {
            examRepository.observeExams().collect { exams ->
                _state.update { it.copy(exams = exams) }
                applyFilters()
            }
        }
    }

    private fun applyFilters() {
        val currentState = _state.value
        val filtered = currentState.exams
            .filter { exam ->
                if (currentState.selectedFilter == "All Records") {
                    true
                } else {
                    exam.type.equals(currentState.selectedFilter, ignoreCase = true)
                }
            }
            .filter { exam ->
                if (currentState.searchQuery.isBlank()) {
                    true
                } else {
                    exam.title.contains(currentState.searchQuery, ignoreCase = true) ||
                        (exam.notes?.contains(currentState.searchQuery, ignoreCase = true) == true)
                }
            }

        _state.update { it.copy(filteredExams = filtered) }
    }
}
