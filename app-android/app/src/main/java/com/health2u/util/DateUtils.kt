package com.health2u.util

import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

object DateUtils {

    fun formatDate(timestamp: Long, pattern: String = Constants.DATE_FORMAT_DISPLAY): String {
        val date = Date(timestamp)
        val formatter = SimpleDateFormat(pattern, Locale.getDefault())
        return formatter.format(date)
    }

    fun parseDate(dateString: String, pattern: String = Constants.DATE_FORMAT_API): Long {
        val formatter = SimpleDateFormat(pattern, Locale.getDefault())
        return formatter.parse(dateString)?.time ?: 0L
    }

    fun isToday(timestamp: Long): Boolean {
        val today = Calendar.getInstance()
        val date = Calendar.getInstance().apply { timeInMillis = timestamp }
        return today.get(Calendar.YEAR) == date.get(Calendar.YEAR) &&
               today.get(Calendar.DAY_OF_YEAR) == date.get(Calendar.DAY_OF_YEAR)
    }
}
