package com.health2u.data.remote.api

import com.health2u.data.remote.dto.*
import okhttp3.MultipartBody
import okhttp3.RequestBody
import retrofit2.Response
import retrofit2.http.*

interface HealthApiService {
    // Authentication
    @POST("auth/login")
    suspend fun login(@Body request: LoginRequest): Response<AuthResponse>

    @POST("auth/refresh")
    suspend fun refreshToken(@Body request: RefreshTokenRequest): Response<AuthResponse>

    @POST("auth/logout")
    suspend fun logout(): Response<Unit>

    // User Profile
    @GET("user/profile")
    suspend fun getProfile(): Response<UserProfileDto>

    @PUT("user/profile")
    suspend fun updateProfile(@Body profile: UserProfileDto): Response<UserProfileDto>

    // Exams
    @GET("exams")
    suspend fun getExams(@Query("filter") filter: String?): Response<List<ExamDto>>

    @GET("exams/{id}")
    suspend fun getExamById(@Path("id") id: String): Response<ExamDto>

    @Multipart
    @POST("exams/upload")
    suspend fun uploadExam(
        @Part file: MultipartBody.Part,
        @Part("metadata") metadata: RequestBody
    ): Response<ExamDto>

    @DELETE("exams/{id}")
    suspend fun deleteExam(@Path("id") id: String): Response<Unit>

    // Appointments
    @GET("appointments")
    suspend fun getAppointments(): Response<List<AppointmentDto>>

    @POST("appointments")
    suspend fun createAppointment(@Body appointment: AppointmentDto): Response<AppointmentDto>

    @PUT("appointments/{id}")
    suspend fun updateAppointment(
        @Path("id") id: String,
        @Body appointment: AppointmentDto
    ): Response<AppointmentDto>

    @DELETE("appointments/{id}")
    suspend fun deleteAppointment(@Path("id") id: String): Response<Unit>

    // Insights
    @GET("insights")
    suspend fun getHealthInsights(): Response<HealthInsightsDto>

    // Emergency Contacts
    @GET("emergency-contacts")
    suspend fun getEmergencyContacts(): Response<List<EmergencyContactDto>>

    @POST("emergency-contacts")
    suspend fun addEmergencyContact(@Body contact: EmergencyContactDto): Response<EmergencyContactDto>

    @PUT("emergency-contacts/{id}")
    suspend fun updateEmergencyContact(
        @Path("id") id: String,
        @Body contact: EmergencyContactDto
    ): Response<EmergencyContactDto>

    @DELETE("emergency-contacts/{id}")
    suspend fun deleteEmergencyContact(@Path("id") id: String): Response<Unit>
}
