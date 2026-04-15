package com.health2u.data.remote.dto

import com.google.gson.annotations.SerializedName

data class HealthInsightsDto(
    @SerializedName("insights") val insights: List<HealthInsightDto>
)

data class HealthInsightDto(
    @SerializedName("id") val id: String,
    @SerializedName("user_id") val userId: String,
    @SerializedName("type") val type: String,
    @SerializedName("title") val title: String,
    @SerializedName("description") val description: String,
    @SerializedName("metric_value") val metricValue: Double?,
    @SerializedName("timestamp") val timestamp: Long,
    @SerializedName("created_at") val createdAt: Long
)
