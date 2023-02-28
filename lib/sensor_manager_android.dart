library sensor_manager_android;

import 'dart:async';
import 'sensor.dart';
import 'sensor_event.dart';
import 'sensor_manager_android_platform_interface.dart';

/// <p>
/// SensorManager lets you access the device's {@link android.hardware.Sensor
/// sensors}.
/// </p>
/// <p>
/// Always make sure to disable sensors you don't need, especially when your
/// activity is paused. Failing to do so can drain the battery in just a few
/// hours. Note that the system will <i>not</i> disable sensors automatically when
/// the screen turns off.
/// </p>
/// <p class="note">
/// Note: Don't use this mechanism with a Trigger Sensor, have a look
/// at {@link TriggerEventListener}. {@link Sensor#TYPE_SIGNIFICANT_MOTION}
/// is an example of a trigger sensor.
/// </p>
/// <p>
/// In order to access sensor data at high sampling rates (i.e. greater than 200 Hz
/// for {@link SensorEventListener} and greater than {@link SensorDirectChannel#RATE_NORMAL}
/// for {@link SensorDirectChannel}), apps must declare
/// the {@link android.Manifest.permission#HIGH_SAMPLING_RATE_SENSORS} permission
/// in their AndroidManifest.xml file.
/// </p>
/// <pre class="prettyprint">
/// public class SensorActivity extends Activity implements SensorEventListener {
///     private final SensorManager mSensorManager;
///     private final Sensor mAccelerometer;
///
///     public SensorActivity() {
///         mSensorManager = (SensorManager)getSystemService(SENSOR_SERVICE);
///         mAccelerometer = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
///     }
///
///     protected void onResume() {
///         super.onResume();
///         mSensorManager.registerListener(this, mAccelerometer, SensorManager.SENSOR_DELAY_NORMAL);
///     }
///
///     protected void onPause() {
///         super.onPause();
///         mSensorManager.unregisterListener(this);
///     }
///
///     public void onAccuracyChanged(Sensor sensor, int accuracy) {
///     }
///
///     public void onSensorChanged(SensorEvent event) {
///     }
/// }
/// </pre>
///
/// @see SensorEventListener
/// @see SensorEvent
/// @see Sensor
///

class SensorManagerAndroid {

  const SensorManagerAndroid._();
  static const _instance = SensorManagerAndroid._();

  static SensorManagerAndroid get instance => _instance;

  Future<String?> getPlatformVersion() {
    return SensorManagerAndroidPlatform.instance.getPlatformVersion();
  }

  /// Use this method to get the list of available sensors of a certain type.
  /// Make multiple calls to get sensors of different types or use
  /// {@link android.hardware.Sensor#TYPE_ALL Sensor.TYPE_ALL} to get all the
  /// sensors. Note that the {@link android.hardware.Sensor#getName()} is
  /// expected to yield a value that is unique across any sensors that return
  /// the same value for {@link android.hardware.Sensor#getType()}.
  ///
  /// <p class="note">
  /// NOTE: Both wake-up and non wake-up sensors matching the given type are
  /// returned. Check {@link Sensor#isWakeUpSensor()} to know the wake-up properties
  /// of the returned {@link Sensor}.
  /// </p>
  ///
  /// @param type of sensors requested
  ///
  /// @return a list of sensors matching the asked type.
  ///
  /// @see #getDefaultSensor(int)
  /// @see Sensor
  Future<List<Sensor>> getSensorList([int? sensorType]) async {
    return SensorManagerAndroidPlatform.instance
        .getSensorList(sensorType ?? -1);
  }

  /// Tell if dynamic sensor discovery feature is supported by system.
  ///
  /// @return <code>true</code> if dynamic sensor discovery is supported, <code>false</code>
  /// otherwise.
  Future<bool> isDynamicSensorDiscoverySupported() async {
    return SensorManagerAndroidPlatform.instance
        .isDynamicSensorDiscoverySupported();
  }

