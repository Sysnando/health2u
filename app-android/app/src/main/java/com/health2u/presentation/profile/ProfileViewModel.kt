package com.health2u.presentation.profile

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.health2u.data.Result
import com.health2u.domain.repository.AppointmentRepository
import com.health2u.domain.repository.ExamRepository
import com.health2u.domain.repository.UserRepository
import com.health2u.util.ErrorMapper
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class ProfileViewModel @Inject constructor(
    private val userRepository: UserRepository,
    private val examRepository: ExamRepository,
    private val appointmentRepository: AppointmentRepository
) : ViewModel() {

    private val _state = MutableStateFlow(ProfileState())
    val state: StateFlow<ProfileState> = _state.asStateFlow()

    init {
        loadProfile()
        observeProfile()
        observeExams()
        observeAppointments()
    }

    private fun loadProfile() {
        viewModelScope.launch {
            _state.update { it.copy(isLoading = true, error = null) }
            when (val result = userRepository.getProfile()) {
                is Result.Success -> {
                    _state.update {
                        it.copy(
                            user = result.data,
                            isLoading = false
                        )
                    }
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

    private fun observeProfile() {
        viewModelScope.launch {
            userRepository.observeProfile().collect { user ->
                if (user != null) {
                    _state.update { it.copy(user = user) }
                }
            }
        }
    }

    private fun observeExams() {
        viewModelScope.launch {
            examRepository.observeExams().collect { exams ->
                _state.update { it.copy(examCount = exams.size) }
            }
        }
    }

    private fun observeAppointments() {
        viewModelScope.launch {
            appointmentRepository.observeAppointments().collect { appointments ->
                _state.update { it.copy(appointmentCount = appointments.size) }
            }
        }
    }

    fun onLogout(onLogoutComplete: () -> Unit) {
        viewModelScope.launch {
            _state.update { it.copy(isLoading = true) }
            when (userRepository.logout()) {
                is Result.Success -> onLogoutComplete()
                is Result.Error -> {
                    _state.update {
                        it.copy(
                            isLoading = false,
                            error = "Failed to logout. Please try again."
                        )
                    }
                }
            }
        }
    }

    fun dismissError() {
        _state.update { it.copy(error = null) }
    }

    fun refresh() {
        loadProfile()
    }
}
