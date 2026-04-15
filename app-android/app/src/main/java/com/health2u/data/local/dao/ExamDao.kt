package com.health2u.data.local.dao

import androidx.room.*
import com.health2u.data.local.entity.ExamEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface ExamDao {
    @Query("SELECT * FROM exams WHERE userId = :userId ORDER BY date DESC")
    fun observeExams(userId: String): Flow<List<ExamEntity>>

    @Query("SELECT * FROM exams WHERE id = :id")
    suspend fun getExamById(id: String): ExamEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertExam(exam: ExamEntity)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertExams(exams: List<ExamEntity>)

    @Delete
    suspend fun deleteExam(exam: ExamEntity)

    @Query("DELETE FROM exams WHERE id = :id")
    suspend fun deleteExamById(id: String)

    @Query("SELECT * FROM exams WHERE userId = :userId ORDER BY date DESC")
    suspend fun getAllExams(userId: String): List<ExamEntity>

    @Query("SELECT * FROM exams WHERE userId = :userId AND type = :type ORDER BY date DESC")
    suspend fun getExamsByType(userId: String, type: String): List<ExamEntity>
}
