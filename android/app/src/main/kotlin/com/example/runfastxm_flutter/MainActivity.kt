package com.example.runfastxm_flutter

import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

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
                "openNotificationSettings" -> {
                    val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                    intent.data = android.net.Uri.fromParts("package", packageName, null)
                    startActivity(intent)
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}

