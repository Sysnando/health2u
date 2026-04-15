package com.health2u.di

import com.health2u.data.repository.AppointmentRepositoryImpl
import com.health2u.data.repository.EmergencyContactRepositoryImpl
import com.health2u.data.repository.ExamRepositoryImpl
import com.health2u.data.repository.HealthInsightRepositoryImpl
import com.health2u.data.repository.UserRepositoryImpl
import com.health2u.domain.repository.AppointmentRepository
import com.health2u.domain.repository.EmergencyContactRepository
import com.health2u.domain.repository.ExamRepository
import com.health2u.domain.repository.HealthInsightRepository
import com.health2u.domain.repository.UserRepository
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
abstract class RepositoryModule {

    @Binds
    @Singleton
    abstract fun bindExamRepository(
        impl: ExamRepositoryImpl
    ): ExamRepository

    @Binds
    @Singleton
    abstract fun bindAppointmentRepository(
        impl: AppointmentRepositoryImpl
    ): AppointmentRepository

    @Binds
    @Singleton
    abstract fun bindUserRepository(
        impl: UserRepositoryImpl
    ): UserRepository

    @Binds
    @Singleton
    abstract fun bindEmergencyContactRepository(
        impl: EmergencyContactRepositoryImpl
    ): EmergencyContactRepository

    @Binds
    @Singleton
    abstract fun bindHealthInsightRepository(
        impl: HealthInsightRepositoryImpl
    ): HealthInsightRepository
}
