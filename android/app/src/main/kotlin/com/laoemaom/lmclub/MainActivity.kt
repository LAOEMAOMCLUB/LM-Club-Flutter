package com.laoemaom.lmclub

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val channel = "broadcast_share_channel"
    private val code = 22643

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == code && resultCode == RESULT_OK) {
            // Get the result data from the intent
            // Create a MethodChannel to communicate with the Flutter side
            val channel = flutterEngine?.let { MethodChannel(it.dartExecutor, channel) }
            channel?.invokeMethod("onActivityResult", "Success")
        }
    }
}
