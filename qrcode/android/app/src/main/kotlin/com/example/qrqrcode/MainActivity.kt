package com.example.qrqrcode

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Build
import android.app.UiModeManager
import android.content.Context
import android.content.res.Configuration
import android.app.Activity
import android.view.WindowManager
import android.graphics.Color
import android.os.Bundle

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app.channel.shared.data"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Forçar tema claro no nível da Activity
        window.decorView.systemUiVisibility = 0
        window.statusBarColor = Color.WHITE
        window.navigationBarColor = Color.WHITE
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Forçar tema claro no nível do sistema
        forceLightMode()
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setForcedDisplayMode" -> {
                    val mode = call.argument<Int>("mode") ?: 0
                    setForcedDisplayMode(mode)
                    result.success(true)
                }
                "forceLightMode" -> {
                    forceLightMode()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun forceLightMode() {
        // Forçar tema claro no nível do sistema
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val uiModeManager = getSystemService(Context.UI_MODE_SERVICE) as UiModeManager
            try {
                uiModeManager.setApplicationNightMode(UiModeManager.MODE_NIGHT_NO)
            } catch (e: Exception) {
                // Fallback para versões mais antigas
                resources.configuration.uiMode = Configuration.UI_MODE_NIGHT_NO
            }
        }

        // Forçar cores da barra de status e navegação
        window.statusBarColor = Color.WHITE
        window.navigationBarColor = Color.WHITE
        
        // Forçar ícones escuros
        window.decorView.systemUiVisibility = 0
    }

    private fun setForcedDisplayMode(mode: Int) {
        if (mode == 1) { // Modo claro
            forceLightMode()
        }
    }
}
