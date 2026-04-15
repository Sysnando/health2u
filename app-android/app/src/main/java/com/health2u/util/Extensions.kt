package com.health2u.util

import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.collectLatest

// Flow extensions for Compose
@Composable
fun <T> Flow<T>.collectAsEffect(block: suspend (T) -> Unit) {
    LaunchedEffect(key1 = this) {
        this@collectAsEffect.collectLatest(block)
    }
}

// String extensions
fun String.isValidEmail(): Boolean {
    return android.util.Patterns.EMAIL_ADDRESS.matcher(this).matches()
}

fun String.isValidPassword(): Boolean {
    // Min 8 characters, at least one letter and one number
    return this.length >= 8 &&
           this.any { it.isLetter() } &&
           this.any { it.isDigit() }
}
