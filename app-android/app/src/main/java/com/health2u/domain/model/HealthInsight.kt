package com.health2u.domain.model

data class HealthInsight(
    val id: String,
    val userId: String,
    val type: String,
    val title: String,
    val description: String,
    val metricValue: Double?,
    val timestamp: Long,
    val createdAt: Long
)
