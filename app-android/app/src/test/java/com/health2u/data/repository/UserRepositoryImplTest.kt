package com.health2u.data.repository

import com.health2u.data.Result
import com.health2u.data.local.dao.UserDao
import com.health2u.data.local.entity.UserEntity
import com.health2u.data.remote.api.HealthApiService
import com.health2u.data.remote.dto.UserProfileDto
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

class UserRepositoryImplTest {

    @Mock
    private lateinit var userDao: UserDao

    @Mock
    private lateinit var apiService: HealthApiService

    private lateinit var repository: UserRepositoryImpl

    private val testUserId = "user_id_placeholder"

    private val testUserEntity = UserEntity(
        id = testUserId,
        email = "test@example.com",
        name = "Test User",
        profilePictureUrl = null,
        dateOfBirth = null,
        phone = null,
        lastSyncTimestamp = 1234567890L
    )

    private val testUserDto = UserProfileDto(
        id = testUserId,
        email = "test@example.com",
        name = "Test User",
        profilePictureUrl = null,
        dateOfBirth = null,
        phone = null
    )

    @Before
    fun setup() {
        MockitoAnnotations.openMocks(this)
        repository = UserRepositoryImpl(userDao, apiService)
    }

    @Test
    fun `getProfile with successful API response should cache and return user`() = runTest {
        // Given
        `when`(apiService.getProfile()).thenReturn(Response.success(testUserDto))

        // When
        val result = repository.getProfile()

        // Then
        assertTrue(result is Result.Success)
        assertEquals(testUserId, (result as Result.Success).data.id)
        assertEquals("test@example.com", result.data.email)
        verify(userDao).insertUser(org.mockito.kotlin.any())
    }

    @Test
    fun `getProfile with API error should return cached data`() = runTest {
        // Given
        `when`(apiService.getProfile()).thenReturn(Response.error(500, "".toResponseBody()))
        `when`(userDao.getUserById(testUserId)).thenReturn(testUserEntity)

        // When
        val result = repository.getProfile()

        // Then
        assertTrue(result is Result.Success)
        assertEquals(testUserId, (result as Result.Success).data.id)
    }

    @Test
    fun `updateProfile should update via API and cache`() = runTest {
        // Given
        val updatedDto = testUserDto.copy(name = "Updated Name")
        `when`(apiService.updateProfile(org.mockito.kotlin.any())).thenReturn(Response.success(updatedDto))

        // When
        val testUser = testUserDto.let {
            com.health2u.domain.model.User(
                id = it.id,
                email = it.email,
                name = "Updated Name",
                profilePictureUrl = it.profilePictureUrl,
                dateOfBirth = it.dateOfBirth,
                phone = it.phone
            )
        }
        val result = repository.updateProfile(testUser)

        // Then
        assertTrue(result is Result.Success)
        assertEquals("Updated Name", (result as Result.Success).data.name)
        verify(userDao).updateUser(org.mockito.kotlin.any())
    }

    @Test
    fun `logout should call API and clear local data`() = runTest {
        // Given
        `when`(apiService.logout()).thenReturn(Response.success(Unit))

        // When
        val result = repository.logout()

        // Then
        assertTrue(result is Result.Success)
        verify(userDao).deleteUser(testUserId)
    }

    @Test
    fun `observeProfile should return Flow of user`() = runTest {
        // Given
        `when`(userDao.observeUser(testUserId)).thenReturn(flowOf(testUserEntity))

        // When
        var emittedUser: com.health2u.domain.model.User? = null
        repository.observeProfile().collect { user ->
            emittedUser = user
        }

        // Then
        assertEquals(testUserId, emittedUser?.id)
        assertEquals("test@example.com", emittedUser?.email)
    }
}
