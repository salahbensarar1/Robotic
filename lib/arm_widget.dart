import 'package:flutter/material.dart';
import 'dart:io';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class ArmWidget extends StatefulWidget {
  const ArmWidget({Key? key}) : super(key: key);

  @override
  _ArmWidgetState createState() => _ArmWidgetState();
}

class _ArmWidgetState extends State<ArmWidget> {
  double _baseAngle = 0;
  double _previousSliderValue = 0;
  double _shoulderAngle = 0;
  double _elbowAngle = 0;
  String _dropdownvalue = "S";
  bool _isSliderHeld = false;
  bool isDropItem = true;
  Socket? _socket; // Declare the socket variable
  bool _isConnected = false; // Track the connection status
  bool isToggled = false;

  void toggleState() {
    setState(() {
      isToggled = !isToggled;
    });
  }

  @override
  void dispose() {
    if (_socket != null) {
      _socket!.destroy();
    }
    super.dispose();
  }

  void disconnectSocket() {
    if (_isConnected) {
      _socket?.close();
      setState(() {
        _isConnected = false;
      });
      print('Socket disconnected.');
    } else {
      print('Socket connection not established.');
    }
  }

  void sendMessage(String message) {
    if (_isConnected) {
      _socket!.write(message);
      print('Sent data: $message');
    } else {
      establishSocketConnection();
      _socket!.write(message);
      print('Sent data: $message');
    }
  }

  void sendSliderData() {
    if (_isConnected) {
      String message =
          "10;${(_baseAngle * 0.1).toStringAsFixed(2)};${(_shoulderAngle * 0.1).toStringAsFixed(2)};${(_elbowAngle * 0.1).toStringAsFixed(2)};0;0;0;0;0;0;0;0";

      // Send the message over the socket
      // ...
    }
  }

