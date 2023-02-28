import 'dart:convert';
import 'dart:core';

import 'package:flutter/foundation.dart';

import 'sensor.dart';

/// This class represents a Trigger Event - the event
/// associated with a Trigger Sensor. When the sensor detects a trigger
/// event condition, such as significant motion in the case of the
/// {@link Sensor#TYPE_SIGNIFICANT_MOTION}, the {@link TriggerEventListener}
/// is called with the TriggerEvent. The sensor is automatically canceled
/// after the trigger.
/// <p>
/// This class holds information such as the value of the sensor
/// when the trigger happened, the timestamp along with detailed
/// information regarding the Sensor itself.
/// </p>
/// @see android.hardware.SensorManager
/// @see android.hardware.TriggerEvent
/// @see android.hardware.Sensor

class TriggerEvent {

  /// <p>
  /// The length and contents of the {@link #values values} array depends on
  /// which {@link android.hardware.Sensor sensor} type is being monitored (see
  /// also {@link SensorEvent} for a definition of the coordinate system used).
  /// </p>
  /// <h4> {@link Sensor#TYPE_SIGNIFICANT_MOTION} </h4>
  /// The value field is of length 1. value[0] = 1.0 when the sensor triggers.
  /// 1.0 is the only allowed value.
  final List<double> values;

  /// The sensor that generated this event. See
  /// {@link android.hardware.SensorManager SensorManager} for details.
  final Sensor sensor;

  /// The time in nanosecond at which the event happened
  final int timestamp;

  const TriggerEvent(this.values, this.sensor, this.timestamp);

  TriggerEvent copyWith({
    List<double>? values,
    Sensor? sensor,
    int? timestamp,
  }) {
    return TriggerEvent(
      values ?? this.values,
      sensor ?? this.sensor,
      timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'values': values,
      'sensor': sensor.toMap(),
      'timestamp': timestamp,
    };
  }

  factory TriggerEvent.fromMap(Map<String, dynamic> map) {
    return TriggerEvent(
      List<double>.from((map['values'] as List<double>)),
      Sensor.fromMap(map['sensor'] as Map<String, dynamic>),
      map['timestamp'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TriggerEvent.fromJson(String source) =>
      TriggerEvent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TriggerEvent(values: $values, sensor: $sensor, timestamp: $timestamp)';

  @override
  bool operator ==(covariant TriggerEvent other) {
    if (identical(this, other)) return true;

    return listEquals(other.values, values) &&
        other.sensor == sensor &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode => values.hashCode ^ sensor.hashCode ^ timestamp.hashCode;
}
