import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gyroscope/gyroscope.dart';

class GyroscopeWidget extends StatefulWidget {
  @override
  _GyroscopeWidgetState createState() => _GyroscopeWidgetState();
}

class _GyroscopeWidgetState extends State<GyroscopeWidget> {
  GyroscopeSensorImpl gyro = GyroscopeSensorImpl();
  final ValueNotifier<GyroscopeData> gyroData = ValueNotifier<GyroscopeData>(
      const GyroscopeData(azimuth: 0, pitch: 0, roll: 0));
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ValueListenableBuilder<GyroscopeData>(
            builder:
                (BuildContext context, GyroscopeData value, Widget? child) {
              return Text(
                  'X: ${value.azimuth} || \nY: ${value.pitch} || \nZ: ${value.roll}');
            },
            valueListenable: gyroData,
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                gyro.unsubscribe();
              },
              label: const Text('Un-Subscribe'),
              icon: const Icon(Icons.thumb_down),
              backgroundColor: Colors.pink,
            ),
            FloatingActionButton.extended(
              onPressed: () {
                gyro.subscribe(data, rate: SampleRate.fastest);
              },
              label: const Text('Subscribe'),
              icon: const Icon(Icons.thumb_up),
              backgroundColor: Colors.green,
            )
          ],
        ),
      ),
    );
  }

  data(GyroscopeData data) {
    gyroData.value = data;
  }
}
