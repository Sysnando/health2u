package com.health2u.data.local

import androidx.room.Database
import androidx.room.RoomDatabase
import com.health2u.data.local.dao.*
import com.health2u.data.local.entity.*

@Database(
    entities = [
        UserEntity::class,
        ExamEntity::class,
        AppointmentEntity::class,
        EmergencyContactEntity::class,
        HealthInsightEntity::class
    ],
    version = 1,
    exportSchema = false
)
abstract class HealthDatabase : RoomDatabase() {
    abstract fun userDao(): UserDao
    abstract fun examDao(): ExamDao
    abstract fun appointmentDao(): AppointmentDao
    abstract fun emergencyContactDao(): EmergencyContactDao
    abstract fun healthInsightDao(): HealthInsightDao
}
