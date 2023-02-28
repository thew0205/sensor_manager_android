import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sensor_manager_android_method_channel.dart';

abstract class SensorManagerAndroidPlatform extends PlatformInterface {
  /// Constructs a SensorManagerAndroidPlatform.
  SensorManagerAndroidPlatform() : super(token: _token);

  static final Object _token = Object();

  static MethodChannelSensorManagerAndroid _instance =
      MethodChannelSensorManagerAndroid();

  /// The default instance of [SensorManagerAndroidPlatform] to use.
  ///
  /// Defaults to [MethodChannelSensorManagerAndroid].
  static MethodChannelSensorManagerAndroid get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SensorManagerAndroidPlatform] when
  /// they register themselves.
  static set instance(SensorManagerAndroidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance as MethodChannelSensorManagerAndroid;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
