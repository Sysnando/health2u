package com.health2u.data.repository

import com.health2u.data.Result
import com.health2u.data.local.dao.ExamDao
import com.health2u.data.mapper.toDomain
import com.health2u.data.mapper.toDto
import com.health2u.data.mapper.toEntity
import com.health2u.data.remote.api.HealthApiService
import com.health2u.domain.model.Exam
import com.health2u.domain.repository.ExamRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody.Companion.asRequestBody
import okhttp3.RequestBody.Companion.toRequestBody
import java.io.File
import javax.inject.Inject

class ExamRepositoryImpl @Inject constructor(
    private val examDao: ExamDao,
    private val apiService: HealthApiService
) : ExamRepository {

    // TODO: Get userId from auth session - hardcoded for now
    private val currentUserId = "user_id_placeholder"

    override suspend fun getExams(filter: String?): Result<List<Exam>> {
        return try {
            // Try API first
            val response = apiService.getExams(filter)
            if (response.isSuccessful && response.body() != null) {
                val exams = response.body()!!.map { it.toDomain() }
                // Cache in database
                examDao.insertExams(exams.map { it.toEntity() })
                Result.Success(exams)
            } else {
                // Fall back to cached data
                val cached = examDao.getAllExams(currentUserId).map { it.toDomain() }
                if (cached.isNotEmpty()) {
                    Result.Success(cached)
                } else {
                    Result.Error(Exception("API error: ${response.code()}, no cached data available"))
                }
            }
        } catch (e: Exception) {
            // Return cached data on network error
            try {
                val cached = examDao.getAllExams(currentUserId).map { it.toDomain() }
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

    override suspend fun getExamById(id: String): Result<Exam> {
        return try {
            // Try local cache first
            val cachedExam = examDao.getExamById(id)
            if (cachedExam != null) {
                Result.Success(cachedExam.toDomain())
            } else {
                // Fetch from API if not in cache
                val response = apiService.getExamById(id)
                if (response.isSuccessful && response.body() != null) {
                    val exam = response.body()!!.toDomain()
                    examDao.insertExam(exam.toEntity())
                    Result.Success(exam)
                } else {
                    Result.Error(Exception("API error: ${response.code()}"))
                }
            }
        } catch (e: Exception) {
            // Try cache on error
            try {
                val cachedExam = examDao.getExamById(id)
                if (cachedExam != null) {
                    Result.Success(cachedExam.toDomain())
                } else {
                    Result.Error(e)
                }
            } catch (cacheError: Exception) {
                Result.Error(e)
            }
        }
    }

    override suspend fun uploadExam(exam: Exam, file: ByteArray): Result<Exam> {
        return try {
            // Create temporary file
            val tempFile = File.createTempFile("exam_", ".pdf")
            tempFile.writeBytes(file)

            val requestFile = tempFile.asRequestBody("application/pdf".toMediaTypeOrNull())
            val filePart = MultipartBody.Part.createFormData("file", tempFile.name, requestFile)

            // Create metadata JSON
            val metadataJson = """
                {
                    "title": "${exam.title}",
                    "type": "${exam.type}",
                    "date": ${exam.date},
                    "notes": "${exam.notes ?: ""}"
                }
            """.trimIndent()
            val metadata = metadataJson.toRequestBody("application/json".toMediaTypeOrNull())

            val response = apiService.uploadExam(filePart, metadata)
            tempFile.delete()

            if (response.isSuccessful && response.body() != null) {
                val uploadedExam = response.body()!!.toDomain()
                examDao.insertExam(uploadedExam.toEntity())
                Result.Success(uploadedExam)
            } else {
                Result.Error(Exception("Upload failed: ${response.code()}"))
            }
        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    override suspend fun deleteExam(id: String): Result<Unit> {
        return try {
            val response = apiService.deleteExam(id)
            if (response.isSuccessful) {
                examDao.deleteExamById(id)
                Result.Success(Unit)
            } else {
                Result.Error(Exception("Delete failed: ${response.code()}"))
            }
        } catch (e: Exception) {
            Result.Error(e)
        }
    }

    override fun observeExams(): Flow<List<Exam>> {
        return examDao.observeExams(currentUserId).map { list ->
            list.map { it.toDomain() }
        }
    }
}
