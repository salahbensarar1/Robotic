import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gyroscope/gyroscope.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class GyroControl extends StatefulWidget {
  const GyroControl({Key? key}) : super(key: key);

  @override
  _GyroControlState createState() => _GyroControlState();
}

class _GyroControlState extends State<GyroControl> {
  GyroscopeSensorImpl gyro = GyroscopeSensorImpl();

  // Gyroscope data
  double _pitch = 0;
  double _roll = 0;
  double _azimuth = 0;

  // Robot arm angles (mapped from gyro)
  double _baseAngle = 0;
  double _shoulderAngle = 0;
  double _elbowAngle = 0;

  // Socket connection
  Socket? _socket;
  bool _isConnected = false;

  // Coffee selection
  String _coffeeSize = "M";

  // Gripper state
  bool _isGripperOpen = false;

  // Gyroscope subscription
  bool _gyroActive = false;

  // Sensitivity multipliers (adjust these for better control)
  final double _rollSensitivity = 2.0;
  final double _pitchSensitivity = 2.0;
  final double _azimuthSensitivity = 1.5;

  @override
  void initState() {
    super.initState();
    establishSocketConnection();
  }

  @override
  void dispose() {
    gyro.unsubscribe();
    if (_socket != null) {
      _socket!.destroy();
    }
    super.dispose();
  }

  void establishSocketConnection() {
    Socket.connect("192.168.137.1", 3333).then((socket) {
      setState(() {
        _socket = socket;
        _isConnected = true;
      });

      _socket!.listen(
        (data) {
          print('Received data: $data');
        },
        onError: (error) {
          print('Socket error: $error');
        },
        onDone: () {
          print('Socket closed');
          setState(() {
            _isConnected = false;
          });
        },
      );
    }).catchError((error) {
      print('Connection error: $error');
      setState(() {
        _isConnected = false;
      });
    });
  }

  void toggleGyroscope() {
    setState(() {
      _gyroActive = !_gyroActive;
    });

    if (_gyroActive) {
      gyro.subscribe(handleGyroscopeData, rate: SampleRate.fastest);
      // Start sending data continuously
      _startContinuousSending();
    } else {
      gyro.unsubscribe();
    }
  }

