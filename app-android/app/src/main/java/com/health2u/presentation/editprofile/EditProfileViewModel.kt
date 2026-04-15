package com.health2u.presentation.editprofile

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.health2u.data.Result
import com.health2u.domain.model.User
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
class EditProfileViewModel @Inject constructor(
    private val userRepository: UserRepository
) : ViewModel() {

    private val _state = MutableStateFlow(EditProfileState())
    val state: StateFlow<EditProfileState> = _state.asStateFlow()

    private var originalUser: User? = null

    init {
        loadProfile()
    }

    private fun loadProfile() {
        viewModelScope.launch {
            _state.update { it.copy(isLoading = true, error = null) }
            when (val result = userRepository.getProfile()) {
                is Result.Success -> {
                    val user = result.data
                    originalUser = user
                    _state.update {
                        it.copy(
                            name = user.name,
                            email = user.email,
                            phone = user.phone ?: "",
                            dateOfBirth = user.dateOfBirth?.let { dob -> formatDate(dob) } ?: "",
                            profilePictureUrl = user.profilePictureUrl,
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

    fun onNameChanged(name: String) {
        _state.update {
            it.copy(
                name = name,
                nameError = null
            )
        }
    }

    fun onEmailChanged(email: String) {
        _state.update {
            it.copy(
                email = email,
                emailError = null
            )
        }
    }

    fun onPhoneChanged(phone: String) {
        _state.update { it.copy(phone = phone) }
    }

    fun onDateOfBirthChanged(dateOfBirth: String) {
        _state.update { it.copy(dateOfBirth = dateOfBirth) }
    }

    fun onSave() {
        val currentState = _state.value

        // Validate
        val nameError = if (currentState.name.isBlank()) "Name is required" else null
        val emailError = when {
            currentState.email.isBlank() -> "Email is required"
            !isValidEmail(currentState.email) -> "Invalid email address"
            else -> null
        }

        if (nameError != null || emailError != null) {
            _state.update {
                it.copy(
                    nameError = nameError,
                    emailError = emailError
                )
            }
            return
        }

        viewModelScope.launch {
            _state.update { it.copy(isSaving = true, error = null) }

            val updatedUser = originalUser?.copy(
                name = currentState.name.trim(),
                email = currentState.email.trim(),
                phone = currentState.phone.trim().ifBlank { null }
            ) ?: return@launch

            when (val result = userRepository.updateProfile(updatedUser)) {
                is Result.Success -> {
                    originalUser = result.data
                    _state.update {
                        it.copy(
                            isSaving = false,
                            saveSuccess = true
                        )
                    }
                }
                is Result.Error -> {
                    _state.update {
                        it.copy(
                            isSaving = false,
                            error = ErrorMapper.toUserMessage(result.exception)
                        )
                    }
                }
            }
        }
    }

    fun dismissError() {
        _state.update { it.copy(error = null) }
    }

    fun onSaveSuccessHandled() {
        _state.update { it.copy(saveSuccess = false) }
    }

    private fun isValidEmail(email: String): Boolean {
        return android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches()
    }

    private fun formatDate(timestamp: Long): String {
        val sdf = java.text.SimpleDateFormat("MM/dd/yyyy", java.util.Locale.getDefault())
        return sdf.format(java.util.Date(timestamp))
    }
}
