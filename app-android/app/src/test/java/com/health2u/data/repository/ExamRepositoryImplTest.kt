package com.health2u.data.repository

import com.health2u.data.Result
import com.health2u.data.local.dao.ExamDao
import com.health2u.data.local.entity.ExamEntity
import com.health2u.data.remote.api.HealthApiService
import com.health2u.data.remote.dto.ExamDto
import com.health2u.domain.model.Exam
import kotlinx.coroutines.flow.flowOf
import kotlinx.coroutines.test.runTest
import okhttp3.ResponseBody.Companion.toResponseBody
import org.junit.Before
import org.junit.Test
import org.mockito.Mock
import org.mockito.Mockito.verify
import org.mockito.Mockito.`when`
import org.mockito.MockitoAnnotations
import retrofit2.Response
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class ExamRepositoryImplTest {

    @Mock
    private lateinit var examDao: ExamDao

    @Mock
    private lateinit var apiService: HealthApiService

    private lateinit var repository: ExamRepositoryImpl

    private val testUserId = "user_id_placeholder"

    private val testExamEntity = ExamEntity(
        id = "exam1",
        userId = testUserId,
        title = "Blood Test",
        type = "Lab",
        date = 1234567890L,
        fileUrl = "https://example.com/exam.pdf",
        localFilePath = null,
        notes = "Test notes",
        createdAt = 1234567890L,
        updatedAt = 1234567890L
    )

    private val testExamDto = ExamDto(
        id = "exam1",
        userId = testUserId,
        title = "Blood Test",
        type = "Lab",
        date = 1234567890L,
        fileUrl = "https://example.com/exam.pdf",
        notes = "Test notes",
        createdAt = 1234567890L,
        updatedAt = 1234567890L
    )

    @Before
    fun setup() {
        MockitoAnnotations.openMocks(this)
        repository = ExamRepositoryImpl(examDao, apiService)
    }

    @Test
    fun `getExams with successful API response should cache and return data`() = runTest {
        // Given
        val examDtos = listOf(testExamDto)
        `when`(apiService.getExams(null)).thenReturn(Response.success(examDtos))

        // When
        val result = repository.getExams(null)

        // Then
        assertTrue(result is Result.Success)
        assertEquals(1, (result as Result.Success).data.size)
        assertEquals("exam1", result.data[0].id)
        verify(examDao).insertExams(org.mockito.kotlin.any())
    }

    @Test
    fun `getExams with API error should return cached data`() = runTest {
        // Given
        `when`(apiService.getExams(null)).thenReturn(Response.error(500, "".toResponseBody()))
        `when`(examDao.getAllExams(testUserId)).thenReturn(listOf(testExamEntity))

        // When
        val result = repository.getExams(null)

        // Then
        assertTrue(result is Result.Success)
        assertEquals(1, (result as Result.Success).data.size)
    }

    @Test
    fun `getExams with network exception should return cached data`() = runTest {
        // Given
        `when`(apiService.getExams(null)).thenThrow(RuntimeException("Network error"))
        `when`(examDao.getAllExams(testUserId)).thenReturn(listOf(testExamEntity))

        // When
        val result = repository.getExams(null)

        // Then
        assertTrue(result is Result.Success)
        assertEquals(1, (result as Result.Success).data.size)
    }

    @Test
    fun `getExamById should return cached exam if available`() = runTest {
        // Given
        `when`(examDao.getExamById("exam1")).thenReturn(testExamEntity)

        // When
        val result = repository.getExamById("exam1")

        // Then
        assertTrue(result is Result.Success)
        assertEquals("exam1", (result as Result.Success).data.id)
    }

    @Test
    fun `deleteExam should delete from API and cache`() = runTest {
        // Given
        `when`(apiService.deleteExam("exam1")).thenReturn(Response.success(Unit))

        // When
        val result = repository.deleteExam("exam1")

        // Then
        assertTrue(result is Result.Success)
        verify(examDao).deleteExamById("exam1")
    }

    @Test
    fun `observeExams should return Flow of exams`() = runTest {
        // Given
        `when`(examDao.observeExams(testUserId)).thenReturn(flowOf(listOf(testExamEntity)))

        // When
        var emittedData: List<Exam>? = null
        repository.observeExams().collect { exams ->
            emittedData = exams
        }

        // Then
        assertEquals(1, emittedData?.size)
        assertEquals("exam1", emittedData?.get(0)?.id)
    }
}
