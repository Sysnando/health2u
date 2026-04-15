package com.health2u.data.local.dao

import androidx.room.*
import com.health2u.data.local.entity.HealthInsightEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface HealthInsightDao {
    @Query("SELECT * FROM health_insights WHERE userId = :userId ORDER BY timestamp DESC")
    fun observeHealthInsights(userId: String): Flow<List<HealthInsightEntity>>

    @Query("SELECT * FROM health_insights WHERE id = :id")
    suspend fun getHealthInsightById(id: String): HealthInsightEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertHealthInsight(insight: HealthInsightEntity)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertHealthInsights(insights: List<HealthInsightEntity>)

    @Delete
    suspend fun deleteHealthInsight(insight: HealthInsightEntity)

    @Query("DELETE FROM health_insights WHERE id = :id")
    suspend fun deleteHealthInsightById(id: String)

    @Query("SELECT * FROM health_insights WHERE userId = :userId ORDER BY timestamp DESC")
    suspend fun getAllHealthInsights(userId: String): List<HealthInsightEntity>

    @Query("SELECT * FROM health_insights WHERE userId = :userId AND type = :type ORDER BY timestamp DESC")
    suspend fun getHealthInsightsByType(userId: String, type: String): List<HealthInsightEntity>
}
