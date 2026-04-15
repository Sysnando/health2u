package com.health2u.domain.repository

import com.health2u.data.Result
import com.health2u.domain.model.Appointment
import kotlinx.coroutines.flow.Flow

interface AppointmentRepository {
    suspend fun getAppointments(): Result<List<Appointment>>
    suspend fun getAppointmentById(id: String): Result<Appointment>
    suspend fun createAppointment(appointment: Appointment): Result<Appointment>
    suspend fun updateAppointment(appointment: Appointment): Result<Appointment>
    suspend fun deleteAppointment(id: String): Result<Unit>
    fun observeAppointments(): Flow<List<Appointment>>
}
