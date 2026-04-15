package com.health2u.domain.model

data class User(
    val id: String,
    val email: String,
    val name: String,
    val profilePictureUrl: String?,
    val dateOfBirth: Long?,
    val phone: String?
)
