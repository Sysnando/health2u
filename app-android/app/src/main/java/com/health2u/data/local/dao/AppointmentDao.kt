package com.health2u.data.local.dao

import androidx.room.*
import com.health2u.data.local.entity.AppointmentEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface AppointmentDao {
    @Query("SELECT * FROM appointments WHERE userId = :userId ORDER BY dateTime ASC")
    fun observeAppointments(userId: String): Flow<List<AppointmentEntity>>

    @Query("SELECT * FROM appointments WHERE id = :id")
    suspend fun getAppointmentById(id: String): AppointmentEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAppointment(appointment: AppointmentEntity)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAppointments(appointments: List<AppointmentEntity>)

    @Update
    suspend fun updateAppointment(appointment: AppointmentEntity)

    @Delete
    suspend fun deleteAppointment(appointment: AppointmentEntity)

    @Query("DELETE FROM appointments WHERE id = :id")
    suspend fun deleteAppointmentById(id: String)

    @Query("SELECT * FROM appointments WHERE userId = :userId ORDER BY dateTime ASC")
    suspend fun getAllAppointments(userId: String): List<AppointmentEntity>

    @Query("SELECT * FROM appointments WHERE userId = :userId AND status = :status ORDER BY dateTime ASC")
    suspend fun getAppointmentsByStatus(userId: String, status: String): List<AppointmentEntity>
}
