# sensor_manager_android
This plugin gives you access to the Android sensor framework lets you access many types of sensors.

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
try{
 bool? isDynamicSensorDiscoverySupported = await SensorManagerAndroid
                    .instance.isDynamicSensorDiscoverySupported();
} on IncompatibleSDKVersionException catch (e) {
  print(e);
}
// Getting the list of available sensors available on device
// To get the list of all available sensor, pass no argument 
// To get a particular sensor, pass the sensor type in 
// e.g. Sensor.TYPE_LIGHT
 List<Sensor> listOfSensor = await SensorManagerAndroid.instance.getSensorList();

 // To get the default sensor pass the sensor type
Sensor sensor = await SensorManagerAndroid.instance.getDefaultSensor(Sensor.TYPE_LIGHT);

// To register a listener to a particular sensor pass the sensor type
// an onSensorChanged and onAccuracyChanged function
SensorEvent? sensorEvent;
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
    SensorManagerAndroid.instance.unregisterListener(SensorType);

```
### List of Available sensors
| <img src="/assets/sensor_list.png?raw=true" width="400px"> | 

### Monitoring Sensor Events
| <img src="/assets/acceleration.png?raw=true" width="400px"> | 

## Description
You can access the sensors and acquire raw sensor data by using this plugin. This plugin tries to mimic the sensor framework which is a part of the android.hardware package and includes the following classes and interfaces and the equivalent.

SensorManager - SensorManagerAndroid
You can use this class to create an instance of the sensor service and communicate the android framework. This class provides various methods for accessing and listing sensors, registering and unregistering sensor event listeners, and acquiring orientation information. This class also provides several sensor constants that are used to report sensor accuracy, set data acquisition rates, and calibrate sensors.
Sensor - Sensor
You can use this class to create an instance of a specific sensor. This class provides various methods that let you determine a sensor's capabilities.
SensorEvent - SensorEvent
The system uses this class to create a sensor event object, which provides information about a sensor event. A sensor event object includes the following information- the raw sensor data, the type of sensor that generated the event, the accuracy of the data, and the timestamp for the event.

In a typical application you use these sensor-related APIs to perform two basic tasks:
* Identifying sensors 
* Sensor capabilities
Identifying sensors and sensor capabilities at runtime is useful if your application has features that rely on specific sensor types or capabilities. For example, you may want to identify all of the sensors that are present on a device and disable any application features that rely on sensors that are not present. Likewise, you may want to identify all of the sensors of a given type so you can choose the sensor implementation that has the optimum performance for your application.

##### Monitor sensor events
Monitoring sensor events is how you acquire raw sensor data. A sensor event occurs every time a sensor detects a change in the parameters it is measuring. A sensor event provides you with four pieces of information: the name of the sensor that triggered the event, the timestamp for the event, the accuracy of the event, and the raw sensor data that triggered the event.

#### Sensor Availability
While sensor availability varies from device to device, it can also vary between Android versions. This is because the Android sensors have been introduced over the course of several platform releases. For example, many sensors were introduced in Android 1.5 (API Level 3), but some were not implemented and were not available for use until Android 2.3 (API Level 9). Likewise, several sensors were introduced in Android 2.3 (API Level 9) and Android 4.0 (API Level 14). 

Table 2 summarizes the availability of each sensor on a platform-by-platform basis. Only four platforms are listed because those are the platforms that involved sensor changes. Sensors that are listed as deprecated are still available on subsequent platforms (provided the sensor is present on a device), which is in line with Android's forward compatibility policy.

#### Identifying Sensors and Sensor Capabilities
This plugin provides several methods that make it easy for you to determine at runtime which sensors are on a device. The API also provides methods that let you determine the capabilities of each sensor, such as its maximum range, its resolution, and its power requirements an more.

To identify the sensors that are on a device you first need to get a reference to the sensor manager. To do this, you need to access the SensorManagerAndroid.instance
Next, you can get a listing of every sensor on a device by calling the getSensorList() method and using the TYPE_ALL constant. For example:
```dart
// Import package
import 'package:sensor_manager_android/sensor_manager_android.dart';

 List<Sensor> listOfSensor = await SensorManagerAndroid.instance.getSensorList(Sensor.typeAll);
