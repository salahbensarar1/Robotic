import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'connect.dart';

class RobotRemoteControl extends StatefulWidget {
  @override
  State<RobotRemoteControl> createState() => _RobotRemoteControlState();
}

class _RobotRemoteControlState extends State<RobotRemoteControl> {
  void _sendCommand(String command) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Robot Remote Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () => _sendCommand('move_forward'),
              child: Text('Move Forward'),
            ),
            FloatingActionButton(
              onPressed: () => _sendCommand('move_backward'),
              child: Text('Move Backward'),
            ),
            FloatingActionButton(
              onPressed: () => _sendCommand('turn_left'),
              child: Text('Turn Left'),
            ),
            FloatingActionButton(
              onPressed: () => _sendCommand('turn_right'),
              child: Text('Turn Right'),
            ),
          ],
        ),
      ),
    );
  }
}
