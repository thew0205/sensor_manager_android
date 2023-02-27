import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_manager_android/sensor_manager_android_method_channel.dart';

void main() {
  MethodChannelSensorManagerAndroid platform = MethodChannelSensorManagerAndroid();
  const MethodChannel channel = MethodChannel('sensor_manager_android');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