```
If you want to list all of the sensors of a given type, you could use another constant instead of typeAll such as typeGyroscope, typeGravity, typeLinearAcceleration or any of the sensorType.

You can also determine whether a specific type of sensor exists on a device by using the getDefaultSensor() method and passing in the type constant for a specific sensor. If a device has more than one sensor of a given type, one of the sensors must be designated as the default sensor. If a default sensor does not exist for a given type of sensor, the method call returns null, which means the device does not have that type of sensor. For example, the following code checks whether there's a magnetometer on a device:
```dart
// Import package
import 'package:sensor_manager_android/sensor_manager_android.dart';

Sensor? sensor = await SensorManagerAndroid.instance.getDefaultSensor(Sensor.TYPE_LIGHT);
if(sensor != null){
   // Success! There's a magnetometer. 
}else{
  // Failure! No magnetometer.
}
```

#### Monitoring Sensor Events
To monitor raw sensor data you need to pass two callback methods t: onAccuracyChanged() and onSensorChanged(). The plugin calls these methods whenever the following occurs:

A sensor's accuracy changes.
In this case the system invokes the onAccuracyChanged() method, providing you with a reference to the Sensor object that changed and the new accuracy of the sensor. Accuracy is represented by one of four status constants: sensorStatusAccuracyLow, sensorStatusAccuracyMedium, sensorStatusAccuracyHigh, or sensorStatusUnreliable.

A sensor reports a new value.
In this case the system invokes the onSensorChanged() method, providing you with a SensorEvent object. A SensorEvent object contains information about the new sensor data, including: the accuracy of the data, the sensor that generated the data, the timestamp at which the data was generated, and the new data that the sensor recorded.

The following code shows how to use the onSensorChanged() method to monitor data from the light sensor. This example displays the sensor information and all the light information as the colour of a bulb and in raw form.
```dart
SensorEvent? sensorEvent;

  @override
  void initState() {
    super.initState();
    SensorManagerAndroid.instance.registerListener(
      widget.sensor.type,
      onSensorChanged: (p0) {
        setState(() {
          sensorEvent = p0;
        });
      },
      onAccuracyChanged: (p0, p1) {},
    );
  }

  @override
  void dispose() {
    super.dispose();
    SensorManagerAndroid.instance.unregisterListener(widget.sensor.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.sensor.name,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SensorManagerAndroid.instance.unregisterListener(widget.sensor.type);
        },
        child: const Text("Cancel"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SensorDataWidget("Vendor", widget.sensor.vendor),
            SensorDataWidget("Version", " ${widget.sensor.version.toString()}"),
            SensorDataWidget("Type", " ${widget.sensor.type.toString()}"),
            SensorDataWidget(
                "Resolution", " ${widget.sensor.resolution.toString()}"),
            SensorDataWidget(
                "Reporting mode", " ${widget.sensor.reportingMode.toString()}"),
            SensorDataWidget("Power", " ${widget.sensor.power.toString()}"),
            SensorDataWidget(
                "Min Delay", " ${widget.sensor.minDelay.toString()}"),
            SensorDataWidget(
                "Max range", " ${widget.sensor.maxRange.toString()}"),
            SensorDataWidget("Is Wake up sensor",
                " ${widget.sensor.isWakeUpSensor.toString()}"),
            SensorDataWidget("Is Dynamic sensor",
                " ${widget.sensor.isDynamicSensor.toString()}"),
            const Text("Sensor data"),
            Expanded(
              child: Column(
                children: [
                  for (var i = 0; i < (sensorEvent?.values.length ?? 0); i++)
                    SensorDataWidget("Value ${i + 1} ",
                        sensorEvent!.values[i].toStringAsFixed(5))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
```

| <img src="/assets/step_counter.png?raw=true" width="400px">  <img src="/assets/step_counter.png?raw=true" width="400px"> |

### Streaming SensorEvent Data
<video width="400px"> <source src="assets\light_sensor_animation.mp4" type="video/mp4"> Streaming SensorEvent Data not showing</video>


## Getting Started
* Create a new flutter project
* Add "sensor_manager_android: ^0.0.2" to your pubspec.yaml file
* Include "import 'package:sensor_manager_android/sensor_manager_android.dart';" at the top of your amin dart file
* Use the SensorManagerAndroid.instance in your project
[For more information about the android sensor API.](https://developer.android.com/guide/topics/sensors/sensors_overview)
Also check the example code



### Current setbacks
* Listeners can only be set for the default sensor.