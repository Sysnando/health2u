package com.health2u.data.local.entity

import androidx.room.Entity
import androidx.room.PrimaryKey
import androidx.room.Index

@Entity(
    tableName = "exams",
    indices = [Index(value = ["userId"]), Index(value = ["date"])]
)
data class ExamEntity(
    @PrimaryKey val id: String,
    val userId: String,
    val title: String,
    val type: String,
    val date: Long,
    val fileUrl: String?,
    val localFilePath: String?,
    val notes: String?,
    val createdAt: Long,
    val updatedAt: Long
)
