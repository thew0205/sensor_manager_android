package com.example.sensor_manager_android

import android.hardware.*
import android.util.Log
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import java.io.*
import java.util.*

val TAG = "SensorManager"

class SensorStreamHandler(
    private val sensorManager: SensorManager,
    private val sensorType: Int,
    private val interval: Int,
) : EventChannel.StreamHandler, SensorEventListener {
    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        sensorManager.registerListener(this, sensorManager.getDefaultSensor(sensorType), interval)
        Log.i(TAG, "Register Listener to ${sensorManager.getDefaultSensor(sensorType)} sensor")
    }

    override fun onCancel(arguments: Any?) {
        sensorManager.unregisterListener(this, sensorManager.getDefaultSensor(sensorType))
        Log.i(TAG, "Unregister Listener to ${sensorManager.getDefaultSensor(sensorType)} sensor")
        eventSink = null
    }

    override fun onSensorChanged(event: SensorEvent?) {
        eventSink?.success(event?.let { sensorEventToJson(it) })
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        sensor?.let {
            val result = sensorToJson(it).toMutableMap()
            result["newAccuracy"] = accuracy
            eventSink?.success(result)
        }
    }


}




