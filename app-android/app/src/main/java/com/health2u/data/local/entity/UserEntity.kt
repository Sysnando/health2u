package com.health2u.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "users")
data class UserEntity(
    @PrimaryKey val id: String,
    val email: String,
    val name: String,
    val profilePictureUrl: String?,
    val dateOfBirth: Long?,
    val phone: String?,
    val lastSyncTimestamp: Long
)
