package com.health2u.util

import java.io.IOException
import java.net.SocketTimeoutException
import java.net.UnknownHostException
import javax.net.ssl.SSLException
import javax.net.ssl.SSLHandshakeException
import retrofit2.HttpException

/**
 * Maps exceptions to user-friendly error messages.
 *
 * Avoid leaking raw exception text (e.g., SSL handshake errors, stack traces)
 * to users. Instead, show a clear message they can act on.
 */
object ErrorMapper {

    /**
     * Convert a Throwable into a short, user-friendly message.
     */
    fun toUserMessage(throwable: Throwable?): String {
        if (throwable == null) return "Something went wrong."
        return when (throwable) {
            is UnknownHostException ->
                "You appear to be offline. Showing cached data when available."
            is SocketTimeoutException ->
                "The server is taking too long to respond. Try again later."
            is SSLHandshakeException, is SSLException ->
                "Couldn't establish a secure connection to the server. Try again later."
            is IOException ->
                "Network error. Check your connection and try again."
            is HttpException -> when (throwable.code()) {
                401 -> "Your session has expired. Please sign in again."
                403 -> "You don't have permission to do that."
                404 -> "We couldn't find what you're looking for."
                in 500..599 -> "The server ran into a problem. Try again later."
                else -> "Request failed. Please try again."
            }
            else -> "Something went wrong. Please try again."
        }
    }

    /**
     * True for exceptions likely caused by a missing/broken network
     * (rather than a logic error).
     */
    fun isNetworkError(throwable: Throwable?): Boolean = when (throwable) {
        is UnknownHostException,
        is SocketTimeoutException,
        is SSLException,
        is IOException -> true
        else -> false
    }
}
