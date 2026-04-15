package com.health2u.data.remote.dto

import com.google.gson.annotations.SerializedName

data class UserProfileDto(
    @SerializedName("id") val id: String,
    @SerializedName("email") val email: String,
    @SerializedName("name") val name: String,
    @SerializedName("profile_picture_url") val profilePictureUrl: String?,
    @SerializedName("date_of_birth") val dateOfBirth: Long?,
    @SerializedName("phone") val phone: String?
)
