package com.health2u.domain.repository

import com.health2u.data.Result
import com.health2u.domain.model.EmergencyContact
import kotlinx.coroutines.flow.Flow

interface EmergencyContactRepository {
    suspend fun getEmergencyContacts(): Result<List<EmergencyContact>>
    suspend fun getEmergencyContactById(id: String): Result<EmergencyContact>
    suspend fun addEmergencyContact(contact: EmergencyContact): Result<EmergencyContact>
    suspend fun updateEmergencyContact(contact: EmergencyContact): Result<EmergencyContact>
    suspend fun deleteEmergencyContact(id: String): Result<Unit>
    fun observeEmergencyContacts(): Flow<List<EmergencyContact>>
}
