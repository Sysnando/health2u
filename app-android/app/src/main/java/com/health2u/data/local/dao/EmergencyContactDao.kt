package com.health2u.data.local.dao

import androidx.room.*
import com.health2u.data.local.entity.EmergencyContactEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface EmergencyContactDao {
    @Query("SELECT * FROM emergency_contacts WHERE userId = :userId ORDER BY `order` ASC")
    fun observeEmergencyContacts(userId: String): Flow<List<EmergencyContactEntity>>

    @Query("SELECT * FROM emergency_contacts WHERE id = :id")
    suspend fun getEmergencyContactById(id: String): EmergencyContactEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertEmergencyContact(contact: EmergencyContactEntity)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertEmergencyContacts(contacts: List<EmergencyContactEntity>)

    @Update
    suspend fun updateEmergencyContact(contact: EmergencyContactEntity)

    @Delete
    suspend fun deleteEmergencyContact(contact: EmergencyContactEntity)

    @Query("DELETE FROM emergency_contacts WHERE id = :id")
    suspend fun deleteEmergencyContactById(id: String)

    @Query("SELECT * FROM emergency_contacts WHERE userId = :userId ORDER BY `order` ASC")
    suspend fun getAllEmergencyContacts(userId: String): List<EmergencyContactEntity>

    @Query("SELECT * FROM emergency_contacts WHERE userId = :userId AND isPrimary = 1")
    suspend fun getPrimaryContact(userId: String): EmergencyContactEntity?
}
