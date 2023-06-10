import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rctc/arm_widget.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'connect.dart';

class Remote extends StatefulWidget {
  const Remote({super.key});

  @override
  State<Remote> createState() => _RemoteState();
}

class _RemoteState extends State<Remote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22.0),
          child: new Column(
            children: <Widget>[
              ArmWidget(),

              // style: ButtonStyle(),
            ],
          ),
        );
      }),
    );
  }
}
