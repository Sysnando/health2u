package com.health2u.data.mapper

import com.health2u.data.local.entity.UserEntity
import com.health2u.data.remote.dto.UserProfileDto
import com.health2u.domain.model.User

// Entity to Domain
fun UserEntity.toDomain(): User = User(
    id = id,
    email = email,
    name = name,
    profilePictureUrl = profilePictureUrl,
    dateOfBirth = dateOfBirth,
    phone = phone
)

// Domain to Entity
fun User.toEntity(lastSyncTimestamp: Long = System.currentTimeMillis()): UserEntity = UserEntity(
    id = id,
    email = email,
    name = name,
    profilePictureUrl = profilePictureUrl,
    dateOfBirth = dateOfBirth,
    phone = phone,
    lastSyncTimestamp = lastSyncTimestamp
)

// DTO to Domain
fun UserProfileDto.toDomain(): User = User(
    id = id,
    email = email,
    name = name,
    profilePictureUrl = profilePictureUrl,
    dateOfBirth = dateOfBirth,
    phone = phone
)

// Domain to DTO
fun User.toDto(): UserProfileDto = UserProfileDto(
    id = id,
    email = email,
    name = name,
    profilePictureUrl = profilePictureUrl,
    dateOfBirth = dateOfBirth,
    phone = phone
)