  /// Use this method to get a list of available dynamic sensors of a certain type.
  /// Make multiple calls to get sensors of different types or use
  /// {@link android.hardware.Sensor#TYPE_ALL Sensor.TYPE_ALL} to get all dynamic sensors.
  ///
  /// <p class="note">
  /// NOTE: Both wake-up and non wake-up sensors matching the given type are
  /// returned. Check {@link Sensor#isWakeUpSensor()} to know the wake-up properties
  /// of the returned {@link Sensor}.
  /// </p>
  ///
  /// @param type of sensors requested
  ///
  /// @return a list of dynamic sensors matching the requested type.
  ///
  /// @see Sensor
  Future<List<Sensor>> getDynamicSensorList(int sensorType) async {
    return SensorManagerAndroidPlatform.instance
        .getDynamicSensorList(sensorType);
  }

  /// Use this method to get the default sensor for a given type. Note that the
  /// returned sensor could be a composite sensor, and its data could be
  /// averaged or filtered. If you need to access the raw sensors use
  /// {@link SensorManager#getSensorList(int) getSensorList}.
  ///
  /// @param type
  ///         of sensors requested
  ///
  /// @return the default sensor matching the requested type if one exists and the application
  ///         has the necessary permissions, or null otherwise.
  ///
  /// @see #getSensorList(int)
  /// @see Sensor
  ///
  /// Return a Sensor with the given type and wakeUp properties. If multiple sensors of this
  /// type exist, any one of them may be returned.
  /// <p>
  /// For example,
  /// <ul>
  ///     <li>getDefaultSensor({@link Sensor#TYPE_ACCELEROMETER}, true) returns a wake-up
  ///     accelerometer sensor if it exists. </li>
  ///     <li>getDefaultSensor({@link Sensor#TYPE_PROXIMITY}, false) returns a non wake-up
  ///     proximity sensor if it exists. </li>
  ///     <li>getDefaultSensor({@link Sensor#TYPE_PROXIMITY}, true) returns a wake-up proximity
  ///     sensor which is the same as the Sensor returned by {@link #getDefaultSensor(int)}. </li>
  /// </ul>
  /// </p>
  /// <p class="note">
  /// Note: Sensors like {@link Sensor#TYPE_PROXIMITY} and {@link Sensor#TYPE_SIGNIFICANT_MOTION}
  /// are declared as wake-up sensors by default.
  /// </p>
  /// @param type
  ///        type of sensor requested
  /// @param wakeUp
  ///        flag to indicate whether the Sensor is a wake-up or non wake-up sensor.
  /// @return the default sensor matching the requested type and wakeUp properties if one exists
  ///         and the application has the necessary permissions, or null otherwise.
  /// @see Sensor#isWakeUpSensor()

  Future<Sensor> getDefaultSensor(int sensorType, [bool? wakeUp]) async {
    return SensorManagerAndroidPlatform.instance
        .getDefaultSensor(sensorType, wakeUp);
  }

  /// Registers a {@link android.hardware.SensorEventListener SensorEventListener} for the given
  /// sensor at the given sampling frequency.
  /// <p>
  /// The events will be delivered to the provided {@code SensorEventListener} as soon as they are
  /// available. To reduce the power consumption, applications can use
  /// {@link #registerListener(SensorEventListener, Sensor, int, int)} instead and specify a
  /// positive non-zero maximum reporting latency.
  /// </p>
  /// <p>
  /// In the case of non-wake-up sensors, the events are only delivered while the Application
  /// Processor (AP) is not in suspend mode. See {@link Sensor#isWakeUpSensor()} for more details.
  /// To ensure delivery of events from non-wake-up sensors even when the screen is OFF, the
  /// application registering to the sensor must hold a partial wake-lock to keep the AP awake,
  /// otherwise some events might be lost while the AP is asleep. Note that although events might
  /// be lost while the AP is asleep, the sensor will still consume power if it is not explicitly
  /// deactivated by the application. Applications must unregister their {@code
  /// SensorEventListener}s in their activity's {@code onPause()} method to avoid consuming power
  /// while the device is inactive.  See {@link #registerListener(SensorEventListener, Sensor, int,
  /// int)} for more details on hardware FIFO (queueing) capabilities and when some sensor events
  /// might be lost.
  /// </p>
  /// <p>
  /// In the case of wake-up sensors, each event generated by the sensor will cause the AP to
  /// wake-up, ensuring that each event can be delivered. Because of this, registering to a wake-up
  /// sensor has very significant power implications. Call {@link Sensor#isWakeUpSensor()} to check
  /// whether a sensor is a wake-up sensor. See
  /// {@link #registerListener(SensorEventListener, Sensor, int, int)} for information on how to
  /// reduce the power impact of registering to wake-up sensors.
  /// </p>
  /// <p class="note">
  /// Note: Don't use this method with one-shot trigger sensors such as
  /// {@link Sensor#TYPE_SIGNIFICANT_MOTION}. Use
  /// {@link #requestTriggerSensor(TriggerEventListener, Sensor)} instead. Use
  /// {@link Sensor#getReportingMode()} to obtain the reporting mode of a given sensor.
  /// </p>
  ///
  /// @param listener A {@link android.hardware.SensorEventListener SensorEventListener} object.
  /// @param sensor The {@link android.hardware.Sensor Sensor} to register to.
  /// @param samplingPeriodUs The rate {@link android.hardware.SensorEvent sensor events} are
  ///            delivered at. This is only a hint to the system. Events may be received faster or
  ///            slower than the specified rate. Usually events are received faster. The value must
  ///            be one of {@link #SENSOR_DELAY_NORMAL}, {@link #SENSOR_DELAY_UI},
  ///            {@link #SENSOR_DELAY_GAME}, or {@link #SENSOR_DELAY_FASTEST} or, the desired delay
  ///            between events in microseconds. Specifying the delay in microseconds only works
  ///            from Android 2.3 (API level 9) onwards. For earlier releases, you must use one of
  ///            the {@code SENSOR_DELAY_*} constants.
  /// @return <code>true</code> if the sensor is supported and successfully enabled.
  /// @see #registerListener(SensorEventListener, Sensor, int, Handler)
  /// @see #unregisterListener(SensorEventListener)
  /// @see #unregisterListener(SensorEventListener, Sensor)

