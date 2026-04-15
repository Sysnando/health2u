package com.health2u.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey
import androidx.room.Index

@Entity(
    tableName = "health_insights",
    indices = [Index(value = ["userId"]), Index(value = ["timestamp"])]
)
data class HealthInsightEntity(
    @PrimaryKey val id: String,
    val userId: String,
    val type: String,
    val title: String,
    val description: String,
    val metricValue: Double?,
    val timestamp: Long,
    val createdAt: Long
)
