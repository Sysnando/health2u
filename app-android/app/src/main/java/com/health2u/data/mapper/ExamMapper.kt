package com.health2u.data.mapper

import com.health2u.data.local.entity.ExamEntity
import com.health2u.data.remote.dto.ExamDto
import com.health2u.domain.model.Exam

// Entity to Domain
fun ExamEntity.toDomain(): Exam = Exam(
    id = id,
    userId = userId,
    title = title,
    type = type,
    date = date,
    fileUrl = fileUrl,
    notes = notes,
    createdAt = createdAt,
    updatedAt = updatedAt
)

// Domain to Entity
fun Exam.toEntity(localFilePath: String? = null): ExamEntity = ExamEntity(
    id = id,
    userId = userId,
    title = title,
    type = type,
    date = date,
    fileUrl = fileUrl,
    localFilePath = localFilePath,
    notes = notes,
    createdAt = createdAt,
    updatedAt = updatedAt
)

// DTO to Domain
fun ExamDto.toDomain(): Exam = Exam(
    id = id,
    userId = userId,
    title = title,
    type = type,
    date = date,
    fileUrl = fileUrl,
    notes = notes,
    createdAt = createdAt,
    updatedAt = updatedAt
)

// Domain to DTO
fun Exam.toDto(): ExamDto = ExamDto(
    id = id,
    userId = userId,
    title = title,
    type = type,
    date = date,
    fileUrl = fileUrl,
    notes = notes,
    createdAt = createdAt,
    updatedAt = updatedAt
)
