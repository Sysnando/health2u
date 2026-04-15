package com.health2u.domain.repository

import com.health2u.data.Result
import com.health2u.domain.model.HealthInsight
import kotlinx.coroutines.flow.Flow

interface HealthInsightRepository {
    suspend fun getHealthInsights(): Result<List<HealthInsight>>
    suspend fun getHealthInsightById(id: String): Result<HealthInsight>
    fun observeHealthInsights(): Flow<List<HealthInsight>>
}
