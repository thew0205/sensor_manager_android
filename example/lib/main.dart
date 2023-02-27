// ignore_for_file: public_member_api_docs, sort_constructors_first
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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
                "isDynamicSensorDiscoverySupported : $isDynamicSensorDiscoverySupported"),
            ElevatedButton(
              onPressed: () async {
                isDynamicSensorDiscoverySupported = await SensorManagerAndroid
                    .instance.isDynamicSensorDiscoverySupported();
                setState(() {});
              },
              child: const Text("isDynamicSensorDiscoverySupported"),
            ),
            Text(
                "isDynamicSensorDiscoverySupported : $isDynamicSensorDiscoverySupported"),
            ElevatedButton(
              onPressed: () async {
                isDynamicSensorDiscoverySupported = await SensorManagerAndroid.instance
                    .isDynamicSensorDiscoverySupported();
                setState(() {});
              },
              child: const Text("isDynamicSensorDiscoverySupported"),
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
            subtitle: Text(sensor.vendor),
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
  SensorWidget({super.key, required this.sensor});

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
      },onAccuracyChanged: (p0, p1) {
        
      },
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
                "Max Range", " ${widget.sensor.maxRange.toString()}"),
            SensorDataWidget("Power", " ${widget.sensor.power.toString()}"),
            SensorDataWidget(
                "Min Delay", " ${widget.sensor.minDelay.toString()}"),
            const Text("Sensor data"),
            Expanded(
              child: Wrap(
                spacing: 18,
                children: sensorEvent?.values
                        .map((e) => Text(e.toString()))
                        .toList() ??
                    [],
              ),
              // FutureBuilder(
              //     future:
              //         SensorManagerAndroid.getSensorEventStream(widget.sensor.type),
              //     builder: (context, snapshot) {
              //       return StreamBuilder<SensorEvent>(
              //         stream: snapshot.data,
              //         builder: (BuildContext context,
              //             AsyncSnapshot<SensorEvent> snapshot) {
              //           print(snapshot.data);
              //           if (snapshot.hasData) {
              //             return Wrap(
              //               spacing: 18,
              //               children: snapshot.data?.values
              //                       .map((e) => Text(e.toString()))
              //                       .toList() ??
              //                   [],
              //             );
              //           } else {
              //             return const Text("No data yet");
              //           }
              //         },
              //       );
              //     }),
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



// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String _platformVersion = 'Unknown';
//   final _SensorManagerAndroidugin = SensorManagerAndroid;

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     String platformVersion;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     // We also handle the message potentially returning null.
//     try {
//       platformVersion =
//           (await _SensorManagerAndroidugin.getSensorList()).toString();
//     } on PlatformException {
//       platformVersion = 'Failed to get platform version.';
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     setState(() {
//       _platformVersion = platformVersion;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Center(
//           child: Text('Running on: $_platformVersion\n'),
//         ),
//       ),
//     );
//   }
// }
