package com.health2u.data.mapper

import com.health2u.data.local.entity.EmergencyContactEntity
import com.health2u.data.remote.dto.EmergencyContactDto
import com.health2u.domain.model.EmergencyContact

// Entity to Domain
fun EmergencyContactEntity.toDomain(): EmergencyContact = EmergencyContact(
    id = id,
    userId = userId,
    name = name,
    relationship = relationship,
    phone = phone,
    email = email,
    isPrimary = isPrimary,
    order = order
)

// Domain to Entity
fun EmergencyContact.toEntity(): EmergencyContactEntity = EmergencyContactEntity(
    id = id,
    userId = userId,
    name = name,
    relationship = relationship,
    phone = phone,
    email = email,
    isPrimary = isPrimary,
    order = order
)

// DTO to Domain
fun EmergencyContactDto.toDomain(): EmergencyContact = EmergencyContact(
    id = id,
    userId = userId,
    name = name,
    relationship = relationship,
    phone = phone,
    email = email,
    isPrimary = isPrimary,
    order = order
)

// Domain to DTO
fun EmergencyContact.toDto(): EmergencyContactDto = EmergencyContactDto(
    id = id,
    userId = userId,
    name = name,
    relationship = relationship,
    phone = phone,
    email = email,
    isPrimary = isPrimary,
    order = order
)
