package com.health2u

import android.app.Application
import dagger.hilt.android.HiltAndroidApp

@HiltAndroidApp
class Health2uApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        // Initialize any app-level services here
    }
}
