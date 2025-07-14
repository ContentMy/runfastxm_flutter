package com.example.runfastxm_flutter

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

/**
 * @Author ContentMy
 * @Date 2025/7/14 14:38
 * @Description
 */

class ReminderReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        Log.d("runfastxm_flutter", "onReceive: 收到通知 - ReminderReceiver")
        val id = intent.getStringExtra("id") ?: ""
        val title = intent.getStringExtra("title") ?: ""
        val content = intent.getStringExtra("content") ?: ""

        NotificationUtils.showNotification(context, id, title, content)
    }
}
