import 'dart:math';

import 'package:flutter/material.dart';

import 'package:sensor_manager_android/sensor.dart';
import 'package:sensor_manager_android/sensor_event.dart';
import 'package:sensor_manager_android/sensor_manager_android.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool? isDynamicSensorDiscoverySupported;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                "Device supports dynamics sensor: $isDynamicSensorDiscoverySupported"),
            ElevatedButton(
              onPressed: () async {
                isDynamicSensorDiscoverySupported = await SensorManagerAndroid
                    .instance
                    .isDynamicSensorDiscoverySupported();
                setState(() {});
              },
              child: const Text("Check support for dynamic sensor"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BrightnessAnimationPage()),
                );
              },
              child: const Text("Brightness Animation Page"),
            ),
            ElevatedButton(
                onPressed: () {
                  SensorManagerAndroid.instance.getSensorList().then(
                        (value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SensorListWidget(sensorList: value),
                          ),
                        ),
                      );
                },
                child: const Text("Get list of available sensor"))
          ],
        ),
      ),
    );
  }
}

class BrightnessAnimationPage extends StatefulWidget {
  const BrightnessAnimationPage({super.key});

  @override
  State<BrightnessAnimationPage> createState() =>
      _BrightnessAnimationPageState();
}

class _BrightnessAnimationPageState extends State<BrightnessAnimationPage> {
  Sensor? lightSensor;
  SensorEvent? sensorEvent;

  @override
  void initState() {
    super.initState();
    SensorManagerAndroid.instance
        .getDefaultSensor(Sensor.typeLight)
        .then((value) => setState(() {
              lightSensor = value;
            }));
    SensorManagerAndroid.instance.registerListener(
      Sensor.typeLight,
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
    SensorManagerAndroid.instance.unregisterListener(Sensor.typeLight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Brightness Animation",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (lightSensor != null) {
            SensorManagerAndroid.instance.unregisterListener(lightSensor!.type);
          }
        },
        child: const Text("Cancel"),
      ),
      body: (lightSensor != null)
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SensorDataWidget("Vendor", lightSensor!.vendor),
                  SensorDataWidget(
                      "Version", " ${lightSensor!.version.toString()}"),
                  SensorDataWidget("Type", " ${lightSensor!.type.toString()}"),
                  SensorDataWidget(
                      "Resolution", " ${lightSensor!.resolution.toString()}"),
                  SensorDataWidget("Reporting mode",
                      " ${lightSensor!.reportingMode.toString()}"),
                  SensorDataWidget(
                      "Power", " ${lightSensor!.power.toString()}"),
                  SensorDataWidget(
                      "Min Delay", lightSensor!.minDelay.toString()),
                  SensorDataWidget(
                      "Max range", " ${lightSensor!.maxRange.toString()}"),
                  SensorDataWidget("Is Wake up sensor",
                      " ${lightSensor!.isWakeUpSensor.toString()}"),
                  SensorDataWidget("Is Dynamic sensor",
                      " ${lightSensor!.isDynamicSensor.toString()}"),
                  const Text("Sensor data"),
                  SensorDataWidget("Value ",
                      sensorEvent?.values.first.toStringAsFixed(5) ?? "nil"),
                  Expanded(
                    child: Icon(
                      Icons.lightbulb,
                      size: 200,
                      color: const Color.fromARGB(255, 254, 152, 0).withOpacity(
                        map_(log(sensorEvent?.values.first ?? 1000) +1, 0,
                            log(lightSensor?.maxRange ?? 10000), 0.15, 1),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

double map_(
    double value, double minValue, double maxValue, double min, double max) {
  final r = ((max - min) * (value - minValue) / (maxValue - minValue)) + min;
  return r.clamp(min, max);
}

class SensorListWidget extends StatelessWidget {
  final List<Sensor> sensorList;
  const SensorListWidget({
    Key? key,
    required this.sensorList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Sensors"),
      ),
      body: ListView.builder(
        itemCount: sensorList.length,
        itemBuilder: (context, index) {
          final sensor = sensorList[index];
          return ListTile(
            title: Text(sensor.name),
            subtitle: Text(Sensor.getSensorName(sensor.type)),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SensorWidget(
                  sensor: sensor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SensorWidget extends StatefulWidget {
  final Sensor sensor;
  const SensorWidget({super.key, required this.sensor});

  @override
  State<SensorWidget> createState() => _SensorWidgetState();
}

class _SensorWidgetState extends State<SensorWidget> {
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
}

class SensorDataWidget extends StatelessWidget {
  const SensorDataWidget(this.sensor, this.data, {Key? key}) : super(key: key);
  final String sensor;
  final String data;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text("$sensor:"),
        Text(
          data,
          style: TextStyle(color: Theme.of(context).primaryColor),
        )
      ]),
    );
  }
}
