package com.health2u.domain.repository

import com.health2u.data.Result
import com.health2u.domain.model.Exam
import kotlinx.coroutines.flow.Flow

interface ExamRepository {
    suspend fun getExams(filter: String?): Result<List<Exam>>
    suspend fun getExamById(id: String): Result<Exam>
    suspend fun uploadExam(exam: Exam, file: ByteArray): Result<Exam>
    suspend fun deleteExam(id: String): Result<Unit>
    fun observeExams(): Flow<List<Exam>>
}
