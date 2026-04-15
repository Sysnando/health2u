package com.health2u.data.repository

import com.health2u.data.Result
import com.health2u.data.local.dao.UserDao
import com.health2u.data.mapper.toDomain
import com.health2u.data.mapper.toDto
import com.health2u.data.mapper.toEntity
import com.health2u.data.remote.api.HealthApiService
import com.health2u.domain.model.User
import com.health2u.domain.repository.UserRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject

class UserRepositoryImpl @Inject constructor(
    private val userDao: UserDao,
    private val apiService: HealthApiService
) : UserRepository {

    // TODO: Get userId from auth session - hardcoded for now
    private val currentUserId = "user_id_placeholder"

    override suspend fun getProfile(): Result<User> {
        return try {
            // Try API first
            val response = apiService.getProfile()
            if (response.isSuccessful && response.body() != null) {
                val user = response.body()!!.toDomain()
                userDao.insertUser(user.toEntity())
                Result.Success(user)
            } else {
                // Fall back to cached data
                val cached = userDao.getUserById(currentUserId)
                if (cached != null) {
                    Result.Success(cached.toDomain())
                } else {
                    Result.Error(Exception("API error: ${response.code()}, no cached data available"))
                }
            }
        } catch (e: Exception) {
            // Return cached data on network error
            try {
                val cached = userDao.getUserById(currentUserId)
                if (cached != null) {
                    Result.Success(cached.toDomain())
                } else {
                    Result.Error(e)
                }
            } catch (cacheError: Exception) {
                Result.Error(e)
            }
        }
    }

    override suspend fun updateProfile(user: User): Result<User> {
        return try {
            val response = apiService.updateProfile(user.toDto())
            if (response.isSuccessful && response.body() != null) {
                val updatedUser = response.body()!!.toDomain()
                userDao.updateUser(updatedUser.toEntity())
                Result.Success(updatedUser)
            } else {
                Result.Error(Exception("Update failed: ${response.code()}"))
            }
        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    override fun observeProfile(): Flow<User?> {
        return userDao.observeUser(currentUserId).map { entity ->
            entity?.toDomain()
        }
    }

    override suspend fun logout(): Result<Unit> {
        return try {
            val response = apiService.logout()
            if (response.isSuccessful) {
                // Clear local data
                userDao.deleteUser(currentUserId)
                Result.Success(Unit)
            } else {
                Result.Error(Exception("Logout failed: ${response.code()}"))
            }
        } catch (e: Exception) {
            Result.Error(e)
        }
    }
}