  void establishSocketConnection() {
    Socket.connect("192.168.137.1", 3333).then((socket) {
      setState(() {
        _socket = socket; // Assign the socket to the variable
        _isConnected = true; // Set the connection status to true
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
            _isConnected = false; // Set the connection status to false
          });
        },
      );
    }).catchError((error) {
      print('Connection error: $error');
    });
  }

  void sendSocketData() {
    if (_isConnected) {
      String message =
          "10;${(_baseAngle * 0.1).toStringAsFixed(2)};${(_shoulderAngle * 0.1).toStringAsFixed(2)};${(_elbowAngle * 0.1).toStringAsFixed(2)};0;0;0;0;0;0;0;0";
      _socket!.write(message);
      print('Sent data: $message');
    } else {
      print('Socket connection not established.');
    }
  }

  void _updateBaseAngle(double angle) {
    setState(() {
      _baseAngle = angle;
    });
  }

  void _updateShoulderAngle(double angle) {
    setState(() {
      _shoulderAngle = angle;
    });
  }

  void _updateElbowAngle(double angle) {
    setState(() {
      _elbowAngle = angle;
    });
  }

  void _dropItem() {
    String message = "6;0;0;0;0;0;0;0;0;0;0;0"; //6 for droping items
    if (_isConnected) {
      _socket!.write(message);
      print('Sent data: $message');
    } else {
      establishSocketConnection();
      _socket!.write(message);
      print('Sent data: $message');
    }
    print('Open');
  }

  void _Home() {
    String message = "8;0;0;0;0;0;0;0;0;0;0;0"; //8 for home
    if (_isConnected) {
      _socket!.write(message);
      print('Sent data: $message');
    } else {
      establishSocketConnection();
      _socket!.write(message);
      print('Sent data: $message');
    }
    print('Home');
  }

  void DropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownvalue = selectedValue;
      });
      if (_dropdownvalue == "S") {
        String message = "3;0;0;0;0;0;0;0;0;0;0;0";
        _socket!.write(message);
        print('Sent data: $message');
      } else {
        print('Socket connection not established.');
      }
      if (_dropdownvalue == "M") {
        String message = "4;0;0;0;0;0;0;0;0;0;0;0";
        _socket!.write(message);
        print('Sent data: $message');
      } else {
        print('Socket connection not established.');
      }
      if (_dropdownvalue == "L") {
        String message = "5;0;0;0;0;0;0;0;0;0;0;0";
        _socket!.write(message);
        print('Sent data: $message');
      } else {
        print('Socket connection not established.');
      }
    }
  }

  void _dropItem2() {
    String message = "7;0;0;0;0;0;0;0;0;0;0;0"; //6 for droping items
    if (_isConnected) {
      _socket!.write(message);
      print('Sent data: $message');
    } else {
      establishSocketConnection();
      _socket!.write(message);
      print('Sent data: $message');
    }
    print('Close');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ScaffoldGradientBackground(
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          Color(0xFF8EC5FC),
          Color(0xFFE0C3FC),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Base rotation control
            Text('Base Angle: $_baseAngle'),

            Slider(
              value: _baseAngle,
              min: -180,
              max: 180,
              divisions: 6,
              label: _baseAngle.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _baseAngle = value;
                  _isSliderHeld = true;
                });
              },
              onChangeEnd: (double value) {
                setState(() {
                  _isSliderHeld = false;
                  _previousSliderValue = _baseAngle;
                });
                if (_isConnected && !_isSliderHeld) {
                  sendSliderData();
                }
              },
            ),

            // Shoulder rotation control
            Text('Shoulder Angle: $_shoulderAngle'),
            Slider(
              value: _shoulderAngle,
              min: -180,
              max: 180,
              divisions: 6,
              label: _shoulderAngle.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _shoulderAngle = value;
                  _isSliderHeld = true;
                });
                if (_isConnected && _isSliderHeld) {
                  sendSliderData();
                }
              },
              onChangeEnd: (double value) {
                setState(() {
                  _isSliderHeld = false;
                  _previousSliderValue = _shoulderAngle;
                });
                if (_isConnected && !_isSliderHeld) {
                  sendSliderData();
                }
              },
            ),
            // Elbow rotation control
            Text('Elbow Angle: $_elbowAngle'),
            Slider(
              value: _elbowAngle,
              min: -180,
              max: 180,
              divisions: 6,
              label: _elbowAngle.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _elbowAngle = value;
                  _isSliderHeld = true;
                });
                if (_isConnected && _isSliderHeld) {
                  sendSliderData();
                }
              },
              onChangeEnd: (double value) {
                setState(() {
                  _isSliderHeld = false;
                  _previousSliderValue = _elbowAngle;
                });
                if (_isConnected && !_isSliderHeld) {
                  sendSliderData();
                }
              },
            ),
            // Wrist rotation control

            // Drop button
            Row(
              children: [
                // ElevatedButton(
                //   onPressed: _dropItem,
                //   child: const Text(
                //     'Open',
                //     style: TextStyle(fontSize: 18),
                //   ),
                // ),
                IconButton(
                  icon: isToggled ? Icon(Icons.start) : Icon(Icons.close),
                  onPressed: () {
                    if (isToggled) {
                      _dropItem();
                    } else {
                      _dropItem2();
                    }

                    // Toggle the state
                    toggleState();
                  },
                ),
                // IconButton(
                //     onPressed: () => null, icon: const Icon(Icons.close)),
                const SizedBox(
                  width: 7,
                ),
                IconButton(
                    onPressed: () => _Home(), icon: const Icon(Icons.home)),
                const SizedBox(
                  width: 110,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_isConnected == true) {
                      sendSocketData();
                    } else {
                      establishSocketConnection();
                    }
                  },
                  child: const Text(
                    " Submit ",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Hi which coffee you want ?",
              style: TextStyle(fontSize: 18),
            ),
            DropdownButton(
              hint: const Text("Coffee"),
              items: const [
                DropdownMenuItem(child: Text("Small"), value: "S"),
                DropdownMenuItem(child: Text("Medium"), value: "M"),
                DropdownMenuItem(child: Text("Large"), value: "L"),
              ],
              value: _dropdownvalue,
              onChanged: DropdownCallback,
            ),
          ],
        ),
      ),
    );
  }
}
