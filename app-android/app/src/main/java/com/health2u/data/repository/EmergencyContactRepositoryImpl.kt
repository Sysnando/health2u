package com.health2u.data.repository

import com.health2u.data.Result
import com.health2u.data.local.dao.EmergencyContactDao
import com.health2u.data.mapper.toDomain
import com.health2u.data.mapper.toDto
import com.health2u.data.mapper.toEntity
import com.health2u.data.remote.api.HealthApiService
import com.health2u.domain.model.EmergencyContact
import com.health2u.domain.repository.EmergencyContactRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject

class EmergencyContactRepositoryImpl @Inject constructor(
    private val emergencyContactDao: EmergencyContactDao,
    private val apiService: HealthApiService
) : EmergencyContactRepository {

    // TODO: Get userId from auth session - hardcoded for now
    private val currentUserId = "user_id_placeholder"

    override suspend fun getEmergencyContacts(): Result<List<EmergencyContact>> {
        return try {
            val response = apiService.getEmergencyContacts()
            if (response.isSuccessful && response.body() != null) {
                val contacts = response.body()!!.map { it.toDomain() }
                emergencyContactDao.insertEmergencyContacts(contacts.map { it.toEntity() })
                Result.Success(contacts)
            } else {
                val cached = emergencyContactDao.getAllEmergencyContacts(currentUserId).map { it.toDomain() }
                if (cached.isNotEmpty()) {
                    Result.Success(cached)
                } else {
                    Result.Error(Exception("API error: ${response.code()}, no cached data available"))
                }
            }
        } catch (e: Exception) {
            try {
                val cached = emergencyContactDao.getAllEmergencyContacts(currentUserId).map { it.toDomain() }
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

    override suspend fun getEmergencyContactById(id: String): Result<EmergencyContact> {
        return try {
            val cached = emergencyContactDao.getEmergencyContactById(id)
            if (cached != null) {
                Result.Success(cached.toDomain())
            } else {
                Result.Error(Exception("Contact not found"))
            }
        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    override suspend fun addEmergencyContact(contact: EmergencyContact): Result<EmergencyContact> {
        return try {
            val response = apiService.addEmergencyContact(contact.toDto())
            if (response.isSuccessful && response.body() != null) {
                val addedContact = response.body()!!.toDomain()
                emergencyContactDao.insertEmergencyContact(addedContact.toEntity())
                Result.Success(addedContact)
            } else {
                Result.Error(Exception("Add failed: ${response.code()}"))
            }
        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    override suspend fun updateEmergencyContact(contact: EmergencyContact): Result<EmergencyContact> {
        return try {
            val response = apiService.updateEmergencyContact(contact.id, contact.toDto())
            if (response.isSuccessful && response.body() != null) {
                val updatedContact = response.body()!!.toDomain()
                emergencyContactDao.updateEmergencyContact(updatedContact.toEntity())
                Result.Success(updatedContact)
            } else {
                Result.Error(Exception("Update failed: ${response.code()}"))
            }
        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    override suspend fun deleteEmergencyContact(id: String): Result<Unit> {
        return try {
            val response = apiService.deleteEmergencyContact(id)
            if (response.isSuccessful) {
                emergencyContactDao.deleteEmergencyContactById(id)
                Result.Success(Unit)
            } else {
                Result.Error(Exception("Delete failed: ${response.code()}"))
            }
        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    override fun observeEmergencyContacts(): Flow<List<EmergencyContact>> {
        return emergencyContactDao.observeEmergencyContacts(currentUserId).map { list ->
            list.map { it.toDomain() }
        }
    }
}
