import 'dart:convert';
import 'dart:core';

/// Class representing a sensor. Use {@link SensorManager#getSensorList} to get
/// the list of available sensors. For more information about Android sensors,
/// read the
/// <a href="/guide/topics/sensors/sensors_motion.html">Motion Sensors guide</a>.</p>
///
/// @see SensorManager
/// @see SensorEventListener
/// @see SensorEvent
///
class Sensor {
  /* Some of these fields are set only by the native bindings in
  * SensorManager.
  */

  /// @return name string of the sensor. The name is guaranteed to be unique
  /// for a particular sensor type.
  final String name;

  /// @return vendor string of this sensor.
  final String vendor;

  /// @return version of the sensor's module.
  final int version;

  /// @return generic type of this sensor.
  final int type;

  /// @return maximum range of the sensor in the sensor's unit.
  final double maxRange;

  /// @return resolution of the sensor in the sensor's unit.
  final double resolution;

  /// @return the power in mA used by this sensor while in use
  final double power;

  /// @return the minimum delay allowed between two events in microseconds
  /// or zero if this sensor only returns a value when the data it's measuring
  /// changes. Note that if the app does not have the
  /// {@link android.Manifest.permission#HIGH_SAMPLING_RATE_SENSORS} permission, the
  /// minimum delay is capped at 5000 microseconds (200 Hz).
  final int minDelay;

  /// Each sensor has exactly one reporting mode associated with it. This method returns the
  /// reporting mode constant for this sensor type.
  ///
  /// @return Reporting mode for the input sensor, one of REPORTING_MODE_* constants.
  /// @see #REPORTING_MODE_CONTINUOUS
  /// @see #REPORTING_MODE_ON_CHANGE
  /// @see #REPORTING_MODE_ONE_SHOT
  /// @see #REPORTING_MODE_SPECIAL_TRIGGER
  final int? reportingMode;

  /// Returns true if the sensor is a dynamic sensor.
  ///
  /// @return <code>true</code> if the sensor is a dynamic sensor (sensor added at runtime).
  /// @see SensorManager.DynamicSensorCallback
  final bool? isDynamicSensor;

  /// Returns true if the sensor is a wake-up sensor.
  /// <p>
  /// <b>Application Processor Power modes</b> <p>
  /// Application Processor(AP), is the processor on which applications run.  When no wake lock is
  /// held and the user is not interacting with the device, this processor can enter a “Suspend”
  /// mode, reducing the power consumption by 10 times or more.
  /// </p>
  /// <p>
  /// <b>Non-wake-up sensors</b> <p>
  /// Non-wake-up sensors are sensors that do not wake the AP out of suspend to report data. While
  /// the AP is in suspend mode, the sensors continue to function and generate events, which are
  /// put in a hardware FIFO. The events in the FIFO are delivered to the application when the AP
  /// wakes up. If the FIFO was too small to store all events generated while the AP was in
  /// suspend mode, the older events are lost: the oldest data is dropped to accommodate the newer
  /// data. In the extreme case where the FIFO is non-existent {@code maxFifoEventCount() == 0},
  /// all events generated while the AP was in suspend mode are lost. Applications using
  /// non-wake-up sensors should usually:
  /// <ul>
  /// <li>Either unregister from the sensors when they do not need them, usually in the activity’s
  /// {@code onPause} method. This is the most common case.
  /// <li>Or realize that the sensors are consuming some power while the AP is in suspend mode and
  /// that even then, some events might be lost.
  /// </ul>
  /// </p>
  /// <p>
  /// <b>Wake-up sensors</b> <p>
  /// In opposition to non-wake-up sensors, wake-up sensors ensure that their data is delivered
  /// independently of the state of the AP. While the AP is awake, the wake-up sensors behave
  /// like non-wake-up-sensors. When the AP is asleep, wake-up sensors wake up the AP to deliver
  /// events. That is, the AP will wake up and the sensor will deliver the events before the
  /// maximum reporting latency is elapsed or the hardware FIFO gets full. See {@link
  /// SensorManager#registerListener(SensorEventListener, Sensor, int, int)} for more details.
  /// </p>
  ///
  /// @return <code>true</code> if this is a wake-up sensor, <code>false</code> otherwise.
  final bool? isWakeUpSensor;

  /// @return Number of events reserved for this sensor in the batch mode FIFO. This gives a
  /// guarantee on the minimum number of events that can be batched.
  final int? fifoReservedEventCount;

  /// @return Maximum number of events of this sensor that could be batched. If this value is zero
  /// it indicates that batch mode is not supported for this sensor. If other applications
  /// registered to batched sensors, the actual number of events that can be batched might be
  /// smaller because the hardware FiFo will be partially used to batch the other sensors.
  final int? fifoMaxEventCount;

