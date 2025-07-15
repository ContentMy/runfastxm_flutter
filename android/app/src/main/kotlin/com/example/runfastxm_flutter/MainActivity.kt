package com.example.runfastxm_flutter

import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.NotificationManager
import android.content.Context
import android.net.Uri
import android.os.Build

class MainActivity: FlutterActivity() {
    private val CHANNEL = "reminder_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "scheduleReminder" -> {
                    val id = call.argument<String>("id") ?: ""
                    val title = call.argument<String>("title") ?: ""
                    val content = call.argument<String>("content") ?: ""
                    val delayMillis = call.argument<Int>("delayMillis")?.toLong() ?: 0L

                    ReminderScheduler.scheduleReminder(this, id, title, content, delayMillis)
                    result.success(null)
                }
                "cancelReminder" -> {
                    val id = call.argument<String>("id") ?: ""
                    ReminderScheduler.cancelReminder(this, id)
                    result.success(null)
                }
                "isNotificationEnabled" -> {
                    val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                    val enabled =
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                            manager.areNotificationsEnabled()
                        } else {
                            true
                        }
                    result.success(enabled)
                }
                "openNotificationSettings" -> {
                    val intent = Intent()
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        intent.action = Settings.ACTION_APP_NOTIFICATION_SETTINGS
                        intent.putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
                    } else {
                        intent.action = Settings.ACTION_APPLICATION_DETAILS_SETTINGS
                        intent.data = Uri.fromParts("package", packageName, null)
                    }
                    intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    startActivity(intent)
                    result.success(null)
                }
                "isAutoStartEnabled" -> {
                    // 简单返回 false，需要自己根据厂商做适配
                    result.success(false)
                }
                "openAutoStartSettings" -> {
                    val intent = AutoStartUtils.getAutoStartIntent(this)
                    if (intent != null) {
                        startActivity(intent)
                    }
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}

