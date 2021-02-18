package com.example.my_tools

import android.content.Intent
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.lang.Exception

class MainActivity : FlutterActivity() {
    private  val TAG = "MainActivity"
    private val CHANNEL: String = "com.example.my_tools/activity"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            Log.d(TAG, "configureFlutterEngine: $call.method")
            if (call.method == "startActivity") {
                try {
                    val activityName = call.arguments<List<String>>()
                    val intent = Intent(this, Class.forName("com.example.my_tools.${activityName[0]}"))
                    intent.putExtra("url", activityName[1])
                    startActivity(intent)
                    result.success("ok" + activityName[0])
                } catch (e: Exception) {
                    result.error("500", e.message, e.localizedMessage)
                }
            } else {
                result.notImplemented()
            }

        }
    }
}
