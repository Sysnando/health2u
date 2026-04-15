package com.health2u.presentation.editprofile

data class EditProfileState(
    val name: String = "",
    val email: String = "",
    val phone: String = "",
    val dateOfBirth: String = "",
    val profilePictureUrl: String? = null,
    val isLoading: Boolean = true,
    val isSaving: Boolean = false,
    val nameError: String? = null,
    val emailError: String? = null,
    val saveSuccess: Boolean = false,
    val error: String? = null
)
