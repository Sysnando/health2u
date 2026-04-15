package com.health2u.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey
import androidx.room.Index

@Entity(
    tableName = "appointments",
    indices = [Index(value = ["userId"]), Index(value = ["dateTime"])]
)
data class AppointmentEntity(
    @PrimaryKey val id: String,
    val userId: String,
    val title: String,
    val description: String?,
    val doctorName: String?,
    val location: String?,
    val dateTime: Long,
    val reminderMinutes: Int?,
    val status: String, // UPCOMING, COMPLETED, CANCELLED
    val createdAt: Long
)
