package com.example.sensor_manager_android

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodChannel.MethodCallHandler


/** SensorManagerAndroidPlugin */
class SensorManagerAndroidPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private val methodChannelName = "com.switches/sensor_manager_android"
    private val eventChannelName = "com.switches/sensor_manager_android/"
    private lateinit var channel: MethodChannel
    private lateinit var sensorManager: SensorManager
    private lateinit var messenger: BinaryMessenger
    private val eventChannels = mutableMapOf<Int, EventChannel>()
    private var eventChannelDynamicSensorCallback: EventChannel? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, methodChannelName)
        channel.setMethodCallHandler(this)
        messenger = flutterPluginBinding.binaryMessenger
        sensorManager =
            flutterPluginBinding.applicationContext.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        eventChannelDynamicSensorCallback =
            EventChannel(messenger, "${eventChannelName}eventChannelDynamicSensorCallback")

    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${Build.VERSION.RELEASE}")
            }
            "getSensorList" -> {
                val sensorMapList = mutableListOf<Map<String, Any>>()
                sensorManager.getSensorList(call.argument<Int>("sensorType") ?: Sensor.TYPE_ALL)
                    .forEach { sensorMap: Sensor -> sensorMapList.add(sensorToJson(sensorMap)) }
                result.success(sensorMapList)
            }
            "isDynamicSensorDiscoverySupported" -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    result.success(sensorManager.isDynamicSensorDiscoverySupported)
                }
            }
            "getDynamicSensorList" -> {
                val sensorMapList = mutableListOf<Map<String, Any>>()
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    sensorManager.getDynamicSensorList(
                        call.argument<Int>("sensorType") ?: Sensor.TYPE_ALL
                    ).forEach { sensorMap: Sensor -> sensorMapList.add(sensorToJson(sensorMap)) }
                }
                result.success(sensorMapList)
            }
            "getDefaultSensor" -> {
                var sensorMap: Map<String, Any> = mutableMapOf()
                if (call.argument<Int>("wakeUp") == null) {
                    sensorMap = sensorToJson(
                        sensorManager.getDefaultSensor(
                            call.argument<Int>("sensorType") ?: Sensor.TYPE_ALL
                        )
                    )
                } else {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        sensorMap = sensorToJson(
                            sensorManager.getDefaultSensor(
                                call.argument<Int>("sensorType") ?: Sensor.TYPE_ALL,
                                call.argument<Boolean>("wakeUp")!!
                            )
                        )
                    }
                }
                result.success(sensorMap)
            }
            "registerListener" -> {
                getSensorEvents(
                    call.argument<Int>("sensorType") ?: Sensor.TYPE_ALL,
                    call.argument<Int>("interval")
                )
            }
            "registerDynamicSensorCallback" -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    if (eventChannelDynamicSensorCallback == null) {
                        eventChannelDynamicSensorCallback = EventChannel(
                            messenger,
                            eventChannelName + "eventChannelDynamicSensorCallback"
                        )
                        eventChannelDynamicSensorCallback?.setStreamHandler(
                            DynamicSensorCallback(sensorManager)
                        )
                    }
                }
            }
            "requestTriggerSensor" -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
                    val sensorType = call.argument<Int>("sensorType") ?: Sensor.TYPE_ALL
                    if (eventChannels[sensorType] == null) {
                        eventChannels[sensorType] =
                            EventChannel(messenger, eventChannelName + setType(sensorType))
                        eventChannels[sensorType]?.setStreamHandler(
                            SensorTriggerEventListener(sensorManager, sensorType)
                        )
                    }
                }
            }
            else -> {
                result.notImplemented()
            }

        }

    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        eventChannels.forEach { (_, eventChannel) -> eventChannel.setStreamHandler(null) }
    }

    private fun getSensorEvents(sensorType: Int, interval: Int?) {
        if (eventChannels[sensorType] == null) {
            eventChannels[sensorType] =
                EventChannel(messenger, eventChannelName + setType(sensorType))
        }
        eventChannels[sensorType]!!.setStreamHandler(
            SensorStreamHandler(
                sensorManager, sensorType, interval ?: SensorManager.SENSOR_DELAY_NORMAL
            )
        )
    }

    private fun setType(sensorType: Int): String {
        return when (sensorType) {
            Sensor.TYPE_ACCELEROMETER -> {
                return Sensor.STRING_TYPE_ACCELEROMETER
            }
            Sensor.TYPE_AMBIENT_TEMPERATURE -> {
                return Sensor.STRING_TYPE_AMBIENT_TEMPERATURE
            }
            Sensor.TYPE_GAME_ROTATION_VECTOR -> {
                return Sensor.STRING_TYPE_GAME_ROTATION_VECTOR
            }
            Sensor.TYPE_GEOMAGNETIC_ROTATION_VECTOR -> {
                return Sensor.STRING_TYPE_GEOMAGNETIC_ROTATION_VECTOR
            }
//            Sensor.TYPE_GLANCE_GESTURE -> {
//                return Sensor.STRING_TYPE_GLANCE_GESTURE
//            }
            Sensor.TYPE_GRAVITY -> {
                return Sensor.STRING_TYPE_GRAVITY
            }
            Sensor.TYPE_GYROSCOPE -> {
                return Sensor.STRING_TYPE_GYROSCOPE
            }
            Sensor.TYPE_GYROSCOPE_UNCALIBRATED -> {
                return Sensor.STRING_TYPE_GYROSCOPE_UNCALIBRATED
            }
            Sensor.TYPE_HEART_RATE -> {
                return Sensor.STRING_TYPE_HEART_RATE
            }
            Sensor.TYPE_LIGHT -> {
                return Sensor.STRING_TYPE_LIGHT
            }
            Sensor.TYPE_LINEAR_ACCELERATION -> {
                return Sensor.STRING_TYPE_LINEAR_ACCELERATION
            }
            Sensor.TYPE_MAGNETIC_FIELD -> {
                return Sensor.STRING_TYPE_MAGNETIC_FIELD
            }
            Sensor.TYPE_MAGNETIC_FIELD_UNCALIBRATED -> {
                return Sensor.STRING_TYPE_MAGNETIC_FIELD_UNCALIBRATED
            }
//            Sensor.TYPE_PICK_UP_GESTURE -> {
//                return Sensor.STRING_TYPE_PICK_UP_GESTURE
//            }
            Sensor.TYPE_PRESSURE -> {
                return Sensor.STRING_TYPE_PRESSURE
            }
            Sensor.TYPE_PROXIMITY -> {
                return Sensor.STRING_TYPE_PROXIMITY
            }
            Sensor.TYPE_RELATIVE_HUMIDITY -> {
                return Sensor.STRING_TYPE_RELATIVE_HUMIDITY
            }
            Sensor.TYPE_ROTATION_VECTOR -> {
                return Sensor.STRING_TYPE_ROTATION_VECTOR
            }
            Sensor.TYPE_SIGNIFICANT_MOTION -> {
                return Sensor.STRING_TYPE_SIGNIFICANT_MOTION
            }
            Sensor.TYPE_STEP_COUNTER -> {
                return Sensor.STRING_TYPE_STEP_COUNTER
            }
            Sensor.TYPE_STEP_DETECTOR -> {
                return Sensor.STRING_TYPE_STEP_DETECTOR
            }
            22 -> {
                return "android.sensor.tilt_detector"
            }
            23 -> {
                return "android.sensor.wake_gesture"
            }
            Sensor.TYPE_ORIENTATION -> {
                return Sensor.STRING_TYPE_ORIENTATION
            }
            Sensor.TYPE_TEMPERATURE -> {
                return Sensor.STRING_TYPE_TEMPERATURE
            }
//            Sensor.TYPE_DEVICE_ORIENTATION -> {
//                return Sensor.STRING_TYPE_DEVICE_ORIENTATION
//            }
//            Sensor.TYPE_DYNAMIC_SENSOR_META -> {
//                return Sensor.STRING_TYPE_DYNAMIC_SENSOR_META
//            }
            Sensor.TYPE_LOW_LATENCY_OFFBODY_DETECT -> {
                return Sensor.STRING_TYPE_LOW_LATENCY_OFFBODY_DETECT
            }
            Sensor.TYPE_ACCELEROMETER_UNCALIBRATED -> {
                return Sensor.STRING_TYPE_ACCELEROMETER_UNCALIBRATED
            }
            Sensor.TYPE_HINGE_ANGLE -> {
                return Sensor.STRING_TYPE_HINGE_ANGLE
            }
            else -> {
                return "Unknown"
            }
        }
    }
}
