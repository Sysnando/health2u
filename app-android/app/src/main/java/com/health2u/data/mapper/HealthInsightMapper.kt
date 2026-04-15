package com.health2u.data.mapper

import com.health2u.data.local.entity.HealthInsightEntity
import com.health2u.data.remote.dto.HealthInsightDto
import com.health2u.domain.model.HealthInsight

// Entity to Domain
fun HealthInsightEntity.toDomain(): HealthInsight = HealthInsight(
    id = id,
    userId = userId,
    type = type,
    title = title,
    description = description,
    metricValue = metricValue,
    timestamp = timestamp,
    createdAt = createdAt
)

// Domain to Entity
fun HealthInsight.toEntity(): HealthInsightEntity = HealthInsightEntity(
    id = id,
    userId = userId,
    type = type,
    title = title,
    description = description,
    metricValue = metricValue,
    timestamp = timestamp,
    createdAt = createdAt
)

// DTO to Domain
fun HealthInsightDto.toDomain(): HealthInsight = HealthInsight(
    id = id,
    userId = userId,
    type = type,
    title = title,
    description = description,
    metricValue = metricValue,
    timestamp = timestamp,
    createdAt = createdAt
)

// Domain to DTO
fun HealthInsight.toDto(): HealthInsightDto = HealthInsightDto(
    id = id,
    userId = userId,
    type = type,
    title = title,
    description = description,
    metricValue = metricValue,
    timestamp = timestamp,
    createdAt = createdAt
)
