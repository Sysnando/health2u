package com.health2u.presentation.settings

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.health2u.data.Result
import com.health2u.domain.repository.UserRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class SettingsViewModel @Inject constructor(
    private val userRepository: UserRepository
) : ViewModel() {

    private val _state = MutableStateFlow(SettingsState())
    val state: StateFlow<SettingsState> = _state.asStateFlow()

    fun onToggleNotifications(enabled: Boolean) {
        _state.update { it.copy(notificationsEnabled = enabled) }
    }

    fun onToggleDarkMode(enabled: Boolean) {
        _state.update { it.copy(darkModeEnabled = enabled) }
    }

    fun onLogout(onLogoutComplete: () -> Unit) {
        viewModelScope.launch {
            _state.update { it.copy(isLoggingOut = true) }
            when (userRepository.logout()) {
                is Result.Success -> onLogoutComplete()
                is Result.Error -> {
                    _state.update {
                        it.copy(
                            isLoggingOut = false,
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
}