  void registerListener(int sensorType,
      {int? interval,
      void Function(SensorEvent)? onSensorChanged,
      void Function(Sensor, int)? onAccuracyChanged}) {
    return SensorManagerAndroidPlatform.instance.registerListener(sensorType,
        interval: interval,
        onSensorChanged: onSensorChanged,
        onAccuracyChanged: onAccuracyChanged);
  }

  /// Unregisters a listener for the sensors with which it is registered.
  ///
  /// <p class="note"></p>
  /// Note: Don't use this method with a one shot trigger sensor such as
  /// {@link Sensor#TYPE_SIGNIFICANT_MOTION}.
  /// Use {@link #cancelTriggerSensor(TriggerEventListener, Sensor)} instead.
  /// </p>
  ///
  /// @param listener
  ///        a SensorEventListener object
  ///
  /// @param sensor
  ///        the sensor to unregister from
  ///
  /// @see #unregisterListener(SensorEventListener)
  /// @see #registerListener(SensorEventListener, Sensor, int)

  void unregisterListener(int sensorType) {
    return SensorManagerAndroidPlatform.instance.unregisterListener(sensorType);
  }

  /// Add a {@link android.hardware.SensorManager.DynamicSensorCallback
  /// DynamicSensorCallback} to receive dynamic sensor connection callbacks. Repeat
  /// registration with the already registered callback object will have no additional effect.
  ///
  /// @param callback An object that implements the
  ///        {@link android.hardware.SensorManager.DynamicSensorCallback
  ///        DynamicSensorCallback}
  ///        interface for receiving callbacks.
  /// @see #registerDynamicSensorCallback(DynamicSensorCallback, Handler)
  ///
  /// @throws IllegalArgumentException when callback is null.

  void registerDynamicSensorCallback() {
    return SensorManagerAndroidPlatform.instance
        .registerDynamicSensorCallback();
  }

  /// Remove a {@link android.hardware.SensorManager.DynamicSensorCallback
  /// DynamicSensorCallback} to stop sending dynamic sensor connection events to that
  /// callback.
  ///
  /// @param callback An object that implements the
  ///        {@link android.hardware.SensorManager.DynamicSensorCallback
  ///        DynamicSensorCallback}
  ///        interface for receiving callbacks.

  void unregisterDynamicListener() {
    return SensorManagerAndroidPlatform.instance
        .unregisterDynamicSensorCallback();
  }