  Timer? _sendTimer;
  void _startContinuousSending() {
    _sendTimer?.cancel();
    _sendTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_gyroActive) {
        sendRobotCommand();
      } else {
        timer.cancel();
      }
    });
  }

  void handleGyroscopeData(GyroscopeData data) {
    setState(() {
      // Update raw gyroscope values
      _pitch = data.pitch;
      _roll = data.roll;
      _azimuth = data.azimuth;

      // Map gyroscope data to robot arm angles
      // Roll controls base rotation (left-right tilt)
      _baseAngle = (_roll * _rollSensitivity).clamp(-180.0, 180.0);

      // Pitch controls shoulder (forward-backward tilt)
      _shoulderAngle = (_pitch * _pitchSensitivity).clamp(-180.0, 180.0);

      // Azimuth controls elbow
      _elbowAngle = (_azimuth * _azimuthSensitivity).clamp(-180.0, 180.0);
    });
  }

  void sendRobotCommand() {
    if (_isConnected) {
      String message =
          "10;${(_baseAngle * 0.1).toStringAsFixed(2)};${(_shoulderAngle * 0.1).toStringAsFixed(2)};${(_elbowAngle * 0.1).toStringAsFixed(2)};0;0;0;0;0;0;0;0";
      _socket!.write(message);
      print('Sent: $message');
    } else {
      print('Not connected to robot');
    }
  }

  void sendCoffeeCommand() {
    String message = "";
    switch (_coffeeSize) {
      case "S":
        message = "3;0;0;0;0;0;0;0;0;0;0;0";
        break;
      case "M":
        message = "4;0;0;0;0;0;0;0;0;0;0;0";
        break;
      case "L":
        message = "5;0;0;0;0;0;0;0;0;0;0;0";
        break;
    }

    if (_isConnected) {
      _socket!.write(message);
      print('Coffee command sent: $message');
    }
  }

  void toggleGripper() {
    setState(() {
      _isGripperOpen = !_isGripperOpen;
    });

    String message = _isGripperOpen
        ? "6;0;0;0;0;0;0;0;0;0;0;0"  // Open
        : "7;0;0;0;0;0;0;0;0;0;0;0"; // Close

    if (_isConnected) {
      _socket!.write(message);
      print('Gripper toggled: ${_isGripperOpen ? "Open" : "Close"}');
    }
  }

  void sendHome() {
    String message = "8;0;0;0;0;0;0;0;0;0;0;0";
    if (_isConnected) {
      _socket!.write(message);
      print('Home command sent');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldGradientBackground(
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          Color(0xFF8EC5FC),
          Color(0xFFE0C3FC),
        ],
      ),
      appBar: AppBar(
        title: Text('Gyroscope Robot Control'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _isConnected ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _isConnected ? 'Connected' : 'Disconnected',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Gyroscope Control Toggle
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Gyroscope Control',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: toggleGyroscope,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _gyroActive ? Colors.red : Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_gyroActive ? Icons.stop : Icons.play_arrow),
                            SizedBox(width: 10),
                            Text(
                              _gyroActive ? 'STOP CONTROL' : 'START CONTROL',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      if (_gyroActive)
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            '🎮 Tilt your phone to control the robot!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Gyroscope Data Display
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Robot Arm Angles',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      _buildAngleIndicator('Base (Roll)', _baseAngle, Icons.rotate_right),
                      _buildAngleIndicator('Shoulder (Pitch)', _shoulderAngle, Icons.trending_up),
                      _buildAngleIndicator('Elbow (Azimuth)', _elbowAngle, Icons.architecture),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Raw Gyroscope Values
              Card(
                elevation: 4,
                color: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Text(
                        'Raw Gyroscope Data',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Pitch: ${_pitch.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.greenAccent, fontSize: 14),
                      ),
                      Text(
                        'Roll: ${_roll.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.greenAccent, fontSize: 14),
                      ),
                      Text(
                        'Azimuth: ${_azimuth.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.greenAccent, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Coffee Selection
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        '☕ Select Coffee Size',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      SegmentedButton<String>(
                        segments: [
                          ButtonSegment(value: 'S', label: Text('Small'), icon: Icon(Icons.local_cafe)),
                          ButtonSegment(value: 'M', label: Text('Medium'), icon: Icon(Icons.coffee)),
                          ButtonSegment(value: 'L', label: Text('Large'), icon: Icon(Icons.coffee_maker)),
                        ],
                        selected: {_coffeeSize},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            _coffeeSize = newSelection.first;
                          });
                        },
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: sendCoffeeCommand,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Make Coffee',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Control Buttons
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Robot Controls',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildControlButton(
                            onPressed: toggleGripper,
                            icon: _isGripperOpen ? Icons.pan_tool : Icons.back_hand,
                            label: _isGripperOpen ? 'Close' : 'Open',
                            color: _isGripperOpen ? Colors.red : Colors.green,
                          ),
                          _buildControlButton(
                            onPressed: sendHome,
                            icon: Icons.home,
                            label: 'Home',
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Instructions
              Card(
                elevation: 2,
                color: Colors.blue.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📱 How to Use:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildInstruction('1. Press START CONTROL to activate gyroscope'),
                      _buildInstruction('2. Tilt your phone left/right to rotate the base'),
                      _buildInstruction('3. Tilt forward/backward to move the shoulder'),
                      _buildInstruction('4. Rotate your phone to control the elbow'),
                      _buildInstruction('5. Select coffee size and press Make Coffee'),
                      _buildInstruction('6. Use Open/Close to control the gripper'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAngleIndicator(String label, double angle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Colors.blue),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 5),
                LinearProgressIndicator(
                  value: (angle + 180) / 360, // Normalize to 0-1
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 8,
                ),
              ],
            ),
          ),
          SizedBox(width: 15),
          Text(
            '${angle.toStringAsFixed(1)}°',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: CircleBorder(),
            padding: EdgeInsets.all(20),
          ),
          child: Icon(icon, size: 30, color: Colors.white),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildInstruction(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, color: Colors.blue.shade900),
      ),
    );
  }
}
