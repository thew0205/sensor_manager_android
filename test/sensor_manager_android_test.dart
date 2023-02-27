import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_manager_android/sensor.dart';
import 'package:sensor_manager_android/sensor_manager_android.dart';
import 'package:sensor_manager_android/sensor_manager_android_platform_interface.dart';
import 'package:sensor_manager_android/sensor_manager_android_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSensorManagerAndroidPlatform
    with MockPlatformInterfaceMixin
    implements SensorManagerAndroidPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  
}

void main() {
  final SensorManagerAndroidPlatform initialPlatform = SensorManagerAndroidPlatform.instance;

  test('$MethodChannelSensorManagerAndroid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSensorManagerAndroid>());
  });

  test('getPlatformVersion', () async {
    SensorManagerAndroid sensorManagerAndroidPlugin = SensorManagerAndroid.instance;
    MockSensorManagerAndroidPlatform fakePlatform = MockSensorManagerAndroidPlatform();
    SensorManagerAndroidPlatform.instance = fakePlatform;

    expect(await sensorManagerAndroidPlugin.getPlatformVersion(), '42');
  });
}