  /// @return The type of this sensor as a string.
  final String? stringType;

  /// This value is defined only for continuous and on-change sensors. It is the delay between two
  /// sensor events corresponding to the lowest frequency that this sensor supports. When lower
  /// frequencies are requested through registerListener() the events will be generated at this
  /// frequency instead. It can be used to estimate when the batch FIFO may be full. Older devices
  /// may set this value to zero. Ignore this value in case it is negative or zero.
  ///
  /// @return The max delay for this sensor in microseconds.
  final int? maxDelay;

  /// @return The sensor id that will be unique for the same app unless the device is factory
  /// reset. Return value of 0 means this sensor does not support this function; return value of -1
  /// means this sensor can be uniquely identified in system by combination of its type and name.
  final int? id;
  const Sensor({
    required this.name,
    required this.vendor,
    required this.version,
    required this.type,
    required this.maxRange,
    required this.resolution,
    required this.power,
    required this.minDelay,
    this.reportingMode,
    this.isDynamicSensor,
    this.isWakeUpSensor,
    this.fifoReservedEventCount,
    this.fifoMaxEventCount,
    this.stringType,
    this.maxDelay,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'vendor': vendor,
      'version': version,
      'type': type,
      'maxRange': maxRange,
      'resolution': resolution,
      'power': power,
      'minDelay': minDelay,
      'reportingMode': reportingMode,
      'isDynamicSensor': isDynamicSensor,
      'isWakeUpSensor': isWakeUpSensor,
      'fifoReservedEventCount': fifoReservedEventCount,
      'fifoMaxEventCount': fifoMaxEventCount,
      'stringType': stringType,
      'maxDelay': maxDelay,
      'id': id,
    };
  }

