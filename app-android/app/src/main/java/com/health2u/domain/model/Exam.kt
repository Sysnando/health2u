package com.health2u.domain.model

data class Exam(
    val id: String,
    val userId: String,
    val title: String,
    val type: String,
    val date: Long,
    val fileUrl: String?,
    val notes: String?,
    val createdAt: Long,
    val updatedAt: Long
)
