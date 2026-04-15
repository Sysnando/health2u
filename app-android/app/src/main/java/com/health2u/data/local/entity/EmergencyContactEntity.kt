package com.health2u.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey
import androidx.room.Index

@Entity(
    tableName = "emergency_contacts",
    indices = [Index(value = ["userId"]), Index(value = ["order"])]
)
data class EmergencyContactEntity(
    @PrimaryKey val id: String,
    val userId: String,
    val name: String,
    val relationship: String,
    val phone: String,
    val email: String?,
    val isPrimary: Boolean,
    val order: Int
)
