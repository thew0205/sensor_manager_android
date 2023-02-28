import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sensor.dart';
import 'sensor_event.dart';
import 'sensor_manager_android_platform_interface.dart';
import 'trigger_event.dart';

/// An implementation of [SensorManagerAndroidPlatform] that uses methodChannel channels.
class MethodChannelSensorManagerAndroid extends SensorManagerAndroidPlatform {
  /// The methodChannel channel used to interact with the native platform.
  static const methodChannelName = 'com.switches/sensor_manager_android';
  static const eventChannelName = 'com.switches/sensor_manager_android/';
  @visibleForTesting
  final methodChannel = const MethodChannel(methodChannelName);

  final _eventChannels = <int, EventChannel>{};
  final _sensorSubscriptions = <int, StreamSubscription?>{};
  EventChannel? _dynamicEventChannel;
  StreamSubscription? _dynamicSensorSubscription;

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Future<List<Sensor>> getSensorList(int sensorType) async {
    final sensorList = (await methodChannel
            .invokeListMethod("getSensorList", {"sensorType": sensorType})) ??
        [];
    return sensorList.map(
      (sensor) {
        return Sensor.fromMap(sensor.cast<String, Object>());
      },
    ).toList();
  }

  Future<bool> isDynamicSensorDiscoverySupported() async {
    return await methodChannel
        .invokeMethod("isDynamicSensorDiscoverySupported");
  }

  Future<List<Sensor>> getDynamicSensorList(int sensorType) async {
    final sensorList = (await methodChannel.invokeListMethod(
            "getDynamicSensorList", {"sensorType": sensorType})) ??
        [];

    return sensorList.map(
      (sensor) {
        return Sensor.fromMap(sensor.cast<String, Object>());
      },
    ).toList();
  }

  Future<Sensor> getDefaultSensor(int sensorType, [bool? wakeUp]) async {
    return Sensor.fromMap(await methodChannel.invokeMethod("getDefaultSensor",
        {"sensorType": sensorType, if (wakeUp != null) "wakeUp": wakeUp}));
  }

  void registerListener(int sensorType,
      {int? interval,
      void Function(SensorEvent)? onSensorChanged,
      void Function(Sensor, int)? onAccuracyChanged}) async {
    methodChannel.invokeMethod('registerListener',
        {"sensorType": sensorType, if (interval != null) "interval": interval});
    _eventChannels[sensorType] =
        EventChannel(eventChannelName + Sensor.setType(sensorType));

    _sensorSubscriptions[sensorType] = _eventChannels[sensorType]
        ?.receiveBroadcastStream()
        .cast<Map>()
        .listen((event) {
      if (event["newAccuracy"] == null) {
        onSensorChanged
            ?.call(SensorEvent.fromMap(event.cast<String, Object>()));
      } else {
        onAccuracyChanged?.call(
            Sensor.fromMap(event.cast<String, Object>()), event["newAccuracy"]);
      }
    });
  }

  void unregisterListener(int sensorType) {
    _sensorSubscriptions[sensorType]?.cancel();
  }

  void registerDynamicSensorCallback(
      {void Function(SensorEvent)? onDynamicSensorDisconnected}) async {
    await methodChannel.invokeMethod('registerDynamicSensorCallback');
    _dynamicEventChannel ??= const EventChannel(
        "${eventChannelName}eventChannelDynamicSensorCallback");
    _dynamicSensorSubscription =
        _dynamicEventChannel?.receiveBroadcastStream().cast<Map>().map((event) {
      return SensorEvent.fromMap(event.cast<String, Object>());
    }).listen(onDynamicSensorDisconnected);
  }

  void unregisterDynamicSensorCallback() {
    _dynamicSensorSubscription?.cancel();
  }

  void registerTriggerSensorCallback(int sensorType,
      {void Function(TriggerEvent)? onTrigger}) async {
    await methodChannel
        .invokeMethod('requestTriggerSensor', {"sensorType": sensorType});
    _eventChannels[sensorType] =
        EventChannel(eventChannelName + Sensor.setType(sensorType));
    _sensorSubscriptions[sensorType] = _eventChannels[sensorType]
        ?.receiveBroadcastStream()
        .cast<Map>()
        .map((event) {
      return TriggerEvent.fromMap(event.cast<String, Object>());
    }).listen(onTrigger);
  }

  void cancelTriggerSensor(int sensorType) {
    _sensorSubscriptions[sensorType]?.cancel();
  }
}
