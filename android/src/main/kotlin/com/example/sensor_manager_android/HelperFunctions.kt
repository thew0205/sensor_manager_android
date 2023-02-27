package com.example.sensor_manager_android

import android.annotation.TargetApi
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.TriggerEvent
import android.os.Build

fun sensorEventToJson(sensorEvent: SensorEvent): Map<String, Any> {
    return mapOf<String, Any>(
        "sensor" to sensorToJson(sensorEvent.sensor),
        "accuracy" to sensorEvent.accuracy,
        "timestamp" to sensorEvent.timestamp,
        "values" to sensorEvent.values
    )
}


@TargetApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
fun triggerEventToJson(triggerEvent: TriggerEvent): Map<String, Any> {
    return mapOf<String, Any>(
        "sensor" to sensorToJson(triggerEvent.sensor),
        "timestamp" to triggerEvent.timestamp,
        "values" to triggerEvent.values
    )
}


fun sensorToJson(sensor: Sensor): Map<String, Any> {
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
        mapOf<String, Any>(
            "name" to sensor.name,
            "vendor" to sensor.vendor,
            "version" to sensor.version,
            "type" to sensor.type,
            "reportingMode" to sensor.reportingMode,
            "isDynamicSensor" to sensor.isDynamicSensor,
            "isWakeUpSensor" to sensor.isWakeUpSensor,
            "maxRange" to sensor.maximumRange,
            "resolution" to sensor.resolution,
            "power" to sensor.power,
            "minDelay" to sensor.minDelay,
            "fifoReservedEventCount" to sensor.fifoReservedEventCount,
            "fifoMaxEventCount" to sensor.fifoMaxEventCount,
            "stringType" to sensor.stringType,
            "maxDelay" to sensor.maxDelay,
            "id" to sensor.id,
        )
    } else {
        mapOf<String, Any>(
            "name" to sensor.name,
            "vendor" to sensor.vendor,
            "version" to sensor.version,
            "type" to sensor.type,
            "maxRange" to sensor.maximumRange,
            "resolution" to sensor.resolution,
            "power" to sensor.power,
            "minDelay" to sensor.minDelay,

            )
    }


}