package com.example.runfastxm_flutter

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat

/**
 * @Author ContentMy
 * @Date 2025/7/14 14:39
 * @Description
 */

object NotificationUtils {

    private const val CHANNEL_ID = "reminder_channel"

    fun showNotification(context: Context, id: String, title: String, content: String) {
        Log.d("runfastxm_flutter", "onReceive: 收到通知 - showNotification")
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "提醒通知",
                NotificationManager.IMPORTANCE_HIGH
            )
            manager.createNotificationChannel(channel)
        }

        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_dialog_info) // 换成你项目里的 icon
            .setContentTitle(title)
            .setContentText(content)
            .setAutoCancel(true)
            .build()

        manager.notify(id.hashCode(), notification)
    }
}
