package com.health2u.data.repository

import com.health2u.data.Result
import com.health2u.data.local.dao.HealthInsightDao
import com.health2u.data.mapper.toDomain
import com.health2u.data.mapper.toEntity
import com.health2u.data.remote.api.HealthApiService
import com.health2u.domain.model.HealthInsight
import com.health2u.domain.repository.HealthInsightRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject

class HealthInsightRepositoryImpl @Inject constructor(
    private val healthInsightDao: HealthInsightDao,
    private val apiService: HealthApiService
) : HealthInsightRepository {

    // TODO: Get userId from auth session - hardcoded for now
    private val currentUserId = "user_id_placeholder"

    override suspend fun getHealthInsights(): Result<List<HealthInsight>> {
        return try {
            val response = apiService.getHealthInsights()
            if (response.isSuccessful && response.body() != null) {
                val insights = response.body()!!.insights.map { it.toDomain() }
                healthInsightDao.insertHealthInsights(insights.map { it.toEntity() })
                Result.Success(insights)
            } else {
                val cached = healthInsightDao.getAllHealthInsights(currentUserId).map { it.toDomain() }
                if (cached.isNotEmpty()) {
                    Result.Success(cached)
                } else {
                    Result.Error(Exception("API error: ${response.code()}, no cached data available"))
                }
            }
        } catch (e: Exception) {
            try {
                val cached = healthInsightDao.getAllHealthInsights(currentUserId).map { it.toDomain() }
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

    override suspend fun getHealthInsightById(id: String): Result<HealthInsight> {
        return try {
            val cached = healthInsightDao.getHealthInsightById(id)
            if (cached != null) {
                Result.Success(cached.toDomain())
            } else {
                Result.Error(Exception("Insight not found"))
            }
        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    override fun observeHealthInsights(): Flow<List<HealthInsight>> {
        return healthInsightDao.observeHealthInsights(currentUserId).map { list ->
            list.map { it.toDomain() }
        }
    }
}
