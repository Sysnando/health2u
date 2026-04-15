package com.health2u.data.remote.dto

import com.google.gson.annotations.SerializedName

data class AppointmentDto(
    @SerializedName("id") val id: String,
    @SerializedName("user_id") val userId: String,
    @SerializedName("title") val title: String,
    @SerializedName("description") val description: String?,
    @SerializedName("doctor_name") val doctorName: String?,
    @SerializedName("location") val location: String?,
    @SerializedName("date_time") val dateTime: Long,
    @SerializedName("reminder_minutes") val reminderMinutes: Int?,
    @SerializedName("status") val status: String,
    @SerializedName("created_at") val createdAt: Long
)
