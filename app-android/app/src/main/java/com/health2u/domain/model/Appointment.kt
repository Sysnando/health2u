package com.health2u.domain.model

data class Appointment(
    val id: String,
    val userId: String,
    val title: String,
    val description: String?,
    val doctorName: String?,
    val location: String?,
    val dateTime: Long,
    val reminderMinutes: Int?,
    val status: AppointmentStatus,
    val createdAt: Long
)

enum class AppointmentStatus {
    UPCOMING, COMPLETED, CANCELLED
}
