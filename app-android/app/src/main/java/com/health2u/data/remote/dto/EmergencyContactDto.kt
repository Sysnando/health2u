package com.health2u.data.remote.dto

import com.google.gson.annotations.SerializedName

data class EmergencyContactDto(
    @SerializedName("id") val id: String,
    @SerializedName("user_id") val userId: String,
    @SerializedName("name") val name: String,
    @SerializedName("relationship") val relationship: String,
    @SerializedName("phone") val phone: String,
    @SerializedName("email") val email: String?,
    @SerializedName("is_primary") val isPrimary: Boolean,
    @SerializedName("order") val order: Int
)
