import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../incompatible_sdk_version.dart';
import '../sensor.dart';
import '../sensor_event.dart';
import 'sensor_manager_android_platform_interface.dart';
import '../trigger_event.dart';

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

  Future<int?> getSDKVersion() async {
    return await methodChannel.invokeMethod<int>("getSDKVersion");
  }

  Future<List<Sensor>> getSensorList(int sensorType) async {
    final sensorList = (await methodChannel.invokeListMethod<Map>(
            "getSensorList", {"sensorType": sensorType})) ??
        [];
    return sensorList.map(
      (sensor) {
        return Sensor.fromMap(sensor.cast<String, Object>());
      },
    ).toList();
  }

  Future<bool?> isDynamicSensorDiscoverySupported() async {
    try {
      return await methodChannel
          .invokeMethod<bool>("isDynamicSensorDiscoverySupported");
    } on PlatformException catch (e) {
      if (e.code == "1") {
        throw IncompatibleSDKVersionException(int.parse(e.message!));
      }
      rethrow;
    }
  }

  Future<List<Sensor>> getDynamicSensorList(int sensorType) async {
    try {
      final sensorList = (await methodChannel.invokeListMethod<Map>(
              "getDynamicSensorList", {"sensorType": sensorType})) ??
          [];

      return sensorList.map(
        (sensor) {
          return Sensor.fromMap(sensor.cast<String, Object>());
        },
      ).toList();
    } on PlatformException catch (e) {
      if (e.code == "1") {
        throw IncompatibleSDKVersionException(int.parse(e.message!));
      }
      rethrow;
    }
  }

  Future<Sensor?> getDefaultSensor(int sensorType, [bool? wakeUp]) async {
    try {
      return Sensor.fromMap(((await methodChannel
              .invokeMapMethod<String, Object>("getDefaultSensor", {
        "sensorType": sensorType,
        if (wakeUp != null) "wakeUp": wakeUp
      })) as Map)
          .cast<String, Object>());
    } on Exception {
       return null;
    }
   
  }

  void registerListener(int sensorType,
      {int? interval,
      int? maxReportLatencyUs,
      void Function(SensorEvent)? onSensorChanged,
      void Function(Sensor, int)? onAccuracyChanged}) async {
    await methodChannel.invokeMethod('registerListener', {
      "sensorType": sensorType,
      if (interval != null) "interval": interval,
      if (maxReportLatencyUs != null) "maxReportLatencyUs": maxReportLatencyUs
    });
    if (_eventChannels[sensorType] == null) {
      _eventChannels[sensorType] =
          EventChannel(eventChannelName + Sensor.getSensorString(sensorType));
    }
    _sensorSubscriptions[sensorType] = _eventChannels[sensorType]!
        .receiveBroadcastStream()
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
        try{
    await methodChannel.invokeMethod('registerDynamicSensorCallback');}
     on PlatformException catch (e) {
      if (e.code == "1") {
        throw IncompatibleSDKVersionException(int.parse(e.message!));
      }
      rethrow;
    }
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
    try {
      await methodChannel
          .invokeMethod('requestTriggerSensor', {"sensorType": sensorType});
    } on PlatformException catch (e) {
      if (e.code == "1") {
        throw IncompatibleSDKVersionException(int.parse(e.message!));
      }
      rethrow;
    }
    if (_eventChannels[sensorType] == null) {
      _eventChannels[sensorType] =
          EventChannel(eventChannelName + Sensor.getSensorString(sensorType));
    }

    _sensorSubscriptions[sensorType] = _eventChannels[sensorType]!
        .receiveBroadcastStream()
        .cast<Map>()
        .map((event) {
      return TriggerEvent.fromMap(event.cast<String, Object>());
    }).listen(onTrigger);
  }

  void cancelTriggerSensor(int sensorType) {
    _sensorSubscriptions[sensorType]?.cancel();
  }
}
