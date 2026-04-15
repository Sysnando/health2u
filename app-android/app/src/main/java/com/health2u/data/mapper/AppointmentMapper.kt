package com.health2u.data.mapper

import com.health2u.data.local.entity.AppointmentEntity
import com.health2u.data.remote.dto.AppointmentDto
import com.health2u.domain.model.Appointment
import com.health2u.domain.model.AppointmentStatus

// Entity to Domain
fun AppointmentEntity.toDomain(): Appointment = Appointment(
    id = id,
    userId = userId,
    title = title,
    description = description,
    doctorName = doctorName,
    location = location,
    dateTime = dateTime,
    reminderMinutes = reminderMinutes,
    status = AppointmentStatus.valueOf(status),
    createdAt = createdAt
)

// Domain to Entity
fun Appointment.toEntity(): AppointmentEntity = AppointmentEntity(
    id = id,
    userId = userId,
    title = title,
    description = description,
    doctorName = doctorName,
    location = location,
    dateTime = dateTime,
    reminderMinutes = reminderMinutes,
    status = status.name,
    createdAt = createdAt
)

// DTO to Domain
fun AppointmentDto.toDomain(): Appointment = Appointment(
    id = id,
    userId = userId,
    title = title,
    description = description,
    doctorName = doctorName,
    location = location,
    dateTime = dateTime,
    reminderMinutes = reminderMinutes,
    status = AppointmentStatus.valueOf(status),
    createdAt = createdAt
)

// Domain to DTO
fun Appointment.toDto(): AppointmentDto = AppointmentDto(
    id = id,
    userId = userId,
    title = title,
    description = description,
    doctorName = doctorName,
    location = location,
    dateTime = dateTime,
    reminderMinutes = reminderMinutes,
    status = status.name,
    createdAt = createdAt
)
