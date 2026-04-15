package com.health2u.domain.repository

import com.health2u.data.Result
import com.health2u.domain.model.User
import kotlinx.coroutines.flow.Flow

interface UserRepository {
    suspend fun getProfile(): Result<User>
    suspend fun updateProfile(user: User): Result<User>
    fun observeProfile(): Flow<User?>
    suspend fun logout(): Result<Unit>
}