  factory Sensor.fromMap(Map<String, dynamic> map) {
    return Sensor(
      name: map['name'] as String,
      vendor: map['vendor'] as String,
      version: map['version'] as int,
      type: map['type'] as int,
      maxRange: map['maxRange'] as double,
      resolution: map['resolution'] as double,
      power: map['power'] as double,
      minDelay: map['minDelay'] as int,
      reportingMode:
          map['reportingMode'] != null ? map['reportingMode'] as int : null,
      isDynamicSensor: map['isDynamicSensor'] != null
          ? map['isDynamicSensor'] as bool
          : null,
      isWakeUpSensor:
          map['isWakeUpSensor'] != null ? map['isWakeUpSensor'] as bool : null,
      fifoReservedEventCount: map['fifoReservedEventCount'] != null
          ? map['fifoReservedEventCount'] as int
          : null,
      fifoMaxEventCount: map['fifoMaxEventCount'] != null
          ? map['fifoMaxEventCount'] as int
          : null,
      stringType:
          map['stringType'] != null ? map['stringType'] as String : null,
      maxDelay: map['maxDelay'] != null ? map['maxDelay'] as int : null,
      id: map['id'] != null ? map['id'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Sensor.fromJson(String source) =>
      Sensor.fromMap(json.decode(source) as Map<String, dynamic>);

  Sensor copyWith({
    String? name,
    String? vendor,
    int? version,
    int? type,
    double? maxRange,
    double? resolution,
    double? power,
    int? minDelay,
    int? reportingMode,
    bool? isDynamicSensor,
    bool? isWakeUpSensor,
    int? fifoReservedEventCount,
    int? fifoMaxEventCount,
    String? stringType,
    int? maxDelay,
    int? id,
  }) {
    return Sensor(
      name: name ?? this.name,
      vendor: vendor ?? this.vendor,
      version: version ?? this.version,
      type: type ?? this.type,
      maxRange: maxRange ?? this.maxRange,
      resolution: resolution ?? this.resolution,
      power: power ?? this.power,
      minDelay: minDelay ?? this.minDelay,
      reportingMode: reportingMode ?? this.reportingMode,
      isDynamicSensor: isDynamicSensor ?? this.isDynamicSensor,
      isWakeUpSensor: isWakeUpSensor ?? this.isWakeUpSensor,
      fifoReservedEventCount:
          fifoReservedEventCount ?? this.fifoReservedEventCount,
      fifoMaxEventCount: fifoMaxEventCount ?? this.fifoMaxEventCount,
      stringType: stringType ?? this.stringType,
      maxDelay: maxDelay ?? this.maxDelay,
      id: id ?? this.id,
    );
  }

  @override
  String toString() {
    return 'Sensor(name: $name, vendor: $vendor, version: $version, type $type maxRange: $maxRange, resolution: $resolution, power: $power, minDelay: $minDelay, reportingMode: $reportingMode, isDynamicSensor: $isDynamicSensor, isWakeUpSensor: $isWakeUpSensor, fifoReservedEventCount: $fifoReservedEventCount, fifoMaxEventCount: $fifoMaxEventCount, stringType: $stringType, maxDelay: $maxDelay, id: $id)';
  }

  @override
  bool operator ==(covariant Sensor other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.vendor == vendor &&
        other.version == version &&
        other.type == type &&
        other.maxRange == maxRange &&
        other.resolution == resolution &&
        other.power == power &&
        other.minDelay == minDelay &&
        other.reportingMode == reportingMode &&
        other.isDynamicSensor == isDynamicSensor &&
        other.isWakeUpSensor == isWakeUpSensor &&
        other.fifoReservedEventCount == fifoReservedEventCount &&
        other.fifoMaxEventCount == fifoMaxEventCount &&
        other.stringType == stringType &&
        other.maxDelay == maxDelay &&
        other.id == id;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        vendor.hashCode ^
        version.hashCode ^
        type.hashCode ^
        maxRange.hashCode ^
        resolution.hashCode ^
        power.hashCode ^
        minDelay.hashCode ^
        reportingMode.hashCode ^
        isDynamicSensor.hashCode ^
        isWakeUpSensor.hashCode ^
        fifoReservedEventCount.hashCode ^
        fifoMaxEventCount.hashCode ^
        stringType.hashCode ^
        maxDelay.hashCode ^
        id.hashCode;
  }

  /// A constant describing an accelerometer sensor type.
  /// <p>See {@link android.hardware.SensorEvent#values SensorEvent.values}
  /// for more details.
  static const int typeAccelerometer = 1;

  /// A constant string describing an accelerometer sensor type.
  ///
  /// @see #typeAccelerometer
  static const String stringTypeAccelerometer = "android.sensor.accelerometer";

  /// A constant describing a magnetic field sensor type.
  /// <p>See {@link android.hardware.SensorEvent#values SensorEvent.values}
  /// for more details.
  static const int typeMagneticField = 2;

  /// A constant string describing a magnetic field sensor type.
  ///
  /// @see #typeMagneticField
  static const String stringTypeMagneticField = "android.sensor.magnetic_field";

  /// A constant describing an orientation sensor type.
  /// <p>See {@link android.hardware.SensorEvent#values SensorEvent.values}
  /// for more details.
  ///
  /// @deprecated use {@link android.hardware.SensorManager#getOrientation
  ///             SensorManager.getOrientation()} instead.
  // @Deprecated("Don't know the reason why it is deprecated")
  static const int typeOrientation = 3;

  /// A constant string describing an orientation sensor type.
  ///
  /// @see #typeOrientation
  /// @deprecated use {@link android.hardware.SensorManager#getOrientation
  ///             SensorManager.getOrientation()} instead.
  // @Deprecated("Don't know the reason hy it is deprecated")
  static const String stringTypeOrientation = "android.sensor.orientation";

  /// A constant describing a gyroscope sensor type.
  /// <p>See {@link android.hardware.SensorEvent#values SensorEvent.values}
  /// for more details.
  static const int typeGyroscope = 4;

  /// A constant string describing a gyroscope sensor type.
  ///
  /// @see #typeGyroscope
  static const String stringTypeGyroscope = "android.sensor.gyroscope";

  /// A constant describing a light sensor type.
  /// <p>See {@link android.hardware.SensorEvent#values SensorEvent.values}
  /// for more details.
  static const int typeLight = 5;

  /// A constant string describing a light sensor type.
  ///
  /// @see #typeLight
  static const String stringTypeLight = "android.sensor.light";

  /// A constant describing a pressure sensor type.
  /// <p>See {@link android.hardware.SensorEvent#values SensorEvent.values}
  /// for more details.
  static const int typePressure = 6;

  /// A constant string describing a pressure sensor type.
  ///
  /// @see #typePressure
  static const String stringTypePressure = "android.sensor.pressure";

  /// A constant describing a temperature sensor type
  ///
  /// @deprecated use
  ///             {@link android.hardware.Sensor#typeAmbientTemperature
  ///             Sensor.typeAmbientTemperature} instead.
  // @Deprecated("{Sensor.typeAmbientTemperature} instead.")
  static const int typeTemperature = 7;

  /// A constant string describing a temperature sensor type
  ///
  /// @see #typeTemperature
  /// @deprecated use
  ///             {@link android.hardware.Sensor#STRINGTypeAmbientTemperature
  ///             Sensor.STRINGTypeAmbientTemperature} instead.
  // @Deprecated("{Sensor.STRINGTypeAmbientTemperature} instead.")
  static const String stringTypeTemperature = "android.sensor.temperature";

  /// A constant describing a proximity sensor type. This is a wake up sensor.
  /// <p>See {@link android.hardware.SensorEvent#values SensorEvent.values}
  /// for more details.
  /// @see #isWakeUpSensor()
  static const int typeProximity = 8;

  /// A constant string describing a proximity sensor type.
  ///
  /// @see #typeProximity
  static const String stringTypeProximity = "android.sensor.proximity";

  /// A constant describing a gravity sensor type.
  /// <p>See {@link android.hardware.SensorEvent#values SensorEvent.values}
  /// for more details.
  static const int typeGravity = 9;

  /// A constant string describing a gravity sensor type.
  ///
  /// @see #typeGravity
  static const String stringTypeGravity = "android.sensor.gravity";

  /// A constant describing a linear acceleration sensor type.
  /// <p>See {@link android.hardware.SensorEvent#values SensorEvent.values}
  /// for more details.
  static const int typeLinearAcceleration = 10;

  /// A constant string describing a linear acceleration sensor type.
  ///
  /// @see #typeLinearAcceleration
  static const String stringTypeLinearAcceleration =
      "android.sensor.linear_acceleration";

  /// A constant describing a rotation vector sensor type.
  /// <p>See {@link android.hardware.SensorEvent#values SensorEvent.values}
  /// for more details.
  static const int typeRotationVector = 11;

  /// A constant string describing a rotation vector sensor type.
  ///
  /// @see #typeRotationVector
  static const String stringTypeRotationVector =
      "android.sensor.rotation_vector";

  /// A constant describing a relative humidity sensor type.
  /// <p>See {@link android.hardware.SensorEvent#values SensorEvent.values}
  /// for more details.
  static const int typeRelativeHumidity = 12;

  /// A constant string describing a relative humidity sensor type
  ///
  /// @see #typeRelativeHumidity
  static const String stringTypeRelativeHumidity =
      "android.sensor.relative_humidity";

  /// A constant describing an ambient temperature sensor type.
  /// <p>See {@link android.hardware.SensorEvent#values SensorEvent.values}
  /// for more details.
  static const int typeAmbientTemperature = 13;

  /// A constant string describing an ambient temperature sensor type.
  ///
  /// @see #typeAmbientTemperature
  static const String stringTypeAmbientTemperature =
      "android.sensor.ambient_temperature";

  /// A constant describing an uncalibrated magnetic field sensor type.
  /// <p>
  /// Similar to {@link #typeMagneticField} but the hard iron calibration (device calibration
  /// due to distortions that arise from magnetized iron, steel or permanent magnets on the
  /// device) is not considered in the given sensor values. However, such hard iron bias values
  /// are returned to you separately in the result {@link android.hardware.SensorEvent#values}
  /// so you may use them for custom calibrations.
  /// <p>Also, no periodic calibration is performed
  /// (i.e. there are no discontinuities in the data stream while using this sensor) and
  /// assumptions that the magnetic field is due to the Earth's poles is avoided, but
  /// factory calibration and temperature compensation have been performed.
  /// </p>
  /// <p>See {@link android.hardware.SensorEvent#values SensorEvent.values} for more
  /// details.
  static const int typeMagneticFieldUncalibrated = 14;

  /// A constant string describing an uncalibrated magnetic field sensor type.
  ///
  /// @see #typeMagneticFieldUncalibrated
  static const String stringTypeMagneticFieldUncalibrated =
      "android.sensor.magnetic_field_uncalibrated";

  /// A constant describing an uncalibrated rotation vector sensor type.
  /// <p>Identical to {@link #typeRotationVector} except that it doesn't
  /// use the geomagnetic field. Therefore the Y axis doesn't
  /// point north, but instead to some other reference, that reference is
  /// allowed to drift by the same order of magnitude as the gyroscope
  /// drift around the Z axis.
  /// <p>
  /// In the ideal case, a phone rotated and returning to the same real-world
  /// orientation should report the same game rotation vector
  /// (without using the earth's geomagnetic field). However, the orientation
  /// may drift somewhat over time.
  /// </p>
  /// <p>See {@link android.hardware.SensorEvent#values SensorEvent.values} for more
  /// details.
  static const int typeGameRotationVector = 15;

  /// A constant string describing an uncalibrated rotation vector sensor type.
  ///
  /// @see #typeGameRotationVector
  static const String stringTypeGameRotationVector =
      "android.sensor.game_rotation_vector";

  /// A constant describing an uncalibrated gyroscope sensor type.
  /// <p>Similar to {@link #typeGyroscope} but no gyro-drift compensation has been performed
  /// to adjust the given sensor values. However, such gyro-drift bias values
  /// are returned to you separately in the result {@link android.hardware.SensorEvent#values}
  /// so you may use them for custom calibrations.
  /// <p>Factory calibration and temperature compensation is still applied
  /// to the rate of rotation (angular speeds).
  /// </p>
  /// <p> See {@link android.hardware.SensorEvent#values SensorEvent.values} for more
  /// details.
  static const int typeGyroscopeUncalibrated = 16;

  /// A constant string describing an uncalibrated gyroscope sensor type.
  ///
  /// @see #typeGyroscopeUncalibrated
  static const String stringTypeGyroscopeUncalibrated =
      "android.sensor.gyroscope_uncalibrated";

  /// A constant describing a significant motion trigger sensor.
  /// <p>
  /// It triggers when an event occurs and then automatically disables
  /// itself. The sensor continues to operate while the device is asleep
  /// and will automatically wake the device to notify when significant
  /// motion is detected. The application does not need to hold any wake
  /// locks for this sensor to trigger. This is a wake up sensor.
  /// <p>See {@link TriggerEvent} for more details.
  ///
  /// @see #isWakeUpSensor()
  static const int typeSignificantMotion = 17;

  /// A constant string describing a significant motion trigger sensor.
  ///
  /// @see #typeSignificantMotion
  static const String stringTypeSignificantMotion =
      "android.sensor.significant_motion";

  /// A constant describing a step detector sensor.
  /// <p>
  /// A sensor of this type triggers an event each time a step is taken by the user. The only
  /// allowed value to return is 1.0 and an event is generated for each step. Like with any other
  /// event, the timestamp indicates when the event (here the step) occurred, this corresponds to
  /// when the foot hit the ground, generating a high variation in acceleration. This sensor is
  /// only for detecting every individual step as soon as it is taken, for example to perform dead
  /// reckoning. If you only need aggregate number of steps taken over a period of time, register
  /// for {@link #typeStepCounter} instead. It is defined as a
  /// {@link Sensor#REPORTING_MODE_SPECIAL_TRIGGER} sensor.
  /// <p>
  /// This sensor requires permission {@code android.permission.ACTIVITY_RECOGNITION}.
  /// <p>
  /// See {@link android.hardware.SensorEvent#values SensorEvent.values} for more details.
  static const int typeStepDetector = 18;

  /// A constant string describing a step detector sensor.
  ///
  /// @see #typeStepDetector
  static const String stringTypeStepDetector = "android.sensor.step_detector";

  /// A constant describing a step counter sensor.
  /// <p>
  /// A sensor of this type returns the number of steps taken by the user since the last reboot
  /// while activated. The value is returned as a float (with the fractional part set to zero) and
  /// is reset to zero only on a system reboot. The timestamp of the event is set to the time when
  /// the last step for that event was taken. This sensor is implemented in hardware and is
  /// expected to be low power. If you want to continuously track the number of steps over a long
  /// period of time, do NOT unregister for this sensor, so that it keeps counting steps in the
  /// background even when the AP is in suspend mode and report the aggregate count when the AP
  /// is awake. Application needs to stay registered for this sensor because step counter does not
  /// count steps if it is not activated. This sensor is ideal for fitness tracking applications.
  /// It is defined as an {@link Sensor#REPORTING_MODE_ON_CHANGE} sensor.
  /// <p>
  /// This sensor requires permission {@code android.permission.ACTIVITY_RECOGNITION}.
  /// <p>
  /// See {@link android.hardware.SensorEvent#values SensorEvent.values} for more details.
  static const int typeStepCounter = 19;

  /// A constant string describing a step counter sensor.
  ///
  /// @see #typeStepCounter
  static const String stringTypeStepCounter = "android.sensor.step_counter";

  /// A constant describing a geo-magnetic rotation vector.
  /// <p>
  /// Similar to {@link #typeRotationVector}, but using a magnetometer instead of using a
  /// gyroscope. This sensor uses lower power than the other rotation vectors, because it doesn't
  /// use the gyroscope. However, it is more noisy and will work best outdoors.
  /// <p>
  /// See {@link android.hardware.SensorEvent#values SensorEvent.values} for more details.
  static const int typeGeomagneticRotationVector = 20;

  /// A constant string describing a geo-magnetic rotation vector.
  ///
  /// @see #typeGeomagneticRotationVector
  static const String stringTypeGeomagneticRotationVector =
      "android.sensor.geomagnetic_rotation_vector";

  /// A constant describing a heart rate monitor.
  /// <p>
  /// The reported value is the heart rate in beats per minute.
  /// <p>
  /// The reported accuracy represents the status of the monitor during the reading. See the
  /// {@code SENSOR_STATUS_*} constants in {@link android.hardware.SensorManager SensorManager}
  /// for more details on accuracy/status values. In particular, when the accuracy is
  /// {@code SENSOR_STATUS_UNRELIABLE} or {@code SENSOR_STATUS_NO_CONTACT}, the heart rate
  /// value should be discarded.
  /// <p>
  /// This sensor requires permission {@code android.permission.BODY_SENSORS}.
  /// It will not be returned by {@code SensorManager.getSensorsList} nor
  /// {@code SensorManager.getDefaultSensor} if the application doesn't have this permission.
  static const int typeHeartRate = 21;

  /// A constant string describing a heart rate monitor.
  ///
  /// @see #typeHeartRate
  static const String stringTypeHeartRate = "android.sensor.heart_rate";

  /// A sensor of this type generates an event each time a tilt event is detected. A tilt event
  /// is generated if the direction of the 2-seconds window average gravity changed by at
  /// least 35 degrees since the activation of the sensor. It is a wake up sensor.
  ///
  /// @hide
  /// @see #isWakeUpSensor()
  static const int typeTiltDetector = 22;

  /// A constant string describing a wake up tilt detector sensor type.
  ///
  /// @hide
  /// @see #typeTiltDetector
  static const String sensorStringTypeTiltDetector =
      "android.sensor.tilt_detector";

  /// A constant describing a wake gesture sensor.
  /// <p>
  /// Wake gesture sensors enable waking up the device based on a device specific motion.
  /// <p>
  /// When this sensor triggers, the device behaves as if the power button was pressed, turning the
  /// screen on. This behavior (turning on the screen when this sensor triggers) might be
  /// deactivated by the user in the device settings. Changes in settings do not impact the
  /// behavior of the sensor: only whether the framework turns the screen on when it triggers.
  /// <p>
  /// The actual gesture to be detected is not specified, and can be chosen by the manufacturer of
  /// the device. This sensor must be low power, as it is likely to be activated 24/7.
  /// Values of events created by this sensors should not be used.
  ///
  /// @see #isWakeUpSensor()
  /// @hide This sensor is expected to only be used by the system ui
  static const int typeWakeGesture = 23;

  /// A constant string describing a wake gesture sensor.
  ///
  /// @hide This sensor is expected to only be used by the system ui
  /// @see #typeWakeGesture
  static const String stringTypeWakeGesture = "android.sensor.wake_gesture";

  /// A constant describing a wake gesture sensor.
  /// <p>
  /// A sensor enabling briefly turning the screen on to enable the user to
  /// glance content on screen based on a specific motion.  The device should
  /// turn the screen off after a few moments.
  /// <p>
  /// When this sensor triggers, the device turns the screen on momentarily
  /// to allow the user to glance notifications or other content while the
  /// device remains locked in a non-interactive state (dozing). This behavior
  /// (briefly turning on the screen when this sensor triggers) might be deactivated
  /// by the user in the device settings. Changes in settings do not impact the
  /// behavior of the sensor: only whether the framework briefly turns the screen on
  /// when it triggers.
  /// <p>
  /// The actual gesture to be detected is not specified, and can be chosen by the manufacturer of
  /// the device. This sensor must be low power, as it is likely to be activated 24/7.
  /// Values of events created by this sensors should not be used.
  ///
  /// @see #isWakeUpSensor()
  /// @hide This sensor is expected to only be used by the system ui
  static const int typeGlanceGesture = 24;

  /// A constant string describing a wake gesture sensor.
  ///
  /// @hide This sensor is expected to only be used by the system ui
  /// @see #typeGlanceGesture
  static const String stringTypeGlanceGesture = "android.sensor.glance_gesture";

  /// A constant describing a pick up sensor.
  ///
  /// A sensor of this type triggers when the device is picked up regardless of wherever it was
  /// before (desk, pocket, bag). The only allowed return value is 1.0. This sensor deactivates
  /// itself immediately after it triggers.
  ///
  /// @hide Expected to be used internally for always on display.
  // @UnsupportedAppUsage(maxTargetSdk = Build.VERSION_CODES.R, trackingBug = 170729553)
  static const int typePickUpGesture = 25;

  /// A constant string describing a pick up sensor.
  ///
  /// @hide This sensor is expected to be used internally for always on display.
  /// @see #typePickUpGesture
  static const String stringTypePickUpGesture =
      "android.sensor.pick_up_gesture";

  /// A constant describing a wrist tilt gesture sensor.
  ///
  /// A sensor of this type triggers when the device face is tilted towards the user.
  /// The only allowed return value is 1.0.
  /// This sensor remains active until disabled.
  ///
  /// @hide This sensor is expected to only be used by the system ui
  // @SystemApi
  // static final int typeWristTiltGesture = 26;

  /// A constant string describing a wrist tilt gesture sensor.
  ///
  /// @hide This sensor is expected to only be used by the system ui
  /// @see #typeWristTiltGesture
  // @SystemApi
  // static final String stringTypeWristTiltGesture = "android.sensor.wrist_tilt_gesture";

  /// The current orientation of the device.
  /// <p>
  /// See {@link android.hardware.SensorEvent#values SensorEvent.values} for more details.
  ///
  /// @hide Expected to be used internally for auto-rotate and speaker rotation.
  ///
  // @UnsupportedAppUsage(maxTargetSdk = Build.VERSION_CODES.R, trackingBug = 170729553)
  static const int typeDeviceOrientation = 27;

  /// A constant string describing a device orientation sensor type.
  ///
  /// @hide
  /// @see #typeDeviceOrientation
  static const String stringTypeDeviceOrientation =
      "android.sensor.device_orientation";

  /// A constant describing a pose sensor with 6 degrees of freedom.
  ///
  /// Similar to {@link #typeRotationVector}, with additional delta
  /// translation from an arbitrary reference point.
  ///
  /// See {@link android.hardware.SensorEvent#values SensorEvent.values} for more details.
  ///
  /// Can use camera, depth sensor etc to compute output value.
  ///
  /// This is expected to be a high power sensor and expected only to be
  /// used when the screen is on.
  ///
  /// Expected to be more accurate than the rotation vector alone.
  ///
  static const int typePose6dof = 28;

  /// A constant string describing a pose sensor with 6 degrees of freedom.
  ///
  /// @see #typePose6dof
  static const String stringTypePose6dof = "android.sensor.pose_6dof";

  /// A constant describing a stationary detect sensor.
  ///
  /// See {@link android.hardware.SensorEvent#values SensorEvent.values} for more details.
  ///
  static const int typeStationaryDetect = 29;

  /// A constant string describing a stationary detection sensor.
  ///
  /// @see #typeStationaryDetect
  static const String stringTypeStationaryDetect =
      "android.sensor.stationary_detect";

  /// A constant describing a motion detect sensor.
  ///
  /// See {@link android.hardware.SensorEvent#values SensorEvent.values} for more details.
  ///
  static const int typeMotionDetect = 30;

  /// A constant string describing a motion detection sensor.
  ///
  /// @see #typeMotionDetect
  static const String stringTypeMotionDetect = "android.sensor.motion_detect";

  /// A constant describing a heart beat sensor.
  ///
  /// See {@link android.hardware.SensorEvent#values SensorEvent.values} for more details.
  ///
  static const int typeHeartBeat = 31;

  /// A constant string describing a heart beat sensor.
  ///
  /// @see #typeHeartBeat

  static const String stringTypeHeartBeat = "android.sensor.heart_beat";

  /// A constant describing a dynamic sensor meta event sensor.
  ///
  /// A sensor event of this type is received when a dynamic sensor is added to or removed from
  /// the system. This sensor type should always use special trigger report mode ({@code
  /// SensorManager.REPORTING_MODE_SPECIAL_TRIGGER}).
  ///
  /// @hide This sensor is expected to be used only by system services.
  //   @SystemApi
  //  static const int typeDynamicSensorMeta = 32;
  /// A constant string describing a dynamic sensor meta event sensor.
  ///
  /// @see #typeDynamicSensorMeta
  ///
  /// @hide This sensor is expected to only be used by the system service
  //   @SystemApi
  //  static const String stringTypeDynamic_sensor_meta =
  //     "android.sensor.dynamic_sensor_meta";

  /* type_additional_info - defined as type 33 in the HAL is not exposed to
     * applications. There are parts of the framework that require the sensors
     * to be in the same order as the HAL. Skipping this sensor
     */

  /// A constant describing a low latency off-body detect sensor.
  ///
  /// See {@link android.hardware.SensorEvent#values SensorEvent.values} for more details.
  ///
  static const int typeLowLatencyOffbodyDetect = 34;

  /// A constant string describing a low-latency offbody detector sensor.
  ///
  /// @see #typeLowLatencyOffbodyDetect
  static const String stringTypeLowLatencyOffbodyDetect =
      "android.sensor.low_latency_offbody_detect";

  /// A constant describing an uncalibrated accelerometer sensor.
  ///
  /// See {@link android.hardware.SensorEvent#values SensorEvent.values} for more details.
  ///
  static const int typeAccelerometerUncalibrated = 35;

  /// A constant string describing an uncalibrated accelerometer sensor.
  ///
  /// @see #typeAccelerometerUncalibrated
  ///
  static const String stringTypeAccelerometerUncalibrated =
      "android.sensor.accelerometer_uncalibrated";

  /// A constant describing a hinge angle sensor.
  ///
  /// See {@link android.hardware.SensorEvent#values SensorEvent.values} for more details.
  ///
  static const int typeHingeAngle = 36;

  /// A constant string describing a hinge angle sensor.
  ///
  /// @see #typeHingeAngle
  ///
  static const String stringTypeHingeAngle = "android.sensor.hinge_angle";

  /// A constant describing all sensor types.

  static const int typeAll = -1;

  /// Events are reported at a constant rate which is set by the rate parameter of
  /// {@link SensorManager#registerListener(SensorEventListener, Sensor, int)}. Note: If other
  /// applications are requesting a higher rate, the sensor data might be delivered at faster rates
  /// than requested.
  static const int reportingModeContinuous = 0;

  /// Events are reported only when the value changes. Event delivery rate can be limited by
  /// setting appropriate value for rate parameter of
  /// {@link SensorManager#registerListener(SensorEventListener, Sensor, int)} Note: If other
  /// applications are requesting a higher rate, the sensor data might be delivered at faster rates
  /// than requested.
  static const int reportingModeOnChange = 1;

  /// Events are reported in one-shot mode. Upon detection of an event, the sensor deactivates
  /// itself and then sends a single event. Sensors of this reporting mode must be registered to
  /// using {@link SensorManager#requestTriggerSensor(TriggerEventListener, Sensor)}.
  static const int reportingModeOneShot = 2;

  /// Events are reported as described in the description of the sensor. The rate passed to
  /// registerListener might not have an impact on the rate of event delivery. See the sensor
  /// definition for more information on when and how frequently the events are reported. For
  /// example, step detectors report events when a step is detected.
  ///
  /// @see SensorManager#registerListener(SensorEventListener, Sensor, int, int)
  static const int reportingModeSpecialTrigger = 3;

  // TODO(): The following arrays are fragile and error-prone. This needs to be refactored.

  // Note: This needs to be updated, whenever a new sensor is added.
  /// Holds the reporting mode and maximum length of the values array
  /// associated with
  /// {@link SensorEvent} or {@link TriggerEvent} for the Sensor
  static const sSensorReportingModes = [
    0,
    3,
    3,
    3,
    3,
    1,
    1,
    1,
    1,
    3,
    3,
    5,
    1,
    1,
    6,
    4,
    6,
    1,
    1,
    1,
    5,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    16,
    1,
    1,
    1,
    2,
    16,
    1,
    6,
    1,
    6,
    6,
    6,
    9,
    9,
    2,
  ];

  static String getSensorName(int sensorType) {
    final string = getSensorString(sensorType);
    final string1 = string.substring(string.lastIndexOf('.') + 1);
    return (string1[0].toUpperCase() + string1.substring(1))
        .replaceAll('_', ' ');
  }

  static String getSensorString(int sensorType) {
    switch (sensorType) {
      case typeAccelerometer:
        return stringTypeAccelerometer;
      case typeAmbientTemperature:
        return stringTypeAmbientTemperature;
      case typeGameRotationVector:
        return stringTypeGameRotationVector;
      case typeGeomagneticRotationVector:
        return stringTypeGeomagneticRotationVector;
      // case typeGlanceGesture:
      //   return stringTypeGlanceGesture;
      case typeGravity:
        return stringTypeGravity;
      case typeGyroscope:
        return stringTypeGyroscope;
      case typeGyroscopeUncalibrated:
        return stringTypeGyroscopeUncalibrated;
      case typeHeartRate:
        return stringTypeHeartRate;
      case typeLight:
        return stringTypeLight;
      case typeLinearAcceleration:
        return stringTypeLinearAcceleration;
      case typeMagneticField:
        return stringTypeMagneticField;
      case typeMagneticFieldUncalibrated:
        return stringTypeMagneticFieldUncalibrated;
      // case typePickUpGesture:
      //   return stringTypePickUpGesture;
      case typePressure:
        return stringTypePressure;
      case typeProximity:
        return stringTypeProximity;
      case typeRelativeHumidity:
        return stringTypeRelativeHumidity;
      case typeRotationVector:
        return stringTypeRotationVector;
      case typeSignificantMotion:
        return stringTypeSignificantMotion;
      case typeStepCounter:
        return stringTypeStepCounter;
      case typeStepDetector:
        return stringTypeStepDetector;
      case typeTiltDetector:
        return sensorStringTypeTiltDetector;
      case typeWakeGesture:
        return stringTypeWakeGesture;
      case typeOrientation:
        return stringTypeOrientation;
      case typeTemperature:
        return stringTypeTemperature;
      // case typeDeviceOrientation:
      //   return stringTypeDeviceOrientation;
      // case typeDynamicSensorMeta:
      //   return stringTypeDynamicSensorMeta;
      case typeLowLatencyOffbodyDetect:
        return stringTypeLowLatencyOffbodyDetect;
      case typeAccelerometerUncalibrated:
        return stringTypeAccelerometerUncalibrated;
      case typeHingeAngle:
        return stringTypeHingeAngle;
      default:
        return "Unknown";
    }
  }
}
