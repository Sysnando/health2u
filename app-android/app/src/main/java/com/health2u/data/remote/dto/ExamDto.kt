package com.health2u.data.remote.dto

import com.google.gson.annotations.SerializedName

data class ExamDto(
    @SerializedName("id") val id: String,
    @SerializedName("user_id") val userId: String,
    @SerializedName("title") val title: String,
    @SerializedName("type") val type: String,
    @SerializedName("date") val date: Long,
    @SerializedName("file_url") val fileUrl: String?,
    @SerializedName("notes") val notes: String?,
    @SerializedName("created_at") val createdAt: Long,
    @SerializedName("updated_at") val updatedAt: Long
)
