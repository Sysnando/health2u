package com.health2u.data.repository

import com.health2u.data.Result
import com.health2u.data.local.dao.AppointmentDao
import com.health2u.data.mapper.toDomain
import com.health2u.data.mapper.toDto
import com.health2u.data.mapper.toEntity
import com.health2u.data.remote.api.HealthApiService
import com.health2u.domain.model.Appointment
import com.health2u.domain.repository.AppointmentRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject

class AppointmentRepositoryImpl @Inject constructor(
    private val appointmentDao: AppointmentDao,
    private val apiService: HealthApiService
) : AppointmentRepository {

    // TODO: Get userId from auth session - hardcoded for now
    private val currentUserId = "user_id_placeholder"

    override suspend fun getAppointments(): Result<List<Appointment>> {
        return try {
            val response = apiService.getAppointments()
            if (response.isSuccessful && response.body() != null) {
                val appointments = response.body()!!.map { it.toDomain() }
                appointmentDao.insertAppointments(appointments.map { it.toEntity() })
                Result.Success(appointments)
            } else {
                val cached = appointmentDao.getAllAppointments(currentUserId).map { it.toDomain() }
                if (cached.isNotEmpty()) {
                    Result.Success(cached)
                } else {
                    Result.Error(Exception("API error: ${response.code()}, no cached data available"))
                }
            }
        } catch (e: Exception) {
            try {
                val cached = appointmentDao.getAllAppointments(currentUserId).map { it.toDomain() }
                if (cached.isNotEmpty()) {
                    Result.Success(cached)
                } else {
                    Result.Error(e)
                }
            } catch (cacheError: Exception) {
                Result.Error(e)
            }
        }
    }

    override suspend fun getAppointmentById(id: String): Result<Appointment> {
        return try {
            val cached = appointmentDao.getAppointmentById(id)
            if (cached != null) {
                Result.Success(cached.toDomain())
            } else {
                Result.Error(Exception("Appointment not found"))
            }
        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    override suspend fun createAppointment(appointment: Appointment): Result<Appointment> {
        return try {
            val response = apiService.createAppointment(appointment.toDto())
            if (response.isSuccessful && response.body() != null) {
                val createdAppointment = response.body()!!.toDomain()
                appointmentDao.insertAppointment(createdAppointment.toEntity())
                Result.Success(createdAppointment)
            } else {
                Result.Error(Exception("Create failed: ${response.code()}"))
            }
        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    override suspend fun updateAppointment(appointment: Appointment): Result<Appointment> {
        return try {
            val response = apiService.updateAppointment(appointment.id, appointment.toDto())
            if (response.isSuccessful && response.body() != null) {
                val updatedAppointment = response.body()!!.toDomain()
                appointmentDao.updateAppointment(updatedAppointment.toEntity())
                Result.Success(updatedAppointment)
            } else {
                Result.Error(Exception("Update failed: ${response.code()}"))
            }
        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    override suspend fun deleteAppointment(id: String): Result<Unit> {
        return try {
            val response = apiService.deleteAppointment(id)
            if (response.isSuccessful) {
                appointmentDao.deleteAppointmentById(id)
                Result.Success(Unit)
            } else {
                Result.Error(Exception("Delete failed: ${response.code()}"))
            }
        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    override fun observeAppointments(): Flow<List<Appointment>> {
        return appointmentDao.observeAppointments(currentUserId).map { list ->
            list.map { it.toDomain() }
        }
    }
}
