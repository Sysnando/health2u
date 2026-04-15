package com.health2u.di

import android.content.Context
import androidx.room.Room
import com.health2u.data.local.HealthDatabase
import com.health2u.data.local.dao.AppointmentDao
import com.health2u.data.local.dao.EmergencyContactDao
import com.health2u.data.local.dao.ExamDao
import com.health2u.data.local.dao.HealthInsightDao
import com.health2u.data.local.dao.UserDao
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object DatabaseModule {

    @Provides
    @Singleton
    fun provideHealthDatabase(
        @ApplicationContext context: Context
    ): HealthDatabase {
        return Room.databaseBuilder(
            context,
            HealthDatabase::class.java,
            "health2u_database"
        )
            .fallbackToDestructiveMigration()
            .build()
    }

    @Provides
    fun provideUserDao(database: HealthDatabase): UserDao {
        return database.userDao()
    }

    @Provides
    fun provideExamDao(database: HealthDatabase): ExamDao {
        return database.examDao()
    }

    @Provides
    fun provideAppointmentDao(database: HealthDatabase): AppointmentDao {
        return database.appointmentDao()
    }

    @Provides
    fun provideEmergencyContactDao(database: HealthDatabase): EmergencyContactDao {
        return database.emergencyContactDao()
    }

    @Provides
    fun provideHealthInsightDao(database: HealthDatabase): HealthInsightDao {
        return database.healthInsightDao()
    }
}