  /// Requests receiving trigger events for a trigger sensor.
  ///
  /// <p>
  /// When the sensor detects a trigger event condition, such as significant motion in
  /// the case of the {@link Sensor#TYPE_SIGNIFICANT_MOTION}, the provided trigger listener
  /// will be invoked once and then its request to receive trigger events will be canceled.
  /// To continue receiving trigger events, the application must request to receive trigger
  /// events again.
  /// </p>
  ///
  /// @param listener The listener on which the
  ///        {@link TriggerEventListener#onTrigger(TriggerEvent)} will be delivered.
  /// @param sensor The sensor to be enabled.
  ///
  /// @return true if the sensor was successfully enabled.
  ///
  /// @throws IllegalArgumentException when sensor is null or not a trigger sensor.

  void registerTriggerSensorCallback(int sensorType) async {
    return SensorManagerAndroidPlatform.instance
        .registerTriggerSensorCallback(sensorType);
  }

  /// Cancels receiving trigger events for a trigger sensor.
  ///
  /// <p>
  /// Note that a Trigger sensor will be auto disabled if
  /// {@link TriggerEventListener#onTrigger(TriggerEvent)} has triggered.
  /// This method is provided in case the user wants to explicitly cancel the request
  /// to receive trigger events.
  /// </p>
  ///
  /// @param listener The listener on which the
  ///        {@link TriggerEventListener#onTrigger(TriggerEvent)}
  ///        is delivered.It should be the same as the one used
  ///        in {@link #requestTriggerSensor(TriggerEventListener, Sensor)}
  /// @param sensor The sensor for which the trigger request should be canceled.
  ///        If null, it cancels receiving trigger for all sensors associated
  ///        with the listener.
  ///
  /// @return true if successfully canceled.
  ///
  /// @throws IllegalArgumentException when sensor is a trigger sensor.

  void cancelTriggerSensor(int sensorType) {
    return SensorManagerAndroidPlatform.instance
        .cancelTriggerSensor(sensorType);
  }

  /// Standard gravity (g) on Earth. This value is equivalent to 1G
  static const standardGravity = 9.80665;

  /// Sun's gravity in SI units (m/s^2)
  static const gravitySun = 275.0;

  /// Mercury's gravity in SI units (m/s^2)
  static const gravityMercury = 3.70;

  /// Venus' gravity in SI units (m/s^2)
  static const gravityVenus = 8.87;

  /// Earth's gravity in SI units (m/s^2)
  static const gravityEarth = 9.80665;

  /// The Moon's gravity in SI units (m/s^2)
  static const gravityMoon = 1.6;

  /// Mars' gravity in SI units (m/s^2)
  static const gravityMars = 3.71;

  /// Jupiter's gravity in SI units (m/s^2)
  static const gravityJupiter = 23.12;

  /// Saturn's gravity in SI units (m/s^2)
  static const gravitySaturn = 8.96;

  /// Uranus' gravity in SI units (m/s^2)
  static const gravityUranus = 8.69;

  /// Neptune's gravity in SI units (m/s^2)
  static const gravityNeptune = 11.0;

  /// Pluto's gravity in SI units (m/s^2)
  static const gravityPluto = 0.6;

  /// Gravity (estimate) on the first Death Star in Empire units (m/s^2)
  static const gravityDeathStarI = 0.000000353036145;

  /// Gravity on the island
  static const gravityTheIsland = 4.815162342;

  /// Maximum magnetic field on Earth's surface
  static const magneticFieldEarthMax = 60.0;

  /// Minimum magnetic field on Earth's surface
  static const magneticFieldEarthMin = 30.0;

  /// Standard atmosphere, or average sea-level pressure in hPa (millibar)
  static const pressureStandardAtmosphere = 1013.25;

  /// Maximum luminance of sunlight in lux
  static const lightSunlightMax = 120000.0;

  /// luminance of sunlight in lux
  static const lightSunlight = 110000.0;

  /// luminance in shade in lux
  static const lightShade = 20000.0;

  /// luminance under an overcast sky in lux
  static const lightOvercast = 10000.0;

  /// luminance at sunrise in lux
  static const lightSunrise = 400.0;

  /// luminance under a cloudy sky in lux
  static const lightCloudy = 100.0;

  /// luminance at night with full moon in lux
  static const lightFullMoon = 0.25;

  /// luminance at night with no moon in lux
  static const lightNoMoon = 0.001;

  /// get sensor data as fast as possible
  static const sensorDelayFastest = 0;

  /// rate suitable for games
  static const sensorDelayGame = 1;

  /// rate suitable for the user interface
  static const sensorDelayUi = 2;

  /// rate (default) suitable for screen orientation changes
  static const sensorDelayNormal = 3;
}
