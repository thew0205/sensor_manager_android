# sensor_manager_android

 A Flutter plugin implementation of the android sensor API. 

## Getting Started

This project is 
This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Platform Support
| Android |
| :-----: |
|   ✔️    |

## Usage

Add `sensor_manager_android` as a dependency in your pubspec.yaml file.

### Example

```dart
// Import package
import 'package:sensor_manager_android/sensor_manager_android.dart';
import 'package:sensor_manager_android/sensor.dart';
import 'package:sensor_manager_android/sensor_event.dart';


// Checking if dynamic sensor is supported
 bool? isDynamicSensorDiscoverySupported; = await SensorManagerAndroid
                    .instance.isDynamicSensorDiscoverySupported();

// Getting the list of available sensors available on device
// To get the list of all available sensor, pass no argument 
// To get a particular sensor, pass the sensor type in 
// e.g. Sensor.TYPE_LIGHT
 List<Sensor> listOfSensor = await bSensorManagerAndroid.instance.      getSensorList();

 // To get the default sensor pass the sensor type
Sensor sensor = await SensorManagerAndroid.instance.getDefaultSensor(Sensor.TYPE_LIGHT);

// To register a listener to a particular sensor pass the sensor type
// an onSensorChanged and onAccuracyChanged function
SensorManagerAndroid.instance.registerListener(
      widget.sensor.type,
      onSensorChanged: (p0) {
        setState(() {
          sensorEvent = p0;
        });
      },onAccuracyChanged: (p0, p1) {
        
      },
    );
// To cancel the listener pass the sensor type
    SensorManagerAndroid.instance.unregisterListener(widget.sensor.type);



```