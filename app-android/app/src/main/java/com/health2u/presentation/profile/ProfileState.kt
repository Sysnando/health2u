package com.health2u.presentation.profile

import com.health2u.domain.model.User

data class ProfileState(
    val user: User? = null,
    val examCount: Int = 0,
    val appointmentCount: Int = 0,
    val isLoading: Boolean = true,
    val error: String? = null
)
