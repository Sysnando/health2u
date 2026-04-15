package com.health2u.util

import android.util.Base64
import java.security.MessageDigest

object SecurityUtils {

    fun hashString(input: String): String {
        val bytes = MessageDigest.getInstance("SHA-256").digest(input.toByteArray())
        return bytes.joinToString("") { "%02x".format(it) }
    }

    fun encodeBase64(input: ByteArray): String {
        return Base64.encodeToString(input, Base64.NO_WRAP)
    }

    fun decodeBase64(input: String): ByteArray {
        return Base64.decode(input, Base64.NO_WRAP)
    }
}
