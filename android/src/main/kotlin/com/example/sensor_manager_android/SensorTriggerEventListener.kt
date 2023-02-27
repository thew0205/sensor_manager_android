package com.example.sensor_manager_android

import android.annotation.TargetApi
import android.hardware.SensorManager
import android.hardware.TriggerEvent
import android.hardware.TriggerEventListener
import android.os.Build
import android.util.Log
import io.flutter.plugin.common.EventChannel


@TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
class SensorTriggerEventListener(
    private val sensorManager: SensorManager,
    private val sensorType: Int
) : TriggerEventListener(), EventChannel.StreamHandler {
    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        sensorManager.requestTriggerSensor(this, sensorManager.getDefaultSensor(sensorType))
        Log.e(
            "event", "${arguments.toString()}"
        )
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        sensorManager.cancelTriggerSensor(this, sensorManager.getDefaultSensor(sensorType))
    }

    override fun onTrigger(event: TriggerEvent?) {
        eventSink?.success(event?.let { triggerEventToJson(it) })
    }
}