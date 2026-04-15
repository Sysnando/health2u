package com.health2u.domain.model

data class EmergencyContact(
    val id: String,
    val userId: String,
    val name: String,
    val relationship: String,
    val phone: String,
    val email: String?,
    val isPrimary: Boolean,
    val order: Int
)
