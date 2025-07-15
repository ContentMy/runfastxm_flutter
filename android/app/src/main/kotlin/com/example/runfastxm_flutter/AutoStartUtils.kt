package com.example.runfastxm_flutter

import android.content.Context
import android.content.Intent

/**
 * @Author ContentMy
 * @Date 2025/7/14 16:03
 * @Description
 */

object AutoStartUtils {

    fun getAutoStartIntent(context: Context): Intent? {
        val manufacturer = android.os.Build.MANUFACTURER.lowercase()
        return when {
            manufacturer.contains("xiaomi") -> Intent().apply {
                setClassName(
                    "com.miui.securitycenter",
                    "com.miui.permcenter.autostart.AutoStartManagementActivity"
                )
            }
            manufacturer.contains("huawei") -> Intent().apply {
                setClassName(
                    "com.huawei.systemmanager",
                    "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity"
                )
            }
            manufacturer.contains("oppo") -> Intent().apply {
                setClassName(
                    "com.coloros.safecenter",
                    "com.coloros.safecenter.startupapp.StartupAppListActivity"
                )
            }
            manufacturer.contains("vivo") -> Intent().apply {
                setClassName(
                    "com.iqoo.secure",
                    "com.iqoo.secure.ui.phoneoptimize.BgStartUpManager"
                )
            }
            else -> null
        }
    }
}
