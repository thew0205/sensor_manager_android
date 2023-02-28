package com.example.sensor_manager_android

import android.annotation.TargetApi
import android.hardware.Sensor
import android.hardware.SensorManager
import android.os.Build
import android.util.Log
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink


@TargetApi(Build.VERSION_CODES.N)
class DynamicSensorCallback(private val sensorManager: SensorManager) :
    SensorManager.DynamicSensorCallback(), EventChannel.StreamHandler {
    private var eventSink: EventChannel.EventSink? = null
    override fun onDynamicSensorConnected(sensor: Sensor?) {
        super.onDynamicSensorConnected(sensor)
        sensor?.let {
            val result = sensorToJson(it).toMutableMap()
            result["isConnected"] = true
            eventSink?.success(result)
        }
    }

    override fun onDynamicSensorDisconnected(sensor: Sensor?) {
        super.onDynamicSensorDisconnected(sensor)
        sensor?.let {
            val result = sensorToJson(it).toMutableMap()
            result["isConnected"] = false
            eventSink?.success(result)
        }
    }

    override fun onListen(arguments: Any?, events: EventSink?) {
        eventSink = events
        sensorManager.registerDynamicSensorCallback(this)
        Log.i( TAG, "Register Listener to dynamic sensor")

    }

    override fun onCancel(arguments: Any?) {
        Log.i( TAG, "Unregister Listener to dynamic sensor")
        sensorManager.unregisterDynamicSensorCallback(this)
        eventSink = null
    }
}