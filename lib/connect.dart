import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rctc/Remote.dart';
import 'package:rctc/main.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'connect.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'arm_widget.dart';

// class SocketManager {
//   static late TcpSocketConnection socketConnection;

//   static void initialize(String ipAddress, int port) {
//     socketConnection = TcpSocketConnection(ipAddress, port);
//   }

//   static TcpSocketConnection getSocketConnection() {
//     return socketConnection;
//   }
// }

class Connection {
  late String _ip;

  String get ip => _ip;

  set ip(String value) {
    _ip = value;
  }

  late int _port;

  int get port => _port;

  set port(int value) {
    _port = value;
  }
}

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});
  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  TextEditingController _ipController = TextEditingController();
  TextEditingController _portController = TextEditingController();

  // static late TcpSocketConnection socketConnection;
  String message = "SZIA";

  bool _isLampOn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Connect'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.greenAccent, Colors.blueAccent],
              ),
            ),
          ),
          leading: IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage())),
              icon: Icon(Icons.arrow_back_ios)),
          backgroundColor: Color.fromARGB(255, 255, 107, 62),
        ),
        endDrawer: Drawer(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    InkWell(
                        onTap: () {},
                        child: ListTile(
                          leading: Icon(Icons.home),
                          title: Text('Home')
                              .animate()
                              .fade()
                              .scale(duration: 600.milliseconds),
                        )),
                    InkWell(
                        onTap: () {},
                        child: ListTile(
                          leading: Icon(Icons.accessibility),
                          title: Text('Accessibility')
                              .animate()
                              .fade()
                              .scale(duration: 900.milliseconds),
                        )),
                    InkWell(
                        onTap: () {},
                        child: ListTile(
                          leading: Icon(Icons.control_point),
                          title: Text('Control')
                              .animate()
                              .fade()
                              .scale(duration: 1100.milliseconds),
                        )),
                    InkWell(
                        onTap: () {},
                        child: ListTile(
                          leading: Icon(Icons.exit_to_app),
                          title: Text('Exit')
                              .animate()
                              .fade()
                              .scale(duration: 1400.milliseconds),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Text("IP ADRESS"),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: _ipController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(5.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(5.5),
                    ),
                    prefixIcon: Icon(Icons.wifi, color: Colors.lightGreen),
                    hintText: "Enter The IP addesse",
                    hintStyle: TextStyle(color: Colors.lightGreen),
                    filled: true,
                    fillColor: Colors.blue[50],
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (value) {},
                ),
              ),

              //Text("Port"),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: _portController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(5.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(5.5),
                    ),
                    prefixIcon:
                        Icon(Icons.podcasts_rounded, color: Colors.lightGreen),
                    hintText: "Enter The Port",
                    hintStyle: TextStyle(color: Colors.lightGreen),
                    filled: true,
                    fillColor: Colors.blue[50],
                  ),
                  validator: (value2) {
                    if (value2!.isEmpty) {
                      return 'Please enter some text for the port';
                    }
                    return null;
                  },
                  onSaved: (value2) {},
                ),
              ),
              SizedBox(
                height: 60,
              ),
              SizedBox(
                width: 150,
                height: 43,
                // style: ButtonStyle(
                //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                //         RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(18.0),
                //   //side: BorderSide(color: Colors.red)
                // ))),
                // setState(() {
                //   _isLampOn = true;
                // });
                // Future.delayed(Duration(seconds: 6), () {
                //   setState(() {
                //     _isLampOn = false;
                //   });
                // });
                child: ElevatedButton(
                  onPressed: () async {
                    final ipAddress = _ipController.text;
                    final port = int.parse(_portController.text);

                    // Socket.connect(ipAddress, port).then((Socket) {
                    //   Socket.listen(
                    //     (data) {},
                    //     onError: (error) {},
                    //     onDone: () {},
                    //   );

                    //   // Send data over the socket
                    //   Socket.write('Your data');

                    //   // Close the socket when done
                    //   //Socket.close();
                    // }).catchError((error) {
                    //   // Handle connection error
                    // });

                    // SocketManager.initialize(ipAddress, port);
                    // socketConnection = TcpSocketConnection(ipAddress, port);
                    // socketConnection.enableConsolePrint(true);
                    // if (await socketConnection.canConnect(5000, attempts: 3)) {
                    //   socketConnection.connect(
                    //     5000,
                    //     messageReceived,
                    //     attempts: 3,
                    //   );
                    //   socketConnection.sendMessage(message);

                    //   Navigator.push(context,
                    //       MaterialPageRoute(builder: (_) => ArmWidget()));
                    // }
                    // SocketManager.initialize(ipAddress, port);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArmWidget(),
                      ),
                    );
                  },
                  child: Text(
                    " Connect ",
                    style: TextStyle(fontSize: 18),
                  ),
                  // style: ButtonStyle(),
                ),
              ),
              SizedBox(
                height: 30,
                // width: 120,
              ),
              // Show the lamp state
              Padding(
                padding: const EdgeInsets.only(right: 36),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isLampOn ? Colors.yellow : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void messageReceived(String msg) {
  //   setState(() {
  //     message = msg;
  //   });
  //   socketConnection.sendMessage(" ALfred  :D ");
  // }
}
